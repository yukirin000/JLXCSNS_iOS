//
//  TopicMainCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"

//话题主页cell
@interface TopicMainCell : UICollectionViewCell

//设置内容
- (void)setContentWith:(TopicModel *)topic;

@end
