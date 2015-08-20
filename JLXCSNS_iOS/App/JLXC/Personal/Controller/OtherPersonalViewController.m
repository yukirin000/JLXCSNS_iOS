//
//  OtherPersonalViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/25.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//
//  PersonalViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "OtherPersonalViewController.h"
#import "OtherPeopleFriendsListViewController.h"
#import "VisitListViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MyNewsListViewController.h"
#import "IMGroupModel.h"
#import <RongIMLib/RCStatusDefine.h>
#import "ChatViewController.h"
#import "FriendSettingViewController.h"
#import "CommonFriendsListViewController.h"
#import "BrowseImageViewController.h"
#import "YSAlertView.h"
#import "ReportOffenceViewController.h"

enum {
    BackgroundImage = 1,
    HeadImage       = 2
};

enum {
    ContentName     = 0,
    ContentSign     = 1,
    ContentBirthday = 2,
    ContentSex      = 3,
    ContentSchool   = 4,
    ContentCity     = 5
};

@interface OtherPersonalViewController ()

//背景滚动视图
@property (strong, nonatomic) UIScrollView * backScrollView;

//背景图
@property (strong, nonatomic) CustomImageView *backImageView;
//头像
@property (strong, nonatomic) CustomButton *headImageBtn;
//姓名
@property (strong, nonatomic) CustomLabel * nameLabel;
//性别
@property (strong, nonatomic) CustomImageView * sexImageView;
//学校
@property (strong, nonatomic) CustomLabel * schoolLabel;

//个人资料label
@property (strong, nonatomic) CustomLabel *informationLabel;

//他的状态
@property (strong, nonatomic) CustomButton *hisNewsBackView;
//新闻imageView1
@property (strong, nonatomic) UIImageView *newsImageView1;
//新闻imageView2
@property (strong, nonatomic) UIImageView *newsImageView2;
//新闻imageView3
@property (strong, nonatomic) UIImageView *newsImageView3;

//好友数量label
@property (nonatomic, strong) CustomLabel * hisFriendCountLabel;
//好友背景图
@property (strong, nonatomic) UIButton *hisFriendBackView;
//TA的好友imageView1
@property (strong, nonatomic) CustomImageView *hisFriendImageView1;
//TA的好友imageView2
@property (strong, nonatomic) CustomImageView *hisFriendImageView2;
//TA的好友imageView3
@property (strong, nonatomic) CustomImageView *hisFriendImageView3;
//TA的好友imageView4
@property (strong, nonatomic) CustomImageView *hisFriendImageView4;

@property (strong, nonatomic) UIView *chatBackView;
//发送消息按钮
@property (strong, nonatomic) CustomButton *sendMessageBtn;
//发送消息按钮上的图片
@property (strong, nonatomic) CustomImageView *sendMessageImageView;
//发送消息按钮上的字
@property (strong, nonatomic) CustomLabel *sendMessageLabel;
//添加好友按钮
@property (strong, nonatomic) CustomButton *addFriendsBtn;

//访客按钮
@property (strong, nonatomic) CustomButton *visitBtn;
//共同好友按钮
@property (strong, nonatomic) CustomButton *commonFriendBtn;
//访客数量
@property (strong, nonatomic) CustomLabel *visitCountLabel;
//共同好友数量
@property (strong, nonatomic) CustomLabel *commonCountLabel;

//个人信息
@property (strong, nonatomic) UITableView * infomationTableView;
//数组
@property (strong, nonatomic) NSArray * informationArr;
//用户模型
@property (nonatomic, strong) UserModel * otherUser;
//是不是好友
@property (nonatomic, assign) BOOL isFriend;
//访客数量
@property (nonatomic, assign) NSInteger visitCount;
//好友数量
@property (nonatomic, assign) NSInteger friendsCount;
//共同好友数量
@property (nonatomic, assign) NSInteger commonFriendsCount;

@end

@implementation OtherPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:ColorLightWhite];
    
    [self initWidget];
    [self configUI];
    //获取该用户信息
    [self getPersonalInformation];

}

- (void)viewWillAppear:(BOOL)animated
{
//    //是好友则查看备注 备注暂时关闭
//    //姓名
//    if (self.isFriend) {
////        //是好友查看备注
////        IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:self.uid]];
////        if (group.groupRemark != nil && group.groupRemark.length > 0) {
////            self.friendRemark = group.groupRemark;
////        }
//        
//        [self.nameBtn setTitle:[ToolsManager getRemarkOrOriginalNameWithUid:self.uid andOriginalName:self.otherUser.name] forState:UIControlStateNormal];
//        [self.infomationTableView reloadData];
// 
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    //背景滚动视图
    self.backScrollView             = [[UIScrollView alloc] init];

    self.navBar.backgroundColor     = [UIColor clearColor];

    //背景图
    self.backImageView              = [[CustomImageView alloc] init];
    //头像
    self.headImageBtn               = [[CustomButton alloc] init];
    //姓名
    self.nameLabel                  = [[CustomLabel alloc] init];
    //性别
    self.sexImageView               = [[CustomImageView alloc] init];
    //学校
    self.schoolLabel                = [[CustomLabel alloc] init];
    
    self.chatBackView               = [[UIView alloc] init];
    self.addFriendsBtn              = [[CustomButton alloc] init];
    self.sendMessageBtn             = [[CustomButton alloc] init];

    //我的状态
    self.hisNewsBackView            = [[CustomButton alloc] init];
    self.newsImageView1             = [[CustomImageView alloc] init];
    self.newsImageView2             = [[CustomImageView alloc] init];
    self.newsImageView3             = [[CustomImageView alloc] init];
    //好友
    self.hisFriendBackView          = [[CustomButton alloc] init];
    self.hisFriendImageView1        = [[CustomImageView alloc] init];
    self.hisFriendImageView2        = [[CustomImageView alloc] init];
    self.hisFriendImageView3        = [[CustomImageView alloc] init];
    self.hisFriendImageView4        = [[CustomImageView alloc] init];
    self.hisFriendCountLabel        = [[CustomLabel alloc] init];
    //他的好友和访问
    self.commonFriendBtn            = [[CustomButton alloc] init];
    self.visitBtn                   = [[CustomButton alloc] init];
    self.visitCountLabel            = [[CustomLabel alloc] init];
    self.commonCountLabel           = [[CustomLabel alloc] init];
    //个人信息
    self.informationLabel           = [[CustomLabel alloc] init];
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.nameLabel];
    [self.backScrollView addSubview:self.sexImageView];
    [self.backScrollView addSubview:self.schoolLabel];
    [self.backScrollView addSubview:self.headImageBtn];
    [self.backScrollView addSubview:self.hisNewsBackView];
    
    [self.backScrollView addSubview:self.chatBackView];
    [self.chatBackView addSubview:self.sendMessageBtn];
    [self.chatBackView addSubview:self.addFriendsBtn];
    
    [self.backScrollView addSubview:self.hisNewsBackView];
    [self.hisNewsBackView addSubview:self.newsImageView1];
    [self.hisNewsBackView addSubview:self.newsImageView2];
    [self.hisNewsBackView addSubview:self.newsImageView3];
   
    [self.backScrollView addSubview:self.hisFriendBackView];
    [self.hisFriendBackView addSubview:self.hisFriendImageView1];
    [self.hisFriendBackView addSubview:self.hisFriendImageView2];
    [self.hisFriendBackView addSubview:self.hisFriendImageView3];
    [self.hisFriendBackView addSubview:self.hisFriendImageView4];
    [self.hisFriendBackView addSubview:self.hisFriendCountLabel];
    
    [self.backScrollView addSubview:self.commonFriendBtn];
    [self.backScrollView addSubview:self.visitBtn];
    [self.backScrollView addSubview:self.informationLabel];
    
    //事件
    [self.hisNewsBackView addTarget:self action:@selector(hisNewsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headImageBtn addTarget:self action:@selector(headImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.hisFriendBackView addTarget:self action:@selector(friendClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.visitBtn addTarget:self action:@selector(visitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commonFriendBtn addTarget:self action:@selector(commonFriendsClick:) forControlEvents:UIControlEventTouchUpInside];
    //发消息
    [self.sendMessageBtn addTarget:self action:@selector(sendMessagePress:) forControlEvents:UIControlEventTouchUpInside];
    //加好友
    [self.addFriendsBtn addTarget:self action:@selector(addFriendCommit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTable
{
    self.informationArr = @[@"昵称",@"签名",@"生日",@"性别",@"学校",@"城市"];
    
    self.infomationTableView                              = [[UITableView alloc] initWithFrame:CGRectMake(0, self.informationLabel.bottom, self.viewWidth, 45 * 6) style:UITableViewStylePlain];
    self.infomationTableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.infomationTableView.scrollEnabled                = NO;
    self.infomationTableView.showsVerticalScrollIndicator = NO;
    self.infomationTableView.delegate                     = self;
    self.infomationTableView.dataSource                   = self;
    
    [self.infomationTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"personalCell"];
    [self.backScrollView addSubview:self.infomationTableView];
    
    self.backScrollView.contentSize = CGSizeMake(0, self.infomationTableView.bottom+1);
}

- (void)configUI
{
    //背景滚动视图
    self.backScrollView.frame                        = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    
    //返回和设置
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"back_white_btn"] forState:UIControlStateNormal];
    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"other_setting_btn"] forState:UIControlStateNormal];

    //调整Mode
    self.newsImageView1.contentMode                  = UIViewContentModeScaleAspectFill;
    self.newsImageView2.contentMode                  = UIViewContentModeScaleAspectFill;
    self.newsImageView3.contentMode                  = UIViewContentModeScaleAspectFill;

    self.hisFriendImageView1.contentMode             = UIViewContentModeScaleAspectFill;
    self.hisFriendImageView2.contentMode             = UIViewContentModeScaleAspectFill;
    self.hisFriendImageView3.contentMode             = UIViewContentModeScaleAspectFill;
    self.hisFriendImageView4.contentMode             = UIViewContentModeScaleAspectFill;

    self.hisFriendImageView1.layer.masksToBounds     = YES;
    self.hisFriendImageView2.layer.masksToBounds     = YES;
    self.hisFriendImageView3.layer.masksToBounds     = YES;
    self.hisFriendImageView4.layer.masksToBounds     = YES;

    self.newsImageView1.layer.masksToBounds          = YES;
    self.newsImageView2.layer.masksToBounds          = YES;
    self.newsImageView3.layer.masksToBounds          = YES;

    //背景
    self.backImageView.frame                         = CGRectMake(0, 0, self.viewWidth, 195);
    self.backImageView.contentMode                   = UIViewContentModeScaleAspectFill;
    self.backImageView.layer.masksToBounds           = YES;
    //头像
    self.headImageBtn.frame                          = CGRectMake(35, 110, 60, 60);
    self.headImageBtn.layer.cornerRadius             = 35;
    self.headImageBtn.layer.masksToBounds            = YES;
    self.headImageBtn.layer.borderColor              = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    self.headImageBtn.layer.borderWidth              = 3;

    //背景图
    self.backImageView.frame               = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    //头像
    self.headImageBtn.frame                = CGRectMake(kCenterOriginX(60), 75, 70, 70);
    //姓名
    self.nameLabel.frame                   = CGRectMake(kCenterOriginX(200), self.headImageBtn.bottom+5, 170, 20);
    self.nameLabel.textColor               = [UIColor colorWithHexString:ColorWhite];
    self.nameLabel.textAlignment           = NSTextAlignmentRight;
    self.nameLabel.font                    = [UIFont systemFontOfSize:FontInformation];
    //性别
    self.sexImageView.frame                = CGRectMake(self.nameLabel.right+3, self.headImageBtn.bottom+8, 15, 15);
    self.sexImageView.contentMode          = UIViewContentModeScaleAspectFill;
    //学校
    self.schoolLabel.frame                 = CGRectMake(kCenterOriginX(200), self.nameLabel.bottom, 200, 15);
    self.schoolLabel.textAlignment         = NSTextAlignmentCenter;
    self.schoolLabel.textColor             = [UIColor colorWithHexString:ColorWhite];
    self.schoolLabel.font                  = [UIFont systemFontOfSize:FontTopSchool];

    //好友交互部分
    self.chatBackView.frame            = CGRectMake(0, 200, self.viewWidth, 70);
    self.chatBackView.backgroundColor  = [UIColor colorWithHexString:ColorLightWhite];
    //设置发消息和加好友
    [self setChatWidget];

    //根据型号放大
    CGFloat width                          = self.viewWidth/4.0;
    //我的状态
    self.hisNewsBackView.frame             = CGRectMake(0, self.chatBackView.bottom, self.viewWidth, 40+width);
    self.hisNewsBackView.backgroundColor   = [UIColor whiteColor];
    //图标
    CustomImageView * newsIconImageView    = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    newsIconImageView.image                = [UIImage imageNamed:@"my_images_icon"];
    [self.hisNewsBackView addSubview:newsIconImageView];
    CustomLabel * newsLabel                = [[CustomLabel alloc] initWithFrame:CGRectMake(newsIconImageView.right+5, newsIconImageView.y, 150, 20)];
    newsLabel.font                         = [UIFont systemFontOfSize:FontPersonalTitle];
    newsLabel.textColor                    = [UIColor colorWithHexString:ColorBrown];
    newsLabel.text                         = @"TA记录的小点滴 (●′ω`●)";
    [self.hisNewsBackView addSubview:newsLabel];
    //箭头
    CustomImageView * arrowImageView       = [[CustomImageView alloc] initWithFrame:CGRectMake(self.viewWidth-30, 7, 10, 15)];
    arrowImageView.image                   = [UIImage imageNamed:@"right_arrow"];
    [self.hisNewsBackView addSubview:arrowImageView];
    //其余
    self.newsImageView1.frame              = CGRectMake(15, newsIconImageView.bottom+10, width, width);
    self.newsImageView2.frame              = CGRectMake(self.newsImageView1.right+10, self.newsImageView1.y, width, width);
    self.newsImageView3.frame              = CGRectMake(self.newsImageView2.right+10, self.newsImageView1.y, width, width);

    //中间分割线
    UIView * lineView1                      = [[UIView alloc] initWithFrame:CGRectMake(0, self.hisNewsBackView.bottom, self.viewWidth, 1)];
    lineView1.backgroundColor               = [UIColor colorWithHexString:ColorLightWhite];
    [self.backScrollView addSubview:lineView1];

    //宽度
    CGFloat friendImageWidth               = (self.viewWidth-180)/4;
    //好友部分
    self.hisFriendBackView.frame           = CGRectMake(0, self.hisNewsBackView.bottom, self.viewWidth, 15+friendImageWidth);
    self.hisFriendBackView.backgroundColor = [UIColor whiteColor];
    //图标
    CustomImageView * friendIconImageView  = [[CustomImageView alloc] initWithFrame:CGRectMake(10, (self.hisFriendBackView.height-15)/2, 20, 15)];
    friendIconImageView.image              = [UIImage imageNamed:@"my_friends_icon"];
    [self.hisFriendBackView addSubview:friendIconImageView];
    CustomLabel * hisFriendLabel           = [[CustomLabel alloc] initWithFrame:CGRectMake(friendIconImageView.right+2, (self.hisFriendBackView.height-20)/2, 60, 20)];
    hisFriendLabel.font                    = [UIFont systemFontOfSize:FontPersonalTitle];
    hisFriendLabel.textColor               = [UIColor colorWithHexString:ColorBrown];
    hisFriendLabel.text                    = @"TA的朋友";
    [self.hisFriendBackView addSubview:hisFriendLabel];
    
    //圆角
    self.hisFriendImageView1.layer.cornerRadius = 2;
    self.hisFriendImageView2.layer.cornerRadius = 2;
    self.hisFriendImageView3.layer.cornerRadius = 2;
    self.hisFriendImageView4.layer.cornerRadius = 2;

    self.hisFriendImageView1.frame              = CGRectMake(hisFriendLabel.right+5, 8, friendImageWidth, friendImageWidth);
    self.hisFriendImageView2.frame              = CGRectMake(self.hisFriendImageView1.right+5, self.hisFriendImageView1.y, friendImageWidth, friendImageWidth);
    self.hisFriendImageView3.frame              = CGRectMake(self.hisFriendImageView2.right+5, self.hisFriendImageView1.y, friendImageWidth, friendImageWidth);
    self.hisFriendImageView4.frame              = CGRectMake(self.hisFriendImageView3.right+5, self.hisFriendImageView1.y, friendImageWidth, friendImageWidth);

    //数量
    self.hisFriendCountLabel.frame              = CGRectMake(self.hisFriendImageView4.right+2, (self.hisFriendBackView.height-20)/2, self.viewWidth-32-self.hisFriendImageView4.right, 20);
    self.hisFriendCountLabel.textAlignment      = NSTextAlignmentRight;
    self.hisFriendCountLabel.font               = [UIFont systemFontOfSize:10];
    self.hisFriendCountLabel.textColor          = [UIColor colorWithHexString:ColorDeepBlack];
    //箭头
    CustomImageView * friArrowImageView         = [[CustomImageView alloc] initWithFrame:CGRectMake(self.viewWidth-30, (self.hisFriendBackView.height-15)/2, 10, 15)];
    friArrowImageView.image                     = [UIImage imageNamed:@"right_arrow"];
    [self.hisFriendBackView addSubview:friArrowImageView];

    //中间分割线
    UIView * lineView2                          = [[UIView alloc] initWithFrame:CGRectMake(0, self.hisFriendBackView.bottom, self.viewWidth, 10)];
    lineView2.backgroundColor                   = [UIColor colorWithHexString:ColorLightWhite];
    [self.backScrollView addSubview:lineView2];
    
    //共同好友部分
    self.commonFriendBtn.frame                  = CGRectMake(0, lineView2.bottom, self.viewWidth, 45);
    [self setCommonArrowAndTitle:@"共同的好友" withView:self.commonFriendBtn];
    //共同好友数量
    self.commonCountLabel.frame                 = CGRectMake(self.viewWidth-132, 13, 100, 20);
    self.commonCountLabel.textAlignment         = NSTextAlignmentRight;
    self.commonCountLabel.font                  = [UIFont systemFontOfSize:10];
    self.commonCountLabel.textColor             = [UIColor colorWithHexString:ColorDeepBlack];
    [self.commonFriendBtn addSubview:self.commonCountLabel];
    
    //中间分割线
    UIView * lineView3                      = [[UIView alloc] initWithFrame:CGRectMake(0, self.commonFriendBtn.bottom, self.viewWidth, 1)];
    lineView3.backgroundColor               = [UIColor colorWithHexString:ColorLightWhite];
    [self.backScrollView addSubview:lineView3];
    
    //他的来访
    self.visitBtn.frame                         = CGRectMake(0, lineView3.bottom, self.viewWidth, 45);
    [self setCommonArrowAndTitle:@"谁看过TA" withView:self.visitBtn];
    //来访数量
    self.visitCountLabel.frame                  = CGRectMake(self.viewWidth-132, 13, 100, 20);
    self.visitCountLabel.textAlignment          = NSTextAlignmentRight;
    self.visitCountLabel.font                   = [UIFont systemFontOfSize:10];
    self.visitCountLabel.textColor              = [UIColor colorWithHexString:ColorDeepBlack];
    [self.visitBtn addSubview:self.visitCountLabel];


    //我的信息
    self.informationLabel.frame            = CGRectMake(0, self.visitBtn.bottom, self.viewWidth, 30);
    self.informationLabel.backgroundColor  = [UIColor colorWithHexString:ColorLightWhite];
    self.informationLabel.textColor        = [UIColor colorWithHexString:ColorCharGary];
    self.informationLabel.font             = [UIFont systemFontOfSize:12];
    self.informationLabel.text             = @"   我的资料";

    [self.view bringSubviewToFront:self.navBar];
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //举报
            ReportOffenceViewController * reportVC = [[ReportOffenceViewController alloc] init];
            reportVC.reportUid                     = self.uid;
            [self pushVC:reportVC];
        }
            break;
        case 1:
        {
            //如果是好友
            if (self.isFriend) {
                //删除
                YSAlertView * alert = [[YSAlertView alloc] initWithTitle:[NSString stringWithFormat:@"确认要删除%@吗？", self.otherUser.name] contentText:@"TA将消失在你的好友列表" leftButtonTitle:StringCommonConfirm rightButtonTitle:StringCommonCancel showView:self.view];
                [alert setLeftBlock:^{
                    [self deleteFriendCommit];
                }];
                [alert show];
            }
            
        }
            
            break;
        default:
            break;
    }
}

#pragma mark- UITableViewDelegate
#define ContentTag 100
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.informationArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell   = [tableView dequeueReusableCellWithIdentifier:@"personalCell"];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //标题
    CustomLabel * titleLabel   = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 13, 40, 20)];
    titleLabel.font            = [UIFont systemFontOfSize:FontPersonalTitle];
    titleLabel.textColor       = [UIColor colorWithHexString:ColorCharGary];
    titleLabel.text            = self.informationArr[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    //内容
    CustomLabel * contentLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(titleLabel.right, 13, 210, 20)];
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contentLabel.tag           = ContentTag;
    contentLabel.numberOfLines = 0;
    contentLabel.font          = [UIFont systemFontOfSize:FontInformation];
    contentLabel.textColor     = [UIColor colorWithHexString:ColorDeepBlack];
    
    //底部线
    UIView * lineView          = [[UIView alloc] initWithFrame:CGRectMake(10, 44, self.viewWidth, 1)];
    lineView.backgroundColor   = [UIColor colorWithHexString:ColorLightGary];
    [cell.contentView addSubview:lineView];
    
    NSString * content = @"未填";
    UserModel * user = self.otherUser;
    //内容
    switch (indexPath.row) {
        case ContentName:
            content = user.name;

            break;
        case ContentSign:
            content = user.sign;
            //计算真实大小
            CGSize signSize     = [ToolsManager getSizeWithContent:content andFontSize:FontInformation andFrame:CGRectMake(0, 0, 200, 300)];
            if (signSize.height < 20) {
                signSize.height = 20;
            }
            contentLabel.height = signSize.height;
            lineView.y          = contentLabel.bottom+10;
            break;
        case ContentBirthday:
            content = user.birthday;
            break;
        case ContentSex:
            if (user.sex == SexBoy) {
                content = @"男孩纸";
            }else if(user.sex == SexGirl){
                content = @"女孩纸";
            }else{
                content = @"你猜";
            }
            break;
        case ContentSchool:
            content = user.school;
            break;
        case ContentCity:
            content = [user.city stringByReplacingOccurrencesOfString:@"," withString:@""];
            break;
        default:
            break;
    }
    
    if (content == nil || content.length < 1) {
        content = @"未填";
    }
    
    contentLabel.text          = content;
    [cell.contentView addSubview:contentLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //签名需要计算高度
    if (indexPath.row == ContentSign) {
        NSString * sign                 = self.otherUser.sign;
        CGSize signSize                 = [ToolsManager getSizeWithContent:sign andFontSize:FontInformation andFrame:CGRectMake(0, 0, 200, 300)];
        if (signSize.height < 20) {
            signSize.height = 20;
        }
        //重置table高度
        tableView.height                = 45 * 5 + signSize.height+25;
        self.backScrollView.contentSize = CGSizeMake(0, tableView.bottom);
        return signSize.height+25;
    }
    
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- method response
//其他人得状态的状态
- (void)hisNewsClick:(id)sender {
    
    MyNewsListViewController * mnlvc = [[MyNewsListViewController alloc] init];
    mnlvc.isOther = YES;
    mnlvc.uid     = self.uid;
    [self pushVC:mnlvc];
}

//发送消息
- (void)sendMessagePress:(id)sender {

    IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:self.uid]];
    //如果存在
    if (group) {
        group.groupTitle     = self.otherUser.name;
        group.avatarPath     = self.otherUser.head_image;
        [group update];
    }else{
        //保存群组信息
        group = [[IMGroupModel alloc] init];
        group.type           = ConversationType_PRIVATE;
        //targetId
        group.groupId        = [ToolsManager getCommonGroupId:self.uid];
        group.groupTitle     = self.otherUser.name;
        group.isNew          = NO;
        group.avatarPath     = self.otherUser.head_image;
        group.isRead         = YES;
        group.currentState   = GroupNotAdd;
        group.owner          = [UserService sharedService].user.uid;
        [group save];
    }
    
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType    = ConversationType_PRIVATE;
    conversationVC.targetId            = group.groupId;
    conversationVC.userName          = group.groupTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
}

//头像点击
- (void)headImageClick:(id)sender {
    
    BrowseImageViewController * bivc = [[BrowseImageViewController alloc] init];
    bivc.canDelete = NO;
    bivc.url = [ToolsManager completeUrlStr:self.otherUser.head_image];
    [self pushVC:bivc];
    
}

//最近来访
- (void)visitClick:(id)sender {
    
    VisitListViewController * vlvc = [[VisitListViewController alloc] init];
    vlvc.uid                       = self.uid;
    [self pushVC:vlvc];
    
}
//好友列表
- (void)friendClick:(id)sender {
    
    OtherPeopleFriendsListViewController * opflvc = [[OtherPeopleFriendsListViewController alloc] init];
    opflvc.uid = self.uid;
    [self pushVC:opflvc];
    
}
//共同好友
- (void)commonFriendsClick:(id)sender {
    
    CommonFriendsListViewController * cflvc = [[CommonFriendsListViewController alloc] init];
    cflvc.uid                               = self.uid;
    [self pushVC:cflvc];
    
}

#pragma mark- private method
//添加好友
- (void)addFriendCommit
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", self.uid]
                              };
    
    debugLog(@"%@ %@", kAddFriendPath, params);
    [self showLoading:@"添加中^_^"];
    //添加好友
    [HttpService postWithUrlString:kAddFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:self.uid]];
            //如果存在
            if (group) {
                
                group.groupTitle     = self.otherUser.name;
                group.avatarPath     = self.otherUser.head_image;
                group.currentState   = GroupHasAdd;
                [group update];
                
            }else{
                //保存群组信息
                group = [[IMGroupModel alloc] init];
                group.type           = ConversationType_PRIVATE;
                //targetId
                group.groupId        = [ToolsManager getCommonGroupId:self.uid];
                group.groupTitle     = self.otherUser.name;
                group.isNew          = NO;
                group.avatarPath     = self.otherUser.head_image;
                group.isRead         = YES;
                group.currentState   = GroupHasAdd;
                group.owner          = [UserService sharedService].user.uid;
                [group save];
            }
            
            //添加成功
            [self showComplete:responseData[HttpMessage]];
            //修改布局
            [self setIsFriendLayout:YES];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}
//删除好友
- (void)deleteFriendCommit
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", self.uid]
                              };
    
    debugLog(@"%@ %@", kDeleteFriendPath, params);
    [self showLoading:@"删除中"];
    //添加好友
    [HttpService postWithUrlString:kDeleteFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            //删除成功
            [self showComplete:responseData[HttpMessage]];
//            IMGroupModel * group = [[IMGroupModel alloc] init];
//            //targetId
//            group.groupId        = [ToolsManager getCommonGroupId:self.uid];
//            group.owner          = [UserService sharedService].user.uid;
//            [group remove];
            
            //清除会话
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:[ToolsManager getCommonGroupId:self.uid]];
            [self setIsFriendLayout:NO];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

//获取用户信息
- (void)getPersonalInformation
{
    //kGetNewsImagesPath
    NSString * path = [kPersnalInformationPath stringByAppendingFormat:@"?uid=%ld&current_id=%ld", self.uid, [UserService sharedService].user.uid];
    debugLog(@"%@", path);
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            [self handleDataWithDic:responseData];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//处理数据
- (void)handleDataWithDic:(NSDictionary *)responseData
{
    //用户信息
    self.otherUser      = [[UserModel alloc] init];
    [self.otherUser setModelWithDic:responseData[HttpResult]];
    
    //图片数组
    NSArray * imageList = responseData[HttpResult][@"image_list"];
    NSArray * images    = @[self.newsImageView1, self.newsImageView2, self.newsImageView3];
    //遍历设置图片
    for (int i=0; i<imageList.count; i++) {
        NSDictionary * dic          = imageList[i];
        CustomImageView * imageView = images[i];
        NSURL * url                 = [NSURL URLWithString:[ToolsManager completeUrlStr:dic[@"sub_url"]]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        imageView.hidden            = NO;
    }
    
    //他的好友数组
    //图片数组
    NSArray * hisFrienList = responseData[HttpResult][@"friend_list"];
    NSArray * hisFriends   = @[self.hisFriendImageView1, self.hisFriendImageView2, self.hisFriendImageView3, self.hisFriendImageView4];
    
    //最多三张
    NSInteger count = hisFrienList.count;
    if (count > 4) {
        count = 4;
    }
    //遍历设置图片
    for (int i=0; i<count; i++) {
        NSDictionary * dic          = hisFrienList[i];
        CustomImageView * imageView = hisFriends[i];
        NSURL * url                 = [NSURL URLWithString:[ToolsManager completeUrlStr:dic[@"head_sub_image"]]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
        imageView.hidden            = NO;
    }
    
    //是否是好友
    self.isFriend           = [responseData[HttpResult][@"isFriend"] boolValue];
    self.visitCount         = [responseData[HttpResult][@"visit_count"] integerValue];
    //这个人的好友数量
    self.friendsCount       = [responseData[HttpResult][@"friend_count"] integerValue];
    //共同好友数量
    self.commonFriendsCount = [responseData[HttpResult][@"common_friend_count"] integerValue];
    //更新UI
    [self refreshUI];
    //初始化列表
    [self initTable];
}

- (void)refreshUI
{
    
    //头像
    NSURL * headUrl         = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, self.otherUser.head_image]];
    [self.headImageBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    //背景
    NSURL * backUrl         = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, self.otherUser.background_image]];
    [self.backImageView sd_setImageWithURL:backUrl placeholderImage:[UIImage imageNamed:@"default_back_image"]];
    //姓名
    self.nameLabel.text     = self.otherUser.name;
    CGSize size             = [ToolsManager getSizeWithContent:self.otherUser.name andFontSize:FontInformation andFrame:CGRectMake(0, 0, 300, 20)];
    //重新布局
    self.nameLabel.frame    = CGRectMake(kCenterOriginX(size.width)-10, self.headImageBtn.bottom+5, size.width, 20);
    self.sexImageView.frame = CGRectMake(self.nameLabel.right+5, self.headImageBtn.bottom+8, 15, 15);
    //性别
    if (self.otherUser.sex == SexBoy) {
        self.sexImageView.image = [UIImage imageNamed:@"sex_boy"];
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"sex_girl"];
    }
    self.schoolLabel.text = self.otherUser.school;

    //访客数量
    self.visitCountLabel.text = [NSString stringWithFormat:@"%ld人", self.visitCount];
    //共同好友数量
    self.commonCountLabel.text = [NSString stringWithFormat:@"%ld人", self.commonFriendsCount];
    
    //好友数量
    if (self.friendsCount > 0) {
        self.hisFriendCountLabel.text = [NSString stringWithFormat:@"%ld人", self.friendsCount];
    }else{
        self.hisFriendCountLabel.text = @"";
    }
    
    //恢复事件
    self.addFriendsBtn.enabled  = YES;
    self.sendMessageBtn.enabled = YES;
    
    //设置发消息布局
    [self setIsFriendLayout:self.isFriend];
    
}
//共同好友和来访
- (void)setCommonArrowAndTitle:(NSString *)title withView:(UIView *)view
{
    view.backgroundColor             = [UIColor colorWithHexString:ColorWhite];
    //他的来访
    CustomLabel * visitFriendLabel   = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 0, 90, 45)];
    visitFriendLabel.font            = [UIFont systemFontOfSize:FontPersonalTitle];
    visitFriendLabel.textColor       = [UIColor colorWithHexString:ColorCharGary];
    visitFriendLabel.text            = title;
    //箭头
    CustomImageView * arrowImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(self.viewWidth-30, 15, 10, 15)];
    arrowImageView.image             = [UIImage imageNamed:@"right_arrow"];
    
    [view addSubview:visitFriendLabel];
    [view addSubview:arrowImageView];
}
//发消息和加好友
- (void)setChatWidget
{
    self.sendMessageBtn.frame            = CGRectMake(15, 15, self.viewWidth/2-30, 40);
    self.addFriendsBtn.frame             = CGRectMake(self.viewWidth/2+15, 15, self.viewWidth/2-30, 40);
    //背景
    [self.sendMessageBtn setBackgroundImage:[UIImage imageNamed:@"send_message_btn_normal"] forState:UIControlStateNormal];
    [self.sendMessageBtn setBackgroundImage:[UIImage imageNamed:@"send_message_btn_press"] forState:UIControlStateHighlighted];
    [self.addFriendsBtn setBackgroundImage:[UIImage imageNamed:@"add_friend_btn_normal"] forState:UIControlStateNormal];
    [self.addFriendsBtn setBackgroundImage:[UIImage imageNamed:@"add_friend_btn_press"] forState:UIControlStateHighlighted];
    //内容图
    self.sendMessageImageView            = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"send_message_content_image"]];
    CustomImageView * addFriendImageView = [[CustomImageView alloc] initWithImage:[UIImage imageNamed:@"add_friend_content_image"]];
    //内容字
    self.sendMessageLabel                = [[CustomLabel alloc] initWithFontSize:20];
    self.sendMessageLabel.text           = @"发消息";
    self.sendMessageLabel.textColor      = [UIColor colorWithHexString:ColorWhite];
    CustomLabel * addFriendLabel         = [[CustomLabel alloc] initWithFontSize:20];
    addFriendLabel.text                  = @"加好友";
    addFriendLabel.textColor             = [UIColor colorWithHexString:ColorWhite];
    
    [self.sendMessageBtn addSubview:self.sendMessageLabel];
    [self.addFriendsBtn addSubview:addFriendLabel];
    [self.sendMessageBtn addSubview:self.sendMessageImageView];
    [self.addFriendsBtn addSubview:addFriendImageView];
    //布局
    [self configPositionWithImageView:self.sendMessageImageView andLabel:self.sendMessageLabel andFather:self.sendMessageBtn];
    [self configPositionWithImageView:addFriendImageView andLabel:addFriendLabel andFather:self.addFriendsBtn];
    
    //自己不显示
    if (self.uid == [UserService sharedService].user.uid) {
        //好友交互部分隐藏
        self.chatBackView.hidden = YES;
        self.chatBackView.height = 0;
        //右上角隐藏
        self.navBar.rightBtn.hidden = YES;
    }else{
        //不是自己 先禁止事件
        self.addFriendsBtn.enabled = NO;
        self.sendMessageBtn.enabled = NO;
    }
}
//配置加好友和发消息的位置
- (void)configPositionWithImageView:(CustomImageView *)imageView andLabel:(CustomLabel *)label andFather:(UIView *)view
{
    CGFloat start   = (view.width-90)/2;
    imageView.frame = CGRectMake(start, 10, 25, 20);
    label.frame     = CGRectMake(imageView.right+5, 10, 60, 20);
}

//设置是否是好友的布局
- (void)setIsFriendLayout:(BOOL)isFriend
{
    self.isFriend = isFriend;
    
    //如果已经是好友了
    if (self.isFriend == YES) {
        self.addFriendsBtn.hidden = YES;
        self.sendMessageBtn.frame = CGRectMake(25, 15, self.viewWidth-50, 40);
    }else{
        //恢复添加按钮
        self.addFriendsBtn.hidden = NO;
        self.sendMessageBtn.frame = CGRectMake(15, 15, self.viewWidth/2-30, 40);
    }
    //修改位置
    [self configPositionWithImageView:self.sendMessageImageView andLabel:self.sendMessageLabel andFather:self.sendMessageBtn];
    
    //有好友可以删好友
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"" andBlock:^{
        UIActionSheet * actionSheet;
        if (sself.isFriend) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:sself cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"举报TA",@"删除好友", nil];
        }else{
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:sself cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"举报TA", nil];
        }
        
        [actionSheet showInView:sself.view];
    }];
}

@end
