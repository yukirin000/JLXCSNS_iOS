//
//  VisitListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/1.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//


#import "VisitListViewController.h"
#import "VisitModel.h"
#import "VisitListCell.h"
#import "OtherPersonalViewController.h"

@interface VisitListViewController ()

//@property (nonatomic, strong) CustomLabel * currentCommentLabel;

@end

@implementation VisitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.revealSideViewController.delegate = self;
    
    [self configUI];
    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    [self loadAndhandleData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)configUI
{
    //如果是自己
    if (self.uid == [UserService sharedService].user.uid) {
        [self setNavBarTitle:@"谁来看过我 (●´ω｀●)φ"];
    }else {
        [self setNavBarTitle:@"谁来看过TA (●´ω｀●)φ"];
    }
}

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
    VisitModel * model                 = self.dataArr[indexPath.row];
    opvc.uid                           = model.uid;
    [self pushVC:opvc];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellid = [NSString stringWithFormat:@"%@%ld", @"visitList", indexPath.row];
    VisitListCell * cell = [self.refreshTableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[VisitListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell setContentWithModel:self.dataArr[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UserService sharedService].user.uid == self.uid) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteVisitModel:self.dataArr[indexPath.row]];
}

#pragma mark- method response

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&uid=%ld", kGetVisitListPath, self.currentPage, self.uid];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
            debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            //下拉刷新清空数组
            if (self.isReloading) {
                [self.dataArr removeAllObjects];
            }
            self.isLastPage = [responseData[HttpResult][@"is_last"] boolValue];
            NSArray * list = responseData[HttpResult][HttpList];
            //数据处理
            for (NSDictionary * visitDic in list) {
                VisitModel * model   = [[VisitModel alloc] init];
                model.uid            = [visitDic[@"uid"] integerValue];
                model.name           = visitDic[@"name"];
                model.head_sub_image = visitDic[@"head_sub_image"];
                model.visit_time     = visitDic[@"visit_time"];
                model.sign           = visitDic[@"sign"];
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

- (void)deleteVisitModel:(VisitModel *)model
{
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"current_id":[NSString stringWithFormat:@"%ld", model.uid]};
    
    debugLog(@"%@ %@", kDeleteVisitPath, params);
    [self showLoading:@"删除中"];
    [HttpService postWithUrlString:kDeleteVisitPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            [self showComplete:responseData[HttpMessage]];
            [self.dataArr removeObject:model];
            [self.refreshTableView reloadData];
            
        }else{
            [self.dataArr removeObject:model];            
            [self showWarn:responseData[HttpMessage]];
            [self.refreshTableView reloadData];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
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


