//
//  TopicMemberViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/25.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"
/*! 圈子成员列表*/
@interface TopicMemberViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

//话题ID
@property (nonatomic, assign) NSInteger topicID;

@end
