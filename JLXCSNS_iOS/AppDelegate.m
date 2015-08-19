//
//  AppDelegate.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/8.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "YunBaService.h"
#import <SMS_SDK/SMS_SDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //初始化主页
    LoginViewController * vc       = [LoginViewController new];
    vc.hideNavbar                  = YES;
    UINavigationController * nav   = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //Status不隐藏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    //708cb4915a090ac04ee8888c5b1c810e
    //高德地图
//    NSString * APIKey = GAODE_AppKey;
//    if ([APIKey length] == 0)
//    {
//        NSString *reason   = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
    //高德地图
    [MAMapServices sharedServices].apiKey = GAODE_AppKey;
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:Rong_AppKey deviceToken:nil];
//    [RCIM sharedRCIM].messageBeep = YES;

    //云巴推送
    [YunBaService setupWithAppkey:YunBa_AppKey];
    
    //初始化SMS服务
    [SMS_SDK registerApp:SMS_AppKey
              withSecret:SMS_Security];
    
    //初始化数据库
    [DatabaseService sharedInstance];

    //apns
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

    self.window.backgroundColor = [UIColor grayColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

// for device token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    debugLog(@"get Device Token: %@", [NSString stringWithFormat:@"=====================Device Token: %@", deviceToken]);
    // uncomment to store device token to YunBa
    [YunBaService storeDeviceToken:deviceToken resultBlock:^(BOOL succ, NSError *error) {
        if (succ) {
            debugLog(@"store device token to YunBa succ");
        } else {
            debugLog(@"store device token to YunBa failed due to : %@, recovery suggestion: %@", error, [error localizedRecoverySuggestion]);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location != NSNotFound) {
        NSLog(@"apns is NOT supported on simulator, run your Application on a REAL device to get device token");
    }
    
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError Error: %@", error);
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}
//高德地图
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        debugLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
