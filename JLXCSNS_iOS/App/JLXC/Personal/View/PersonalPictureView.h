//
//  PersonalPictureView.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
/* 主页我的图片滚动视图*/
@interface PersonalPictureView : UIView

//父控制器
@property (nonatomic, strong) BaseViewController * personalVC;

//设置图片数组
- (void)setImageWithList:(NSArray *)imageList;

@end
