//
//  MorTopicCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"

/*! 更多话题cell*/
@interface MoreTopicCell : UITableViewCell

//设置内容
- (void)setContentWith:(TopicModel *)topic;

@end
