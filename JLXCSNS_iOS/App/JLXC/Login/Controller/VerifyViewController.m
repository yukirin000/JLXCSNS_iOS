//
//  VerifyViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/8/18.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "VerifyViewController.h"
#import "YSAlertView.h"
#import "CusTabBarViewController.h"
#import "RegisterViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/CountryAndAreaCode.h>

@interface VerifyViewController ()

@property (nonatomic, strong) CustomButton * nextBtn;
@property (nonatomic, strong) CustomButton * reverifyBtn;
@property (nonatomic, strong) CustomTextField * verifyTextField;
//倒计时
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) int timerNum;

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //获取验证码
    [self getVerify];
    
    self.timerNum = 59;
    self.view.backgroundColor = [UIColor grayColor];
    
    [self createWidget];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
    }
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.verifyTextField resignFirstResponder];
}

#pragma mark- layout
- (void)createWidget
{
    self.navBar.backgroundColor = [UIColor clearColor];
    
    //背景
    CustomImageView * backImageView = [[CustomImageView alloc] initWithFrame:self.view.bounds];
    backImageView.contentMode       = UIViewContentModeScaleAspectFill;
    backImageView.image             = [UIImage imageNamed:@"login_back_image"];
    [self.view addSubview:backImageView];
    [self.view sendSubviewToBack:backImageView];
    
    //注册
    self.nextBtn     = [[CustomButton alloc] init];
    //验证码
    self.verifyTextField = [[CustomTextField alloc] init];
    //重新验证
    self.reverifyBtn     = [[CustomButton alloc] init];
    
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.verifyTextField];
    [self.view addSubview:self.reverifyBtn];
    
    [self.nextBtn addTarget:self action:@selector(verifyCommit:) forControlEvents:UIControlEventTouchUpInside];
    [self.reverifyBtn addTarget:self action:@selector(resend:) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) sself = self;
    //设置返回
    [self.navBar setLeftBtnWithContent:nil andBlock:^{
        YSAlertView * alertView = [[YSAlertView alloc] initWithTitle:@"已经发送验证码辣" contentText:@"不等一会吗？" leftButtonTitle:@"好的" rightButtonTitle:@"不了"  showView:sself.view];
        [alertView setRightBlock:^{
            [sself.navigationController popViewControllerAnimated:YES];
        }];
        [alertView show];
    }];
}

- (void)configUI
{
    
    [self.navBar setNavTitle:@"验证码"];
    //标题
    CustomLabel * textLabel                    = [[CustomLabel alloc] initWithFontSize:14];
    textLabel.textColor                        = [UIColor colorWithHexString:ColorDeepBlack];
    textLabel.frame                            = CGRectMake(kCenterOriginX(250), 100, 250, 20);
    textLabel.text                             = [NSString stringWithFormat:@"已发送验证码至手机：%@", self.phoneNumber];
    [self.view addSubview:textLabel];

    //placeHolder处理 验证textView
    UIFont * placeHolderFont                   = [UIFont systemFontOfSize:FontLoginTextField];
    UIColor * placeHolderWhite                 = [UIColor colorWithHexString:ColorWhite];
    NSAttributedString * placeHolderString     = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSFontAttributeName:placeHolderFont,NSForegroundColorAttributeName:placeHolderWhite}];
    //loginTextFiled样式处理
    self.verifyTextField.frame                 = CGRectMake(kCenterOriginX(250), textLabel.bottom+10, 180, 30);
    self.verifyTextField.delegate              = self;
    self.verifyTextField.attributedPlaceholder = placeHolderString;
    self.verifyTextField.font                  = placeHolderFont;
    self.verifyTextField.clearButtonMode       = UITextFieldViewModeWhileEditing;
    self.verifyTextField.textColor             = [UIColor colorWithHexString:ColorDeepBlack];
    self.verifyTextField.tintColor             = [UIColor colorWithHexString:ColorLightBlack];
    self.verifyTextField.keyboardType          = UIKeyboardTypeNumberPad;

    //重发按钮
    self.reverifyBtn.frame                     = CGRectMake(self.verifyTextField.right+5, self.verifyTextField.y, 65, self.verifyTextField.height-2);
    self.reverifyBtn.titleLabel.font           = [UIFont systemFontOfSize:FontLoginButton];
    self.reverifyBtn.layer.cornerRadius        = 2;
    [self.reverifyBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    [self.reverifyBtn setBackgroundColor:[UIColor colorWithHexString:ColorYellow]];
    self.reverifyBtn.enabled                   = NO;
    [self.reverifyBtn setTitle:@"59秒" forState:UIControlStateNormal];
    
    //增加底部线
    UIView * lineView                         = [[UIView alloc] initWithFrame:CGRectMake(self.verifyTextField.x, self.verifyTextField.bottom, 250, 1)];
    lineView.backgroundColor                  = [UIColor colorWithHexString:ColorWhite];
    [self.view addSubview:lineView];
    
    //btn样式处理
    self.nextBtn.frame                       = CGRectMake(kCenterOriginX(250), self.verifyTextField.bottom+30, 250, 40);
    self.nextBtn.layer.cornerRadius          = 3;
    [self.nextBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    self.nextBtn.fontSize                    = FontLoginButton;
    self.nextBtn.backgroundColor             = [UIColor colorWithHexString:ColorYellow];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerResend:) userInfo:nil repeats:YES];
}

#pragma mark- event Response

- (void)verifyCommit:(id)sender
{
    [self showLoading:@"验证中...."];
    [SMS_SDK commitVerifyCode:self.verifyTextField.text result:^(enum SMS_ResponseState state) {
        
        if (1 == state) {
            
            [self showComplete:@"验证成功"];
            RegisterViewController * rvc = [[RegisterViewController alloc] init];
            rvc.isFindPwd                = self.isFindPwd;
            rvc.phoneNumber              = self.phoneNumber;
            [self.navigationController pushViewController:rvc animated:YES];

        }else {
            [self showWarn:@"这验证码好像不太对。。"];
        }
    }];

}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.verifyTextField resignFirstResponder];
    return YES;
}


#pragma mark- private method
//获取验证码
- (void)getVerify
{
    [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneNumber zone:@"86"
                                        result:^(SMS_SDKError *error){
                                            
         //发送完毕隐藏
         if (!error)
         {
             [self showComplete:@"验证码很快就发过来辣~"];
         }
         else
         {
             [self showWarn:@"验证码发送失败sad~"];
             [self.timer invalidate];
             [self.reverifyBtn setTitle:[NSString stringWithFormat:@"点击重发"] forState:UIControlStateNormal];
             self.reverifyBtn.enabled = YES;
         }
         
     }];
}
- (void)timerResend:(id)sender
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
    [self showLoading:@"验证码获取中=_="];
    //获取验证码
    [self getVerify];
    self.timerNum = 59;
    self.reverifyBtn.enabled = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerResend:) userInfo:nil repeats:YES];
    
    
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
