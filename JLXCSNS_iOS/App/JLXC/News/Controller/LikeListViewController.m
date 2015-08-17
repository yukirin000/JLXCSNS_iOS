//
//  LikeListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "LikeListViewController.h"
#import "OtherPersonalViewController.h"
#import "LikeListCell.h"
#import "LikeModel.h"

@interface LikeListViewController ()

@end

@implementation LikeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    
    [self loadAndhandleData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
#pragma override
//下拉刷新
- (void)refreshData
{
    [super refreshData];
    [self loadAndhandleData];
}
//加载更多
- (void)loadingData
{
    [super loadingData];
    [self loadAndhandleData];
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
    LikeModel * model                 = self.dataArr[indexPath.row];
    opvc.uid                           = model.user_id;
    [self pushVC:opvc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellid = [NSString stringWithFormat:@"%@%ld", @"likeList", indexPath.row];
    LikeListCell * cell = [self.refreshTableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[LikeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell setContentWithModel:self.dataArr[indexPath.row]];
    return cell;
}

#pragma mark- method response

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&size=20&news_id=%ld", kGetNewsLikeListPath, self.currentPage, self.news_id];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
            }
            self.isLastPage = [responseData[HttpResult][@"is_last"] boolValue];
            NSArray * list = responseData[HttpResult][HttpList];
            //数据处理
            for (NSDictionary * likeDic in list) {
                LikeModel * model    = [[LikeModel alloc] init];
                model.user_id        = [likeDic[@"user_id"] integerValue];
                model.name           = likeDic[@"name"];
                model.head_sub_image = likeDic[@"head_sub_image"];
                [self.dataArr addObject:model];
            }
            [self reloadTable];
        }else{
            [self showWarn:responseData[HttpMessage]];
            self.isReloading = NO;
            [self.refreshTableView refreshFinish];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isReloading = NO;
        [self.refreshTableView refreshFinish];
        [self showWarn:StringCommonNetException];
    }];
    
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
