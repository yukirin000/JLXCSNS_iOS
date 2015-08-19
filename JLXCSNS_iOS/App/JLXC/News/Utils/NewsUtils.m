//
//  NewsUtils.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/8/19.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewsUtils.h"

@implementation NewsUtils

//获取合适的比例
+ (CGRect)getRectWithSize:(CGSize) size
{
    CGFloat x,y,width,height;
    if (size.width > size.height) {
        width  = 200;
        height = size.height*(200/size.width);
    }else{
        height  = 250;
        width = size.width*(250/size.height);
    }
    CGRect rect = CGRectMake(x, y, width, height);
    
    return rect;
}

@end
