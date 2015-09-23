//
//  TopicCategoryModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 类别模型*/
@interface TopicCategoryModel : NSObject

// 类型ID
@property (nonatomic, assign) NSInteger category_id;
// 类型名
@property (nonatomic, copy) NSString * category_name;
// 类型封面
@property (nonatomic, copy) NSString * category_cover;
// 类型描述
@property (nonatomic, copy) NSString * category_desc;

@end
