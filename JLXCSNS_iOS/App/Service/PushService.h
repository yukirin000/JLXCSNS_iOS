//
//  PushService.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/26.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsPushModel.h"

/*! 推送服务类*/
@interface PushService : NSObject

+(PushService *) sharedInstance;

//重新连接Push 重新登录的时候使用
- (void)pushReconnect;

//退出
- (void)logout;

/*!
    @brief 添加好友 推送通知发送
    @param topic 要推送的对象
 */
//-(void)pushAddFriendMessageWithTargetID:(NSString *)topic;

@end
