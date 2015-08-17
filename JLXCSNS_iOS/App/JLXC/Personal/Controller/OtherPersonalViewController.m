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

//背景图
@property (strong, nonatomic) CustomImageView *backImageView;
//头像
@property (strong, nonatomic) CustomButton *headImageBtn;
//姓名
@property (strong, nonatomic) CustomButton *nameBtn;
//性别
@property (strong, nonatomic) CustomLabel *sexLabel;
//签名
@property (strong, nonatomic) CustomLabel *signLabel;
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

@property (strong, nonatomic) UIView *chatBackView;
//发送消息按钮
@property (strong, nonatomic) CustomButton *sendMessageBtn;
//添加好友按钮
@property (strong, nonatomic) CustomButton *addFriendsBtn;

//背景
@property (strong, nonatomic) UIButton *friendAndVisitView;
//访客按钮
@property (strong, nonatomic) UIButton *visitBtn;
//好友按钮
@property (strong, nonatomic) UIButton *commonFriendBtn;

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
    
    [self initWidget];
    [self configUI];
    //获取该用户信息
    [self getPersonalInformation];

}

- (void)viewWillAppear:(BOOL)animated
{
    //是好友则查看备注
    //姓名
    if (self.isFriend) {
//        //是好友查看备注
//        IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:self.otherUser.uid]];
//        if (group.groupRemark != nil && group.groupRemark.length > 0) {
//            self.friendRemark = group.groupRemark;
//        }
        
        [self.nameBtn setTitle:[ToolsManager getRemarkOrOriginalNameWithUid:self.otherUser.uid andOriginalName:self.otherUser.name] forState:UIControlStateNormal];
        [self.infomationTableView reloadData];
 
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    //默认三图片隐藏
    self.newsImageView1.hidden         = YES;
    self.newsImageView2.hidden         = YES;
    self.newsImageView3.hidden         = YES;

    self.hisFriendImageView1.hidden = YES;
    self.hisFriendImageView2.hidden = YES;
    self.hisFriendImageView3.hidden = YES;
    
    self.navBar.backgroundColor        = [UIColor clearColor];
    
    //背景图
    self.backImageView  = [[CustomImageView alloc] init];
    //头像
    self.headImageBtn   = [[CustomButton alloc] init];
    //姓名
    self.nameBtn        = [[CustomButton alloc] init];
    //姓名
    self.sexLabel       = [[CustomLabel alloc] initWithFontSize:15];
    //签名
    self.signLabel      = [[CustomLabel alloc] initWithFontSize:15];

    self.chatBackView   = [[UIView alloc] init];
    self.addFriendsBtn  = [[CustomButton alloc] init];
    self.sendMessageBtn = [[CustomButton alloc] init];

    //我的状态
    self.hisNewsBackView        = [[CustomButton alloc] init];
    self.newsImageView1         = [[CustomImageView alloc] init];
    self.newsImageView2         = [[CustomImageView alloc] init];
    self.newsImageView3         = [[CustomImageView alloc] init];
    //好友
    self.hisFriendBackView   = [[CustomButton alloc] init];
    self.hisFriendImageView1 = [[CustomImageView alloc] init];
    self.hisFriendImageView2 = [[CustomImageView alloc] init];
    self.hisFriendImageView3 = [[CustomImageView alloc] init];
    self.hisFriendCountLabel = [[CustomLabel alloc] initWithFontSize:15];
    //他的好友和访问
    self.friendAndVisitView     = [[CustomButton alloc] init];
    self.commonFriendBtn        = [[CustomButton alloc] init];
    self.visitBtn               = [[CustomButton alloc] init];
    //个人信息
    self.informationLabel       = [[CustomLabel alloc] initWithFontSize:15];
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.nameBtn];
    [self.view addSubview:self.headImageBtn];
    [self.view addSubview:self.sexLabel];
    [self.view addSubview:self.signLabel];
    [self.view addSubview:self.chatBackView];
    [self.chatBackView addSubview:self.sendMessageBtn];
    [self.chatBackView addSubview:self.addFriendsBtn];
    
    [self.view addSubview:self.hisNewsBackView];
    [self.hisNewsBackView addSubview:self.newsImageView1];
    [self.hisNewsBackView addSubview:self.newsImageView2];
    [self.hisNewsBackView addSubview:self.newsImageView3];
   
    [self.view addSubview:self.hisFriendBackView];
    [self.hisFriendBackView addSubview:self.hisFriendImageView1];
    [self.hisFriendBackView addSubview:self.hisFriendImageView2];
    [self.hisFriendBackView addSubview:self.hisFriendImageView3];
    [self.hisFriendBackView addSubview:self.hisFriendCountLabel];
    [self.friendAndVisitView addSubview:self.commonFriendBtn];
    [self.friendAndVisitView addSubview:self.visitBtn];
    [self.view addSubview:self.friendAndVisitView];
    [self.view addSubview:self.informationLabel];
    
}

- (void)initTable
{
    self.informationArr = @[@"昵称",@"签名",@"生日",@"性别",@"学校",@"城市"];
    
    self.infomationTableView                              = [[UITableView alloc] initWithFrame:CGRectMake(0, self.informationLabel.bottom, self.informationLabel.width, self.viewHeight-self.informationLabel.bottom) style:UITableViewStylePlain];
    //    self.infomationTableView.bounces    = NO;
    self.infomationTableView.showsVerticalScrollIndicator = NO;
    self.infomationTableView.delegate                     = self;
    self.infomationTableView.dataSource                   = self;
    [self.infomationTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"personalCell"];
    [self.view addSubview:self.infomationTableView];
    
}

- (void)configUI
{
    //调整Mode
    self.newsImageView1.contentMode              = UIViewContentModeScaleAspectFill;
    self.newsImageView2.contentMode              = UIViewContentModeScaleAspectFill;
    self.newsImageView3.contentMode              = UIViewContentModeScaleAspectFill;

    self.hisFriendImageView1.contentMode         = UIViewContentModeScaleAspectFill;
    self.hisFriendImageView2.contentMode         = UIViewContentModeScaleAspectFill;
    self.hisFriendImageView3.contentMode         = UIViewContentModeScaleAspectFill;

    self.hisFriendImageView1.layer.masksToBounds = YES;
    self.hisFriendImageView2.layer.masksToBounds = YES;
    self.hisFriendImageView3.layer.masksToBounds = YES;

    self.newsImageView1.layer.masksToBounds      = YES;
    self.newsImageView2.layer.masksToBounds      = YES;
    self.newsImageView3.layer.masksToBounds      = YES;
    
    //背景
    self.backImageView.frame           = CGRectMake(0, 0, self.viewWidth, 195);
    self.backImageView.backgroundColor = [UIColor cyanColor];
    //头像
    self.headImageBtn.frame            = CGRectMake(35, 110, 60, 60);
    [self.headImageBtn addTarget:self action:@selector(headImageClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nameBtn.frame                 = CGRectMake(113, 110, 60, 30);
    //性别
    self.sexLabel.frame                = CGRectMake(self.nameBtn.right, self.nameBtn.y, 30, 30);
    self.sexLabel.textAlignment        = NSTextAlignmentCenter;
    self.sexLabel.textColor            = [UIColor whiteColor];
    //签名
    self.signLabel.frame               = CGRectMake(self.nameBtn.x, self.nameBtn.bottom, 200, 30);

    //好友部分
    self.chatBackView.frame            = CGRectMake(0, self.backImageView.bottom, self.viewWidth, 50);
    self.chatBackView.backgroundColor  = [UIColor blueColor];
    self.sendMessageBtn.frame          = CGRectMake(((self.viewWidth/2)-100)/2, 10, 100, 30);
    self.addFriendsBtn.frame           = CGRectMake(((self.viewWidth/2)-100)/2+self.viewWidth/2, 10, 100, 30);
    [self.sendMessageBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [self.addFriendsBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.sendMessageBtn addTarget:self action:@selector(sendMessagePress:) forControlEvents:UIControlEventTouchUpInside];
    [self.addFriendsBtn addTarget:self action:@selector(addFriendsPress:) forControlEvents:UIControlEventTouchUpInside];

    //我的状态
    self.hisNewsBackView.frame                = CGRectMake(0, self.chatBackView.bottom, self.viewWidth, 65);
    self.hisNewsBackView.backgroundColor      = [UIColor greenColor];
    [self.hisNewsBackView addTarget:self action:@selector(hisNewsClick:) forControlEvents:UIControlEventTouchUpInside];
    CustomLabel * newsLabel                   = [[CustomLabel alloc] initWithFontSize:13];
    newsLabel.frame                           = CGRectMake(10, 23, 70, 20);
    newsLabel.text                            = @"TA的相片";
    [self.hisNewsBackView addSubview:newsLabel];
    self.newsImageView1.frame                 = CGRectMake(newsLabel.right+10, 5, 55, 55);
    self.newsImageView2.frame                 = CGRectMake(self.newsImageView1.right+10, 5, 55, 55);
    self.newsImageView3.frame                 = CGRectMake(self.newsImageView2.right+10, 5, 55, 55);

    //好友部分
    self.hisFriendBackView.frame           = CGRectMake(0, self.hisNewsBackView.bottom, self.viewWidth, 65);
    self.hisFriendBackView.backgroundColor = [UIColor yellowColor];
    [self.hisFriendBackView addTarget:self action:@selector(friendClick:) forControlEvents:UIControlEventTouchUpInside];
    CustomLabel * hisFriendLabel           = [[CustomLabel alloc] initWithFontSize:13];
    hisFriendLabel.frame                   = CGRectMake(10, 23, 70, 20);
    hisFriendLabel.text                    = @"TA的好友";
    [self.hisFriendBackView addSubview:hisFriendLabel];
    self.hisFriendImageView1.frame         = CGRectMake(hisFriendLabel.right+10, 5, 55, 55);
    self.hisFriendImageView2.frame         = CGRectMake(self.hisFriendImageView1.right+10, 5, 55, 55);
    self.hisFriendImageView3.frame         = CGRectMake(self.hisFriendImageView2.right+10, 5, 55, 55);
    self.hisFriendCountLabel.frame         = CGRectMake(self.hisFriendImageView3.right+10, self.hisFriendImageView3.y, 30, 30);
    
    //共同好友部分
    self.friendAndVisitView.frame             = CGRectMake(0, self.hisFriendBackView.bottom, self.viewWidth, 50);
    self.friendAndVisitView.backgroundColor   = [UIColor redColor];
    self.visitBtn.frame                       = CGRectMake(((self.viewWidth/2)-100)/2+self.viewWidth/2, 10, 100, 30);
    self.visitBtn.backgroundColor             = [UIColor grayColor];
    self.commonFriendBtn.frame                = CGRectMake(((self.viewWidth/2)-100)/2, 10, 100, 30);
    self.commonFriendBtn.backgroundColor      = [UIColor grayColor];
    [self.visitBtn addTarget:self action:@selector(visitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commonFriendBtn addTarget:self action:@selector(commonFriendsClick:) forControlEvents:UIControlEventTouchUpInside];

    //我的信息
    self.informationLabel.frame               = CGRectMake(0, self.friendAndVisitView.bottom, self.viewWidth, 20);
    self.informationLabel.backgroundColor     = [UIColor blueColor];
    self.informationLabel.text                = @"   个人信息";

    [self.view bringSubviewToFront:self.navBar];
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
    
    CustomLabel * titleLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 5, 60, 20)];
    titleLabel.font          = [UIFont systemFontOfSize:13];
    titleLabel.textColor     = [UIColor darkGrayColor];
    titleLabel.text          = self.informationArr[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    CustomLabel * contentLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(titleLabel.right+5, 5, 260, 20)];
    contentLabel.tag           = ContentTag;
    contentLabel.font          = [UIFont systemFontOfSize:14];
    contentLabel.textColor     = [UIColor blackColor];
    
    NSString * content = @"未填";
    UserModel * user = self.otherUser;
    //内容
    switch (indexPath.row) {
        case ContentName:
            if (self.isFriend) {
                content = [ToolsManager getRemarkOrOriginalNameWithUid:self.otherUser.uid andOriginalName:self.otherUser.name];
            }else{
                content = user.name;
            }

            break;
        case ContentSign:
            content = user.sign;
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
    return 30.0f;
}
#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //添加好友
        [self addFriendCommit];
    }
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

    IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:self.otherUser.uid]];
    //如果存在
    if (group) {
        if (group.currentState == GroupNotAdd) {
            group.groupTitle     = self.otherUser.name;
            group.avatarPath     = self.otherUser.head_image;
            group.isRead         = YES;
            group.isNew          = YES;
            group.currentState   = GroupNotAdd;
            [group update];
        }
    }else{
        //保存群组信息
        group = [[IMGroupModel alloc] init];
        group.type           = ConversationType_PRIVATE;
        //targetId
        group.groupId        = [ToolsManager getCommonGroupId:self.otherUser.uid];
        group.groupTitle     = self.otherUser.name;
        group.isNew          = YES;
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

//添加好友
- (void)addFriendsPress:(id)sender {

    NSString * message = [NSString stringWithFormat:@"确认要添加%@为好友吗?", self.otherUser.name];
    UIAlertView * friendAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:StringCommonConfirm, nil];
    [friendAlert show];
    
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
    vlvc.uid                       = self.otherUser.uid;
    [self pushVC:vlvc];
    
}

- (void)friendClick:(id)sender {
    
    OtherPeopleFriendsListViewController * opflvc = [[OtherPeopleFriendsListViewController alloc] init];
    opflvc.uid = self.otherUser.uid;
    [self pushVC:opflvc];
    
}

- (void)commonFriendsClick:(id)sender {
    
    CommonFriendsListViewController * cflvc = [[CommonFriendsListViewController alloc] init];
    cflvc.uid                               = self.otherUser.uid;
    [self pushVC:cflvc];
    
}

#pragma mark- private method
//添加好友
- (void)addFriendCommit
{
    //kAddFriendPath
    NSDictionary * params = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"friend_id":[NSString stringWithFormat:@"%ld", self.otherUser.uid]
                              };
    
    debugLog(@"%@ %@", kAddFriendPath, params);
    [self showLoading:@"添加中^_^"];
    //添加好友
    [HttpService postWithUrlString:kAddFriendPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        
        if (status == HttpStatusCodeSuccess) {
            IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:self.otherUser.uid]];
            //如果存在
            if (group) {
                
                group.groupTitle     = self.otherUser.name;
                group.avatarPath     = self.otherUser.head_image;
                group.isRead         = YES;
                group.isNew          = NO;
                group.currentState   = GroupHasAdd;
                [group update];
                
            }else{
                //保存群组信息
                group = [[IMGroupModel alloc] init];
                group.type           = ConversationType_PRIVATE;
                //targetId
                group.groupId        = [ToolsManager getCommonGroupId:self.otherUser.uid];
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
            //添加成功不能在添加了
            self.addFriendsBtn.hidden = YES;
//            //发送消息通知
//            [[PushService sharedInstance] pushAddFriendMessageWithTargetID:group.groupId];
            
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
            debugLog(@"%@", responseData);
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
        [imageView sd_setImageWithURL:url];
        imageView.hidden            = NO;
    }
    
    //他的好友数组
    //图片数组
    NSArray * hisFrienList = responseData[HttpResult][@"friend_list"];
    NSArray * hisFriends   = @[self.hisFriendImageView1, self.hisFriendImageView2, self.hisFriendImageView3];
    //遍历设置图片
    for (int i=0; i<hisFrienList.count; i++) {
        NSDictionary * dic          = hisFrienList[i];
        CustomImageView * imageView = hisFriends[i];
        
        NSURL * url                 = [NSURL URLWithString:[ToolsManager completeUrlStr:dic[@"head_sub_image"]]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"testimage"]];
        imageView.hidden            = NO;
    }
    
    
    //是否是好友
    self.isFriend           = [responseData[HttpResult][@"isFriend"] boolValue];
    self.visitCount         = [responseData[HttpResult][@"visit_count"] integerValue];
    //这个人的好友数量
    self.friendsCount       = [responseData[HttpResult][@"friend_count"] integerValue];
    //共同好友数量
    self.commonFriendsCount = [responseData[HttpResult][@"common_friend_count"] integerValue];
    [self refreshUI];
    
    //初始化列表
    [self initTable];
}

- (void)refreshUI
{
    
    //姓名
    if (self.isFriend) {
        [self.nameBtn setTitle:[ToolsManager getRemarkOrOriginalNameWithUid:self.otherUser.uid andOriginalName:self.otherUser.name] forState:UIControlStateNormal];
    }else{
        [self.nameBtn setTitle:self.otherUser.name forState:UIControlStateNormal];
    }
    //性别
    if (self.otherUser.sex == SexBoy) {
        self.sexLabel.text = @"男";
        self.sexLabel.backgroundColor = [UIColor blueColor];
    }else{
        self.sexLabel.text = @"女";
        self.sexLabel.backgroundColor = [UIColor yellowColor];
    }
    //签名
    self.signLabel.text = self.otherUser.sign;
    
    //头像
    NSURL * headUrl                       = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, self.otherUser.head_image]];
    [self.headImageBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"testimage"]];
    self.headImageBtn.layer.cornerRadius  = 30;
    self.headImageBtn.layer.masksToBounds = YES;
    
    //背景
    NSURL * backUrl                       = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, self.otherUser.background_image]];
    [self.backImageView sd_setImageWithURL:backUrl];
    
    //自己不显示
    if (self.otherUser.uid == [UserService sharedService].user.uid) {
        self.sendMessageBtn.enabled         = NO;
        self.addFriendsBtn.enabled          = NO;
        self.sendMessageBtn.backgroundColor = [UIColor darkGrayColor];
        self.addFriendsBtn.backgroundColor  = [UIColor darkGrayColor];
    }else{
        //不是自己可以删好友
        __weak typeof(self) sself = self;
        [self.navBar setRightBtnWithContent:@"设置" andBlock:^{
            FriendSettingViewController * fsVC = [[FriendSettingViewController alloc] init];
            fsVC.friendId                      = sself.otherUser.uid;
            fsVC.deleteName                    = sself.otherUser.name;
            [sself pushVC:fsVC];
            
        }];
    }
    
    //访客数量
    [self.visitBtn setTitle:[NSString stringWithFormat:@"访客%ld", self.visitCount] forState:UIControlStateNormal];
    //共同好友数量
    [self.commonFriendBtn setTitle:[NSString stringWithFormat:@"共同好友%ld", self.commonFriendsCount] forState:UIControlStateNormal];
    //好友数量
    if (self.friendsCount > 0) {
        self.hisFriendCountLabel.text = [NSString stringWithFormat:@"%ld", self.friendsCount];
    }else{
        self.hisFriendCountLabel.text = @"";
    }
    
    //如果已经是好友了
    if (self.isFriend == YES) {
        self.addFriendsBtn.hidden = YES;
        self.sendMessageBtn.x      = kCenterOriginX(100);
    }
}

@end
