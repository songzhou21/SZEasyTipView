//
//  SZEasyTipView.h
//  SZEasyTipView
//
//  Created by Song Zhou on 5/28/16.
//  Copyright © 2016 Song Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SZLeftTopPoint(frame)       CGPointMake(frame.origin.x, frame.origin.y)
#define SZLeftBottomPoint(frame)    CGPointMake(frame.origin.x, frame.origin.y + frame.size.height)
#define SZRightTopPoint(frame)      CGPointMake(frame.origin.x + frame.size.width, frame.origin.y)
#define SZRightBottomPoint(frame)   CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height)

#define SZPathAddArcToPoint(path, point1, point2, radius) \
    CGPathAddArcToPoint(path, NULL, point1.x, point1.y, point2.x, point2.y, radius)

#define SZPathAddRoundRectWithPoints(path, point1, point2, point3, point4, radius) \
    SZPathAddArcToPoint(path, point1, point2, radius);\
    SZPathAddArcToPoint(path, point2, point3, radius);\
    SZPathAddArcToPoint(path, point3, point4, radius);\
    SZPathAddArcToPoint(path, point4, point1, radius)


typedef NS_ENUM(NSInteger, SZArrowPosition)  {
   SZArrowPositionTop,
   SZArrowPositionBottom
};

NS_ASSUME_NONNULL_BEGIN

@class SZConfig, SZEasyTipView;

@protocol SZEasyTipViewDelegate <NSObject>

@optional
- (void)easyTipViewDidDismiss:(SZEasyTipView *)view;
@end


@interface SZEasyTipView : UIView

- (instancetype)initWithText:(NSString *)text config:(SZConfig * __nullable)config delegate:(id<SZEasyTipViewDelegate> __nullable)delegate;

+ (void)showForView:(UIView *)view withinSuperView:(UIView * __nullable)superView text:(NSString *)text config:(SZConfig * __nullable)config delegate:(id<SZEasyTipViewDelegate> __nullable)delegate animated:(BOOL)animated;
+ (void)showForItem:(UIBarItem *)item withinSuperView:(UIView * __nullable)superView text:(NSString *)text config:(SZConfig * __nullable)config delegate:(id<SZEasyTipViewDelegate> __nullable)delegate animated:(BOOL)animated;

- (void)showForView:(UIView *)view withinSuperView:(UIView * __nullable)superView animated:(BOOL)animated;
- (void)showForItem:(UIBarItem *)item withinSuperView:(UIView * __nullable)superView animated:(BOOL)animated;
@end

@interface SZConfig : NSObject

#pragma mark - Drawing
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat arrowHeight;
@property (nonatomic) CGFloat arrowWidth;
@property (nonatomic) UIColor *foregroundColor;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) SZArrowPosition arrowPosition;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) UIColor *borderColor;
@property (nonatomic) UIFont *font;

#pragma mark - Positioning
@property (nonatomic) CGFloat bubbleHInset;
@property (nonatomic) CGFloat bubbleVInset;
@property (nonatomic) CGFloat textHInset;
@property (nonatomic) CGFloat textVInset;
@property (nonatomic) CGFloat maxWidth;

#pragma mark - Animating
@property (nonatomic) CGAffineTransform dismissTransform;
@property (nonatomic) CGAffineTransform showInitialTransform;
@property (nonatomic) CGAffineTransform showFinalTransform;
@property (nonatomic) CGFloat springDamping;
@property (nonatomic) CGFloat springVelocity;
@property (nonatomic) CGFloat showInitialAlpha;
@property (nonatomic) CGFloat dismissFinalAlpha;
@property (nonatomic) CGFloat showDuration;
@property (nonatomic) CGFloat dismissDuration;

@property (nonatomic, getter=hasBorder) BOOL border;

@end

@interface UIView (SZExtension)

- (CGPoint)originDistantWithinSuperView:(UIView *)superView;
- (BOOL)hasSuperView:(UIView *)superView;

@end

@interface UIBarItem (SZExtension)

- (UIView *)SZView;

@end

NS_ASSUME_NONNULL_END