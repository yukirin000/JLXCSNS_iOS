//
//  NSString+ImageCache.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/8/19.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ImageCache)

//本地缓存图片 二次封装SD
- (void)cacheImageWithUrl:(NSString *)url;

@end
