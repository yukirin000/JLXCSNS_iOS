//
//  ViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/8.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "SDWebImageManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#define HUDProgressTag 99999

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navBar = [[NavBar alloc] init];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBaseVC];
}

#pragma layout
//初始化基类内部
- (void)initBaseVC
{
    
    self.view.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    self.viewWidth = [DeviceManager getDeviceWidth];
    self.viewHeight = [DeviceManager getDeviceHeight];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;        
        [self setNeedsStatusBarAppearanceUpdate];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    //初始化HUD
    [self initHUD];
    //创建导航栏
    [self createNavBar];
    //设置返回按钮
    [self setBackBtn];
    //处理原始的navBar
    [self handleOriginNavBar];
    
    if (self.hideNavbar == YES) {
        
        self.navigationController.navigationBarHidden = YES;
        //隐藏导航栏
        self.navBar.hidden = YES;

    }else if (self.hideLeftBtn == YES){
        //隐藏左边按钮
        self.navBar.leftBtn.hidden = YES;
    }
}

- (void)initHUD
{
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    self.hudProgress = [[MBProgressHUD alloc] initWithView:window];
    self.hudProgress.tag = HUDProgressTag;
//    [self.view addSubview:self.hudProgress];
    [window addSubview:_hudProgress];
    //点击HUD消失效果
    UITapGestureRecognizer *hudTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLoading)];
    [self.hudProgress addGestureRecognizer:hudTap];
}

- (void)createNavBar
{
    
    [self.view addSubview:self.navBar];
//    self.navBar.alpha = 0.5;
    
}

- (void)setBackBtn
{
    __weak typeof(self) sself = self;
    //返回按钮
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"back_white_btn_selected"] forState:UIControlStateHighlighted];
    if ([DeviceManager getDeviceSystem] >= 7.0) {
        [self.navBar setLeftBtnWithFrame:CGRectMake(10, 15, 40, 50) andContent:nil andBlock:^{
            [sself.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [self.navBar setLeftBtnWithFrame:CGRectMake(10, 0, 40, 50) andContent:nil  andBlock:^{
            [sself.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}

- (void)handleOriginNavBar
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), false, 0);
    UIColor * color     = [UIColor clearColor];
    [color setFill];
    UIRectFillUsingBlendMode(CGRectMake(0, 0, 100, 100), kCGBlendModeXOR);
    CGImageRef cgimage  = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    UIImage * backImage = [UIImage imageWithCGImage:cgimage];
    
    [self.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:backImage];
    self.navigationController.navigationBar.translucent = YES;
    self.edgesForExtendedLayout                         = UIRectEdgeAll;
//    self.extendedLayoutIncludesOpaqueBars = NO;

    UIView * backView = [self.navigationController.navigationBar.subviews lastObject];
    if ([backView isKindOfClass:[backView class]]) {
        self.navigationController.navigationBar.topItem.title = @"";
        backView.frame = CGRectZero;
    }
    
//    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    
}

#pragma mark- override method
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark- private method

/*!设置NavBarTitle*/
- (void)setNavBarTitle:(NSString *)title
{
    [self.navBar setNavTitle:title];
}

/*!入栈*/
- (void)pushVC:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

/*!出栈*/
- (void)popToTabBarViewController
{
    [self popToTabBarViewControllerWithAnimate:YES];
}

/*!无动画出栈*/
- (void)popToTabBarViewControllerNoAnimation
{
    [self popToTabBarViewControllerWithAnimate:NO];
}

- (void)popToTabBarViewControllerWithAnimate:(BOOL)yesOrNo
{
    for (int i=0; i<[self.navigationController viewControllers].count; i++) {
        UIViewController *viewController = [[self.navigationController viewControllers] objectAtIndex:i];
        if ([NSStringFromClass([viewController class]) isEqual:@"CusTabBarViewController"]) {
            CusTabBarViewController *main = [self.navigationController.viewControllers objectAtIndex:i];
            [self.navigationController popToViewController:main animated:yesOrNo];
        }
    }
}


//hud
//显示完成
-(void)showComplete:(NSString *)text
{
	_hudProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ToastFinish"]];
	// Set custom view mode
	_hudProgress.mode = MBProgressHUDModeCustomView;
	_hudProgress.delegate = self;
	_hudProgress.labelText = text;
	[_hudProgress show:YES];
	[_hudProgress hide:YES afterDelay:1];
}

//显示有错误
-(void)showWarn:(NSString *)text
{
    _hudProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ToastWarn"]];
	// Set custom view mode
	_hudProgress.mode = MBProgressHUDModeCustomView;
	_hudProgress.delegate = self;
	_hudProgress.labelText = text;
	[_hudProgress show:YES];
	[_hudProgress hide:YES afterDelay:1.0];
}

//显示Loading动画
- (void)showLoading:(NSString *)text
{
    _hudProgress.mode = MBProgressHUDModeIndeterminate;
    _hudProgress.delegate = self;
    _hudProgress.labelText = text;
    [_hudProgress show:YES];
}

//隐藏Loading动画
- (void)hideLoading
{
    [_hudProgress hide:YES];
}

//弹出提示，3秒后自动消失
- (void)toast:(NSString *)text
{
    _hudProgress.mode = MBProgressHUDModeText;
    _hudProgress.labelText = text;
    _hudProgress.margin = 10.f;
    [_hudProgress show:YES];
    [_hudProgress hide:YES afterDelay:1];
}

- (void)didReceiveMemoryWarning
{
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
