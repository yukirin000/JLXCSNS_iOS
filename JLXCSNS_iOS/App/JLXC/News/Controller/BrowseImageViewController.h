//
//  BrowseImageViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/14.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^DeleteImageBlock) (NSInteger num);

/*!
    查看图片的VC
 */
@interface BrowseImageViewController : BaseViewController

@property (nonatomic, assign) BOOL needDownLoad;
//大图Url
@property (nonatomic, copy) NSString * url;
//要看的image大图
@property (nonatomic, strong) UIImage * image;
//第几张
@property (nonatomic, assign) NSInteger num;
//是否能删除
@property (nonatomic, assign) BOOL canDelete;

//设置删除图片block
- (void)setDeleteBlock:(DeleteImageBlock)block;

@end
