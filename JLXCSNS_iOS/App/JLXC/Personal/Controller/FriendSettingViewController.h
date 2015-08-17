//
//  FriendSettingViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/30.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

/*! 好友设置界面*/
@interface FriendSettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

/*! 要删除的id*/
@property (nonatomic, assign) NSInteger friendId;

/*! 要删除的人名*/
@property (nonatomic, copy) NSString * deleteName;

@end
