//
//  MyFriendsListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/8/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "MyFriendsListViewController.h"
#import "OtherPeopleFriendModel.h"
#import "OtherPeopleFriendCell.h"
#import "OtherPersonalViewController.h"
#import "IMGroupModel.h"

@interface MyFriendsListViewController ()

//@property (nonatomic, strong) CustomLabel * currentCommentLabel;

@end

@implementation MyFriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.revealSideViewController.delegate = self;
    
    [self setNavBarTitle:@"我的小伙伴  (●´ω｀●)φ"];
    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    
    [self syncFriends];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super refreshData];
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
    OtherPeopleFriendModel * model     = self.dataArr[indexPath.row];
    opvc.uid                           = model.uid;
    [self pushVC:opvc];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellid = [NSString stringWithFormat:@"%@%ld", @"friendsList", indexPath.row];
    OtherPeopleFriendCell * cell = [self.refreshTableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[OtherPeopleFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell setContentWithModel:self.dataArr[indexPath.row]];
    return cell;
}

#pragma mark- method response

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&user_id=%ld&size=20", kGetFriendsListPath, self.currentPage, [UserService sharedService].user.uid];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
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
                OtherPeopleFriendModel * model = [[OtherPeopleFriendModel alloc] init];
                model.uid                      = [visitDic[@"uid"] integerValue];
                model.name                     = visitDic[@"name"];
                model.head_sub_image           = visitDic[@"head_sub_image"];
                model.school                   = visitDic[@"school"];
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


//同步好友
- (void)syncFriends
{
    
    NSInteger friendsCount = [IMGroupModel findHasAddAll].count;
    NSString * path = [NSString stringWithFormat:@"%@?user_id=%ld&friends_count=%ld", kNeedSyncFriendsPath, [UserService sharedService].user.uid, friendsCount];
    //    debugLog(@"%@", path);
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            BOOL needUpdate = [responseData[HttpResult][@"needUpdate"] boolValue];
            if (needUpdate) {
                [self getFriendsList];
            }
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取好友列表
- (void)getFriendsList
{
    NSString * path = [NSString stringWithFormat:@"%@?user_id=%ld", kGetAllFriendsListPath, [UserService sharedService].user.uid];
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            NSArray * friendsList = responseData[HttpResult][HttpList];
            for (NSDictionary * friendDic in friendsList) {
                IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:[friendDic[@"uid"] intValue]]];
                if (group != nil) {
                    
                    group.groupTitle     = friendDic[@"name"];
                    group.avatarPath     = friendDic[@"head_image"];
                    group.groupRemark    = friendDic[@"friend_remark"];
                    group.currentState   = GroupHasAdd;
                    [group update];
                    
                }else{
                    
                    group = [[IMGroupModel alloc] init];
                    group.type           = ConversationType_PRIVATE;
                    //targetId
                    group.groupId        = [ToolsManager getCommonGroupId:[friendDic[@"uid"] intValue]];
                    group.groupTitle     = friendDic[@"name"];
                    group.isNew          = NO;
                    group.avatarPath     = friendDic[@"head_image"];
                    group.groupRemark    = friendDic[@"friend_remark"];
                    group.isRead         = YES;
                    group.currentState   = GroupHasAdd;
                    group.owner          = [UserService sharedService].user.uid;
                    [group save];
                }
                
            }
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
