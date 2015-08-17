//
//  UserService.h
//  UBaby_iOS
//
//  Created by bhczmacmini on 14-10-27.
//  Copyright (c) 2014年 bhczmacmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
/*!
 用户信息服务类
 
 */
@interface UserService : NSObject

/*! 
    @property
    @brief apns设备码
 */
@property (nonatomic, copy) NSString * deviceToken;

/*! 用户模型*/
@property (nonatomic, strong) UserModel * user;

/*! 返回用户服务单例*/
+ (instancetype)sharedService;

/*! 
    @method
    @brief 存储token
 */
- (void)saveDeviceToken;

//保存数据
- (void)saveAndUpdate;

//获取缓存数据
- (void)find;

//删除缓存数据
- (void)clear;

@end
