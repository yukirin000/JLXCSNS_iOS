//
//  YSTabBarViewController.m
//  爱限免
//
//  Created by qianfeng on 14-8-27.
//  Copyright (c) 2014年 com.qf. All rights reserved.
//

#import "CusTabBarViewController.h"
#import "IMGroupModel.h"
#import "DeviceManager.h"
#import "BaseViewController.h"
#import "ToolsManager.h"
#import "TabBarBtn.h"
#import "DatabaseService.h"
#import "LeftPersonalViewController.h"
#import "NewsMainViewController.h"
#import "YunBaService.h"
#import "PushService.h"
#import "RCDRCIMDataSource.h"


enum Tab{
    //新闻首页
    TabNews     = 0,
    //消息
    TabChat     = 1,
    //找同学
    TabFind     = 2,
    //我
    TabMe       = 3
};

@interface CusTabBarViewController ()

//@property (nonatomic, strong) LeftPersonalViewController * leftVC;

//侧滑时的遮罩view
@property (nonatomic, strong) UIView * coverView;

@end

@implementation CusTabBarViewController
{
    
    //背景View
    UIImageView * _backView;
    //控制器数组
    NSMutableArray * _vcArr;
    //标题数组
    NSMutableArray * _titleArr;
    //按钮数组
    NSMutableArray * _btnArr;
    //选中图片数组
    NSMutableArray * _selectedArr;
    //普通图片数组
    NSMutableArray * _normaleArr;
    //宽度
    CGFloat space;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

static CusTabBarViewController * instance = nil;

/*! 返回单例服务单例*/
+ (instancetype)sharedService
{
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[CusTabBarViewController alloc] init];
//    });
    if (instance == nil) {
        instance = [[CusTabBarViewController alloc] init];
    }
    
    return instance;
}

+ (void)reinit
{
    if (instance != nil) {
        instance = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;

    _backView                 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [DeviceManager getDeviceWidth], kTabBarHeight)];
    _backView.image           = [UIImage imageNamed:@"tabbar"];
//    _backView.backgroundColor = [UIColor grayColor];
    _backView.userInteractionEnabled = YES;
    [self.tabBar addSubview:_backView];

//    self.leftVC = [[LeftPersonalViewController alloc] init];
    
    [self createVC];
    
    [self registerNotification];
    
    //初始化侧滑用的遮罩 侧滑关闭
//    [self initCoverView];
    
    //初始化 推送服务类
    [[PushService sharedInstance] pushReconnect];
    //初始化 融云
    [[RCDRCIMDataSource shareInstance] IMReconnect];
    //初始化Tools中的耗时工具
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ToolsManager sharedManager];        
    });
    [self badgeNotify:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
//    self.revealSideViewController.delegate = self;
//    [self handleLeftVC];
    //遮罩变化
//        [self.revealSideViewController.rootViewController.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)handleLeftVC
{

//    self.leftVC.hideLeftBtn = YES;
//    self.leftVC.hideNavbar  = YES;
//    //    [self.revealSideViewController preloadViewController:self.leftVC forSide:PPRevealSideDirectionLeft];
//    [self.revealSideViewController preloadViewController:self.leftVC
//                                                 forSide:PPRevealSideDirectionLeft
//                                              withOffset:150];
//    [self.revealSideViewController addGesturesToCenterController];
//    self.revealSideViewController.delegate = self;
}

//- (void)setLeftBtnSlideWithNavBar:(NavBar *)navBar
//{
//    __weak typeof(self) sself  = self;
//    [navBar setLeftBtnWithContent:nil andBlock:^{
//        [self.revealSideViewController pushViewController:sself.leftVC onDirection:PPRevealSideDirectionLeft withOffset:150 animated:YES completion:nil];
//    }];
//}

//通知刷新徽标
- (void)badgeNotify:(NSNotification *)notify
{
    //清空徽标
    for (TabBarBtn * barBtn in _btnArr) {
        [barBtn refreshBadgeWith:0];
    }
    
//    //徽标 最多显示99
//    //首页
//    NSInteger newsUnreadCount = [NewsPushModel findUnreadCount].count;
//    if (newsUnreadCount > 99) {
//        newsUnreadCount = 99;
//    }
//    TabBarBtn * chatBtn = _btnArr[TabNews];
//    [newsBtn refreshBadgeWith:newsUnreadCount];
    
    //聊天页面
    //新好友请求未读
    NSInteger newFriendsCount = [IMGroupModel unReadNewFriendsCount];
    //聊天未读
    NSInteger IMUnreadCount = [[RCIMClient sharedRCIMClient]getUnreadCount: @[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
    
    //徽标 最多显示99
    //未读推送
    NSInteger newsUnreadCount = [NewsPushModel findUnreadCount].count;
    //聊天未读
    NSInteger chatCount = newFriendsCount+IMUnreadCount;
    NSInteger total = newsUnreadCount+chatCount;
    if (total > 99) {
        total = 99;
    }
    TabBarBtn * chatBtn = _btnArr[TabChat];
    [chatBtn refreshBadgeWith:total];
    
}

/*!
 @brief 自定义切换tab
 @param index为要切换的tab
 */
- (void)customSelectedIndex:(NSInteger)index
{
    self.selectedIndex = index;
    for (UIButton * item in _backView.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            item.selected = NO;
        }
    }
    
    TabBarBtn * tbb = _btnArr[index];
    tbb.selected = YES;
}


- (void)createVC
{
    NSString * fileName = @"JLXCSNS";
    NSString * path     = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray * arr       = [NSArray arrayWithContentsOfFile:path];
    _vcArr              = [[NSMutableArray alloc] init];
    _titleArr           = [[NSMutableArray alloc] init];
    _btnArr             = [[NSMutableArray alloc] init];
    _selectedArr        = [[NSMutableArray alloc] init];
    _normaleArr         = [[NSMutableArray alloc] init];
    for (NSDictionary * dic in arr) {
        Class class = NSClassFromString([dic objectForKey:@"controller"]);
        BaseViewController * bVC = [[[class class] alloc] init];
        bVC.hideLeftBtn          = YES;
        NSString * title         = [dic objectForKey:@"title"];
        [_titleArr addObject:title];
        [_vcArr addObject:bVC];
        [_normaleArr addObject:dic[@"normalPic"]];
        [_selectedArr addObject:dic[@"selectedPic"]];
    
    }
    
    NSInteger count = _vcArr.count;
    space = [DeviceManager getDeviceWidth]/count;
    
    for (int i=0; i<count; i++) {
        TabBarBtn * item = [[TabBarBtn alloc] initWithFrame:CGRectMake(space*i, 0, space, kTabBarHeight)];
        item.titeLabel.text = _titleArr[i];
        [_btnArr addObject:item];
        [item setImage:[UIImage imageNamed:_normaleArr[i]] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:_selectedArr[i]] forState:UIControlStateSelected];
        [item setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 16, 0)];
        if (i == 0) {
            item.selected = YES;
        }
        
        [_backView addSubview:item];
    }
    
    self.viewControllers = _vcArr;
    
}

- (void)initCoverView
{
    //遮罩view初始化
    self.coverView        = [[UIView alloc] initWithFrame:self.view.bounds];
    self.coverView.hidden = YES;
    [self.view addSubview:self.coverView];
}

#pragma mark- PPRevealSideViewControllerDelegate
//- (NSArray *)customViewsToAddPanGestureOnPPRevealSideViewController:(PPRevealSideViewController *)controller
//{
//    NewsMainViewController * mvc = _vcArr[0];
//    NSArray * arr = @[mvc.newsListVC.view];
//    return arr;
//}
//- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController *)controller directionsAllowedForPanningOnView:(UIView *)view {
//    
//    return PPRevealSideDirectionLeft;
//}
//
//- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController {
//
//    self.coverView.hidden = NO;
//}
//
//- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController {
//    
//    self.coverView.hidden = YES;
//}

#pragma mark- tabBar点击代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    for (UIButton * item in _backView.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            item.selected = NO;
        }
    }
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TAB_PRESS object:nil];
    }
    TabBarBtn * btn = _btnArr[index];
    btn.selected = YES;
 

}

#pragma mark- tabBar点击代理
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

#pragma mark - 注册通知
//注册通知
- (void)registerNotification
{
    //通知增加一个徽标
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeNotify:) name:NOTIFY_TAB_BADGE object:nil];
}

#pragma mark- 云巴推送部分


- (void)onPresenceReceived:(NSNotification *)notification {
//    YBPresenceEvent *presence = [notification object];
//    NSLog(@"new presence, action=%@, topic=%@, alias=%@, time=%lf", [presence action], [presence topic], [presence alias], [presence time]);
//    
//    NSString *curMsg = [NSString stringWithFormat:@"[Presence] %@:%@ => %@[%@]", [presence topic], [presence alias], [presence action], [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[presence time]/1000] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
