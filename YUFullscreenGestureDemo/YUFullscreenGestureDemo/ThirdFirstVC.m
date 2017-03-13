//
//  ThirdFirstVC.m
//  YUFullscreenGestureDemo
//
//  Created by mayubo on 2017/3/13.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "ThirdFirstVC.h"

@interface ThirdFirstVC ()

@end

@implementation ThirdFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem yu_barButtonWithImage:@"arrowBack" title:@"返回" target:self action:@selector(leftBarClick)];
    
    // 添加 scrollView
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    [self.view addSubview:scrollV];
}

- (void)leftBarClick {
    YULog(@"%s", __FUNCTION__);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
