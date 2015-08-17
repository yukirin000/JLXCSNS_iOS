//
//  PersonalSettingViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/30.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "HttpCache.h"
#import "AccountSettingViewController.h"
#import "SDWebImageManager.h"
#import "AboutHelloHaViewController.h"

@interface PersonalSettingViewController ()

//清空缓存按钮
@property (nonatomic, strong) CustomButton * clearDiskBtn;

@end

@implementation PersonalSettingViewController

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
    CustomButton * accountSettingBtn  = [[CustomButton alloc] init];
    accountSettingBtn.frame           = CGRectMake(kCenterOriginX(280), kNavBarAndStatusHeight+30, 280, 30);
    accountSettingBtn.backgroundColor = [UIColor grayColor];
    [accountSettingBtn setTitle:@"账号设置" forState:UIControlStateNormal];
    [accountSettingBtn addTarget:self action:@selector(accountSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountSettingBtn];
    
    //清除按钮
    self.clearDiskBtn                 = [[CustomButton alloc] init];
    self.clearDiskBtn.frame           = CGRectMake(kCenterOriginX(280), accountSettingBtn.bottom+3, 280, 30);
    self.clearDiskBtn.backgroundColor = [UIColor grayColor];
    CGFloat mb                        = [SDWebImageManager sharedManager].imageCache.getSize/(1024.0f*1024.0f);
    NSString * content                = [NSString stringWithFormat:@"清空缓存%.2fM", mb];
    [self.clearDiskBtn setTitle:content forState:UIControlStateNormal];
    [self.clearDiskBtn addTarget:self action:@selector(clearDiskClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearDiskBtn];

    //关于
    CustomButton * aboutBtn  = [[CustomButton alloc] init];
    aboutBtn.frame           = CGRectMake(kCenterOriginX(280), self.clearDiskBtn.bottom+30, 280, 30);
    aboutBtn.backgroundColor = [UIColor grayColor];
    [aboutBtn setTitle:@"关于" forState:UIControlStateNormal];
    [aboutBtn addTarget:self action:@selector(aboutClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutBtn];
}

- (void)accountSettingClick:(id)sender
{
    AccountSettingViewController * asVC = [[AccountSettingViewController alloc] init];
    [self pushVC:asVC];
}

- (void)clearDiskClick:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否要清空缓存图片吗？" message:@"聊天信息不会被清除" delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:StringCommonConfirm, nil];
    [alert show];
}

- (void)aboutClick:(id)sender
{
    AboutHelloHaViewController * ahhVC = [[AboutHelloHaViewController alloc] init];
    [self pushVC:ahhVC];
    
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [[SDWebImageManager sharedManager].imageCache clearMemory];
        [[SDWebImageManager sharedManager].imageCache clearDisk];
        [HttpCache clearDisk];
        
        CGFloat mb                        = [SDWebImageManager sharedManager].imageCache.getSize/(1024.0f*1024.0f);
        NSString * content                = [NSString stringWithFormat:@"清空缓存%.2fM", mb];
        [self.clearDiskBtn setTitle:content forState:UIControlStateNormal];
        
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
