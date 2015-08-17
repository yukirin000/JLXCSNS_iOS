//
//  NewsModel.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/15.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewsModel.h"
#import "ImageModel.h"
#import "CommentModel.h"
#import "LikeModel.h"

@implementation NewsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.image_arr  = [[NSMutableArray alloc] init];
        self.comment_arr = [[NSMutableArray alloc] init];
        self.like_arr   = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setContentWithDic:(NSDictionary *)newsDic
{
    self.nid              = [newsDic[@"id"] integerValue];
    self.uid              = [newsDic[@"uid"] integerValue];
    self.name             = newsDic[@"name"];
    self.school           = newsDic[@"school"];
    self.publish_date     = newsDic[@"add_date"];
    self.publish_time     = newsDic[@"add_time"];
    self.location         = newsDic[@"location"];
    self.comment_quantity = [newsDic[@"comment_quantity"] integerValue];
    self.like_quantity    = [newsDic[@"like_quantity"] integerValue];
    self.browse_quantity  = [newsDic[@"browse_quantity"] integerValue];
    self.content_text     = newsDic[@"content_text"];
    self.head_image       = newsDic[@"head_image"];
    self.head_sub_image   = newsDic[@"head_sub_image"];
    self.is_like          = [newsDic[@"is_like"] boolValue];
    self.typeDic          = newsDic[@"type"];
    NSArray * images      = newsDic[@"images"];
    NSArray * comments    = newsDic[@"comments"];
    NSArray * likes       = newsDic[@"likes"];
    //图片数组
    for (NSDictionary * imageDic in images) {
        ImageModel * imageModel = [[ImageModel alloc] init];
        imageModel.iid          = [imageDic[@"id"] integerValue];
        imageModel.size         = imageDic[@"size"];
        imageModel.url          = imageDic[@"url"];
        imageModel.sub_url      = imageDic[@"sub_url"];
        imageModel.width        = [imageDic[@"width"] integerValue];
        imageModel.height       = [imageDic[@"height"] integerValue];
        [self.image_arr addObject:imageModel];
    }
    //评论数组
    for (NSDictionary * commentDic in comments) {
        CommentModel * comment  = [[CommentModel alloc] init];
        [comment setContentWithDic:commentDic];
        [self.comment_arr addObject:comment];
    }
    //点赞数组
    for (NSDictionary * likeDic in likes) {
        LikeModel * like    = [[LikeModel alloc] init];
        like.head_image     = likeDic[@"head_image"];
        like.head_sub_image = likeDic[@"head_sub_image"];
        like.user_id        = [likeDic[@"user_id"] integerValue];
        [self.like_arr addObject:like];
    }
}

@end
