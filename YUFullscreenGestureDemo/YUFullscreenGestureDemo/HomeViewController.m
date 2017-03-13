//
//  HomeViewController.m
//  YUFullscreenGestureDemo
//
//  Created by 马裕博 on 2017/3/13.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "HomeViewController.h"
#import "UIBarButtonItem+YUCustom.h"
#import "RedViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem yu_barButtonWithTitle:@"红" target:self action:@selector(redView)];
}

- (void)redView {
    RedViewController *redVC = [[RedViewController alloc] init];
    [self.navigationController pushViewController:redVC animated:YES];
}

@end
