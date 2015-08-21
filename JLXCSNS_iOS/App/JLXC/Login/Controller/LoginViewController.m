//
//  LoginViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/12.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "LoginViewController.h"
#import "VerifyViewController.h"
#import "SecondLoginViewController.h"
#import "PublishNewsViewController.h"
#import "ChoiceSchoolViewController.h"
#import "NewsListViewController.h"
#import "TestListViewController.h"
#import "PersonalViewController.h"
#import "CommonFriendsListViewController.h"
#import "YSAlertView.h"

@interface LoginViewController ()

@property(nonatomic, strong) CustomButton * loginBtn;
@property(nonatomic, strong) CustomTextField * loginTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:ColorYellow];
    
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
    //背景
    CustomImageView * backImageView = [[CustomImageView alloc] initWithFrame:self.view.bounds];
    backImageView.contentMode       = UIViewContentModeScaleAspectFill;
    backImageView.image             = [UIImage imageNamed:@"login_back_image"];
    [self.view addSubview:backImageView];
    //登录按钮
    self.loginBtn       = [[CustomButton alloc] init];
    //登录textfield
    self.loginTextField = [[CustomTextField alloc] init];
    
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.loginTextField];
    
    //绑定事件
    [self.loginBtn addTarget:self action:@selector(nextLogin:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configUI
{
    //placeHolder处理
    UIFont * placeHolderFont                  = [UIFont systemFontOfSize:FontLoginTextField];
    UIColor * placeHolderWhite                = [UIColor colorWithHexString:ColorWhite];
    NSAttributedString * placeHolderString    = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSFontAttributeName:placeHolderFont,NSForegroundColorAttributeName:placeHolderWhite}];
    //loginTextFiled样式处理
    self.loginTextField.frame                 = CGRectMake(kCenterOriginX(250), 150, 250, 30);
    self.loginTextField.delegate              = self;
    self.loginTextField.attributedPlaceholder = placeHolderString;
    self.loginTextField.font                  = placeHolderFont;
    self.loginTextField.clearButtonMode       = UITextFieldViewModeWhileEditing;
    self.loginTextField.textColor             = [UIColor colorWithHexString:ColorDeepBlack];
    self.loginTextField.tintColor             = [UIColor colorWithHexString:ColorLightBlack];
    self.loginTextField.keyboardType          = UIKeyboardTypeNumberPad;
    
    //增加底部线
    UIView * lineView                         = [[UIView alloc] initWithFrame:CGRectMake(self.loginTextField.x, self.loginTextField.bottom, self.loginTextField.width, 1)];
    lineView.backgroundColor                  = [UIColor colorWithHexString:ColorWhite];
    [self.view addSubview:lineView];

    //btn样式处理
    self.loginBtn.frame                       = CGRectMake(kCenterOriginX(250), self.loginTextField.bottom+30, 250, 40);
    self.loginBtn.layer.cornerRadius          = 3;
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    self.loginBtn.fontSize                    = FontLoginButton;
    self.loginBtn.backgroundColor             = [UIColor colorWithHexString:ColorYellow];
    [self.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    
    self.loginTextField.text         = @"18888888888";
    
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
                SecondLoginViewController * slVC = [[SecondLoginViewController alloc] init];
                slVC.username                    = self.loginTextField.text;
                [self pushVC:slVC];
            }
            
            if (direction == registerDirection) {
                VerifyViewController * vvc = [[VerifyViewController alloc] init];
                vvc.phoneNumber            = self.loginTextField.text;
                [self pushVC:vvc];
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

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.loginTextField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //手机号不超过11位
    if (range.length == 0) {
        if ((textField.text.length+string.length)>11) {
            return NO;
        }
    }
    
    return YES;
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

            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:nav animated:NO completion:^{
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
