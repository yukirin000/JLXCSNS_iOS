//
//  NewsDetailViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/18.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsModel.h"

typedef NS_ENUM(NSInteger, CommentState) {
    //不直接回复
    CommentNone   = 1,
    //回复当前
    CommentFirst  = 2,
    //二级回复
    CommentSecond = 3
};

@interface NewsDetailViewController : BaseViewController<UIActionSheetDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

//新闻模型
@property (nonatomic, assign) NSInteger newsId;
//回复类型
@property (nonatomic, assign) CommentState commentType;
//回复的模型
@property (nonatomic, assign) NSInteger commentId;

@end
