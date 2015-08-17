//
//  SendCommentViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/16.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentModel.h"
typedef void(^CommentSuccessBlock) (CommentModel * comment);

/*! 发送评论VC*/
@interface SendCommentViewController : BaseViewController<UITextViewDelegate>

/*! 新闻的id*/
@property (nonatomic, assign) NSInteger nid;

/*! 设置Block*/
- (void)setCommentSuccessBlock:(CommentSuccessBlock)block;

///*! 是否是二级评论*/
//@property (nonatomic, assign) BOOL isSecond;
//
///*! 二级评论的id*/
//@property (nonatomic, assign) NSInteger comment_id;

@end
