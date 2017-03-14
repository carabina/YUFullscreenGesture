//
//  YUTabButton.m
//  YUFullscreenGestureDemo
//
//  Created by 马裕博 on 2017/3/14.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "YUTabButton.h"

@implementation YUTabButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setImage:[UIImage yu_resizableImageWith:@"themeColor"] forState:UIControlStateSelected];
        
        [self setTitleColor:kColorWithRGB(51, 51, 51) forState:UIControlStateNormal];
        
        [self setTitleColor:kColorTheme forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:15.f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setAdjustsImageWhenHighlighted:NO];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = self.titleLabel.yu_textSize.width;
    CGFloat h = 1.25f;
    CGFloat x = (self.yu_width - w)/2.f;
    CGFloat y = self.yu_height - h;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat w = self.yu_width;
    CGFloat h = self.yu_height - 1;
    return CGRectMake(0, 0, w, h);
}

@end
