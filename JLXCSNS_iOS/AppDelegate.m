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
#import "MobClick.h"
#import "ZWIntroductionViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) ZWIntroductionViewController * launchVC;

@end

@implementation AppDelegate

#define Launch @"JLXCLaunch1"

#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithHexString:ColorYellow];
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //初始化主页
    LoginViewController * vc       = [LoginViewController new];
    vc.hideNavbar                  = YES;
    UINavigationController * nav   = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    NSString * launch = [[NSUserDefaults standardUserDefaults] objectForKey:Launch];
    if (launch == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Launch];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSArray *coverImageNames = @[@"guide_page1", @"guide_page2", @"guide_page3"];
        self.launchVC            = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:nil];
        [self.window addSubview:self.launchVC.view];
        __weak typeof(self) sself      = self;
        self.launchVC.didSelectedEnter = ^() {
            [UIView animateWithDuration:0.5 animations:^{
                sself.launchVC.view.alpha = 0;
            } completion:^(BOOL finished) {
                [sself.launchVC.view removeFromSuperview];
                sself.launchVC = nil;
            }];
        };
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //Status不隐藏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    //友盟
    [self umengTrack];
    //高德地图
    [MAMapServices sharedServices].apiKey = GAODE_AppKey;
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:Rong_AppKey];
    [[RCIM sharedRCIM] setGlobalConversationAvatarStyle:RC_USER_AVATAR_RECTANGLE];
    [[RCIM sharedRCIM] setGlobalMessageAvatarStyle:RC_USER_AVATAR_RECTANGLE];
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
    [YunBaService close];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [YunBaService setup];
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
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

// for device token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    debugLog(@"get Device Token: %@", [NSString stringWithFormat:@"=====================Device Token: %@", deviceToken]);
    // uncomment to store device token to YunBa 26bec6bef14344f7a8c726001469e261b0586359f64aed8ecc90ed21264fc714
    [YunBaService storeDeviceToken:deviceToken resultBlock:^(BOOL succ, NSError *error) {
        if (succ) {
            debugLog(@"store device token to YunBa succ");
        } else {
            debugLog(@"store device token to YunBa failed due to : %@, recovery suggestion: %@", error, [error localizedRecoverySuggestion]);
        }
    }];
    
    NSString * deviceTokenStr = deviceToken.description;
    if ([deviceTokenStr hasPrefix:@"<"]) {
        deviceTokenStr = [deviceTokenStr substringFromIndex:1];
    }
    if ([deviceTokenStr hasSuffix:@">"]) {
        deviceTokenStr = [deviceTokenStr substringToIndex:deviceTokenStr.length-1];
    }
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:deviceTokenStr];
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

//友盟统计
- (void)umengTrack {
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_AppKey reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
}

@end
