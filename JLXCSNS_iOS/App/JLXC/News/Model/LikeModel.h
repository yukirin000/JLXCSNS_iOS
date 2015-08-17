//
//  LikeModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/18.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 点赞模型*/
@interface LikeModel : NSObject

/*! 用户id*/
@property (nonatomic, assign) NSInteger user_id;

/*! 姓名*/
@property (nonatomic, copy) NSString * name;

/*! 用户头像*/
@property (nonatomic, copy) NSString * head_image;

/*! 用户头像缩略图*/
@property (nonatomic, copy) NSString * head_sub_image;

@end
