//
//  TopicCategoryView.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/24.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicCategoryModel;

@protocol TopicCategoryDelegate <NSObject>

- (void)colorChange:(NSString *)colorStr;

- (void)categorySelect:(TopicCategoryModel *)topic;

@end


/*! 话题首页类别视图*/
@interface TopicCategoryView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak)id<TopicCategoryDelegate> delegete;

/*! 设置内容*/
- (void)setCategoryList:(NSArray *)categoryList;

@end
