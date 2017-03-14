//
//  FourFirstVC.m
//  YUFullscreenGestureDemo
//
//  Created by 马裕博 on 2017/3/14.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "FourFirstVC.h"
#import "ThirdFirstSV.h"
#import "YUTabView.h"

@interface FourFirstVC () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
/** tabView */
@property (nonatomic, weak) YUTabView *tabView;
/** 标题数组 */
@property (nonatomic, copy) NSArray<NSString *> *titleArr;

/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollV;
/** 当前页码（scrollView） */
@property (nonatomic, assign) int currentTab;

/** tableView */
@property (nonatomic, weak) UITableView *tableView1;
@property (nonatomic, weak) UITableView *tableView2;
@property (nonatomic, weak) UITableView *tableView3;
@end

@implementation FourFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem yu_barButtonWithImage:@"arrowBack"
                                                                             title:@"返回"
                                                                            target:self
                                                                            action:@selector(leftBarClick)];
    
    [self addScrollViewAndTableView];
}

- (void)leftBarClick {
    YULog(@"%s", __FUNCTION__);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addScrollViewAndTableView {
    
    YUTabView *tabView = [[YUTabView alloc] init];
    [tabView setupTabIndex:0];
    [tabView setTitle:self.titleArr then:^(int tag) {
        YULog(@"%@ -->点击%d", self.class, tag);
        CGFloat y = kScreenWidth * tag;
        [self.scrollV setContentOffset:CGPointMake(y, 0) animated:YES];
    }];
    [self.view addSubview:tabView];
    
    UIView *tabViewBottomLine = [[UIView alloc] init];
    tabViewBottomLine.backgroundColor = kColorDriveLine;
    [self.view addSubview:tabViewBottomLine];
    
    // 添加 scrollView 和 tableView
    ThirdFirstSV *scrollV = [[ThirdFirstSV alloc] init];
    scrollV.backgroundColor = [UIColor whiteColor];
    scrollV.delegate = self;
    scrollV.pagingEnabled = YES;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.bounces = NO;
    [self.view addSubview:scrollV];
    
    UIView *contentView = [UIView new];
    [scrollV addSubview:contentView];
    
    UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.backgroundColor = [UIColor purpleColor];
    [contentView addSubview:tableView1];
    
    UITableView *tableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.backgroundColor = [UIColor blueColor];
    [contentView addSubview:tableView2];
    
    UITableView *tableView3 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView3.delegate = self;
    tableView3.dataSource = self;
    tableView3.backgroundColor = [UIColor yellowColor];
    [contentView addSubview:tableView3];
    
    self.tabView = tabView;
    self.scrollV = scrollV;
    self.tableView1 = tableView1;
    self.tableView2 = tableView2;
    self.tableView3 = tableView3;
    
    /******** 自动布局 ********/
    [tabView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(39);
    }];
    
    [tabViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(tabView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(tabViewBottomLine.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(scrollV);
        make.height.mas_equalTo(scrollV);
    }];
    
    [tableView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(scrollV);
    }];
    [tableView2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.mas_equalTo(contentView);
        make.left.mas_equalTo(tableView1.mas_right);
        make.width.mas_equalTo(scrollV);
    }];
    [tableView3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.mas_equalTo(contentView);
        make.left.mas_equalTo(tableView2.mas_right);
        make.width.mas_equalTo(scrollV);
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(tableView3.mas_right);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    YULog(@"偏移%f", scrollView.contentOffset.x);
    if (scrollView.contentOffset.x > 0) {
        double ratio = scrollView.contentOffset.x / kScreenWidth;
        int page = (int)(ratio + 0.5);
        
        YULog(@"第%d页", page);
        self.currentTab = page;
        [self.tabView setupTabIndex:page];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld组,第%ld行", (long)indexPath.section, (long)indexPath.row];
    return cell;
}

- (NSArray<NSString *> *)titleArr {
    if (_titleArr == nil) {
        _titleArr = [NSArray arrayWithObjects:@"01.purple", @"02.blue", @"03.yellow", nil];
    }
    return _titleArr;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
