//
//  BrowseImageView.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/4.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! 浏览图像的ImageView*/
@interface BrowseImageView : UIView<UIScrollViewDelegate,UIActionSheetDelegate>

//图像地址
@property (nonatomic, strong) NSString * urlStr;
//如果是已经有的图片
@property (nonatomic, strong) UIImage * image;

@property (nonatomic, strong) UIScrollView * backScrollView;

@end
