//
//  SchoolNewsCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/26.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListCell.h"

@interface SchoolNewsCell : UITableViewCell

@property (nonatomic, weak) id<NewsListDelegate> delegate;

/*! 内容填充*/
- (void)setConentWithModel:(NewsModel *)news;

@end
