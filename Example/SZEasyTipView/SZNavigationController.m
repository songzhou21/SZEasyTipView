//
//  SZNavigationController.m
//  SZEasyTipView
//
//  Created by Song Zhou on 5/29/16.
//  Copyright © 2016 Song Zhou. All rights reserved.
//

#import "SZNavigationController.h"
#import "SZEasyTipView.h"

@interface SZNavigationController ()

@end

@implementation SZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"test";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

static NSString * const testCellIdentifier = @"test cell";

@implementation SZTableViewController

- (void)viewDidLoad {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(tapOnLeft:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(tapOnRight:)];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testCellIdentifier];
    _data = @[@1, @2, @3, @4, @5];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [_data[indexPath.row] stringValue];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:testCellIdentifier];
    
    cell.textLabel.text = text;
    
    UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [disclosure addTarget:self action:@selector(tapOnDisclosure:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = disclosure;
    
    return cell;
}

- (void)tapOnDisclosure:(UIButton *)sender {
    [SZEasyTipView showForView:sender withinSuperView:self.tableView text:@"Lose yourself - Eminem" config:nil delegate:nil animated:YES];
}



- (void)tapOnLeft:(UIBarButtonItem *)sender {
    [SZEasyTipView showForItem:sender withinSuperView:nil text:@"you tap on left" config:nil delegate:nil animated:YES];
}

- (void)tapOnRight:(UIBarButtonItem *)sender {
    [SZEasyTipView showForItem:sender withinSuperView:nil text:@"you tap on right" config:nil delegate:nil animated:YES];
}
@end
