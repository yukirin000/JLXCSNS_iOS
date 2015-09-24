//
//  TopicNewsViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshViewController.h"

/*! 圈子新闻列表*/
@interface TopicNewsViewController : RefreshViewController

//该圈子的ID
@property (nonatomic, assign) NSInteger topicID;
//圈子名
@property (nonatomic, copy) NSString * topicName;

@end
