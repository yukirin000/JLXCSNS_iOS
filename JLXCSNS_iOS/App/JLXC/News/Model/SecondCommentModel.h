//
//  SecondCommentModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/19.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 二级评论模型*/
@interface SecondCommentModel : NSObject

/*! 该条评论id*/
@property (nonatomic, assign) NSInteger scid;

/*! 评论内容*/
@property (nonatomic, copy) NSString * comment_content;

/*! 新闻用户id*/
@property (nonatomic, assign) NSInteger news_id;

/*! 评论用户id*/
@property (nonatomic, assign) NSInteger user_id;

/*! 评论用户姓名*/
@property (nonatomic, copy) NSString * name;

/*! 被回复评论的用户id*/
@property (nonatomic, assign) NSInteger reply_uid;

/*! 被回复评论的用户名字*/
@property (nonatomic, copy) NSString * reply_name;

/*! 被回复评论Id*/
@property (nonatomic, assign) NSInteger reply_comment_id;

/*! 最上级评论的id*/
@property (nonatomic, assign) NSInteger top_comment_id;

/*! 添加时间*/
@property (nonatomic, copy) NSString * add_date;

- (void)setContentWithDic:(NSDictionary *)commentDic;

@end
