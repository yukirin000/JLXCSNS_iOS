//
//  DeviceManager.m
//  UBaby_iOS
//
//  Created by bhczmacmini on 14-10-20.
//  Copyright (c) 2014年 bhczmacmini. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager

/*!
 @brief 获取屏幕宽
 */
+ (CGFloat)getDeviceWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}
/*!
 @brief 获取屏幕高
 */
+ (CGFloat)getDeviceHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

/*!
 @brief 获取设备系统版本
 */
+ (CGFloat)getDeviceSystem
{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

@end
