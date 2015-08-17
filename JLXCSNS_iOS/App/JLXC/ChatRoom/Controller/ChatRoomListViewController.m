//
//  ChatRoomListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChatRoomListViewController.h"
#import "ChatRoomCell.h"
#import "ChatRoomModel.h"
#import "CreateChatRoomViewController.h"
#import "ChatRoomDetailViewController.h"
#import "MyChatRoomListViewController.h"

@interface ChatRoomListViewController ()

@end

@implementation ChatRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshTableView.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight-kTabBarHeight);
    
    //发状态
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"创建" andBlock:^{
        CreateChatRoomViewController * ccrvc = [[CreateChatRoomViewController alloc] init];
        [sself pushVC:ccrvc];
    }];
    
    //我的聊天室
    [self.navBar.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.navBar setLeftBtnWithContent:@"我的" andBlock:^{
        MyChatRoomListViewController * mcrvc = [[MyChatRoomListViewController alloc] init];
        [sself pushVC:mcrvc];
    }];
    
    [self loadAndhandleData];
    
//    [self setLeftSide];
    
    [self registerNotify];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
//- (void)setLeftSide
//{
//    CusTabBarViewController * tab = (CusTabBarViewController *)self.tabBarController;
//    [tab setLeftBtnSlideWithNavBar:self.navBar];
//}

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
    ChatRoomDetailViewController * crdvc = [[ChatRoomDetailViewController alloc] init];
    crdvc.chatRoomModel                  = self.dataArr[indexPath.row];
    [self pushVC:crdvc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString * cellid   = [NSString stringWithFormat:@"%@%ld", @"chatroomList", indexPath.row];
    NSString * cellid   = @"chatroomListCell";
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
    
    NSString * url = [NSString stringWithFormat:@"%@?page=%d", kGetChatRoomListPath, self.currentPage];
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
//注册通知
- (void)registerNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createChatroom:) name:NOTIFY_CREATE_CHATROOM object:nil];
}
//新消息发布成功刷新页面
- (void)createChatroom:(NSNotification *)notify
{
    [self refreshData];
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
