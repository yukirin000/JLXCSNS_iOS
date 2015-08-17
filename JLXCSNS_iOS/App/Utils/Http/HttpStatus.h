//
//  NetStatus.h
//  UBaby_iOS
//
//  Created by bhczmacmini on 15-1-27.
//  Copyright (c) 2015年 bhczmacmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

//网络状态
@interface HttpStatus : NSObject

@property (nonatomic, strong) Reachability * reach;

+ (instancetype)defaultManager;

+ (NetworkStatus)getNetStatus;

@end
