//
//  TopicModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject<NSCopying>

//话题ID
@property (nonatomic, assign) NSInteger topic_id;
//话题名
@property (nonatomic, copy) NSString * topic_name;
//话题描述
@property (nonatomic, copy) NSString * topic_detail;
//话题封面原图
@property (nonatomic, copy) NSString * topic_cover_image;
//话题封面缩略图
@property (nonatomic, copy) NSString * topic_cover_sub_image;
//最后一次刷新时间
@property (nonatomic, copy) NSString * last_refresh_date;
//成员数量
@property (nonatomic, assign) NSInteger member_count;
//新闻数量
@property (nonatomic, assign) NSInteger news_count;
//未读数量
@property (nonatomic, assign) NSInteger unread_news_count;
//是否有内容
@property (nonatomic, assign) BOOL has_news;


@end
