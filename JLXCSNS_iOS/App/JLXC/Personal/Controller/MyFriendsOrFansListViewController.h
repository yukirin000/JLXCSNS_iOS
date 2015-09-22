//
//  MyFriendsListViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/8/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshViewController.h"

typedef NS_ENUM(NSInteger, RelationType) {
    //关注类型
    RelationAttentType = 1,
    //粉丝类型
    RelationFansType = 2
};

//我的好友或者粉丝列表
@interface MyFriendsOrFansListViewController : RefreshViewController

//是关注或者粉丝
@property (nonatomic, assign) RelationType type;

@end
