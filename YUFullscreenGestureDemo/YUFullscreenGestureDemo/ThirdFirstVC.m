//
//  ThirdFirstVC.m
//  YUFullscreenGestureDemo
//
//  Created by mayubo on 2017/3/13.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "ThirdFirstVC.h"
#import "ThirdFirstSV.h"

@interface ThirdFirstVC ()

@end

@implementation ThirdFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem yu_barButtonWithImage:@"arrowBack"
                                                                             title:@"返回"
                                                                            target:self
                                                                            action:@selector(leftBarClick)];
    
    // 添加 scrollView
    ThirdFirstSV *scrollV = [[ThirdFirstSV alloc] init];
    scrollV.frame = self.view.bounds;
    scrollV.contentSize = CGSizeMake(1000, 800);
    [self.view addSubview:scrollV];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"内容中心";
    lab.frame = CGRectMake(500, 400, 90, 60);
    [scrollV addSubview:lab];
}

- (void)leftBarClick {
    YULog(@"%s", __FUNCTION__);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
