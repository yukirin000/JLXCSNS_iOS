//
//  OtherAttentOrFansViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "OtherAttentOrFansViewController.h"
#import "FriendModel.h"
#import "OtherFriendCell.h"
#import "OtherPersonalViewController.h"
#import "IMGroupModel.h"
#import "FindUtils.h"
#import "YSAlertView.h"

@interface OtherAttentOrFansViewController ()<FriendOperateDelegate>

@end

@implementation OtherAttentOrFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == RelationAttentType) {
        [self setNavBarTitle:@"TA关注的人 (●´ω｀●)φ"];
    }else{
        [self setNavBarTitle:@"关注TA的人 (●´ω｀●)φ"];
    }
    
    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    
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
    FriendModel * model     = self.dataArr[indexPath.row];
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
    OtherFriendCell * cell = [self.refreshTableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell          = [[OtherFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.type     = self.type;
        cell.delegate = self;
    }
    [cell setContentWithModel:self.dataArr[indexPath.row]];
    return cell;
}

#pragma mark- FriendOperateDelegate
- (void)attentBtnClickCall:(FriendModel *)friendModel
{
    //关注或者取消关注
    if (friendModel.isOrHasAttent == YES) {
        [self deleteFriendAlert:friendModel];
    }else{
        [self addFriendCommit:friendModel];
    }
}

#pragma mark- method response
- (void)deleteFriendAlert:(FriendModel *)friendModel
{
    //删除
    YSAlertView * alert = [[YSAlertView alloc] initWithTitle:[NSString stringWithFormat:@"确认要删除%@吗？", friendModel.name] contentText:@"TA将消失在你的好友列表" leftButtonTitle:StringCommonConfirm rightButtonTitle:StringCommonCancel showView:self.view];
    [alert setLeftBlock:^{
        [self deleteFriendCommit:friendModel];
    }];
    [alert show];
}


//添加好友
- (void)addFriendCommit:(FriendModel *)friendModel
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", friendModel.uid]
                              };
    
    debugLog(@"%@ %@", kAddFriendPath, params);
    [self showLoading:@"添加中^_^"];
    //添加好友
    [HttpService postWithUrlString:kAddFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            
            IMGroupModel * model = [[IMGroupModel alloc] init];
            model.groupId = [ToolsManager getCommonGroupId:friendModel.uid];
            model.groupTitle = friendModel.name;
            model.groupTitle = friendModel.head_image;
            [FindUtils addFriendWith:model];
            //添加成功
            [self showComplete:responseData[HttpMessage]];
            friendModel.isOrHasAttent = YES;
            //页面刷新
            [self.refreshTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.dataArr indexOfObject:friendModel] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}
//删除好友
- (void)deleteFriendCommit:(FriendModel *)friendModel
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", friendModel.uid]
                              };
    
    debugLog(@"%@ %@", kDeleteFriendPath, params);
    [self showLoading:@"删除中"];
    //添加好友
    [HttpService postWithUrlString:kDeleteFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            //删除成功
            [self showComplete:responseData[HttpMessage]];
            //清除会话
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:[ToolsManager getCommonGroupId:friendModel.uid]];
            //关注删除 粉丝更新状态
            friendModel.isOrHasAttent = NO;
            [self.refreshTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.dataArr indexOfObject:friendModel] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d&size=20&self_user_id=%ld&target_user_id=%ld", kGetOtherAttentListPath, self.currentPage, [UserService sharedService].user.uid, self.userId];
    if (self.type == RelationFansType) {
        url = [NSString stringWithFormat:@"%@?page=%d&size=20&self_user_id=%ld&target_user_id=%ld", kGetOtherFansListPath, self.currentPage, [UserService sharedService].user.uid, self.userId];
    }
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
            for (NSDictionary * attentDic in list) {
                FriendModel * model  = [[FriendModel alloc] init];
                model.uid            = [attentDic[@"uid"] integerValue];
                model.name           = attentDic[@"name"];
                model.head_sub_image = attentDic[@"head_sub_image"];
                model.school         = attentDic[@"school"];
                model.isOrHasAttent  = [attentDic[@"isAttent"] boolValue];
                
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
