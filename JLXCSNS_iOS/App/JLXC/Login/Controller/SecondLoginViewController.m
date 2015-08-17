//
//  SecondLoginViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/13.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "SecondLoginViewController.h"
#import "NSString+Encrypt.h"
#import "AppDelegate.h"
#import "CusTabBarViewController.h"
#import "RegisterViewController.h"
#import "ChoiceSchoolViewController.h"
@interface SecondLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginClick:(id)sender;
- (IBAction)forgetPwd:(id)sender;

@end

@implementation SecondLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.passwordTextField.text = @"123456";
    self.passwordTextField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passwordTextField resignFirstResponder];
}

#pragma mark- method response
- (IBAction)loginClick:(id)sender {
    
    if (self.passwordTextField.text.length < 1) {
        ALERT_SHOW(StringCommonPrompt, @"请输入密码=_=");
        return;
    }

    debugLog(@"%@", kLoginUserPath);
    NSDictionary * dic = @{@"username":self.username,
                           @"password":[self.passwordTextField.text MD5]};
    debugLog(@"%@", dic);
    [self showLoading:@"登录中.."];
    [HttpService postWithUrlString:kLoginUserPath params:dic andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
//        debugLog(@"%@", responseData);
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
//            [self showComplete:responseData[@"message"]];
            [self hideLoading];
            [[[UserService sharedService] user] setModelWithDic:responseData[@"result"]];
            //数据本地缓存
            [[UserService sharedService] saveAndUpdate];
            
            //没填学校 就去填学校
            if ([UserService sharedService].user.school.length < 1) {
                ChoiceSchoolViewController * csvc = [[ChoiceSchoolViewController alloc] init];
                [self pushVC:csvc];
            }else{
                //登录成功进入主页
                [CusTabBarViewController reinit];
                CusTabBarViewController * ctbvc = [CusTabBarViewController sharedService];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctbvc];
                
                //侧滑
                PPRevealSideViewController * revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
                //设置状态栏背景颜色
                [revealSideViewController setFakeiOS7StatusBarColor:[UIColor clearColor]];
                //    [revealSlideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
                [revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNone];
                [self presentViewController:revealSideViewController animated:YES completion:^{
                
                    //登录成功 出栈
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }

        }else{
            [self showWarn:responseData[@"message"]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:@"网络异常T_T"];
    }];
}

- (IBAction)forgetPwd:(id)sender {
    [self sendVerify];
}

#pragma mark- private Method
//跳转到找回密码页面 发送验证码
- (void)sendVerify
{
    debugLog(@"%@", kGetMobileVerifyPath);
    [HttpService postWithUrlString:kGetMobileVerifyPath params:@{@"phone_num":self.username} andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            RegisterViewController * rvc = [[RegisterViewController alloc] init];
            rvc.phoneNumber              = self.username;
            rvc.isFindPwd                = YES;
            [self pushVC:rvc];
            [self hideLoading];
        }else{
            [self showWarn:responseData[@"message"]];
        }
        
        NSLog(@"%@", responseData);
        
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:@"网络异常T_T"];
        
    }];
}
@end
