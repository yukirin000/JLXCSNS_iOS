//
//  FriendModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 好友模型*/
@interface FriendModel : NSObject

/*! 用户Id*/
@property (nonatomic, assign) NSInteger uid;

/*! 用户姓名*/
@property (nonatomic, copy) NSString * name;

/*! 头像缩略图*/
@property (nonatomic, copy) NSString * head_sub_image;

/*! 头像原图*/
@property (nonatomic, copy) NSString * head_image;

/*! 学校*/
@property (nonatomic, copy) NSString * school;

/*! 是否被关注或者已经关注*/
@property (nonatomic, assign) BOOL isOrHasAttent;

@end
