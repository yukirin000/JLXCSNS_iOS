//
//  RegisterViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/12.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+Encrypt.h"
#import "ChoiceSchoolViewController.h"
#import "CusTabBarViewController.h"

@interface RegisterViewController ()

@property (nonatomic, strong) CustomButton * registerBtn;
@property (nonatomic, strong) CustomButton * reverifyBtn;
@property (nonatomic, strong) CustomTextField * verifyTextField;
@property (nonatomic, strong) CustomTextField * pwdTextField;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) int timerNum;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timerNum = 10;
    self.view.backgroundColor = [UIColor grayColor];
    
    [self createWidget];
    [self configUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.verifyTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}

#pragma mark- layout
- (void)createWidget
{
    self.registerBtn     = [[CustomButton alloc] init];
    self.verifyTextField = [[CustomTextField alloc] init];
    self.reverifyBtn     = [[CustomButton alloc] init];
    self.pwdTextField    = [[CustomTextField alloc] init];
    
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.verifyTextField];
    [self.view addSubview:self.reverifyBtn];
    [self.view addSubview:self.pwdTextField];
}

- (void)configUI
{
    self.verifyTextField.frame        = CGRectMake(kCenterOriginX(250), 100, 250, 30);
    self.verifyTextField.placeholder  = @"请输入验证码";
    self.verifyTextField.borderStyle  = UITextBorderStyleRoundedRect;

    self.pwdTextField.frame           = CGRectMake(kCenterOriginX(250), self.verifyTextField.bottom+20, 250, 30);
    self.pwdTextField.placeholder     = @"请输入6-24位密码";
    self.pwdTextField.secureTextEntry = YES;
    self.pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.registerBtn.frame             = CGRectMake(kCenterOriginX(100), self.pwdTextField.bottom+40, 100, 30);
    [self.registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    if (self.isFindPwd) {
        [self.registerBtn addTarget:self action:@selector(findPwdLogin:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.registerBtn addTarget:self action:@selector(registerLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CustomLabel * textLabel = [[CustomLabel alloc] initWithFontSize:14];
    textLabel.textColor     = [UIColor cyanColor];
    textLabel.frame         = CGRectMake(self.verifyTextField.x, self.verifyTextField.y-30, 200, 20);
    textLabel.text          = [NSString stringWithFormat:@"已发送验证码至%@", self.phoneNumber];
    [self.view addSubview:textLabel];
    
    self.reverifyBtn.frame           = CGRectMake(self.verifyTextField.right-30, textLabel.y, 60, 20);
    self.reverifyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.reverifyBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.reverifyBtn addTarget:self action:@selector(resend:) forControlEvents:UIControlEventTouchUpInside];
    self.reverifyBtn.enabled = NO;
    [self.reverifyBtn setTitle:@"10秒" forState:UIControlStateNormal];
    
    self.verifyTextField.text        = @"123456";
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerResend:) userInfo:nil repeats:YES];
}

#pragma mark- event Response
- (void)registerLogin:(id)sender
{
//    username=15810710441&password=123456&verify_code=123456
    
    if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length > 24) {
        ALERT_SHOW(StringCommonPrompt, @"请输入6-24位密码=_=");
        return;
    }
    
    debugLog(@"%@", kRegisterUserPath);
    NSDictionary * dic = @{@"username":self.phoneNumber,
                           @"password":[self.pwdTextField.text MD5],
                           @"verify_code":self.verifyTextField.text};
    debugLog(@"%@", dic);
    [self showLoading:@"用户注册中.."];
    [HttpService postWithUrlString:kRegisterUserPath params:dic andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        NSLog(@"%@", responseData);
        
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[@"message"]];
            [[[UserService sharedService] user] setModelWithDic:responseData[@"result"]];
            //数据本地缓存
            [[UserService sharedService] saveAndUpdate];
            
            ChoiceSchoolViewController * csvc = [[ChoiceSchoolViewController alloc] init];
            [self pushVC:csvc];
            
        }else{
            [self showWarn:responseData[@"message"]];
        }
        
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:@"网络异常T_T"];
    }];
}

- (void)findPwdLogin:(id)sender
{
    
    if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length > 24) {
        ALERT_SHOW(StringCommonPrompt, @"请输入6-24位密码=_=");
        return;
    }
    
    debugLog(@"%@", kFindPwdPath);
    NSDictionary * dic = @{@"username":self.phoneNumber,
                           @"password":[self.pwdTextField.text MD5],
                           @"verify_code":self.verifyTextField.text};
    
    debugLog(@"%@", dic);
    [self showLoading:@"密码修改中.."];
    [HttpService postWithUrlString:kFindPwdPath params:dic andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        NSLog(@"%@", responseData);
        
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[@"message"]];
            [[[UserService sharedService] user] setModelWithDic:responseData[@"result"]];
            
            //数据本地缓存
            [[UserService sharedService] saveAndUpdate];
            
            //找回密码成功进入主页
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
            
        }else{
            [self showWarn:responseData[@"message"]];
        }
        
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:@"网络异常T_T"];
    }];
}

#pragma mark- private method
- (void)timerResend:(id)ti
{
    self.timerNum --;
    [self.reverifyBtn setTitle:[NSString stringWithFormat:@"%d秒", self.timerNum] forState:UIControlStateNormal];
    
    if (self.timerNum == 0) {
        [self.timer invalidate];
        [self.reverifyBtn setTitle:[NSString stringWithFormat:@"点击重发"] forState:UIControlStateNormal];
        self.reverifyBtn.enabled = YES;
        return;
    }
    
}

- (void)resend:(id)sender
{
    debugLog(@"%@", kGetMobileVerifyPath);
    [HttpService postWithUrlString:kGetMobileVerifyPath params:@{@"phone_num":self.phoneNumber} andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[@"message"]];
            self.timerNum = 10;
            self.reverifyBtn.enabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerResend:) userInfo:nil repeats:YES];
            
        }else{
            [self showWarn:responseData[@"message"]];
        }
        
        NSLog(@"%@", responseData);
        
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:@"网络异常T_T"];
        
    }];
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
