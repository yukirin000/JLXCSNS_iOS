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
#import "YSAlertView.h"

@interface PersonalSettingViewController ()

//清空缓存按钮
@property (nonatomic, strong) CustomLabel * clearDiskLabel;

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
    self.view.backgroundColor         = [UIColor colorWithHexString:ColorLightWhite];

    //账号设置
    CustomButton * accountSettingBtn  = [[CustomButton alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusHeight+40, self.viewWidth, 45)];
    //线
    UIView * line1                    = [[UIView alloc] initWithFrame:CGRectMake(0, accountSettingBtn.bottom, self.viewWidth, 1)];
    line1.backgroundColor             = [UIColor colorWithHexString:ColorLightGary];
    [self.view addSubview:line1];
    //清除按钮
    CustomButton * clearDiskBtn       = [[CustomButton alloc] initWithFrame:CGRectMake(0, line1.bottom, self.viewWidth, 45)];
    self.clearDiskLabel               = [[CustomLabel alloc] init];
    self.clearDiskLabel.frame         = CGRectMake(self.viewWidth-154, 13, 120, 20);
    self.clearDiskLabel.textAlignment = NSTextAlignmentRight;
    self.clearDiskLabel.font          = [UIFont systemFontOfSize:12];
    self.clearDiskLabel.textColor     = [UIColor colorWithHexString:ColorDeepBlack];
    [clearDiskBtn addSubview:self.clearDiskLabel];
    CGFloat mb                        = [SDWebImageManager sharedManager].imageCache.getSize/(1024.0f*1024.0f);
    NSString * content                = [NSString stringWithFormat:@"%.2fM", mb*0.8];
    self.clearDiskLabel.text          = content;
    //关于
    CustomButton * aboutBtn           = [[CustomButton alloc] initWithFrame:CGRectMake(0, clearDiskBtn.bottom+30, self.viewWidth, 45)];

    [self setNavBarTitle:@"设置"];
    [self setArrowAndTitle:@"账号设置" withView:accountSettingBtn];
    [self setArrowAndTitle:@"清空缓存" withView:clearDiskBtn];
    [self setArrowAndTitle:@"关于" withView:aboutBtn];
    
    [accountSettingBtn addTarget:self action:@selector(accountSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    [clearDiskBtn addTarget:self action:@selector(clearDiskClick:) forControlEvents:UIControlEventTouchUpInside];
    [aboutBtn addTarget:self action:@selector(aboutClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)accountSettingClick:(id)sender
{
    AccountSettingViewController * asVC = [[AccountSettingViewController alloc] init];
    [self pushVC:asVC];
}

- (void)clearDiskClick:(id)sender
{

    YSAlertView * alert = [[YSAlertView alloc] initWithTitle:@"是否要清空缓存图片吗？" contentText:@"聊天信息不会被清除" leftButtonTitle:StringCommonConfirm rightButtonTitle:StringCommonCancel showView:self.view];
    [alert setLeftBlock:^{
        [[SDWebImageManager sharedManager].imageCache clearMemory];
        [[SDWebImageManager sharedManager].imageCache clearDisk];
        [HttpCache clearDisk];
        
        CGFloat mb                        = [SDWebImageManager sharedManager].imageCache.getSize/(1024.0f*1024.0f);
        NSString * content                = [NSString stringWithFormat:@"%.2fM", mb];
        self.clearDiskLabel.text = content;
    }];
    [alert show];
    
}

- (void)aboutClick:(id)sender
{
    AboutHelloHaViewController * ahhVC = [[AboutHelloHaViewController alloc] init];
    [self pushVC:ahhVC];
    
}

//通用UI布局
- (void)setArrowAndTitle:(NSString *)title withView:(UIView *)view
{
    view.backgroundColor             = [UIColor colorWithHexString:ColorWhite];
    //标题
    CustomLabel * label   = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 0, 90, 45)];
    label.font            = [UIFont systemFontOfSize:FontPersonalTitle];
    label.textColor       = [UIColor colorWithHexString:ColorCharGary];
    label.text            = title;
    
    //箭头
    CustomImageView * arrowImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(self.viewWidth-30, 15, 10, 15)];
    arrowImageView.image             = [UIImage imageNamed:@"right_arrow"];
    
    [view addSubview:label];
    [view addSubview:arrowImageView];
    [self.view addSubview:view];
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
