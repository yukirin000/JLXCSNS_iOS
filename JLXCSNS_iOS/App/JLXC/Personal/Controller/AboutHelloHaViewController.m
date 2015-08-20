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
    
    [self setNavBarTitle:@"关于"];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)configUI
{
    CustomImageView * backImageView = [[CustomImageView alloc] initWithFrame:self.view.bounds];
    [backImageView setImage:[UIImage imageNamed:@"about_back_image"]];
    [self.view addSubview:backImageView];

    CustomImageView * iconImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(kCenterOriginX(80), kNavBarAndStatusHeight+60, 80, 80)];
    iconImageView.image             = [UIImage imageNamed:@"Icon-60"];
    [self.view addSubview:iconImageView];

    CustomLabel * helloHaLabel      = [[CustomLabel alloc] initWithFontSize:14];
    helloHaLabel.textColor          = [UIColor colorWithHexString:ColorDeepGary];
    helloHaLabel.frame              = CGRectMake(0, iconImageView.bottom+10, self.viewWidth, 20);
    helloHaLabel.text               = [NSString stringWithFormat:@"HelloHa %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    helloHaLabel.textAlignment      = NSTextAlignmentCenter;
    [self.view addSubview:helloHaLabel];
    
    
    

    CustomLabel * bottomLabel1      = [[CustomLabel alloc] initWithFontSize:11];
    bottomLabel1.textColor          = [UIColor lightGrayColor];
    bottomLabel1.frame              = CGRectMake(0, self.viewHeight-60, self.viewWidth, 20);
    bottomLabel1.text               = @"玖零新创科技 版权所有";
    bottomLabel1.textAlignment      = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel1];

    CustomLabel * bottomLabel2      = [[CustomLabel alloc] initWithFontSize:11];
    bottomLabel2.textColor          = [UIColor lightGrayColor];
    bottomLabel2.frame              = CGRectMake(0, bottomLabel1.bottom, self.viewWidth, 20);
    bottomLabel2.text               = @"Copyright @2015 90newtec. All rights reserved";
    bottomLabel2.textAlignment      = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel2];
    
    [self.view bringSubviewToFront:self.navBar];
    
    [self setTitle:@"官方网站" andContent:@"www.90newtec.com" num:0];
    [self setTitle:@"微信公众平台" andContent:@"逗比学院" num:1];
    [self setTitle:@"官方微博" andContent:@"@HelloHa" num:2];
    [self setTitle:@"用户交流群" andContent:@"327979932" num:3];
}

//通用UI布局
- (void)setTitle:(NSString *)title andContent:(NSString *)content num:(NSInteger)num
{
    UIView * view              = [[UIView alloc] init];
    view.frame                 = CGRectMake(0, kNavBarAndStatusHeight+num*40+210, self.viewWidth, 40);
    view.backgroundColor       = [UIColor colorWithHexString:ColorWhite];
    //标题
    CustomLabel * label        = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    label.font                 = [UIFont systemFontOfSize:FontPersonalTitle];
    label.textColor            = [UIColor colorWithHexString:ColorCharGary];
    label.text                 = title;
    //内容
    CustomLabel * contentLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(label.right+10, 0, 190, 40)];
    contentLabel.font          = [UIFont systemFontOfSize:FontPersonalTitle];
    contentLabel.textColor     = [UIColor colorWithHexString:ColorCharGary];
    contentLabel.text          = content;
    //线
    UIView * lineView          = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.viewWidth, 1)];
    lineView.backgroundColor   = [UIColor colorWithHexString:ColorLightGary];
    
    [view addSubview:lineView];
    [view addSubview:contentLabel];
    [view addSubview:label];
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
