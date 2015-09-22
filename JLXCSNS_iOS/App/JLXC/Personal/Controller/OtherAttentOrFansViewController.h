//
//  OtherAttentOrFansViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshViewController.h"
#import "MyFriendsOrFansListViewController.h"


@interface OtherAttentOrFansViewController : RefreshViewController

//是关注或者粉丝
@property (nonatomic, assign) RelationType type;

@end
