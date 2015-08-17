//
//  NetCache.h
//  UBaby_iOS
//
//  Created by bhczmacmini on 14-12-10.
//  Copyright (c) 2014年 bhczmacmini. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
    @interface
    @brief 网络缓存类
 */
@interface HttpCache : NSObject

/*! 
    @method
    @brief 存储缓存
    @param data 要缓存的data url要缓存的地址
 */
+ (void)cacheHandleWith:(NSDictionary *)dic andUrl:(NSString *)url;

/*!
 @method
 @brief 获取缓存数据
 @param url 要获取的缓存地址
 */
+ (NSDictionary *)getCacheWithUrl:(NSString *)url;

/*!
 @method
 @brief 清空缓存
 */
+ (void)clearDisk;

@end
