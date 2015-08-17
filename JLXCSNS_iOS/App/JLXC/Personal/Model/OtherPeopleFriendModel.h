//
//  OtherPeopleFriendModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/2.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 其他人好友model*/
@interface OtherPeopleFriendModel : NSObject

/*! 用户Id*/
@property (nonatomic, assign) NSInteger uid;

/*! 用户姓名*/
@property (nonatomic, copy) NSString * name;

/*! 头像缩略图*/
@property (nonatomic, copy) NSString * head_sub_image;

/*! 学校*/
@property (nonatomic, copy) NSString * school;

@end