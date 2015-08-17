//
//  HttpService.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

/** @brief Http状态枚举 */
enum HttpStatusCode {
    HttpStatusCodeFailed = 0,
    HttpStatusCodeSuccess = 1
};

const static NSString * HttpResult  = @"result";
const static NSString * HttpMessage = @"message";
const static NSString * HttpStatus  = @"status";
const static NSString * HttpList    = @"list";

typedef void(^SuccessBlock) (AFHTTPRequestOperation * operation, id responseData);
typedef void(^FailBlock) (AFHTTPRequestOperation * operation, NSError * error);

/*!
    @brief http服务类
 */
@interface HttpService : NSObject

/*!
    @brief get请求
    @param urlStr 请求url
    @param success success block
@param success fail block
 */
+ (void)getWithUrlString:(NSString *)urlStr andCompletion:(SuccessBlock)success andFail:(FailBlock)fail;

/*!
    @brief 无附件post请求
    @param urlStr 请求url
    @param params 请求参数
    @param success success block
@param success fail block
 */
+ (void)postWithUrlString:(NSString *)urlStr params:(NSDictionary *)params andCompletion:(SuccessBlock)success andFail:(FailBlock)fail;

/*!
    @brief 上传附件post请求
    @param urlStr 请求url
    @param params 请求参数
    @param files 文件数组
    @param success success block
@param success fail block
 */
+ (void)postFileWithUrlString:(NSString *)urlStr params:(NSDictionary *)params files:(NSArray *)files andCompletion:(SuccessBlock)success andFail:(FailBlock)fail;



@end
