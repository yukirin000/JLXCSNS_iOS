//
//  NewsPushModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    //添加好友
    PushAddFriend     = 1,
    //回复消息
    PushNewsAnwser    = 2,
    //回复二级评论
    PushSecondComment = 3,
    //点赞
    PushLikeNews      = 4
};

//该模型对应数据表 jlxc_news_push 该表中不存储类型为'添加好友'的推送类型
@interface NewsPushModel : NSObject

//本条数据的id
@property (nonatomic, assign) NSInteger pid;

//发送推送人的id
@property (nonatomic, assign) NSInteger uid;

//发送人的头像
@property (nonatomic, copy) NSString * head_image;

//姓名
@property (nonatomic, copy) NSString * name;

//评论内容
@property (nonatomic, copy) NSString * comment_content;

//推送类型 Push
@property (nonatomic, assign) NSInteger type;

//新闻id
@property (nonatomic, assign) NSInteger news_id;

//新闻内容
@property (nonatomic, copy) NSString * news_content;

//新闻cover图片
@property (nonatomic, copy) NSString * news_image;

//新闻用户名
@property (nonatomic, copy) NSString * news_user_name;

//是否已读
@property (nonatomic, assign) BOOL is_read;

//发布时间
@property (nonatomic, copy) NSString * push_time;

//所有者
@property (nonatomic, assign) NSInteger owner;


/**
 * 保存数据
 */
- (int)save;

/**
 * 更新数据 现在更新已读状态
 */
- (void)update;

/**
 * 删除
 */
- (void)remove;

/**
 * 是否存在 如果存在则是重复推送不接受
 */
- (BOOL)isExist;

/**
 * 删除全部
 */
+ (void)removeAll;

/**
 * 设置已读
 */
+ (void)setIsRead;

/**
 * 从数据库中查出所有的通知
 * //暂时不分页
 * @param pageNumber 页数
 * @param pageCount 每页数据数
 */
+ (NSMutableArray *)findAll;

/**
 * 从数据库中查出所有的通知
 * @param page 页数
 * @param size 每页数据数
 */
+ (NSMutableArray *)findWithPage:(NSInteger)page size:(NSInteger)size;

/**
 * 从数据库中查出所有某种类型未读的数据
 *
 */
+ (NSMutableArray *)findUnreadCount;

@end
