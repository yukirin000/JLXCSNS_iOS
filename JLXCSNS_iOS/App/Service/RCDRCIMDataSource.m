//
//  RCDRCIMDelegateImplementation.m
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 胡利武. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "RCDRCIMDataSource.h"
#import "IMGroupModel.h"
#import "HttpService.h"

@interface RCDRCIMDataSource ()

@end

@implementation RCDRCIMDataSource

+ (RCDRCIMDataSource*)shareInstance
{
    static RCDRCIMDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //设置信息提供者
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
        //设置消息到达代理
        [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
        
        //连接融云
//        [self setIMToken:[UserService sharedService].user.im_token];
        //同步群组
        //        [self syncGroups];
        
        //注册通知
        [self registerNotify];
    }
    return self;
}

- (void)IMReconnect
{
    //连接融云
    [self setIMToken:[UserService sharedService].user.im_token];
}

- (void)setIMToken:(NSString *)imToken
{
    [[RCIM sharedRCIM] connectWithToken:imToken success:^(NSString *userId) {
        // Connect 成功
        debugLog(@"==================================Rong userID:%@", userId);
    } error:^(RCConnectErrorCode status) {
        // Connect失败
        debugLog(@"==================================Rong fail:%ld", status);
//        [self setIMToken:[UserService sharedService].user.im_token];
    } tokenIncorrect:^{
        [self setIMToken:[UserService sharedService].user.im_token];
    }];

}

- (void) closeClient
{
    [[RCIM sharedRCIM] disconnect];
}

-(void) syncGroups
{
    //开发者调用自己的服务器接口获取所属群组信息，同步给融云服务器，也可以直接
    //客户端创建，然后同步
//    [RCDHTTPTOOL getMyGroupsWithBlock:^(NSMutableArray *result) {
//        if ([result count]) {
//            //同步群组
//            [[RCIMClient sharedClient] syncGroups:result
//                                         completion:^{
//                //DebugLog(@"同步成功!");
//            } error:^(RCErrorCode status) {
//                //DebugLog(@"同步失败!  %ld",(long)status);
//                
//            }];
//        }
//    }];

}

#pragma mark - GroupInfoFetcherDelegate
//获取聊天室信息
- (void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup*))completion
{
    if ([groupId length] == 0)
        return completion(nil);
    
    //kGetChatRoomTitleAndBackPath
    NSString * url = [NSString stringWithFormat:@"%@?chatroom_id=%@",kGetChatRoomTitleAndBackPath, [groupId stringByReplacingOccurrencesOfString:JLXC_CHATROOM withString:@""]];
    debugLog(@"%@", url);
    //获取标题 背景图
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            NSDictionary * result = responseData[HttpResult];
            RCGroup * group       = [[RCGroup alloc] initWithGroupId:groupId groupName:result[@"chatroom_title"] portraitUri:[ToolsManager completeUrlStr:result[@"chatroom_background"]]];
            return completion(group);
            
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
    //如果没查到
    RCGroup * group = [[RCGroup alloc] initWithGroupId:groupId groupName:@"一个聊天室" portraitUri:nil];
    return completion(group);
}

#pragma mark - RCIMUserInfoFetcherDelegagte
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{

    
    if ([userId length] == 0)
        return completion(nil);
    else{
        
        //如果是自己
        if ([[ToolsManager getCommonGroupId:[UserService sharedService].user.uid] isEqualToString:userId]) {
            //头像代理
            RCUserInfo * usr = [[RCUserInfo alloc] initWithUserId:userId name:[UserService sharedService].user.name portrait:[ToolsManager completeUrlStr:[UserService sharedService].user.head_image]];
            return completion(usr);
        }
        
        //如果是别人
        IMGroupModel * group = [IMGroupModel findByGroupId:userId];
        //如果存在
        if (group) {
            //头像代理
            //备注
            NSString * name = [ToolsManager getRemarkOrOriginalNameWithUid:[[group.groupId stringByReplacingOccurrencesOfString:JLXC withString:@""] integerValue] andOriginalName:group.groupTitle];
            RCUserInfo * usr = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:[ToolsManager completeUrlStr:group.avatarPath]];
            //用旧的
            completion(usr);
        }else{
            //默认的
            RCUserInfo * usr = [[RCUserInfo alloc] initWithUserId:userId name:@"学僧" portrait:nil];
            completion(usr);
        }
        
        //网络请求获取新的
        NSString * url = [NSString stringWithFormat:@"%@?user_id=%@",kGetImageAndNamePath, [userId stringByReplacingOccurrencesOfString:JLXC withString:@""]];
        debugLog(@"%@", url);
        //获取图片 姓名
        [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
            
            int status = [responseData[HttpStatus] intValue];
            if (status == HttpStatusCodeSuccess) {
                
                NSDictionary * result = responseData[HttpResult];
                NSString * name = @"";
                //如果有这个好友
                if (group) {
                    group.groupTitle = result[@"name"];
                    group.avatarPath = result[@"head_image"];
                    //更新
                    [group update];
                }
                //聊天名
                name = [ToolsManager getRemarkOrOriginalNameWithUid:[[group.groupId stringByReplacingOccurrencesOfString:JLXC withString:@""] integerValue] andOriginalName:result[@"name"]];
                RCUserInfo * usr = [[RCUserInfo alloc] initWithUserId:userId name:name portrait:[ToolsManager completeUrlStr:result[@"head_image"]]];
                return completion(usr);
            }
            
        } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }

}


#pragma mark- RCIMReceiveMessageDelegate

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        
        //踢出聊天室
        RCContactNotificationMessage * nmessage = (RCContactNotificationMessage *)message.content;
        debugLog(@"newMessage。。。。。。。。。。。。。。。。。%@", nmessage.message);
        //被踢出前缀
        if ([nmessage.message hasPrefix:@"kick_"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_QUIT_CHATROOM object:nmessage.message];
        }
        
    }
    
    //顶部刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_REFRESH object:nil];
    
    //    if ([message.content isKindOfClass:[RCTextMessage class]]) {
    //        RCTextMessage * m = (RCTextMessage *)message.content;
    //        debugLog(@"!!!!!%@  %d", m.content, left);
    //    }
}

#pragma mark- private method
//注册通知
- (void)registerNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitChatroom:) name:NOTIFY_QUIT_CHATROOM object:nil];
    
}
//新消息发布成功刷新页面
- (void)quitChatroom:(NSNotification *)notify
{
    NSString * targetId = notify.object;
    if ([targetId hasPrefix:@"kick_"]) {
        targetId = [targetId stringByReplacingOccurrencesOfString:@"kick_" withString:@""];
    }
    
    //删除这个聊天室
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:targetId];
}


@end
