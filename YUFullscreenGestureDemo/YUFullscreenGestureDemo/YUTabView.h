//
//  YUTabView.h
//  YUFullscreenGestureDemo
//
//  Created by 马裕博 on 2017/3/14.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YUTabViewBlock)(int tag);

@interface YUTabView : UIView

/**
 *  设置标题和默认选中第几个
 *
 *  @param titleArr 标题数组
 *  @param tagBlock 传出第几个btn被点击
 */
- (void)setTitle:(NSArray <NSString *>*)titleArr then:(YUTabViewBlock)tagBlock;

/** 索引 */
- (BOOL)setupTabIndex:(int)index;

@end
