//
//  NewsMainViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsListViewController.h"
/*!
    状态流主页
 */
@interface NewsMainViewController : BaseViewController<UIScrollViewDelegate>

//放到外面提供侧滑
@property (nonatomic, strong) NewsListViewController * newsListVC;

@end
