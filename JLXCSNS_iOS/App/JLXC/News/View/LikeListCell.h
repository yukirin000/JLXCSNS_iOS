//
//  LikeListCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeModel.h"

@interface LikeListCell : UITableViewCell

//设置内容
- (void) setContentWithModel:(LikeModel *)model;

@end
