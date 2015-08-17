//
//  CommonFriendsListViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/2.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

/*! 共同的好友列表*/
@interface CommonFriendsListViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>

/*! 用户id*/
@property (nonatomic, assign) NSInteger uid;

@end
