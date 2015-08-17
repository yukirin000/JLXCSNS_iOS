//
//  RecommendCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendFriendModel.h"

@protocol RecommendDelegate <NSObject>

- (void)addFriendClick:(RecommendFriendModel *)model;

@end

/*! 推荐的人模型cell*/
@interface RecommendCell : UITableViewCell


@property (nonatomic, assign) id<RecommendDelegate> delegate;

- (void)setContentWithModel:(RecommendFriendModel *)model;

@end
