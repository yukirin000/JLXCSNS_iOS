//
//  RecommendFriendModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendFriendModel : NSObject

//用户id
@property (nonatomic, assign) NSInteger uid;

//姓名
@property (nonatomic, copy) NSString * name;

//学校
@property (nonatomic, copy) NSString * school;

//头像图
@property (nonatomic, copy) NSString * head_image;

//头像缩略图
@property (nonatomic, copy) NSString * head_sub_image;

//头像缩略图
@property (nonatomic, strong) NSMutableArray * imageArr;

/*! 类型字典*/
@property (nonatomic, strong) NSDictionary * typeDic;

/*! 添加了这个人 只用于添加好友使用*/
@property (nonatomic, assign) BOOL addFriend;

@end
