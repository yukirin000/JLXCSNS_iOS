//
//  RefreshTableView.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshTableView.h"

@implementation RefreshTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.bottomLoading = @"努力加载中...>_<";
        self.notLoading    = @"对不起 没了...T_T";
        [self createHeaderView];
        [self createFootView];
        [self performSelector:@selector(refreshFinishedLoadData) withObject:nil afterDelay:0.0f];
    }
    
    return self;
}

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - 100,
                                     self.frame.size.width, 100)];
    _refreshHeaderView.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    _refreshHeaderView.delegate = self;
    
    [self addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)createFootView{
    
    UIView * footBackView        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth], 30)];
    footBackView.backgroundColor = [UIColor clearColor];
    _footLabel                   = [[CustomLabel alloc] initWithFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth], 30)];
    _footLabel.textAlignment     = NSTextAlignmentCenter;
    _footLabel.font              = [UIFont systemFontOfSize:13];
    _footLabel.textColor         = [UIColor lightGrayColor];
    _footLabel.backgroundColor   = [UIColor clearColor];
    _footLabel.text              = self.bottomLoading;
    [footBackView addSubview:_footLabel];

    self.tableFooterView         = footBackView;
}

- (void)canLoadingMore
{
    _footLabel.text              = self.bottomLoading;
}

- (void)isLastPage
{
    _footLabel.text              = self.notLoading;
}

-(void)refreshFinishedLoadData{
    
    [self finishReloadingData];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    _reloading = NO;
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }

}


-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    if (aRefreshPos == EGORefreshHeader)
    {
        if ([self.refreshDelegate respondsToSelector:@selector(refreshData)]) {
            [self performSelector:@selector(excuteDelegate) withObject:nil afterDelay:0.0];
        }else{
            [self performSelector:@selector(refreshFinish) withObject:nil afterDelay:0.0];
        }
    }

}

- (void)excuteDelegate
{
    [self.refreshDelegate performSelector:@selector(refreshData) withObject:nil];
}

//刷新调用的方法
-(void)refreshFinish
{
    [self refreshFinishedLoadData];
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    
    [self beginToReloadData:aRefreshPos];
    
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    
    return [NSDate date]; // should return date data source was last changed
    
}

- (void)refreshingTop
{
    if (_refreshHeaderView)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self setContentOffset:CGPointMake(0, -65)];
        } completion:^(BOOL finished) {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];        
        }];
    
    }
}



@end
