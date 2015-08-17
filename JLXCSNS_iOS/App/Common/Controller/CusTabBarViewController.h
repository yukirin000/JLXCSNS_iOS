//
//  YSTabBarViewController.h
//  爱限免
//
//  Created by qianfeng on 14-8-27.
//  Copyright (c) 2014年 com.qf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBar.h"
/*!
   @brief 自定义tabBar
 */
@interface CusTabBarViewController : UITabBarController<UITabBarControllerDelegate,UIAlertViewDelegate>

/*! 返回用户服务单例*/
+ (instancetype)sharedService;

/*! 重新初始化单例*/
+ (void)reinit;

/*!
    @brief 自定义切换tab
    @param index为要切换的tab
 */
- (void)customSelectedIndex:(NSInteger)index;

/*!
 @brief 设置侧滑
 */
//- (void)setLeftBtnSlideWithNavBar:(NavBar *)navBar;

@end
