//
//  VisitListCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/1.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitModel.h"

/*!最近来访cell */
@interface VisitListCell : UITableViewCell

- (void) setContentWithModel:(VisitModel *)model;

@end
