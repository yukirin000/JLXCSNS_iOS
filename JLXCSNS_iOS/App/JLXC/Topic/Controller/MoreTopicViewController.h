//
//  MoreTopicViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshViewController.h"

/*! 更多圈子列表 按分类查询*/
@interface MoreTopicViewController : RefreshViewController

//类别ID
@property (nonatomic, assign) NSInteger categoryId;
//类别名字
@property (nonatomic, copy) NSString * categoryName;

@end
