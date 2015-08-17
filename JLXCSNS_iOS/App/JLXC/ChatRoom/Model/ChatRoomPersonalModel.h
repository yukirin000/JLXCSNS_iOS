//
//  ChatRoomPersonalModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 聊天室的人*/
@interface ChatRoomPersonalModel : NSObject

//如果是删除cell
@property (nonatomic, assign) BOOL isDeleteCell;

/*! 用户id*/
@property (nonatomic, assign) NSInteger uid;

/*! 用户名字*/
@property (nonatomic, copy) NSString * name;

/*! 用户学校*/
@property (nonatomic, copy) NSString * school;

/*! 用户头像缩略图*/
@property (nonatomic, copy) NSString * head_sub_image;



@end
