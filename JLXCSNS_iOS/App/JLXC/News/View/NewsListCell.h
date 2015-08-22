//
//  NewsListCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/17.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@protocol NewsListDelegate <NSObject>

@optional
/*! 图片点击*/
- (void)imageClick:(NewsModel *)news index:(NSInteger)index;
///*! 删除评论*/
//- (void)deleteCommentClick:(NewsModel *)news index:(NSInteger)index;
/*! 发送评论*/
- (void)sendCommentClick:(NewsModel *)news;
/*! 点赞或者取消赞点击*/
- (void)likeClick:(NewsModel *)news likeOrCancel:(BOOL)flag;
/*! 删除该条状态*/
- (void)deleteNewsClick:(NewsModel *)news;

@end

/*! 新闻表格cell*/
@interface NewsListCell : UITableViewCell<UIActionSheetDelegate>


@property (nonatomic, weak) id<NewsListDelegate> delegate;

/*! 内容填充*/
- (void)setConentWithModel:(NewsModel *)news;

@end
