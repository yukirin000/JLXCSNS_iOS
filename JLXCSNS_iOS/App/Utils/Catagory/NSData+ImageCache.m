//
//  NSString+ImageCache.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/8/19.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NSData+ImageCache.h"
#import "SDWebImageManager.h"

@implementation NSData (ImageCache)

- (void)cacheImageWithUrl:(NSString *)url
{
    //缓存头像
    NSString * path = [[SDImageCache sharedImageCache] diskCachePath];
    NSString * fileName = [[SDImageCache sharedImageCache] cachedFileNameForKey:url];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    [fileManager createFileAtPath:[path stringByAppendingPathComponent:fileName] contents:self attributes:nil];
    
}

@end
