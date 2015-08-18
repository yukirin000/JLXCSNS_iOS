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
#import "VerifyViewController.h"

@interface SecondLoginViewController ()

//密码
@property(nonatomic, strong) CustomTextField * passwordTextField;
//登录
@property(nonatomic, strong) CustomButton * loginBtn;
//找回密码
@property(nonatomic, strong) CustomButton * findPwdBtn;


@end

@implementation SecondLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWidget];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    //背景
    CustomImageView * backImageView = [[CustomImageView alloc] initWithFrame:self.view.bounds];
    backImageView.contentMode       = UIViewContentModeScaleAspectFill;
    backImageView.image             = [UIImage imageNamed:@"login_back_image"];
    [self.view addSubview:backImageView];
    [self.view sendSubviewToBack:backImageView];
    
    //登录按钮
    self.loginBtn          = [[CustomButton alloc] init];
    //密码textfield
    self.passwordTextField = [[CustomTextField alloc] init];
    self.findPwdBtn        = [[CustomButton alloc] init];
    
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.findPwdBtn];
    
    //设置事件
    [self.loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.findPwdBtn addTarget:self action:@selector(forgetPwd:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configUI
{
    self.navBar.backgroundColor = [UIColor clearColor];
    [self.navBar setNavTitle:@"登录"];
    
    //placeHolder处理
    UIFont * placeHolderFont                     = [UIFont systemFontOfSize:FontLoginTextField];
    UIColor * placeHolderWhite                   = [UIColor colorWithHexString:ColorWhite];
    NSAttributedString * placeHolderString       = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSFontAttributeName:placeHolderFont,NSForegroundColorAttributeName:placeHolderWhite}];
    //loginTextFiled样式处理
    self.passwordTextField.frame                 = CGRectMake(kCenterOriginX(250), 150, 250, 30);
    self.passwordTextField.delegate              = self;
    self.passwordTextField.secureTextEntry       = YES;
    self.passwordTextField.clearButtonMode       = UITextFieldViewModeWhileEditing;
    self.passwordTextField.attributedPlaceholder = placeHolderString;
    self.passwordTextField.font                  = placeHolderFont;
    self.passwordTextField.textColor             = [UIColor colorWithHexString:ColorDeepBlack];
    self.passwordTextField.tintColor             = [UIColor colorWithHexString:ColorLightBlack];

    //增加底部线
    UIView * lineView                            = [[UIView alloc] initWithFrame:CGRectMake(self.passwordTextField.x, self.passwordTextField.bottom, self.passwordTextField.width, 1)];
    lineView.backgroundColor                     = [UIColor colorWithHexString:ColorWhite];
    [self.view addSubview:lineView];

    //btn样式处理
    self.loginBtn.frame                          = CGRectMake(kCenterOriginX(250), self.passwordTextField.bottom+30, 250, 30);
    self.loginBtn.layer.cornerRadius             = 3;
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    self.loginBtn.fontSize                       = FontLoginButton;
    self.loginBtn.backgroundColor                = [UIColor colorWithHexString:ColorYellow];
    [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];

    //找回密码
    self.findPwdBtn.frame                        = CGRectMake(kCenterOriginX(120), self.view.bottom-50, 120, 40);
    self.findPwdBtn.fontSize                     = 13;
    [self.findPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.findPwdBtn setTitle:@"啊咧，忘记密码？" forState:UIControlStateNormal];
    
    self.passwordTextField.text                  = @"123456";
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passwordTextField resignFirstResponder];
}

#pragma mark- method response
- (void)loginClick:(id)sender {
    
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

- (void)forgetPwd:(id)sender {
    
    //忘记密码
    VerifyViewController * vvc = [[VerifyViewController alloc] init];
    vvc.phoneNumber            = self.username;
    vvc.isFindPwd              = YES;
    [self pushVC:vvc];
    
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordTextField resignFirstResponder];
    return YES;
}


#pragma mark- private Method
//跳转到找回密码页面 发送验证码
//- (void)sendVerify
//{
//    debugLog(@"%@", kGetMobileVerifyPath);
//    [HttpService postWithUrlString:kGetMobileVerifyPath params:@{@"phone_num":self.username} andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        
//        int status = [responseData[@"status"] intValue];
//        if (status == HttpStatusCodeSuccess) {
//            RegisterViewController * rvc = [[RegisterViewController alloc] init];
//            rvc.phoneNumber              = self.username;
//            rvc.isFindPwd                = YES;
//            [self pushVC:rvc];
//            [self hideLoading];
//        }else{
//            [self showWarn:responseData[@"message"]];
//        }
//        
//        NSLog(@"%@", responseData);
//        
//        
//    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showWarn:@"网络异常T_T"];
//        
//    }];
//}
@end
