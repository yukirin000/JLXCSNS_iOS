//
//  CutImageView.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! 切割图像的ImageView 弃用*/
@interface OldCutImageView : UIView<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIImage * image;

@end
