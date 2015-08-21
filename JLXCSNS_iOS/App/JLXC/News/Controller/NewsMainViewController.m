//
//  NewsMainViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NewsMainViewController.h"
#import "HMSegmentedControl.h"
#import "PublishNewsViewController.h"
#import "SchoolNewsListViewController.h"
#import "NotifyNewsViewController.h"
#import "RegisterInformationViewController.h"

@interface NewsMainViewController ()

////通知按钮
//@property (nonatomic, strong) CustomButton * notifyBtn;
////未读通知label
//@property (nonatomic, strong) CustomLabel * notifyLabel;

@property (nonatomic, strong) HMSegmentedControl * segmentedControl;

@property (nonatomic, strong) SchoolNewsListViewController * schoolNewsListVC;

@property (nonatomic, strong) UIScrollView * backScroll;

@end

@implementation NewsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化控件
    [self initWidget];
    //初始化UI
    [self configUI];
    //初始化ChildVC
    [self initChildVC];
//    //设置左滑
//    [self setLeftSide];
    //设置通知
    [self registerNotify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
//- (void)setLeftSide
//{
//    CusTabBarViewController * tab = (CusTabBarViewController *)self.tabBarController;
//    [tab setLeftBtnSlideWithNavBar:self.navBar];
//}

- (void)initWidget
{
    
    self.backScroll       = [[UIScrollView alloc] init];
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"状态", @"校园"]];
//    self.notifyBtn        = [[CustomButton alloc] init];
//    self.notifyLabel      = [[CustomLabel alloc] init];
    
    [self.view addSubview:self.backScroll];
    [self.navBar addSubview: self.segmentedControl];
//    [self.navBar addSubview:self.notifyBtn];
//    [self.notifyBtn addSubview:self.notifyLabel];
}

- (void)configUI
{
    
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

    //背景scroll
    self.backScroll.frame                          = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kTabBarHeight);
    self.backScroll.pagingEnabled                  = YES;
    self.backScroll.contentSize                    = CGSizeMake(self.viewWidth*2, 0);
    self.backScroll.showsHorizontalScrollIndicator = NO;
    self.backScroll.delegate                       = self;
    self.backScroll.bounces                        = NO;
    
    //设置右上点击事件
    //发状态
    __weak typeof(self) sself = self;
    
    self.navBar.rightBtn.backgroundColor = [UIColor redColor];
    [self.navBar setRightBtnWithContent:@"发布" andBlock:^{
        PublishNewsViewController * pnvc = [[PublishNewsViewController alloc] init];
        [sself pushVC:pnvc];
    }];
    if ([DeviceManager getDeviceSystem] > 7.0) {
        self.navBar.rightBtn.frame = CGRectMake([DeviceManager getDeviceWidth]-45, 20, 40, 44);
    }else{
        self.navBar.rightBtn.frame = CGRectMake([DeviceManager getDeviceWidth]-45, 0, 60, 44);
    }
    
    //通知按钮
//    self.notifyBtn.frame             = CGRectMake(self.navBar.rightBtn.x-45, self.navBar.rightBtn.y, 40, 44);
//    [self.notifyBtn setTitle:@"通知" forState:UIControlStateNormal];
//    [self.notifyBtn addTarget:self action:@selector(notifyListClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.notifyLabel.frame           = CGRectMake(0, 0, 20, 20);
//    self.notifyLabel.font            = [UIFont systemFontOfSize:13];
    
//    //提示
//    [self unreadNewsPush];
    
}


//添加子类VC
- (void)initChildVC
{
    //会话VC
    self.newsListVC = [[NewsListViewController alloc] init];
    [self addChildViewController:self.newsListVC];
    self.newsListVC.view.frame = CGRectMake(0, 0, self.viewWidth, self.backScroll.height);
    [self.backScroll addSubview:self.newsListVC.view];
    
    //好友VC
    self.schoolNewsListVC = [[SchoolNewsListViewController alloc] init];
    [self addChildViewController:self.schoolNewsListVC];
    self.schoolNewsListVC.view.frame = CGRectMake(self.viewWidth, 0, self.viewWidth, self.backScroll.height);
    [self.backScroll addSubview:self.schoolNewsListVC.view];
    
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= self.viewWidth) {
        [self.segmentedControl setSelectedSegmentIndex:1 animated:NO];
    }else{
        [self.segmentedControl setSelectedSegmentIndex:0 animated:NO];
    }
}


#pragma mark- method response
//页面修改
-(void) segmentedControlChangedValue:(HMSegmentedControl *)segment
{
    [UIView animateWithDuration:0.3f animations:^{
        self.backScroll.contentOffset = CGPointMake(segment.selectedSegmentIndex*self.viewWidth, 0);
    }];
}

//- (void)notifyListClick:(id)sender
//{
//    NotifyNewsViewController * nnVC = [[NotifyNewsViewController alloc] init];
//    [self pushVC:nnVC];
//    
////    self.notifyLabel.hidden         = YES;
//}
#pragma mark- private method
- (void)registerNotify
{
//    //新推送到来
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadNewsPush) name:NOTIFY_NEWS_PUSH object:nil];
//    //所有变成已读
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadNewsPush) name:NOTIFY_NEWS_ISREAD object:nil];
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
