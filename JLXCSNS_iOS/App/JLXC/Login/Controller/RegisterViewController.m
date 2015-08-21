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
#import "YSAlertView.h"

@interface RegisterViewController ()

//注册按钮
@property (nonatomic, strong) CustomButton * registerBtn;
//密码textfield
@property (nonatomic, strong) CustomTextField * passwordTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self.passwordTextField resignFirstResponder];
}

#pragma mark- layout
- (void)createWidget
{
    //背景
    CustomImageView * backImageView = [[CustomImageView alloc] initWithFrame:self.view.bounds];
    backImageView.contentMode       = UIViewContentModeScaleAspectFill;
    backImageView.image             = [UIImage imageNamed:@"login_back_image"];
    [self.view addSubview:backImageView];
    [self.view sendSubviewToBack:backImageView];
    
    //注册
    self.registerBtn     = [[CustomButton alloc] init];
    //密码
    self.passwordTextField    = [[CustomTextField alloc] init];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.passwordTextField];
    
    
    __weak typeof(self) sself = self;
    //设置返回
    [self.navBar setLeftBtnWithContent:nil andBlock:^{
        YSAlertView * alertView = [[YSAlertView alloc] initWithTitle:@"不注册了吗？" contentText:@"勉为其难注册一下吧~" leftButtonTitle:@"好的" rightButtonTitle:@"不了"  showView:sself.view];
        [alertView setRightBlock:^{
            [sself.navigationController popViewControllerAnimated:YES];
        }];
        [alertView show];
    }];
}

- (void)configUI
{
    if (self.isFindPwd) {
        [self.navBar setNavTitle:@"找回密码"];
    }else{
        [self.navBar setNavTitle:@"注册"];
    }
    self.navBar.backgroundColor = [UIColor clearColor];
    
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

    CustomLabel * promptLabel                    = [[CustomLabel alloc] initWithFrame:CGRectMake(lineView.x, lineView.bottom+5, lineView.width, 20)];
    promptLabel.text                             = @"密码长度只能是6到24位哦";
    promptLabel.textAlignment                    = NSTextAlignmentCenter;
    promptLabel.textColor                        = [UIColor colorWithHexString:ColorBrown];
    promptLabel.font                             = [UIFont systemFontOfSize:10];
    [self.view addSubview:promptLabel];

    //btn样式处理
    self.registerBtn.frame                       = CGRectMake(kCenterOriginX(250), self.passwordTextField.bottom+50, 250, 30);
    self.registerBtn.layer.cornerRadius          = 3;
    [self.registerBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    self.registerBtn.fontSize                    = FontLoginButton;
    self.registerBtn.backgroundColor             = [UIColor colorWithHexString:ColorYellow];
    [self.registerBtn setTitle:@"下一步" forState:UIControlStateNormal];

    if (self.isFindPwd) {
        [self.registerBtn addTarget:self action:@selector(findPwdLogin:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.registerBtn addTarget:self action:@selector(registerLogin:) forControlEvents:UIControlEventTouchUpInside];
    }

}

#pragma mark- event Response
- (void)registerLogin:(id)sender
{
//    username=15810710441&password=123456&verify_code=123456
    
    if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 24) {
        [self showWarn:@"请输入6-24位密码=_="];
        return;
    }
    
    debugLog(@"%@", kRegisterUserPath);
    NSDictionary * dic = @{@"username":self.phoneNumber,
                           @"password":[self.passwordTextField.text MD5]};
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
    
    if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 24) {
        [self showWarn:@"请输入6-24位密码=_="];
        return;
    }
    
    debugLog(@"%@", kFindPwdPath);
    NSDictionary * dic = @{@"username":self.phoneNumber,
                           @"password":[self.passwordTextField.text MD5]};
    
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
            
            [self presentViewController:nav animated:YES completion:^{
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

#pragma mark- UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark- private method
//- (void)timerResend:(id)ti
//{
//    self.timerNum --;
//    [self.reverifyBtn setTitle:[NSString stringWithFormat:@"%d秒", self.timerNum] forState:UIControlStateNormal];
//    
//    if (self.timerNum == 0) {
//        [self.timer invalidate];
//        [self.reverifyBtn setTitle:[NSString stringWithFormat:@"点击重发"] forState:UIControlStateNormal];
//        self.reverifyBtn.enabled = YES;
//        return;
//    }
//    
//}

//- (void)resend:(id)sender
//{
//    debugLog(@"%@", kGetMobileVerifyPath);
//    [HttpService postWithUrlString:kGetMobileVerifyPath params:@{@"phone_num":self.phoneNumber} andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        
//        int status = [responseData[@"status"] intValue];
//        if (status == HttpStatusCodeSuccess) {
//            [self showComplete:responseData[@"message"]];
//            self.timerNum = 10;
//            self.reverifyBtn.enabled = NO;
//            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerResend:) userInfo:nil repeats:YES];
//            
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
