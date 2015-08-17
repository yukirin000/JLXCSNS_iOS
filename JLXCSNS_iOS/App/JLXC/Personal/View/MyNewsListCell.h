//
//  MyNewsListCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@protocol MyNewsListDelegate <NSObject>

/*! 图片点击*/
- (void)imageClick:(NewsModel *)news index:(NSInteger)index;
/*! 点赞或者取消赞点击*/
- (void)likeClick:(NewsModel *)news likeOrCancel:(BOOL)flag;
/*! 删除该条状态*/
- (void)deleteNewsClick:(NewsModel *)news;

@end

/*! 新闻表格cell*/
@interface MyNewsListCell : UITableViewCell<UIActionSheetDelegate>


@property (nonatomic, weak) id<MyNewsListDelegate> delegate;

//是否是别人查看
@property (nonatomic, assign) BOOL isOther;

/*! 内容填充*/
- (void)setConentWithModel:(NewsModel *)news;

@end
