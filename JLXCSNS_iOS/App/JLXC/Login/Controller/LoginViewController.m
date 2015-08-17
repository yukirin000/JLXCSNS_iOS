//
//  LoginViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/12.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "RegisterInformationViewController.h"
#import "SecondLoginViewController.h"
#import "PublishNewsViewController.h"
#import "ChoiceSchoolViewController.h"
#import "NewsListViewController.h"
#import "TestListViewController.h"
#import "PersonalViewController.h"
#import "CommonFriendsListViewController.h"

@interface LoginViewController ()

@property(nonatomic, strong) CustomButton * loginBtn;
@property(nonatomic, strong) CustomTextField * loginTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    //自动登录
    if ([self autoLogin]) {
        
        return;
    }else{
        //非自动登录 初始化页面
        [self createWidget];
        [self configUI];
    }
}

#pragma mark- layout
- (void)createWidget
{
    self.loginBtn       = [[CustomButton alloc] init];
    self.loginTextField = [[CustomTextField alloc] init];
    
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.loginTextField];
}

- (void)configUI
{
    self.loginTextField.frame       = CGRectMake(kCenterOriginX(250), 100, 200, 30);
    self.loginTextField.placeholder = @"请输入手机号";
    self.loginTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.loginBtn.frame             = CGRectMake(kCenterOriginX(100), self.loginTextField.bottom+40, 100, 30);
    [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(nextLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginTextField.text        = @"13736661240";
    
}

#pragma mark- event Response
- (void)nextLogin:(id)sender
{
    
    if (![ToolsManager validateMobile:self.loginTextField.text]) {
        [self showWarn:@"请输入正确的手机号码"];
        return;
    }
    
    [self showLoading:nil];
    NSDictionary * params = @{@"username":self.loginTextField.text};
    debugLog(@"%@", kIsUserPath);
    [HttpService postWithUrlString:kIsUserPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        //登录
        int loginDirection    = 1;
        //注册
        int registerDirection = 2;
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            int direction = [responseData[@"result"][@"direction"] intValue];
            if (direction == loginDirection) {
                [self hideLoading];
                debugLog(@"跳转到登录");
                SecondLoginViewController * slVC = [[SecondLoginViewController alloc] init];
                slVC.username                    = self.loginTextField.text;
                [self pushVC:slVC];
            }
            
            if (direction == registerDirection) {
                debugLog(@"跳转到注册");
//                [self sendVerify];
                RegisterViewController * rvc = [[RegisterViewController alloc] init];
                rvc.phoneNumber              = self.loginTextField.text;
                [self pushVC:rvc];
                [self hideLoading];
            }
            
        }else{
            [self showWarn:responseData[@"message"]];
        }
//        debugLog(@"%@", responseData);
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:@"网络异常T_T"];
    }];
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.loginTextField resignFirstResponder];
}

#pragma mark- privateMethod
////跳转到注册页面 发送验证码
//- (void)sendVerify
//{
//    debugLog(@"%@", kGetMobileVerifyPath);
//    [HttpService postWithUrlString:kGetMobileVerifyPath params:@{@"phone_num":self.loginTextField.text} andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//
//        int status = [responseData[@"status"] intValue];
//        if (status == HttpStatusCodeSuccess) {
//            RegisterViewController * rvc = [[RegisterViewController alloc] init];
//            rvc.phoneNumber              = self.loginTextField.text;
//            [self pushVC:rvc];
//            [self hideLoading];
//        }else{
//            [self showWarn:responseData[@"message"]];
//        }
//        
//        debugLog(@"%@", responseData);
//        
//    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showWarn:@"网络异常T_T"];
//
//    }];
//}

//自动登录
- (BOOL)autoLogin
{
    [[UserService sharedService] find];
    //如果用户登录过 自动登录
    if ([UserService sharedService].user.uid > 0 && [UserService sharedService].user.login_token.length > 0) {
        
        if ([UserService sharedService].user.school.length < 1) {
            ChoiceSchoolViewController * csvc = [[ChoiceSchoolViewController alloc] init];
            [self.navigationController pushViewController:csvc animated:NO];
            //自动登录成功 初始化这个页面
            [self createWidget];
            [self configUI];
        }else{
            //登录成功进入主页
            CusTabBarViewController * ctbvc = [CusTabBarViewController sharedService];
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctbvc];
            //侧滑
            PPRevealSideViewController * revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
            //设置状态栏背景颜色
            [revealSideViewController setFakeiOS7StatusBarColor:[UIColor clearColor]];
            //    [revealSlideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
            [revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNone];
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:revealSideViewController animated:NO completion:^{
                //自动登录成功 初始化这个页面
                [self createWidget];
                [self configUI];
            }];
        }
        
        return YES;
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
