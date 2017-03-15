//
//  SecondFirstVC.m
//  YUFullscreenGestureDemo
//
//  Created by mayubo on 2017/3/13.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "SecondFirstVC.h"
#import "FirstFirstVC.h"

@interface SecondFirstVC ()

@end

@implementation SecondFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.yu_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = kColorWithRGB(0, 128, 0);
    
    // 添加 push 按钮
    [self addPushButton];
}

- (void)addPushButton {
    UIButton *pushBtn = [[UIButton alloc] init];
    [pushBtn setTitle:@"push" forState:UIControlStateNormal];
    [pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(pushBtnClick) forControlEvents:UIControlEventTouchUpInside];
    pushBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:pushBtn];
    
    NSLayoutConstraint *btnCenterXLc = [NSLayoutConstraint constraintWithItem:pushBtn
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f
                                                                     constant:0];
    [self.view addConstraint:btnCenterXLc];
    NSLayoutConstraint *btnCenterYLc = [NSLayoutConstraint constraintWithItem:pushBtn
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f
                                                                     constant:0];
    [self.view addConstraint:btnCenterYLc];
    NSLayoutConstraint *btnWLc = [NSLayoutConstraint constraintWithItem:pushBtn
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:kNilOptions
                                                             multiplier:1.0f
                                                               constant:90.0f];
    [pushBtn addConstraint:btnWLc];
    NSLayoutConstraint *btnHLc = [NSLayoutConstraint constraintWithItem:pushBtn
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:kNilOptions
                                                             multiplier:1.0f
                                                               constant:50];
    // 由于没有参照物，所以约束添加于自身身上
    [pushBtn addConstraint:btnHLc];
}

- (void)pushBtnClick {
    FirstFirstVC *firstFirst = [[FirstFirstVC alloc] init];
    [self.navigationController pushViewController:firstFirst animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
