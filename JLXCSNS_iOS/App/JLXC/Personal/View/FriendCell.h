//
//  FriendCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"
#import "MyFriendsOrFansListViewController.h"

@protocol FriendOperateDelegate <NSObject>

- (void)attentBtnClickCall:(FriendModel *)friendModel;

@end

/* 好友cell*/
@interface FriendCell : UITableViewCell

@property (nonatomic, weak) id<FriendOperateDelegate> delegate;

//关注还是粉丝
@property (nonatomic, assign) RelationType type;

- (void)setContentWithModel:(FriendModel *)model;

@end
