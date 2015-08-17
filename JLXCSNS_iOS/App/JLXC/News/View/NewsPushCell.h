//
//  NewsPushCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/25.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsPushModel.h"
@interface NewsPushCell : UITableViewCell

//设置内容
- (void) setContentWithModel:(NewsPushModel *)model;

@end
