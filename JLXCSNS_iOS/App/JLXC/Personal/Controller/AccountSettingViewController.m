//
//  AccountSettingViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/30.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "RCDRCIMDataSource.h"
#import "YSAlertView.h"

@interface AccountSettingViewController ()

@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)configUI
{
    [self setNavBarTitle:@"账号设置"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    
    CustomButton * logoutBtn  = [[CustomButton alloc] init];
    logoutBtn.frame           = CGRectMake(kCenterOriginX(300), 50+kNavBarAndStatusHeight, 300, 45);
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logout_btn"] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [logoutBtn setTitleColor:[UIColor colorWithHexString:ColorWhite] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}

#pragma mark- method response
- (void)logout:(id)sender
{
    
    YSAlertView * alert = [[YSAlertView alloc] initWithTitle:@"确认要退出吗？？" contentText:@"" leftButtonTitle:StringCommonConfirm rightButtonTitle:StringCommonCancel showView:self.view];
    [alert setLeftBlock:^{
        //清空
        [[UserService sharedService] clear];
        [[RCDRCIMDataSource shareInstance] closeClient];
        [[PushService sharedInstance] logout];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert show];
    
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
