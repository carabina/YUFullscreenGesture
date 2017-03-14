//
//  YUTabView.m
//  YUFullscreenGestureDemo
//
//  Created by 马裕博 on 2017/3/14.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "YUTabView.h"
#import "YUTabButton.h"

@interface YUTabView ()

/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray<YUTabButton *> *btnArrM;

/** 处理 */
@property (nonatomic, copy) YUTabViewBlock tagBlock;

@end

@implementation YUTabView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setTitle:(NSArray<NSString *> *)titleArr then:(YUTabViewBlock)tagBlock {
    _tagBlock = tagBlock;
    int count = (int)titleArr.count;
    for (int i = 0; i < count; i++) {
        YUTabButton *btn = [YUTabButton new];
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
        [self.btnArrM addObject:btn];
    }
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [self.btnArrM[i] mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.height.bottom.mas_equalTo(self);
                make.left.mas_equalTo(self);
                make.width.mas_equalTo(self).dividedBy(count);
            }];
        } else if (i > 0 && i < count - 1) {
            [self.btnArrM[i] mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.height.bottom.mas_equalTo(self);
                make.left.mas_equalTo(self.btnArrM[i-1].mas_right);
                make.width.mas_equalTo(self).dividedBy(count);
            }];
        } else {
            [self.btnArrM[i] mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.height.bottom.mas_equalTo(self);
                make.left.mas_equalTo(self.btnArrM[i-1].mas_right);
                make.right.mas_equalTo(self);
                make.width.mas_equalTo(self).dividedBy(count);
            }];
        }
    }
    
    for (YUTabButton *botton in self.btnArrM) {
        if (botton.tag == 0) {
            botton.selected = YES;
        } else {
            botton.selected = NO;
        }
    }
}

- (void)btnClick:(YUTabButton *)btn {
    // 传出tag
    int tag = (int)btn.tag;
    self.tagBlock(tag);
}

- (BOOL)setupTabIndex:(int)index {
    if (index < 0 || index > self.btnArrM.count) {
        return NO;
    }
    for (int i = 0; i < self.btnArrM.count; i++) {
        if (i == index) {
            self.btnArrM[i].selected = YES;
        } else {
            self.btnArrM[i].selected = NO;
        }
    }
    return YES;
}

#pragma mark - LazyLoad
- (NSMutableArray<YUTabButton *> *)btnArrM {
    if (_btnArrM == nil) {
        _btnArrM = [NSMutableArray array];
    }
    return _btnArrM;
}

@end
