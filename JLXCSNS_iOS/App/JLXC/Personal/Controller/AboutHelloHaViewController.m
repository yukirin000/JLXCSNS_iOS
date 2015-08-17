//
//  AboutHelloHaViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/7/1.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "AboutHelloHaViewController.h"

@interface AboutHelloHaViewController ()

@end

@implementation AboutHelloHaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    debugLog(@"%@", [[NSBundle mainBundle] infoDictionary]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)configUI
{
    CustomImageView * iconImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(kCenterOriginX(80), kNavBarAndStatusHeight+60, 80, 80)];
    iconImageView.backgroundColor   = [UIColor grayColor];
    [self.view addSubview:iconImageView];
    
    CustomLabel * helloHaLabel = [[CustomLabel alloc] initWithFontSize:15];
    helloHaLabel.frame         = CGRectMake(0, iconImageView.bottom+20, self.viewWidth, 20);
    helloHaLabel.text          = [NSString stringWithFormat:@"HelloHa %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    helloHaLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:helloHaLabel];
    
    CustomLabel * bottomLabel1 = [[CustomLabel alloc] initWithFontSize:11];
    bottomLabel1.textColor     = [UIColor lightGrayColor];
    bottomLabel1.frame         = CGRectMake(0, self.viewHeight-60, self.viewWidth, 20);
    bottomLabel1.text          = @"玖零新创科技 版权所有";
    bottomLabel1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel1];
    
    CustomLabel * bottomLabel2 = [[CustomLabel alloc] initWithFontSize:11];
    bottomLabel2.textColor     = [UIColor lightGrayColor];
    bottomLabel2.frame         = CGRectMake(0, bottomLabel1.bottom, self.viewWidth, 20);
    bottomLabel2.text          = @"Copyright @2015 90newtec. All rights reserved";
    bottomLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel2];
    
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
