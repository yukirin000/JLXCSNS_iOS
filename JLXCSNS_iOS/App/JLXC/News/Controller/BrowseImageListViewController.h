//
//  BrowseImageListViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/4.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"


/*!
 查看图片列表的VC
 */
@interface BrowseImageListViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

//第几张
@property (nonatomic, assign) NSInteger num;

//数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@end
