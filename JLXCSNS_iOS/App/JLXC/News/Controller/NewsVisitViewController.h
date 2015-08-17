//
//  NewsVisitViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/2.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshViewController.h"

/*! 该状态最近来访list*/
@interface NewsVisitViewController : RefreshViewController

/*! 状态id*/
@property (nonatomic, assign) NSInteger newsId;

@end
