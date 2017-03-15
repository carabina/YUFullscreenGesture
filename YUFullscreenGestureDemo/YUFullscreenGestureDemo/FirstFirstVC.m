//
//  FirstFirstVC.m
//  YUFullscreenGestureDemo
//
//  Created by mayubo on 2017/3/13.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "FirstFirstVC.h"

@interface FirstFirstVC ()

@end

@implementation FirstFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem yu_barButtonWithImage:@"arrowBack" title:@"返回" target:self action:@selector(leftBarClick)];
    
    UILabel *weibo = [[UILabel alloc] init];
    weibo.font = [UIFont systemFontOfSize:22];
    weibo.textAlignment = NSTextAlignmentCenter;
    weibo.textColor = kColorTheme;
    weibo.text = @"新浪微博:裕之都";
    [self.view addSubview:weibo];
    
    [weibo mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.mas_equalTo(self.view);
    }];
}

- (void)leftBarClick {
    YULog(@"%s", __FUNCTION__);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
