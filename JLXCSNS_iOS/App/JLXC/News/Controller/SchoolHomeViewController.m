//
//  SchoolHomeViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/21.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "SchoolHomeViewController.h"
#import "UIImageView+WebCache.h"

@interface SchoolHomeViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

//学校名
@property (nonatomic, strong) CustomLabel * schoolLabel;

//地区名
@property (nonatomic, strong) CustomLabel * locationLabel;

//学校成员ABC
@property (nonatomic, strong) CustomImageView * memberAImageView;
@property (nonatomic, strong) CustomImageView * memberBImageView;
@property (nonatomic, strong) CustomImageView * memberCImageView;

//学校成员总数
@property (nonatomic, strong) CustomLabel * schoolMemberLabel;

//学校新消息
@property (nonatomic, strong) CustomLabel * schoolUnreadMsgLabel;


@end

@implementation SchoolHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initWidget];
    [self configUI];
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    //背景滚动视图
    self.scrollView           = [[UIScrollView alloc] init];

    self.schoolLabel          = [[CustomLabel alloc] init];
    self.locationLabel        = [[CustomLabel alloc] init];
    self.memberAImageView     = [[CustomImageView alloc] init];
    self.memberBImageView     = [[CustomImageView alloc] init];
    self.memberCImageView     = [[CustomImageView alloc] init];
    self.schoolMemberLabel    = [[CustomLabel alloc] init];
    self.schoolUnreadMsgLabel = [[CustomLabel alloc] init];
    
    [self.view addSubview:self.scrollView];

}

- (void)configUI
{
    [self.navBar setNavTitle:@"校园主页"];
    
    self.scrollView.frame                        = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    //背景图
    CustomImageView * backImageView  = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"group_main_background"]];
    backImageView.frame              = CGRectMake(0, 0, self.viewWidth, 200);
    //黑色遮罩
    UIView * backCoverView           = [[UIView alloc] initWithFrame:CGRectMake(0, 130, self.viewWidth, 70)];
    backCoverView.backgroundColor    = [UIColor blackColor];
    backCoverView.alpha              = 0.5;
    //学校名
    self.schoolLabel.frame           = CGRectMake(15, 147, 150, 45);
    self.schoolLabel.font            = [UIFont systemFontOfSize:18];
    self.schoolLabel.textColor       = [UIColor colorWithHexString:ColorWhite];
    self.schoolLabel.numberOfLines   = 0;
    //图标
    CustomImageView * locationImage  = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"school_localtion"]];
    locationImage.frame = CGRectMake(self.viewWidth-135, 160, 20, 20);
    //位置
    self.locationLabel.frame         = CGRectMake(self.viewWidth-110, 150, 100, 40);
    self.locationLabel.font          = [UIFont systemFontOfSize:14];
    self.locationLabel.textColor     = [UIColor colorWithHexString:ColorWhite];
    self.locationLabel.numberOfLines = 0;
    
    //校内的人
    UIView * schoolMemberView               = [[UIView alloc] initWithFrame:CGRectMake(0, backCoverView.bottom+15, self.viewWidth, 70)];
    schoolMemberView.backgroundColor        = [UIColor colorWithHexString:ColorWhite];
    //图标
    CustomImageView * schoolMemberImageView = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"campus_person"]];
    schoolMemberImageView.frame             = CGRectMake(10, 20, 30, 30);
    //文字
    CustomLabel * schoolMemberLabel         = [[CustomLabel alloc] initWithFontSize:14];
    schoolMemberLabel.textColor             = [UIColor colorWithHexString:ColorDeepBlack];
    schoolMemberLabel.text                  = @"校内小伙伴";
    schoolMemberLabel.frame                 = CGRectMake(schoolMemberImageView.right+5, 20, 100, 30);
    //人员总数
    self.schoolMemberLabel.frame         = CGRectMake(self.viewWidth-45, 20, 20, 30);
    self.schoolMemberLabel.textAlignment = NSTextAlignmentCenter;
    self.schoolMemberLabel.font          = [UIFont systemFontOfSize:14];
    self.schoolMemberLabel.textColor     = [UIColor colorWithHexString:ColorLightBlack];
    //箭头
    CustomImageView * arrowImageView = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
    arrowImageView.frame = CGRectMake(self.viewWidth-25, 27, 10, 15);
    
    self.memberAImageView.frame = CGRectMake(self.schoolMemberLabel.x-45, 15, 40, 40);
    self.memberAImageView.image = [UIImage imageNamed:@"title_image"];
    self.memberBImageView.frame = CGRectMake(self.memberAImageView.x-45, 15, 40, 40);
    self.memberCImageView.frame = CGRectMake(self.memberBImageView.x-45, 15, 40, 40);
    
    self.memberAImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.memberBImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.memberCImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.memberAImageView.layer.masksToBounds = YES;
    self.memberBImageView.layer.masksToBounds = YES;
    self.memberCImageView.layer.masksToBounds = YES;
    
    //校内动态
    UIView * schoolNewsView                 = [[UIView alloc] initWithFrame:CGRectMake(0, schoolMemberView.bottom+15, self.viewWidth, 70)];
    schoolNewsView.backgroundColor          = [UIColor colorWithHexString:ColorWhite];
    //图标
    CustomImageView * schoolNewsImageView   = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"campus_news"]];
    schoolNewsImageView.frame               = CGRectMake(10, 20, 30, 30);
    //文字
    CustomLabel * schoolNewsLabel           = [[CustomLabel alloc] initWithFontSize:14];
    schoolNewsLabel.textColor               = [UIColor colorWithHexString:ColorDeepBlack];
    schoolNewsLabel.text                    = @"校园新鲜事";
    schoolNewsLabel.frame                   = CGRectMake(schoolNewsImageView.right+5, 20, 100, 30);
    //校内动态未读
    self.schoolUnreadMsgLabel.frame         = CGRectMake(self.viewWidth-45, 20, 20, 30);
    self.schoolUnreadMsgLabel.textAlignment = NSTextAlignmentCenter;
    self.schoolUnreadMsgLabel.font          = [UIFont systemFontOfSize:14];
    self.schoolUnreadMsgLabel.textColor     = [UIColor colorWithHexString:ColorLightBlack];
    
    //顶部背景部分
    [self.scrollView addSubview:backImageView];
    [self.scrollView addSubview:backCoverView];
    [self.scrollView addSubview:self.schoolLabel];
    [self.scrollView addSubview:locationImage];
    [self.scrollView addSubview:self.locationLabel];
    //校内成员部分
    [self.scrollView addSubview:schoolMemberView];
    [schoolMemberView addSubview:schoolMemberImageView];
    [schoolMemberView addSubview:schoolMemberLabel];
    [schoolMemberView addSubview:self.memberAImageView];
    [schoolMemberView addSubview:self.memberBImageView];
    [schoolMemberView addSubview:self.memberCImageView];
    [schoolMemberView addSubview:self.schoolMemberLabel];
    [schoolMemberView addSubview:arrowImageView];
    //校内动态部分
    [self.scrollView addSubview:schoolNewsView];
    [schoolNewsView addSubview:schoolNewsImageView];
    [schoolNewsView addSubview:schoolNewsLabel];
    [schoolNewsView addSubview:self.schoolUnreadMsgLabel];
    
    self.scrollView.contentSize = CGSizeMake(0, self.viewHeight);
}

#pragma override


#pragma mark- private method
//获取数据
- (void)getData
{
    if (self.schoolCode.length < 1) {
        self.schoolCode = [UserService sharedService].user.school_code;
    }
    
    NSUserDefaults * defaluts = [NSUserDefaults standardUserDefaults];
    NSString * lastRefreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:SchoolLastRefreshDate];
    if (lastRefreshTime.length < 1) {
        [defaluts setObject:[NSString stringWithFormat:@"%d", (int)[NSDate date].timeIntervalSince1970] forKey:SchoolLastRefreshDate];
        [defaluts synchronize];
    }
    NSString * url = [NSString stringWithFormat:@"%@?user_id=%ld&school_code=%@&last_time=%@", kSchoolHomeDataPath, [UserService sharedService].user.uid, self.schoolCode, lastRefreshTime];
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self handleData:responseData[HttpResult]];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

//处理数据
- (void)handleData:(NSDictionary *)resultDic
{
    self.schoolLabel.text            = [UserService sharedService].user.school;

    //学校名以及位置
    NSDictionary * schoolDic         = resultDic[@"school"];
    self.locationLabel.text          = [NSString stringWithFormat:@"%@ · %@", schoolDic[@"city_name"], schoolDic[@"district_name"]];;
    //学校名
    self.schoolLabel.text            = schoolDic[@"name"];
    //成员数量
    self.schoolMemberLabel.text      = resultDic[@"student_count"];
    //未读数量
    self.schoolUnreadMsgLabel.text   = resultDic[@"unread_news_count"];
    if (self.schoolUnreadMsgLabel.text.integerValue < 1) {
        self.schoolUnreadMsgLabel.text = @"";
    }
    //不是本校没有未读
    if ([[UserService sharedService].user.school_code compare:self.schoolCode] != NSOrderedSame) {
    self.schoolUnreadMsgLabel.hidden = YES;
    }
    
    //成员
    NSArray * memberArr          = resultDic[@"info"];
    self.memberAImageView.hidden = YES;
    self.memberBImageView.hidden = YES;
    self.memberCImageView.hidden = YES;
    
    NSArray * memberViewArr = @[self.memberAImageView, self.memberBImageView, self.memberCImageView];
    //最多三个
    NSInteger size          = memberArr.count;
    if (size > 3) {
        size = 3;
    }
    for (int i=0; i<size; i++) {
        NSDictionary * personalDic  = memberArr[i];
        CustomImageView * imageView = memberViewArr[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr , personalDic[@"head_sub_image"]]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        imageView.hidden = NO;
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
