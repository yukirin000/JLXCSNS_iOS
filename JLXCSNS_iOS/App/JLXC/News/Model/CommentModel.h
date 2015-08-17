//
//  CommentModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/16.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 评论模型*/
@interface CommentModel : NSObject

/*! 评论id*/
@property (nonatomic, assign) NSInteger cid;

/*! 新闻id*/
@property (nonatomic, assign) NSInteger news_id;

/*! 评论内容*/
@property (nonatomic, copy) NSString * comment_content;

/*! 评论用户id*/
@property (nonatomic, assign) NSInteger user_id;

/*! 评论用户姓名*/
@property (nonatomic, copy) NSString * name;

/*! 评论用户头像*/
@property (nonatomic, copy) NSString * head_image;

/*! 评论用户头像缩略图*/
@property (nonatomic, copy) NSString * head_sub_image;

/*! 点赞次数*/
@property (nonatomic, assign) CGFloat like_quantity;

/*! 二级评论数组*/
@property (nonatomic, strong) NSMutableArray * second_comments;

/*! 添加时间*/
@property (nonatomic, copy) NSString * add_date;

- (void)setContentWithDic:(NSDictionary *)commentDic;

@end
