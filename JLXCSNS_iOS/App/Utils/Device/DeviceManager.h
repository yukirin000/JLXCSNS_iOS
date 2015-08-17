//
//  DeviceManager.h
//  UBaby_iOS
//
//  Created by bhczmacmini on 14-10-20.
//  Copyright (c) 2014年 bhczmacmini. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @brief 设备类
 */
@interface DeviceManager : NSObject

/*!
    @brief 获取屏幕宽
 */
+ (CGFloat)getDeviceWidth;
/*!
    @brief 获取屏幕高
 */
+ (CGFloat)getDeviceHeight;

/*!
 @brief 获取设备系统版本
 */
+ (CGFloat)getDeviceSystem;

@end
