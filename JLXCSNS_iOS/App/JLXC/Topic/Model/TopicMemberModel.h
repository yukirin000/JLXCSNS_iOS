//
//  TopicMemberModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/25.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

//成员模型 内部类
@interface TopicMemberModel : NSObject

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * head_sub_image;

@end
