//
//  VisitModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/1.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 最近来访model*/
@interface VisitModel : NSObject

/*! 用户Id*/
@property (nonatomic, assign) NSInteger uid;

/*! 用户姓名*/
@property (nonatomic, copy) NSString * name;

/*! 头像缩略图*/
@property (nonatomic, copy) NSString * head_sub_image;

/*! 最近来访时间*/
@property (nonatomic, copy) NSString * visit_time;

/*! 签名*/
@property (nonatomic, copy) NSString * sign;

@end
