//
//  PushService.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/26.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "PushService.h"
#import "YunBaService.h"
#import "IMGroupModel.h"


@implementation PushService

static PushService *_shareInstance=nil;

+(PushService *) sharedInstance
{
    if(!_shareInstance) {
        _shareInstance=[[PushService alloc] init];
    }
    
    return _shareInstance;
}

-(id)init
{
    self = [super init];
    if (self) {

        [self registerNotify];
        
//        [self initYunBa];
    }
    return self;
}
- (void)pushReconnect
{
    [self initYunBa];
}

#pragma mark- 通知部分
- (void)registerNotify
{
    NSNotificationCenter *defaultNC = [NSNotificationCenter defaultCenter];
    [defaultNC addObserver:self selector:@selector(onConnectionStateChanged:) name:kYBConnectionStatusChangedNotification object:nil];
    [defaultNC addObserver:self selector:@selector(onMessageReceived:) name:kYBDidReceiveMessageNotification object:nil];
}

- (void)onConnectionStateChanged:(NSNotification *)notification {
    if ([YunBaService isConnected]) {
        debugLog(@"didConnect");
    } else {
        debugLog(@"didDisconnected");
    }
}

- (void)onMessageReceived:(NSNotification *)notification {
    YBMessage *message = [notification object];
    //如果不是自己订阅的则不接收
    if (![[message topic] isEqualToString:[ToolsManager getCommonGroupId:[UserService sharedService].user.uid]]) {
        return;
    }
    
    debugLog(@"new message, %zu bytes, topic=%@", (unsigned long)[[message data] length], [message topic]);
    NSString *payloadString = [[NSString alloc] initWithData:[message data] encoding:NSUTF8StringEncoding];
    debugLog(@"data: %@", payloadString);
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:message.data options:NSJSONReadingMutableContainers error:nil];
    
    NSInteger type = [dic[@"type"] intValue];
    
    switch (type) {
        //如果是添加好友信息
        case PushAddFriend:
            [self handleNewFriend:dic];
            break;
            //如果是状态回复消息
        case PushNewsAnwser:
            [self handleNewsPush:dic];
            break;
            //如果是二级回复消息
        case PushSecondComment:
            [self handleNewsPush:dic];
            break;
            //如果是点赞
        case PushLikeNews:
            [self handleNewsPush:dic];
            break;
            
        default:
            break;
    }
    
}

#pragma mark- private method
//初始化 订阅消息
- (void)initYunBa
{
    
    //订阅自己
    NSString * topic = [ToolsManager getCommonGroupId:[UserService sharedService].user.uid];
    [YunBaService subscribe:topic resultBlock:^(BOOL succ, NSError *error) {
        debugLog(@"==================================yunba Subscribe:%d %@", succ, topic);
        [YunBaService getTopicList:^(NSArray *res, NSError *error) {
            debugLog(@"yunba topic: %@", res);
        }];
    }];
}

//添加好友 推送发送 弃用
//- (void)pushAddFriendMessageWithTargetID:(NSString *)topic
//{
//    //添加好友
//    NSDictionary * publishDic = @{@"type":[NSString stringWithFormat:@"%d", PushAddFriend],
//                                  @"uid":[ToolsManager getCommonGroupId:[UserService sharedService].user.uid],
//                                  @"name":[UserService sharedService].user.name,
//                                  @"avatar":[UserService sharedService].user.head_image,
//                                  @"content":@""
//                                  };
//    
//    NSData * data =[NSJSONSerialization dataWithJSONObject:publishDic options:NSJSONWritingPrettyPrinted error:nil];
//
//    [YunBaService publish:topic data:data option:[YBPublishOption optionWithQos:kYBQosLevel2 retained:YES] resultBlock:^(BOOL succ, NSError *error) {
//        debugLog(@"publish:%@ %d", topic, succ);
//    }];
//
//}
/*!
 @brief 回复状态消息通知
 @param topic 要推送的对象
 */
-(void)pushNewsAnwserMessageWithTargetID:(NSString *)topic
{

//    NSDictionary * publishDic = @{@"type":[NSString stringWithFormat:@"%d", PushNewsAnwser]};
//    NSData * data =[NSJSONSerialization dataWithJSONObject:publishDic options:NSJSONWritingPrettyPrinted error:nil];
//    [YunBaService publish:topic data:data option:[YBPublishOption optionWithQos:kYBQosLevel2 retained:YES] resultBlock:^(BOOL succ, NSError *error) {
//        debugLog(@"publish:%@ %d", topic, succ);
//    }];
}


//通知处理
//处理新好友通知
- (void)handleNewFriend:(NSDictionary *)dic
{
    
    NSDictionary * pushDic = dic[@"content"];
    IMGroupModel * group = [IMGroupModel findByGroupId:pushDic[@"uid"]];
    
    if (group) {
        //如果没加好友 但是有新朋友
        if (group.currentState == GroupNotAdd) {
            group.isNew = YES;
            [group update];
        }else{
            //发送通知
            //                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ADD_GROUP object:group];
        }
    }else{
        //保存群组信息
        group = [[IMGroupModel alloc] init];
        group.type           = [pushDic[@"type"] intValue];
        //targetId
        group.groupId        = pushDic[@"uid"];
        group.groupTitle     = pushDic[@"name"];
        group.avatarPath     = pushDic[@"avatar"];
        group.addDate        = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
        group.isNew          = YES;
        group.currentState   = GroupNotAdd;
        group.isRead         = NO;
        group.owner          = [UserService sharedService].user.uid;
        [group save];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEW_GROUP object:group];
        //顶部刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_REFRESH object:nil];
    }

    //徽标跟新
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TAB_BADGE object:nil];

}

//新闻回复点赞到来 处理消息
- (void)handleNewsPush:(NSDictionary *)dic
{
    NSDictionary * pushDic = dic[@"content"];
    
    //存储
    NewsPushModel * push = [[NewsPushModel alloc] init];
    push.uid             = [pushDic[@"uid"] integerValue];
    push.name            = pushDic[@"name"];
    push.head_image      = pushDic[@"head_image"];
    push.comment_content = pushDic[@"comment_content"];
    push.type            = [dic[@"type"] integerValue];
    push.news_id         = [pushDic[@"news_id"] integerValue];
    push.news_content    = pushDic[@"news_content"];
    push.news_image      = pushDic[@"news_image"];
    push.news_user_name  = pushDic[@"news_user_name"];
    push.is_read         = NO;
    push.push_time       = pushDic[@"push_time"];
    [push save];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEWS_PUSH object:nil];
    //徽标跟新
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TAB_BADGE object:nil];
    //顶部刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_REFRESH object:nil];

}

////处理消息回复
//- (void)handleNewsAnwser:(NSDictionary *)dic
//{
//    //发送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEWS_PUSH object:nil];
//}
//
////二级评论推送
//- (void)handleSecondComment:(NSDictionary *)dic
//{
//    //发送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEWS_PUSH object:nil];
//}
//
////点赞推送
//- (void)handleLikeNews:(NSDictionary *)dic
//{
//    //发送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEWS_PUSH object:nil];
//}



@end
