//
//  NewsDetailViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/18.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsModel.h"

@interface NewsDetailViewController : BaseViewController<UIActionSheetDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

//新闻模型
@property (nonatomic, assign) NSInteger newsId;

@end
