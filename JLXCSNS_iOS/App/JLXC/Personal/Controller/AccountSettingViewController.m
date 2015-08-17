//
//  AccountSettingViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/30.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "RCDRCIMDataSource.h"

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
    CustomButton * logoutBtn  = [[CustomButton alloc] init];
    logoutBtn.frame           = CGRectMake(kCenterOriginX(280), kNavBarAndStatusHeight+230, 280, 30);
    logoutBtn.backgroundColor = [UIColor grayColor];
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}

#pragma mark- method response
- (void)logout:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确认要退出吗？？" message:nil delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:StringCommonConfirm, nil];
    [alert show];
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //清空
        [[UserService sharedService] clear];
        [[RCDRCIMDataSource shareInstance] closeClient];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
