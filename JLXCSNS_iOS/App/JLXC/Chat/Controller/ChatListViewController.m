//
//  ChatListViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/27.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "IMGroupModel.h"
#import "ChatRoomChatController.h"
@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];

    self.conversationListTableView.frame = CGRectMake(0, 0, [DeviceManager getDeviceWidth], [DeviceManager getDeviceHeight]-kNavBarAndStatusHeight-kTabBarHeight);
    
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TAB_BADGE object:nil];
    //顶部消息通知未读提示更新
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_REFRESH object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- override
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    //私聊
    if (model.conversationType == ConversationType_PRIVATE) {
        ChatViewController *conversationVC = [[ChatViewController alloc]init];
        conversationVC.conversationType    = model.conversationType;
        conversationVC.targetId            = model.targetId;
        conversationVC.userName          = model.conversationTitle;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    
    //聊天室
    if (model.conversationType == ConversationType_GROUP) {
//        RCTextMessage * tm = [[RCTextMessage alloc] init];
//        tm.content = @"hahaha";
//        [[RCIMClient sharedClient] sendMessage:ConversationType_GROUP targetId:model.targetId content:tm pushContent:nil success:^(long messageId) {
//    
//        } error:^(RCErrorCode nErrorCode, long messageId) {
//            
//        }];
        
        ChatRoomChatController *conversationVC = [[ChatRoomChatController alloc]init];
        conversationVC.conversationType        = model.conversationType;
        conversationVC.targetId                = model.targetId;
        conversationVC.userName              = model.conversationTitle;

        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    
}

- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RCConversationBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[RCConversationBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"gaga"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gaga"];
//    }
//
//    RCConversationModel * model = self.conversationListDataSource[indexPath.row];
//    debugLog(@"!!!!!!!%@", model.targetId);
//    RCTextMessage * textM = (RCTextMessage *)model.lastestMessage;
////    RCMessageModel * msg = model.lastestMessage;
//    cell.textLabel.text = textM.content;
//    
//    NSInteger unreadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:model.conversationType targetId:model.targetId];
//    debugLog(@"!!!!!!%ld", unreadCount);
//    
//    return cell;
//}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    RCConversationModel * model = self.conversationListDataSource[indexPath.row];
//    debugLog(@"!!!!!!!%@", model.targetId);
    
//    RCConversationCell * ccell       = (RCConversationCell *)cell;
//
//    RCMessageBubbleTipView * tipView = [[RCMessageBubbleTipView alloc] init];
//    ccell.bubbleTipView              = tipView;
//    
//    NSInteger unreadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:cell.model.conversationTitle];
//    debugLog(@"%ld", unreadCount);
    
//    tipView.backgroundColor = [UIColor redColor];
//    tipView.bubbleTipText = @"11";

    
//    ccell.portraitStyle = RC_USER_AVATAR_RECTANGLE
//    [ccell setHeaderImagePortraitStyle:RC_USER_AVATAR_RECTANGLE];
}


- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    
    return dataSource;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TAB_BADGE object:nil];
}

#pragma mark- private method

- (void)notifyUpdateUnReadMessageCount
{
    
    //    NSInteger count = [[RCIMClient sharedClient]getUnreadCount: @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
    NSInteger count = [[RCIMClient sharedRCIMClient]getUnreadCount: @[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
    debugLog(@"unread:%ld", count);
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TAB_BADGE object:nil];
    
}

- (void)didReceiveMessageNotification:(NSNotification *)notification
{
    
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        RCContactNotificationMessage * nmessage = (RCContactNotificationMessage *)message.content;
        if ([nmessage.message hasPrefix:@"kick_"]) {
            return;
        }
    }

        //调用父类刷新未读消息数
    [super didReceiveMessageNotification:notification];
    //调用父类刷新未读消息数
    [self notifyUpdateUnReadMessageCount];
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
