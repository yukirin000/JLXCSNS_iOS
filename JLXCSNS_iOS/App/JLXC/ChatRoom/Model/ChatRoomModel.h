//
//  ChatRoomModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>
/*! 聊天室模型*/
@interface ChatRoomModel : NSObject

/*! 聊天室Id*/
@property (nonatomic, assign) NSInteger cid;
/*! 群主Id*/
@property (nonatomic, assign) NSInteger user_id;
/*! 聊天室标题*/
@property (nonatomic, copy) NSString * chatroom_title;

/*! 开始时间*/
@property (nonatomic, copy) NSString * chatroom_create_time;

/*! 持续时间*/
@property (nonatomic, copy) NSString * chatroom_duration;

/*! 聊天室背景*/
@property (nonatomic, copy) NSString * chatroom_background;

/*! 当前人数*/
@property (nonatomic, assign) NSInteger current_quantity;

/*! 最大人数*/
@property (nonatomic, assign) NSInteger max_quantity;

/*! 标签数组*/
@property (nonatomic, strong) NSMutableArray * tagArr;

@end
