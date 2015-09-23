//
//  OtherFriendCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"
#import "MyFriendsOrFansListViewController.h"
#import "FriendCell.h"

/* 好友cell*/
@interface OtherFriendCell : UITableViewCell

@property (nonatomic, weak) id<FriendOperateDelegate> delegate;

//关注还是粉丝
@property (nonatomic, assign) RelationType type;

- (void)setContentWithModel:(FriendModel *)model;
@end
