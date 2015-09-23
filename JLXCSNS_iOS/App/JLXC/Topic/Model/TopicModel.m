//
//  TopicModel.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

- (id)copyWithZone:(NSZone *)zone
{
    TopicModel * topic = [TopicModel allocWithZone:zone];
    
    topic.topic_id              = self.topic_id;
    topic.topic_name            = self.topic_name;
    topic.topic_detail          = self.topic_detail;
    topic.topic_cover_image     = self.topic_cover_image;
    topic.topic_cover_sub_image = self.topic_cover_sub_image;
    topic.last_refresh_date     = self.last_refresh_date;
    topic.member_count          = self.member_count;
    topic.news_count            = self.news_count;
    topic.unread_news_count     = self.unread_news_count;
    topic.has_news              = self.has_news;
    
    return topic;
}

@end
