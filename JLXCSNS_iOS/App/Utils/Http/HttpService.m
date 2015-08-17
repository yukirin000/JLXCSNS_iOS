//
//  HttpService.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "HttpService.h"
#import "HttpCache.h"
@implementation HttpService

+ (void)getWithUrlString:(NSString *)urlStr andCompletion:(SuccessBlock)success andFail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [HttpService createAFEntity];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            //缓存
            if (operation != nil) {
                [HttpCache cacheHandleWith:responseObject andUrl:urlStr];
            }
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(operation, error);
        }
    }];
}

+ (void)postWithUrlString:(NSString *)urlStr params:(NSDictionary *)params andCompletion:(SuccessBlock)success andFail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [HttpService createAFEntity];
    
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(operation, error);
        }
    }];
}

    //files格式 @{FileDataKey:UIImageJPEGRepresentation(image, 0.8),FileNameKey:fileName}
+ (void)postFileWithUrlString:(NSString *)urlStr params:(NSArray *)params files:(NSDictionary *)files andCompletion:(SuccessBlock)success andFail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [HttpService createAFEntity];

    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (files != nil && files.count >0) {
            for (NSDictionary * file in files) {
                [formData appendPartWithFileData:file[FileDataKey] name:file[FileNameKey] fileName:file[FileNameKey] mimeType:@""];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(operation, error);
        }
    }];

}

//创建AF实体
+ (AFHTTPRequestOperationManager *)createAFEntity
{
    AFHTTPRequestOperationManager * manager           = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer                         = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer                        = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval         = 60.0f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    return manager;
    
}

@end
