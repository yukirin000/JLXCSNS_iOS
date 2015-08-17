//
//  RefreshViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"
#import "RefreshTableView.h"
@interface RefreshViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

/*! 内部刷新Table*/
@property (nonatomic, strong) RefreshTableView * refreshTableView;

/*! 正在刷新*/
@property (nonatomic, assign) BOOL isReloading;

/*! 数据源数组*/
@property (nonatomic, strong) NSMutableArray * dataArr;

/*! 当前页码*/
@property (nonatomic, assign) int currentPage;

/*! 是否是最后一页*/
@property (nonatomic, assign) BOOL isLastPage;

/*! 重写该方法重置table*/
- (void)createRefreshView;

/*! 重写该方法进行刷新网络请求*/
- (void)refreshData;
/*! 重写该方法进行加载更多网络请求*/
- (void)loadingData;

/*! 重写该方法定制Cell*/
- (void)handleTableViewContentWith:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath;

/*! 刷新table*/
- (void)reloadTable;

/*! 刷新完成*/
- (void) refreshFinish;

@end
