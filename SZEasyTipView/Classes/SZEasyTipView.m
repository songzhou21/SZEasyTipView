//
//  SZEasyTipView.m
//  SZEasyTipView
//
//  Created by Song Zhou on 5/28/16.
//  Copyright © 2016 Song Zhou. All rights reserved.
//

#import "SZEasyTipView.h"


@interface SZEasyTipView ()

@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGSize textSize;
@property (nonatomic) NSString *text;
@property (nonatomic) SZConfig *config;
@property (nonatomic, weak) id<SZEasyTipViewDelegate> delegate;
@property (nonatomic, weak) UIView *presentingView;
@property (nonatomic) CGPoint arrowTip;

@end

@implementation SZEasyTipView

- (instancetype)initWithText:(NSString *)text config:(SZConfig *)config delegate:(id<SZEasyTipViewDelegate>)delegate {
    _textSize = CGSizeZero;
    _contentSize = CGSizeZero;
    _arrowTip = CGPointZero;
    
    _text = text;
    self.config = config;
    _delegate = delegate;
    
    self = [self initWithFrame:CGRectZero];
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

#pragma mark - Getters
- (CGSize)contentSize {
    if (CGSizeEqualToSize(_contentSize, CGSizeZero)) {
        _contentSize = CGSizeMake(self.textSize.width + _config.textHInset * 2 + _config.bubbleHInset * 2, self.textSize.height + _config.textVInset * 2 + _config.bubbleVInset * 2 + _config.arrowHeight);
    }
    
    return _contentSize;
}

- (CGSize)textSize {
    if (CGSizeEqualToSize(_textSize, CGSizeZero)) {
        NSDictionary *attributes = @{NSFontAttributeName: _config.font};
        CGSize size = CGSizeMake(_config.maxWidth, CGFLOAT_MAX);
        CGSize textSize = [_text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL].size;
        
        textSize.width = ceil(textSize.width);
        textSize.height = ceil(textSize.height);
        
        if (textSize.width < _config.arrowWidth) {
            textSize.width = _config.arrowWidth;
        }
        
        _textSize = textSize;
    }
    
    return _textSize;
}

#pragma mark - Setters
- (void)setConfig:(SZConfig *)config {
    if (!config) {
        _config = [[SZConfig alloc] init];
    } else {
        _config = config;
    }
}

#pragma mark - Drawing
- (void)drawBubble:(CGRect)rect arrowPosition:(SZArrowPosition)position context:(CGContextRef)context {
    CGFloat arrowWidth = _config.arrowWidth;
    CGFloat arrowHeight = _config.arrowHeight;
    CGFloat cornerRadius = _config.cornerRadius;
    CGFloat arrowJointYOrigin  = _arrowTip.y + (position == SZArrowPositionBottom ? -1 : 1) * arrowHeight;
    
    CGMutablePathRef contourPath = CGPathCreateMutable();
    
    CGPathMoveToPoint(contourPath, NULL, _arrowTip.x, _arrowTip.y);
    CGPathAddLineToPoint(contourPath, NULL, _arrowTip.x - arrowWidth / 2, arrowJointYOrigin);
    
    if (position == SZArrowPositionBottom) {
        [self drawBubbleBottomShape:rect cornerRadius:cornerRadius path:contourPath];
    } else {
        [self drawBubbleTopShape:rect cornerRadius:cornerRadius path:contourPath];
    }
    
    CGPathAddLineToPoint(contourPath, NULL, _arrowTip.x + arrowWidth / 2, arrowJointYOrigin);
    CGPathCloseSubpath(contourPath);
    CGContextAddPath(context, contourPath);
    CGContextClip(context);
    
    [self paintBubble:context];
    
    if ([_config hasBorder]) {
        [self drawBorder:contourPath context:context];
    }
}

- (void)drawBubbleBottomShape:(CGRect)frame cornerRadius:(CGFloat)radius path:(CGMutablePathRef)path {
    CGPoint leftTop = SZLeftTopPoint(frame);
    CGPoint leftBottom = SZLeftBottomPoint(frame);
    CGPoint rightTop = SZRightTopPoint(frame);
    CGPoint rightBottom = SZRightBottomPoint(frame);
    
    SZPathAddRoundRectWithPoints(path, leftBottom, leftTop, rightTop, rightBottom, radius);
}

- (void)drawBubbleTopShape:(CGRect)frame cornerRadius:(CGFloat)radius path:(CGMutablePathRef)path {
    CGPoint leftTop = SZLeftTopPoint(frame);
    CGPoint leftBottom = SZLeftBottomPoint(frame);
    CGPoint rightTop = SZRightTopPoint(frame);
    CGPoint rightBottom = SZRightBottomPoint(frame);
    
    SZPathAddRoundRectWithPoints(path, leftTop, leftBottom, rightBottom, rightTop, radius);
}

- (void)paintBubble:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, _config.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
}

- (void)drawBorder:(CGPathRef)path context:(CGContextRef)context {
    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, _config.borderColor.CGColor);
    CGContextSetLineWidth(context, _config.borderWidth);
    CGContextStrokePath(context);
}

- (void)drawText:(CGRect)rect context:(CGContextRef)context {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = _config.textAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect textRect = CGRectMake(rect.origin.x + (CGRectGetWidth(rect) - self.textSize.width)/2, rect.origin.y + (CGRectGetHeight(rect) - self.textSize.height)/2, self.textSize.width, self.textSize.height);
    
    [_text drawInRect:textRect withAttributes:@{NSFontAttributeName: _config.font, NSForegroundColorAttributeName: _config.foregroundColor, NSParagraphStyleAttributeName: paragraphStyle}];
}

- (void)drawRect:(CGRect)rect {
    CGFloat bubbleWidth = self.contentSize.width - 2 * _config.bubbleHInset;
    CGFloat bubbleHeight = self.contentSize.height - 2 * _config.bubbleVInset - _config.arrowHeight;
    CGFloat bubbleXOrigin = _config.bubbleHInset;
    CGFloat bubbleYOrigin = _config.arrowPosition == SZArrowPositionBottom ? _config.bubbleVInset : _config.bubbleVInset + _config.arrowHeight;
    CGRect bubbleFrame = CGRectMake(bubbleXOrigin, bubbleYOrigin, bubbleWidth, bubbleHeight);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [self drawBubble:bubbleFrame arrowPosition:_config.arrowPosition context:context];
    [self drawText:bubbleFrame context:context];
    
    CGContextRestoreGState(context);
}

#pragma mark - Class Methods
+ (void)showForView:(UIView *)view withinSuperView:(UIView *)superView text:(NSString *)text config:(SZConfig *)config delegate:(id<SZEasyTipViewDelegate>)delegate animated:(BOOL)animated {
    SZEasyTipView *ev = [[SZEasyTipView alloc] initWithText:text config:config delegate:delegate];
    [ev showForView:view withinSuperView:superView animated:animated];
}

+ (void)showForItem:(UIBarItem *)item withinSuperView:(UIView *)superView text:(NSString *)text config:(SZConfig *)config delegate:(id<SZEasyTipViewDelegate>)delegate animated:(BOOL)animated {
    
    SZEasyTipView *ev = [[SZEasyTipView alloc] initWithText:text config:config delegate:delegate];
    [ev showForItem:item withinSuperView:superView animated:animated];
}

#pragma mark - Instance Methods
- (void)showForItem:(UIBarItem *)item withinSuperView:(UIView *)superView animated:(BOOL)animated {
    UIView *view = [item SZView];
    if (view) {
        [self showForView:view withinSuperView:superView animated:animated];
    }
    
}

- (void)showForView:(UIView *)view withinSuperView:(UIView *)superView animated:(BOOL)animated {
    NSAssert(superView == nil || [view hasSuperView:superView], @"The supplied superview %@ is not a direct nor an indirect superview of the supplied reference view %@. The superview passed to this method should be a direct or an indirect superview of the reference view. To display the tooltip within the main window, ignore the superview parameter.", superView, view);
    
    if (!superView) {
        superView = [UIApplication sharedApplication].windows.firstObject;
    }
    
    CGAffineTransform initialTransform = _config.showInitialTransform;
    CGAffineTransform finalTransform = _config.showFinalTransform;
    CGFloat initialAlpha = _config.showInitialAlpha;
    CGFloat damping = _config.springDamping;
    CGFloat velocity = _config.springVelocity;
    
    _presentingView = view;
    [self arrangeWithInSuperView:superView];
    
    self.transform = initialTransform;
    self.alpha = initialAlpha;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tap];
    
    [superView addSubview:self];
    
    // animation
    void(^animatin)(void) = ^{
       self.transform = finalTransform;
       self.alpha = 1;
    };
    
    if (animated) {
        [UIView animateWithDuration:_config.showDuration
                              delay:0
             usingSpringWithDamping:damping
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            animatin();
                        } completion:nil];
    } else {
        animatin();
    }
    
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    CGFloat damping = _config.springDamping;
    CGFloat velocity = _config.springVelocity;
    
    [UIView animateWithDuration:_config.dismissDuration delay:0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = _config.dismissTransform;
        self.alpha = _config.dismissFinalAlpha;
    } completion:^(BOOL finished) {
        if (finished) {
            if (completion) {
                completion();
            }
            [self removeFromSuperview];
            self.transform = CGAffineTransformIdentity;
        }
    }];
}

#pragma mark - Private Methods
- (void)arrangeWithInSuperView:(UIView *)superView {
    SZArrowPosition position = _config.arrowPosition;
    
    CGPoint refViewOrigin = [_presentingView originDistantWithinSuperView:superView];
    CGSize refViewSize = _presentingView.frame.size;
    CGPoint refViewCenter = CGPointMake(refViewOrigin.x + refViewSize.width / 2, refViewOrigin.y + refViewSize.height / 2);
    
    CGFloat xOrigin = refViewCenter.x - self.contentSize.width / 2;
    CGFloat yOrigin = position == SZArrowPositionBottom ? refViewOrigin.y - self.contentSize.height : refViewOrigin.y + refViewSize.height;
    
    CGRect frame = CGRectMake(xOrigin, yOrigin, self.contentSize.width, self.contentSize.height);
    
    // horizontal arrange
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    } else if (CGRectGetMaxX(frame) > CGRectGetWidth(superView.frame)) {
        frame.origin.x = CGRectGetWidth(superView.frame) - CGRectGetWidth(frame);
    }
    
    // vertical arrange
    if (position == SZArrowPositionBottom) {
        if (CGRectGetMinY(frame) < 0) {
            _config.arrowPosition = SZArrowPositionTop;
            frame.origin.y = refViewOrigin.y + refViewSize.height;
        }
    } else {
        if (CGRectGetMaxY(frame) > CGRectGetHeight(superView.frame)) {
            _config.arrowPosition = SZArrowPositionBottom;
            frame.origin.y = refViewOrigin.y = self.contentSize.height;
        }
    }
    
    // arraw
    CGFloat arrowTipXOrigin;
    if (CGRectGetWidth(frame) < refViewSize.width) {
        arrowTipXOrigin = self.contentSize.width / 2;
    } else {
        arrowTipXOrigin = fabs(frame.origin.x - refViewOrigin.x) + refViewSize.width / 2;
    }
    
    _arrowTip = CGPointMake(arrowTipXOrigin, _config.arrowPosition == SZArrowPositionBottom ? self.contentSize.height - _config.bubbleVInset : _config.bubbleVInset);
    
    self.frame = frame;
}

- (void)handleTap {
   [self dismissWithCompletion:^{
       if ([self.delegate respondsToSelector:@selector(easyTipViewDidDismiss:)]) {
           [self.delegate easyTipViewDidDismiss:self];
       }
   }];
}

@end

@implementation SZConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cornerRadius = 5.0;
        _arrowHeight = 5.0;
        _arrowWidth = 10.0;
        _foregroundColor = [UIColor whiteColor];
        _backgroundColor = [UIColor redColor];
        _arrowPosition = SZArrowPositionBottom;
        _textAlignment = NSTextAlignmentCenter;
        _borderWidth = 0;
        _borderColor = [UIColor clearColor];
        _font = [UIFont systemFontOfSize:15];
        
        _bubbleHInset = 10.0;
        _bubbleVInset = 1.0;
        _textHInset = 10.0;
        _textVInset = 10.0;
        _maxWidth = 200.0;
        
        _dismissTransform = CGAffineTransformMakeScale(0.1, 0.1);
        _showInitialTransform = CGAffineTransformMakeScale(0, 0);
        _showFinalTransform = CGAffineTransformIdentity;
        _springDamping = 0.7;
        _springVelocity = 0.7;
        _showInitialAlpha = 0;
        _dismissFinalAlpha = 0;
        _showDuration = 0.7;
        _dismissDuration = 0.7;
    }
    return self;
}

#pragma mark - Getters
- (BOOL)hasBorder {
    return _borderWidth > 0 && _borderColor != [UIColor clearColor];
}

@end

@implementation UIView (SZExtension)

- (CGPoint)originDistantWithinSuperView:(UIView *)superView {
    if (self.superview == nil) {
        return self.frame.origin;
    }
    
    return [self viewOriginInSuperView:self.superview refSuperView:superView origin:self.frame.origin];
}

- (BOOL)hasSuperView:(UIView *)superView {
    return [self viewHasSuperView:self superView:superView];
}

#pragma mark - Private Methods
// search until `superView` isEqual to `refSuperView`, or find `Window`
- (CGPoint)viewOriginInSuperView:(UIView *)superView refSuperView:(UIView *)view origin:(CGPoint)origin {
    CGPoint newOrigin = CGPointMake(superView.frame.origin.x + origin.x, superView.frame.origin.y + origin.y);
    
    if (superView.superview == nil) { // find window, search finish
        return newOrigin;
    }
    
    if (view == nil) { // search up to window
        return [self viewOriginInSuperView:superView.superview refSuperView:nil origin:newOrigin];
    }
    
    if (view == superView) { // find refSuperView, search finish
        return origin;
    }
    
    // search up to refSuperView
    return [self viewOriginInSuperView:superView.superview refSuperView:view origin:newOrigin];
}

- (BOOL)viewHasSuperView:(UIView *)view superView:(UIView *)superView {
    if (view.superview == nil) {
        return NO;
    }
    
    if (view.superview == superView) {
        return YES;
    }
    
    return [self viewHasSuperView:view.superview superView:superView];
}

@end

@implementation UIBarItem (SZExtension)
- (UIView *)SZView {
    if ([self isKindOfClass:[UIBarButtonItem class]]) {
        UIBarButtonItem *item = (UIBarButtonItem *)self;
        if ([item customView]) {
            return [item customView];
        }
    }
    
    return (UIView *)[self valueForKey:@"view"];
}

@end