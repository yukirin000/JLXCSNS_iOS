//
//  ViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/8.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
#import "MBProgressHUD.h"
#import "NavBar.h"
#import "HttpService.h"
#import "UserService.h"
#import "CusTabBarViewController.h"
@interface BaseViewController : UIViewController<MBProgressHUDDelegate>

//界面宽
@property int viewWidth;
//界面高
@property int viewHeight;
@property (nonatomic, strong) MBProgressHUD *hudProgress;
/*!导航栏*/
@property (nonatomic, strong) NavBar * navBar;

/*!是否隐藏左边按钮*/
@property (nonatomic, assign) BOOL hideLeftBtn;
/*!是否隐藏navBar*/
@property (nonatomic, assign) BOOL hideNavbar;

/*!设置NavBarTitle*/
- (void)setNavBarTitle:(NSString *)title;

/*!入栈*/
- (void)pushVC:(UIViewController *)vc;

/*!出栈*/
- (void)popToTabBarViewController;

/*!无动画出栈*/
- (void)popToTabBarViewControllerNoAnimation;

/*!
    @brief 显示有错误的Hud
 */
- (void)showWarn:(NSString *)text;
/*!
    @brief 显示Loading状态的Hud
 */
- (void)showLoading:(NSString *) text;
/*!
    @brief 隐藏Hud
 */
- (void)hideLoading;
/*!
    @brief toast
 */
- (void)toast:(NSString *)text;
/*!
    @brief completeHud
 */
- (void)showComplete:(NSString *)text;

@end
