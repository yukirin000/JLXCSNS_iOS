//
//  ImageHelper.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/13.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject


/*! 获取缩放后的大图*/
+(UIImage *)getBigImage:(UIImage *)image;

/*! 获取缩放后的小图 弃用*/
//+(UIImage *)getSubImage:(UIImage *)image;



@end
