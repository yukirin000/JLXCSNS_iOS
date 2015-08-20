//
//  FindUtils.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/8/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "FindUtils.h"

@implementation FindUtils

+ (void)addFriendWith:(IMGroupModel *)group
{
    IMGroupModel * newGroup = [IMGroupModel findByGroupId:group.groupId];
    //如果存在
    if (newGroup) {
        newGroup.groupTitle     = group.groupTitle;
        newGroup.avatarPath     = group.avatarPath;
        newGroup.currentState   = GroupHasAdd;
        [newGroup update];
    }else{
        //保存群组信息
        newGroup              = [[IMGroupModel alloc] init];
        newGroup.type         = ConversationType_PRIVATE;
        //targetId
        newGroup.groupId      = group.groupId;
        newGroup.groupTitle   = group.groupTitle;
        newGroup.isNew        = NO;
        newGroup.avatarPath   = group.avatarPath;
        newGroup.isRead       = YES;
        newGroup.currentState = GroupHasAdd;
        newGroup.owner        = [UserService sharedService].user.uid;
        [newGroup save];
    }
}

@end
