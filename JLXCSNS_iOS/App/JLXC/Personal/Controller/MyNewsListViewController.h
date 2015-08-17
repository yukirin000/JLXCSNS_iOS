//
//  MyNewsListViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshViewController.h"

@interface MyNewsListViewController : RefreshViewController

//如果是其他人看
@property (nonatomic, assign) BOOL isOther;
//其他人的id
@property (nonatomic, assign) NSInteger uid;

@end
