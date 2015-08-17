//
//  StudentListViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/23.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

/*! 学生列表*/
@interface StudentListViewController : BaseViewController<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, copy) NSString * school_code;

@end
