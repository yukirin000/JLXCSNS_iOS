//
//  TestListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "TestListViewController.h"
#import "PublishNewsViewController.h"
@interface TestListViewController ()

@end

@implementation TestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataArr addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"8",@"8",@"8",@"8"]];
    
//    [self setLeftSide];
}

//- (void)setLeftSide
//{
//    CusTabBarViewController * tab = (CusTabBarViewController *)self.tabBarController;
//    [tab setLeftBtnSlideWithNavBar:self.navBar];
//}

//iOS的一些渲染问题 需要在该生命周期的时候将navBar隐藏以便于使用定制Nav
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
}
//下拉刷新
- (void)refreshData
{
    [super refreshData];

    [self performSelector:@selector(handleData) withObject:nil afterDelay:2.0];
}
//加载更多
- (void)loadingData
{
    [super loadingData];
    self.isLastPage = YES;
    [self performSelector:@selector(handleData) withObject:nil afterDelay:2.0];
    
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestListViewController * t = [[TestListViewController alloc] init];
    [self pushVC:t];
}
- (void)handleTableViewContentWith:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = self.dataArr[indexPath.row];
}

#pragma mark- private method
- (void)handleData
{
    //如果是下拉刷新清空数据
    if (self.isReloading) {
         [self.dataArr removeAllObjects];
    }
    
    [self.dataArr addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"8",@"8",@"8",@"8"]];
    
    [self reloadTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
