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
{
    AFHTTPRequestOperationManager * _manager;
}

static HttpService * instance;

+ (instancetype)manager {
    
    if (!instance) {
        instance = [[HttpService alloc] init];
    }
    return instance;
}

+ (void)getWithUrlString:(NSString *)urlStr andCompletion:(SuccessBlock)success andFail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [[HttpService manager] createAFEntity];
    
   [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            @try {
                //缓存
                if (operation != nil) {
                    [HttpCache cacheHandleWith:responseObject andUrl:urlStr];
                }
                success(operation, responseObject);
            }
            @catch (NSException *exception) {
                 fail(operation, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(operation, error);
        }
    }];

}

+ (void)postWithUrlString:(NSString *)urlStr params:(NSDictionary *)params andCompletion:(SuccessBlock)success andFail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [[HttpService manager] createAFEntity];
    
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            @try {
                success(operation, responseObject);
            }
            @catch (NSException *exception) {
                fail(operation, nil);
            }
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
    AFHTTPRequestOperationManager * manager = [[HttpService manager] createAFEntity];

    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (files != nil && files.count >0) {
            for (NSDictionary * file in files) {
                [formData appendPartWithFileData:file[FileDataKey] name:file[FileNameKey] fileName:file[FileNameKey] mimeType:@""];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            @try {
                success(operation, responseObject);
            }
            @catch (NSException *exception) {
                fail(operation, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(operation, error);
        }
    }];

}

//创建AF实体
- (AFHTTPRequestOperationManager *)createAFEntity
{
    if (_manager == nil) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    _manager.requestSerializer                         = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer                        = [AFJSONResponseSerializer serializer];
    _manager.requestSerializer.timeoutInterval         = 30.0f;
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    return _manager;
    
}

@end
