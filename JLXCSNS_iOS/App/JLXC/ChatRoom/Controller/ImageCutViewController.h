//
//  ImageCutViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

//剪切完毕
typedef void(^ImageCutBlock) (UIImage *cutImage);

/*! 剪切图片页面*/
@interface ImageCutViewController : BaseViewController

//要剪切的Image
@property (nonatomic, strong)UIImage * image;

- (void)setImageCutBlock:(ImageCutBlock)block;

@end
