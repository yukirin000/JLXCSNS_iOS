//
//  ImageModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/15.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 图片模型*/
@interface ImageModel : NSObject

/*! 图片id*/
@property (nonatomic, assign) NSInteger iid;

/*! 图片大小*/
@property (nonatomic, copy) NSString * size;

/*! 原图地址*/
@property (nonatomic, copy) NSString * url;

/*! 缩略图地址*/
@property (nonatomic, copy) NSString * sub_url;

/*! 大图宽*/
@property (nonatomic, assign) CGFloat width;

/*! 大图高*/
@property (nonatomic, assign) CGFloat height;

@end
