//
//  MyChatRoomListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "MyChatRoomListViewController.h"
#import "ChatRoomCell.h"
#import "ChatRoomModel.h"
#import "CreateChatRoomViewController.h"
#import "ChatRoomDetailViewController.h"
#import "MyChatRoomListViewController.h"
#import "ChatRoomChatController.h"
@interface MyChatRoomListViewController ()

@end

@implementation MyChatRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshTableView.frame            = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight-kTabBarHeight);
    self.refreshTableView.footLabel.hidden = YES;
    
    //发状态
//    __weak typeof(self) sself = self;
//    [self.navBar setRightBtnWithContent:@"创建" andBlock:^{
//        CreateChatRoomViewController * ccrvc = [[CreateChatRoomViewController alloc] init];
//        [sself pushVC:ccrvc];
//    }];
//    
//    //我的聊天室
//    [self.navBar.leftBtn setImage:nil forState:UIControlStateNormal];
//    [self.navBar setLeftBtnWithContent:@"我的" andBlock:^{
//        MyChatRoomListViewController * mcrvc = [[MyChatRoomListViewController alloc] init];
//        [sself pushVC:mcrvc];
//    }];
    
    [self loadAndhandleData];
    
    //    [self setLeftSide];
    
    [self registerNotify];
    
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
//    ChatRoomDetailViewController * crdvc = [[ChatRoomDetailViewController alloc] init];
//    crdvc.chatRoomModel                  = self.dataArr[indexPath.row];
//    [self pushVC:crdvc];
    
    ChatRoomModel * chatRoomModel = self.dataArr[indexPath.row];
    NSInteger leftTimeInterval = chatRoomModel.chatroom_create_time.integerValue+chatRoomModel.chatroom_duration.integerValue-[[NSDate date] timeIntervalSince1970];
    if (leftTimeInterval<0) {
        [self showWarn:@"这个聊天室到点了=_="];
        return;
    }
    
    //进入页面
    ChatRoomChatController *conversationVC = [[ChatRoomChatController alloc]init];
    conversationVC.conversationType        = ConversationType_GROUP;
    conversationVC.targetId                = [ToolsManager getChatroomIMId:chatRoomModel.cid];
    conversationVC.userName              = chatRoomModel.chatroom_title;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    NSString * cellid   = [NSString stringWithFormat:@"%@%ld", @"chatroomList", indexPath.row];
    NSString * cellid   = @"myChatroomListCell";
    ChatRoomCell * cell = [self.refreshTableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell            = [[ChatRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    ChatRoomModel * crm = self.dataArr[indexPath.row];
    [cell setContentWithModel:crm];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CutImageHeight;
}

#pragma mark- method response

#pragma mark- private method
- (void)loadAndhandleData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?user_id=%ld&page=%d", kGetMyChatRoomListPath, [UserService sharedService].user.uid,self.currentPage];
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
            NSArray * list  = responseData[HttpResult][HttpList];
            //数据处理
            for (NSDictionary * roomDic in list) {
                ChatRoomModel * crm      = [[ChatRoomModel alloc] init];
                crm.chatroom_title       = roomDic[@"chatroom_title"];
                crm.chatroom_background  = roomDic[@"chatroom_background"];
                crm.max_quantity         = [roomDic[@"max_quantity"] integerValue];
                crm.current_quantity     = [roomDic[@"current_quantity"] integerValue];
                crm.chatroom_create_time = roomDic[@"chatroom_create_time"];
                crm.cid                  = [roomDic[@"id"] integerValue];
                crm.chatroom_duration    = roomDic[@"chatroom_duration"];
                crm.user_id              = [roomDic[@"user_id"] integerValue];
                for (NSDictionary * tagDic in roomDic[@"tags"]) {
                    [crm.tagArr addObject:tagDic[@"tag_content"]];
                }
                
                [self.dataArr addObject:crm];
            }
            
            [self reloadTable];
        }else{
            self.isReloading = NO;
            [self.refreshTableView refreshFinish];
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isReloading = NO;
        [self.refreshTableView refreshFinish];
        [self showWarn:StringCommonNetException];
    }];
    
}
//注册通知
- (void)registerNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitChatroom:) name:NOTIFY_QUIT_CHATROOM object:nil];

}
//新消息发布成功刷新页面
- (void)quitChatroom:(NSNotification *)notify
{
    NSInteger targetId = [[notify.object stringByReplacingOccurrencesOfString:JLXC_CHATROOM withString:@""] integerValue];
    
    for (ChatRoomModel * model in self.dataArr) {
        if (model.cid == targetId) {
            [self.dataArr removeObject:model];
            [self.refreshTableView reloadData];
            break;
        }
    }
    
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
