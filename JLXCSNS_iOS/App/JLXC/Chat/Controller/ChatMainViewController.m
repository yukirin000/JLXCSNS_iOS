//
//  ChatMainViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/27.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChatMainViewController.h"
#import "IMGroupModel.h"
#import "ChatListViewController.h"
#import "HMSegmentedControl.h"
#import "NotifyNewsViewController.h"

@interface ChatMainViewController ()

@property (nonatomic, strong) HMSegmentedControl * segmentedControl;

@property (nonatomic, strong) ChatListViewController * chatListVC;

//@property (nonatomic, strong) FriendsListViewController * friendsListVC;

@property (nonatomic, strong) NotifyNewsViewController * newsNotifyVC;

//当前的VC
@property (nonatomic, strong) UIViewController * currentVC;

//通知未读label
@property (nonatomic, strong) CustomLabel * notifyUnreadLabel;

//聊天未读label
@property (nonatomic, strong) CustomLabel * chatUnreadLabel;


@end

@implementation ChatMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化控件
    [self initWidget];
    //初始化UI
    [self configUI];
    //初始化ChildVC
    [self initChildVC];
    //注册通知
    [self registerNotify];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    self.notifyUnreadLabel = [[CustomLabel alloc] initWithFontSize:10];
    self.chatUnreadLabel   = [[CustomLabel alloc] initWithFontSize:10];
    self.segmentedControl  = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"会话", @"通知"]];
    
    [self.navBar addSubview: self.segmentedControl];
    [self.segmentedControl addSubview:self.notifyUnreadLabel];
    [self.segmentedControl addSubview:self.chatUnreadLabel];
    
}

- (void)configUI
{

//    CusTabBarViewController * tab = (CusTabBarViewController *)self.tabBarController;
//    [tab setLeftBtnSlideWithNavBar:self.navBar];

//    __weak typeof(self) sself = self;
//    [self.navBar setRightBtnWithContent:@"清空" andBlock:^{
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:StringCommonPrompt message:@"确认要清空么?" delegate:sself cancelButtonTitle:StringCommonCancel otherButtonTitles:StringCommonConfirm, nil];
//        [alert show];
//    }];
//    sself.navBar.rightBtn.hidden = YES;

    //创建segment
    self.segmentedControl.autoresizingMask            = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.frame                       = CGRectMake(kCenterOriginX(120), 25, 120, 30);
    self.segmentedControl.backgroundColor             = [UIColor clearColor];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectionStyle              = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation  = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight    = 2.0;
    self.segmentedControl.selectionIndicatorColor     = [UIColor colorWithHexString:ColorOrange];
    self.segmentedControl.titleTextAttributes         = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:ColorBrown andAlpha:0.5], NSFontAttributeName : [UIFont systemFontOfSize:FontNavBarTitle]};
    self.segmentedControl.shouldAnimateUserSelection  = NO;
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:ColorBrown], NSFontAttributeName : [UIFont systemFontOfSize:FontNavBarTitle]};
    

    self.chatUnreadLabel.frame                 = CGRectMake(5, 5, 6, 6);
    self.chatUnreadLabel.layer.cornerRadius    = 3;
    self.chatUnreadLabel.layer.masksToBounds   = YES;
    self.chatUnreadLabel.backgroundColor       = [UIColor redColor];
    self.chatUnreadLabel.textAlignment         = NSTextAlignmentCenter;

    self.notifyUnreadLabel.frame               = CGRectMake(65, 5, 6, 6);
    self.notifyUnreadLabel.layer.cornerRadius  = 3;
    self.notifyUnreadLabel.layer.masksToBounds = YES;
    self.notifyUnreadLabel.backgroundColor     = [UIColor redColor];
    self.notifyUnreadLabel.textAlignment       = NSTextAlignmentCenter;
    
    [self refreshMessage];
}


//添加子类VC
- (void)initChildVC
{
    //会话VC
    self.chatListVC            = [[ChatListViewController alloc] init];
    [self addChildViewController:self.chatListVC];
    self.chatListVC.view.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kTabBarHeight);
    [self.view addSubview:self.chatListVC.view];
    
    //好友VC
    self.newsNotifyVC            = [[NotifyNewsViewController alloc] init];
    [self addChildViewController:self.newsNotifyVC];
    self.newsNotifyVC.view.frame = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kTabBarHeight);

    self.currentVC               = self.chatListVC;
    
}

#pragma mark- method response
//页面修改
-(void) segmentedControlChangedValue:(HMSegmentedControl *)segment
{

    UIViewController * toViewController;
    
    if (segment.selectedSegmentIndex == 0) {
        toViewController = self.chatListVC;
//        self.navBar.rightBtn.hidden = YES;
    }else{
//        toViewController = self.friendsListVC;
        toViewController = self.newsNotifyVC;
//        self.navBar.rightBtn.hidden = NO;
    }
    
    [self transitionFromViewController:self.currentVC toViewController:toViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        
        if (segment.selectedSegmentIndex == 0) {
            self.currentVC = self.chatListVC;
        }else{
//            self.currentVC = self.friendsListVC;
            self.currentVC = self.newsNotifyVC;
        }
    }];
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [NewsPushModel removeAll];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NEWS_PUSH object:nil];
        //徽标跟新
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TAB_BADGE object:nil];
        //顶部刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_REFRESH object:nil];
    }
}

#pragma mark- private method
- (void)registerNotify
{
    //顶部刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage) name:NOTIFY_MESSAGE_REFRESH object:nil];
}

- (void)refreshMessage
{
    //新好友请求未读
    NSInteger newFriendsCount = [IMGroupModel unReadNewFriendsCount];
    //未读推送
    NSInteger newsUnreadCount = [NewsPushModel findUnreadCount].count;
    NSInteger pushCount       = newFriendsCount + newsUnreadCount;
    
    //聊天未读
    NSInteger IMUnreadCount = [[RCIMClient sharedRCIMClient]getUnreadCount: @[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
    
    //徽标 最多显示99
    if (pushCount > 99) {
        pushCount = 99;
    }
    if (pushCount < 1) {
        self.notifyUnreadLabel.hidden = YES;
    }else{
        self.notifyUnreadLabel.hidden = NO;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.notifyUnreadLabel.text   = [NSString stringWithFormat:@"%ld", pushCount];
//        });
    }
    
    if (IMUnreadCount > 99) {
        IMUnreadCount = 99;
    }
    if (IMUnreadCount < 1) {
        self.chatUnreadLabel.hidden = YES;
    }else{
        self.chatUnreadLabel.hidden = NO;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.chatUnreadLabel.text   = [NSString stringWithFormat:@"%ld", IMUnreadCount];
//        });

    }
}

////未读推送
//- (void)unreadNewsPush
//{
//    NSInteger count = [NewsPushModel findUnreadCount].count;
//    if (count > 99) {
//        count = 99;
//    }
//
//    if (count < 1) {
//        self.notifyLabel.hidden = YES;
//    }else{
//        self.notifyLabel.hidden = NO;
//        self.notifyLabel.text   = [NSString stringWithFormat:@"%ld", count];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
