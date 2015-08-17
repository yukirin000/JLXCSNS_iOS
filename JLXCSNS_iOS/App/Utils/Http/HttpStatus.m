//
//  NetStatus.m
//  UBaby_iOS
//
//  Created by bhczmacmini on 15-1-27.
//  Copyright (c) 2015年 bhczmacmini. All rights reserved.
//

#import "HttpStatus.h"

@implementation HttpStatus

+ (instancetype)defaultManager
{
    static HttpStatus * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[HttpStatus alloc] init];
        
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        [_reach startNotifier];
    }
    return self;
}

+ (NetworkStatus)getNetStatus
{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
}

@end
