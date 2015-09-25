//
//  TopicDetailViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/9/25.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MoreTopicViewController.h"
#import "OtherPersonalViewController.h"
#import "TopicMemberViewController.h"
#import "TopicMemberModel.h"

@interface TopicDetailViewController ()

//背景滚动视图
@property (nonatomic, strong) UIScrollView * backScrollView;
//背景图片
@property (nonatomic, strong) CustomImageView * backImageView;
//名字
@property (nonatomic, strong) CustomLabel * topicNameLabel;
//内容数量
@property (nonatomic, strong) CustomLabel * newsCountLabel;

//创建人头像
@property (nonatomic, strong) CustomImageView * creatorImageView;
//创建人名字
@property (nonatomic, strong) CustomLabel * creatorLabel;
//成员数量
@property (nonatomic, strong) CustomLabel * memberCountLabel;
//成员A
@property (nonatomic, strong) CustomImageView * memberAImageView;
//成员B
@property (nonatomic, strong) CustomImageView * memberBImageView;
//成员C
@property (nonatomic, strong) CustomImageView * memberCImageView;
//成员D
@property (nonatomic, strong) CustomImageView * memberDImageView;
//频道类别
@property (nonatomic, strong) CustomLabel * categoryLabel;
//频道介绍
@property (nonatomic, strong) CustomLabel * topicDescLabel;
//描述背景View
@property (nonatomic, strong) UIView * topicDescView;
//关注或者取消关注按钮
@property (nonatomic, strong) CustomButton * attentBtn;

//类别ID
@property (nonatomic, assign) NSInteger categoryID;
//创建者ID
@property (nonatomic, assign) NSInteger creatorID;
//加入状态
@property (nonatomic, assign) BOOL isJoin;
//成员数组
@property (nonatomic, strong) NSMutableArray * memberArr;

@end

@implementation TopicDetailViewController

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

#pragma mark- layoutf
- (void)initWidget
{
    self.memberArr        = [[NSMutableArray alloc] init];
    self.backScrollView   = [[UIScrollView alloc] init];
    //顶部背景
    self.backImageView    = [[CustomImageView alloc] init];
    self.newsCountLabel   = [[CustomLabel alloc] init];
    self.topicNameLabel   = [[CustomLabel alloc] init];
    
    self.creatorImageView = [[CustomImageView alloc] init];
    self.creatorLabel     = [[CustomLabel alloc] init];
    self.memberCountLabel = [[CustomLabel alloc] init];
    self.memberAImageView = [[CustomImageView alloc] init];
    self.memberBImageView = [[CustomImageView alloc] init];
    self.memberCImageView = [[CustomImageView alloc] init];
    self.memberDImageView = [[CustomImageView alloc] init];

    self.categoryLabel    = [[CustomLabel alloc] init];
    self.topicDescLabel   = [[CustomLabel alloc] init];
    self.attentBtn        = [[CustomButton alloc] init];

    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.backImageView];
    [self.backScrollView addSubview:self.newsCountLabel];
    [self.backScrollView addSubview:self.topicNameLabel];
    [self.backScrollView addSubview:self.attentBtn];
    
    [self.attentBtn addTarget:self action:@selector(joinOrQuit:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configUI
{
    [self setNavBarTitle:@"频道信息"];
    self.backScrollView.frame                        = CGRectMake(0, kNavBarAndStatusHeight, self.viewWidth, self.viewHeight-kNavBarAndStatusHeight);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    //背景图
    self.backImageView.frame               = CGRectMake(0, 0, self.viewWidth, 200);
    self.backImageView.contentMode         = UIViewContentModeScaleAspectFill;
    self.backImageView.layer.masksToBounds = YES;
    //名字
    self.topicNameLabel.frame              = CGRectMake(13, 140, self.viewWidth, 30);
    [self.topicNameLabel setFontBold];
    self.topicNameLabel.font               = [UIFont systemFontOfSize:17];
    self.topicNameLabel.textColor          = [UIColor colorWithHexString:ColorWhite];
    //数量
    self.newsCountLabel.frame              = CGRectMake(13, 170, self.viewWidth, 20);
    self.newsCountLabel.font               = [UIFont systemFontOfSize:13];
    self.newsCountLabel.textColor          = [UIColor colorWithHexString:ColorWhite];
    //黑色遮罩
    UIView * nameBackView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 135, self.viewWidth, 65)];
    nameBackView.backgroundColor           = [UIColor blackColor];
    nameBackView.alpha                     = 0.5;
    
    //创建的人
    CustomButton * creatorView          = [self getCommonBackWhiteViewWithTitle:@"创建的人"];
    creatorView.y                       = self.backImageView.bottom+10;
    self.creatorImageView.frame         = CGRectMake(self.viewWidth-70, 10, 40, 40);
    self.creatorLabel.frame             = CGRectMake(self.creatorImageView.x-120, 20, 110, 20);
    self.creatorLabel.textColor         = [UIColor colorWithHexString:ColorLightBlack];
    self.creatorLabel.font              = [UIFont systemFontOfSize:14];
    self.creatorLabel.textAlignment     = NSTextAlignmentRight;
    [self setArrowWithView:creatorView];
    
    //关注的成员
    CustomButton * memberView           = [self getCommonBackWhiteViewWithTitle:@"关注的人"];
    memberView.y                        = creatorView.bottom+10;
    self.memberCountLabel.frame         = CGRectMake(self.viewWidth-30, 20, 30, 20);
    self.memberCountLabel.textColor     = [UIColor colorWithHexString:ColorLightBlack];
    self.memberCountLabel.font          = [UIFont systemFontOfSize:14];
    self.memberCountLabel.textAlignment = NSTextAlignmentCenter;

    self.memberAImageView.frame         = CGRectMake(self.memberCountLabel.x-40, 10, 40, 40);
    self.memberBImageView.frame         = CGRectMake(self.memberAImageView.x-45, 10, 40, 40);
    self.memberCImageView.frame         = CGRectMake(self.memberBImageView.x-45, 10, 40, 40);
    self.memberDImageView.frame         = CGRectMake(self.memberCImageView.x-45, 10, 40, 40);

    //频道类别
    CustomButton * categoryView         = [self getCommonBackWhiteViewWithTitle:@"频道类别"];
    categoryView.y                      = memberView.bottom+10;
    self.categoryLabel.frame            = CGRectMake(self.viewWidth-25-160, 20, 160, 20);
    self.categoryLabel.textColor        = [UIColor colorWithHexString:ColorLightBlack];
    self.categoryLabel.font             = [UIFont systemFontOfSize:14];
    self.categoryLabel.textAlignment    = NSTextAlignmentRight;
    [self setArrowWithView:categoryView];

    //频道介绍
    self.topicDescView                 = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 60)];
    self.topicDescView.backgroundColor = [UIColor whiteColor];
    //标题
    CustomLabel * titleLabel           = [[CustomLabel alloc] initWithFontSize:14];
    titleLabel.textColor               = [UIColor colorWithHexString:ColorDeepBlack];
    titleLabel.frame                   = CGRectMake(10, 5, 100, 20);
    titleLabel.text                    = @"频道介绍";
    [self.topicDescView addSubview:titleLabel];
    [self.backScrollView addSubview:self.topicDescView];
    
    self.topicDescView.y              = categoryView.bottom+10;
    self.topicDescLabel.numberOfLines = 0;
    self.topicDescLabel.frame         = CGRectMake(10, 30, self.viewWidth-30, 0);
    self.topicDescLabel.textColor     = [UIColor colorWithHexString:ColorLightBlack];
    self.topicDescLabel.font          = [UIFont systemFontOfSize:14];
    //关注按钮
    self.attentBtn.frame           = CGRectMake(kCenterOriginX(180), self.topicDescView.bottom+30, 180, 30);
    self.attentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.attentBtn.enabled         = NO;
    [self.attentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.backScrollView addSubview:nameBackView];
    [self.backScrollView insertSubview:nameBackView aboveSubview:self.backImageView];
    [creatorView addSubview:self.creatorImageView];
    [creatorView addSubview:self.creatorLabel];
    [memberView addSubview:self.memberCountLabel];
    [memberView addSubview:self.memberAImageView];
    [memberView addSubview:self.memberBImageView];
    [memberView addSubview:self.memberCImageView];
    [memberView addSubview:self.memberDImageView];
    [categoryView addSubview:self.categoryLabel];
    [self.topicDescView addSubview:self.topicDescLabel];
    
    
    [categoryView addTarget:self action:@selector(topicCategoryClick:) forControlEvents:UIControlEventTouchUpInside];
    [creatorView addTarget:self action:@selector(creatorClick:) forControlEvents:UIControlEventTouchUpInside];
    [memberView addTarget:self action:@selector(memberListClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark- method response
- (void)topicCategoryClick:(id)sender
{
    if (self.categoryID > 1) {
        MoreTopicViewController * mtvc = [[MoreTopicViewController alloc] init];
        mtvc.categoryId                = self.categoryID;
        mtvc.categoryName              = self.categoryLabel.text;
        [self pushVC:mtvc];
    }

}
//加入或者退出圈子
- (void)joinOrQuit:(id)sender
{
    if (self.isJoin) {
        [self quitTopic];
    }else{
        [self attentTopic];
    }
}
//创建者点击
- (void)creatorClick:(id)sender
{
    if (self.creatorID > 1) {
        OtherPersonalViewController * opvc = [[OtherPersonalViewController alloc] init];
        opvc.uid                           = self.creatorID;
        [self pushVC:opvc];
    }
}
- (void)memberListClick:(id)sender
{
    TopicMemberViewController * tmvc = [[TopicMemberViewController alloc] init];
    tmvc.topicID                     = self.topicID;
    [self pushVC:tmvc];
}


#pragma mark- private method
//关注圈子
- (void)attentTopic
{
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"topic_id":[NSString stringWithFormat:@"%ld", self.topicID]};
    
    [self showLoading:@"加入中..."];
    [HttpService postWithUrlString:kJoinTopicPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            // 加入状态
            self.isJoin = YES;
            [self.attentBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            [self.attentBtn setBackgroundColor:[UIColor colorWithHexString:ColorRed]];
         
        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

//关注圈子
- (void)quitTopic
{
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"topic_id":[NSString stringWithFormat:@"%ld", self.topicID]};
    
    [self showLoading:@"取消中..."];
    [HttpService postWithUrlString:kQuitTopicPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self showComplete:responseData[HttpMessage]];
            self.isJoin = NO;
            [self.attentBtn setTitle:@"关注" forState:UIControlStateNormal];
            [self.attentBtn setBackgroundColor:[UIColor colorWithHexString:ColorYellow]];
            
        }else{
            
            [self showWarn:responseData[HttpMessage]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

- (void)getData
{
    
    NSString * url = [NSString stringWithFormat:@"%@?topic_id=%ld&user_id=%ld", kGetTopicDetailPath, self.topicID, [UserService sharedService].user.uid];
    debugLog(@"%@", url);
    [HttpService getWithUrlString:url andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            NSDictionary * result = responseData[HttpResult];
            [self handleResult:result];
        
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self showWarn:StringCommonNetException];
    }];
}
//处理结果
- (void)handleResult:(NSDictionary *)result
{
    self.attentBtn.enabled     = YES;
    NSDictionary * content     = result[@"content"];
    // 名字
    self.topicNameLabel.text   = content[@"topic_name"];
    //内容数量
    self.newsCountLabel.text   = [NSString stringWithFormat:@"%@条内容", result[@"news_count"]];
    //背景
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:content[@"topic_cover_image"]]]  placeholderImage:[UIImage imageNamed:@"default_back_image"]];
    self.creatorID             = [content[@"user_id"] integerValue];
    // 创建者
    self.creatorLabel.text     = content[@"name"];
    //创建人头像
    [self.creatorImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:content[@"head_sub_image"]]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    //成员数量
    self.memberCountLabel.text = result[@"member_count"];
    //类别ID
    self.categoryID            = [content[@"category_id"] integerValue];
    // 类别名
    self.categoryLabel.text    = content[@"category_name"];
    // 圈子介绍
    self.topicDescLabel.text   = content[@"topic_detail"];
    //位置重新布局
    CGSize descSize            = [ToolsManager getSizeWithContent:self.topicDescLabel.text andFontSize:14 andFrame:CGRectMake(0, 0, self.viewWidth-30, MAXFLOAT)];
    self.topicDescLabel.height = descSize.height;
    self.topicDescView.height  = descSize.height + 40;
    self.attentBtn.y           = self.topicDescView.bottom + 30;
    self.backScrollView.contentSize = CGSizeMake(0, self.attentBtn.bottom+30);

    // 加入状态
    self.isJoin = [result[@"join_state"] boolValue];
    if (self.isJoin) {
        [self.attentBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.attentBtn setBackgroundColor:[UIColor colorWithHexString:ColorRed]];
    }else{
        [self.attentBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentBtn setBackgroundColor:[UIColor colorWithHexString:ColorYellow]];
    }
    
    if (self.creatorID == [UserService sharedService].user.uid) {
        self.attentBtn.hidden = YES;
    }else{
        self.attentBtn.hidden = NO;
    }
    
    NSArray * members = result[@"members"];
    NSInteger size = members.count;
    if (size > 4) {
        size = 4;
    }
    //成员列表整理
    NSArray * tmpMemberArr = @[self.memberAImageView, self.memberBImageView, self.memberCImageView, self.memberDImageView];
    [self.memberArr removeAllObjects];
    for (int i=0; i<size; i++) {
        NSDictionary * member             = members[i];
        TopicMemberModel * memberModel = [[TopicMemberModel alloc] init];
        memberModel.user_id = [member[@"user_id"] integerValue];
        memberModel.name = member[@"name"];
        memberModel.head_sub_image = member[@"head_sub_image"];
        [self.memberArr addObject:memberModel];
        //头像设置
        CustomImageView * memberImageView = tmpMemberArr[i];
        [memberImageView sd_setImageWithURL:[NSURL URLWithString:[ToolsManager completeUrlStr:memberModel.head_sub_image]] placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    }

}

- (CustomButton *)getCommonBackWhiteViewWithTitle:(NSString *)title
{
    CustomButton * view            = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 60)];
    view.backgroundColor     = [UIColor whiteColor];
    //标题
    CustomLabel * titleLabel = [[CustomLabel alloc] initWithFontSize:14];
    titleLabel.textColor     = [UIColor colorWithHexString:ColorDeepBlack];
    titleLabel.frame         = CGRectMake(10, 20, 100, 20);
    titleLabel.text          = title;
    [view addSubview:titleLabel];
    [self.backScrollView addSubview:view];
    return view;
}

- (void)setArrowWithView:(UIView *)arrowView
{
    //箭头
    CustomImageView * arrowImageView       = [[CustomImageView alloc] initWithFrame:CGRectMake(self.viewWidth-20, 24, 7, 12)];
    arrowImageView.image                   = [UIImage imageNamed:@"right_arrow"];
    [arrowView addSubview:arrowImageView];
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
