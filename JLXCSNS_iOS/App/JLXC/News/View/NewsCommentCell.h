//
//  NewsCommentCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/19.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "SecondCommentModel.h"
@protocol NewsCommentDelegate <NSObject>

/*! 删除评论*/
- (void)deleteCommentClick:(CommentModel *)comment;

/*! 删除二级评论*/
- (void)deleteSecondCommentClick:(SecondCommentModel *)secondCommentModel andComment:(CommentModel *)comment;

/*! 回复评论*/
- (void)replyComment:(SecondCommentModel *)comment andTopComment:(CommentModel *)comment;

@end

/*! 评论cell*/
@interface NewsCommentCell : UITableViewCell<UIActionSheetDelegate>


@property (nonatomic, weak) id<NewsCommentDelegate> delegate;

/*! 内容填充*/
- (void)setConentWithModel:(CommentModel *)comment;

@end
