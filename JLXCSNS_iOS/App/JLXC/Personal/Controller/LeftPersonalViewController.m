//
//  LeftPersonalViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "LeftPersonalViewController.h"
#import "TestListViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "PersonalViewController.h"
#import "MyCardViewController.h"
#import "RCDRCIMDataSource.h"

@interface LeftPersonalViewController ()

//头像
@property (nonatomic, strong) CustomButton * headImageBtn;
//姓名
@property (nonatomic, strong) CustomButton * nameBtn;
//我的名片
@property (nonatomic, strong) CustomButton * myCardBtn;
//退出按钮
@property (nonatomic, strong) CustomButton * logoutBtn;

@end

@implementation LeftPersonalViewController

#pragma mark- life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self initWidget];
    [self configUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    NSURL * headUrl        = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.head_image]];    
    [self.headImageBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"testimage"]];
    [self.nameBtn setTitle:[UserService sharedService].user.name forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- layout
- (void) initWidget
{
    self.headImageBtn = [[CustomButton alloc] initWithFontSize:15];
    self.nameBtn      = [[CustomButton alloc] initWithFontSize:15];
    self.logoutBtn    = [[CustomButton alloc] initWithFontSize:15];
    self.myCardBtn    = [[CustomButton alloc] initWithFontSize:15];
    
    [self.view addSubview:self.headImageBtn];
    [self.view addSubview:self.nameBtn];
    [self.view addSubview:self.myCardBtn];
    [self.view addSubview:self.logoutBtn];
    
}

- (void) configUI
{

    //头像
    NSURL * headUrl                       = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.head_image]];
    self.headImageBtn.frame               = CGRectMake(30, 50, 80, 80);
    self.headImageBtn.backgroundColor     = [UIColor yellowColor];
    self.headImageBtn.layer.cornerRadius  = 40;
    self.headImageBtn.layer.masksToBounds = YES;
    [self.headImageBtn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headImageBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"testimage"]];
    
    //姓名
    self.nameBtn.frame           = CGRectMake(15, self.headImageBtn.bottom+10, 120, 20);
    self.nameBtn.backgroundColor = [UIColor yellowColor];
    [self.nameBtn setTitle:[UserService sharedService].user.name forState:UIControlStateNormal];
    [self.nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //我的名片
    self.myCardBtn.frame           = CGRectMake(15, self.nameBtn.bottom+10, 120, 20);
    self.myCardBtn.backgroundColor = [UIColor yellowColor];
    [self.myCardBtn addTarget:self action:@selector(myCardClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myCardBtn setTitle:@"我的名片" forState:UIControlStateNormal];
    [self.myCardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //退出
    self.logoutBtn.frame           = CGRectMake(15, self.myCardBtn.bottom+10, 120, 20);
    self.logoutBtn.backgroundColor = [UIColor yellowColor];
    [self.logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [self.logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

#pragma mark- method repondse
- (void)detailClick:(id)sender
{
    //详情点击
    [self.revealSideViewController popViewControllerAnimated:YES];
    PersonalViewController * pvc = [[PersonalViewController alloc] init];
    [[CusTabBarViewController sharedService].navigationController pushViewController:pvc animated:NO];
    
}

- (void)myCardClick:(id)sender
{
    //我的名片点击
    [self.revealSideViewController popViewControllerAnimated:YES];
    MyCardViewController * cardVC = [[MyCardViewController alloc] init];
    [[CusTabBarViewController sharedService].navigationController pushViewController:cardVC animated:NO];
}

- (void)logout:(id)sender
{
    //清空
    [[UserService sharedService] clear];
    [[RCDRCIMDataSource shareInstance] closeClient];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
