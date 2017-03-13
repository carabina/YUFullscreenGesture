//
//  HomeViewController.m
//  YUFullscreenGestureDemo
//
//  Created by 马裕博 on 2017/3/13.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "HomeViewController.h"
#import "FirstFirstVC.h"
#import "SecondFirstVC.h"
#import "ThirdFirstVC.h"

@interface HomeViewController ()
/** 标题 */
@property (nonatomic, strong) NSMutableArray *titleArrM;
@end

@implementation HomeViewController

- (NSMutableArray *)titleArrM {
    if (_titleArrM == nil) {
        _titleArrM =
        [NSMutableArray arrayWithObjects:@"1.Push a VC with bar",
                                         @"2.Push a VC without bar",
                                         @"3.Push a VC with scrollView",
                                         nil];
    }
    return _titleArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"YUFullscreenGesture";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArrM[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            FirstFirstVC *firstFirst = [[FirstFirstVC alloc] init];
            [self.navigationController pushViewController:firstFirst animated:YES];
        }
            break;
        case 1:
        {
            SecondFirstVC *secondFirst = [[SecondFirstVC alloc] init];
            [self.navigationController pushViewController:secondFirst animated:YES];
        }
            break;
        case 2:
        {
            ThirdFirstVC *thirdFirst = [[ThirdFirstVC alloc] init];
            [self.navigationController pushViewController:thirdFirst animated:YES];
        }
            break;
            
        default:
            break;
    }
}



@end
