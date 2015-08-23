//
//  RefreshViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshViewController.h"

@interface RefreshViewController ()<RefreshDataDelegate>

@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr     = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    [self createRefreshView];
}

#pragma mark- layout
#define kCellIdentifier @"RefreshCell"
- (void)createRefreshView
{
    self.refreshTableView                 = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight) style:UITableViewStylePlain];
    self.refreshTableView.delegate        = self;
    self.refreshTableView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    self.refreshTableView.dataSource      = self;
    self.refreshTableView.refreshDelegate = self;
    self.refreshTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;

//    [self.refreshTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.refreshTableView];
}

#pragma mark- RefreshDataDelegate
//下拉刷新
- (void)refreshData
{
    if (!self.isReloading) {
        self.currentPage = 1;
        self.isLastPage  = NO;
        [self.refreshTableView canLoadingMore];
        self.isReloading = YES;
    }else{
        return;
    }
    
}
//加载更多
- (void)loadingData
{
    if (self.isReloading) {
        return;
    }
    if (self.isLastPage) {
        return;
    }
    
    self.currentPage ++;
}

#pragma mark- UITableViewDelegate & UIScrollViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
//##############################定制cell类重写该方法##############################
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellid = [NSString stringWithFormat:@"%@%ld", kCellIdentifier, indexPath.row];
    UITableViewCell * cell = [self.refreshTableView dequeueReusableCellWithIdentifier:cellid];
    if (cell) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    [self handleTableViewContentWith:cell andIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //显示最后一行的时候 加载更多
    if (indexPath.row == self.dataArr.count-1) {
        if (self.isLastPage) {
            //最后一页不请求
            [self.refreshTableView isLastPage];
        }else{
            [self loadingData];
        }
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refreshTableView refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.refreshTableView refreshScrollViewDidEndDragging:scrollView];
}

#pragma mark- private method
- (void)handleTableViewContentWith:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)reloadTable
{
    if (self.isLastPage) {
        //最后一页
        [self.refreshTableView isLastPage];
    }
    self.isReloading = NO;
    [self.refreshTableView reloadData];
    [self.refreshTableView refreshFinish];
    
}

/*! 刷新完成*/
- (void) refreshFinish
{
    [self.refreshTableView refreshFinish];
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
