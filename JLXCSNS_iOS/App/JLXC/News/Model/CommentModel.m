//
//  CommentModel.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/16.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.second_comments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setContentWithDic:(NSDictionary *)commentDic
{
    self.comment_content = commentDic[@"comment_content"];
    self.cid             = [commentDic[@"id"] integerValue];
    self.name            = commentDic[@"name"];
    self.like_quantity   = [commentDic[@"like_quantity"] integerValue];
    self.user_id         = [commentDic[@"user_id"] integerValue];
    self.add_date        = commentDic[@"add_date"];
    self.head_image      = commentDic[@"head_image"];
    self.head_sub_image  = commentDic[@"head_sub_image"];
}

@end
