//
//  RefreshTableView.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@protocol RefreshDataDelegate <NSObject>

/*! 调用该方法进行数据请求*/
- (void)refreshData;

@end

/*! 自定义刷新table*/
@interface RefreshTableView : UITableView<EGORefreshTableDelegate,UIScrollViewDelegate>
{
    EGORefreshTableHeaderView * _refreshHeaderView;
    BOOL _reloading;
}
//底部加载中提示
@property (nonatomic, copy) NSString * bottomLoading;
//底部没了提示
@property (nonatomic, copy) NSString * notLoading;

//底部footLabel
@property (nonatomic, strong) CustomLabel * footLabel;
//添加delegate
@property (nonatomic, assign) id <RefreshDataDelegate> refreshDelegate;

/*!
   @brief override
 */
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)refreshFinish;

- (void)canLoadingMore;

- (void)isLastPage;

- (void)refreshingTop;

@end
