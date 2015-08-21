//
//  PersonalViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "PersonalViewController.h"
#import "VisitListViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "InformationChangeViewController.h"
#import "ZHPickView.h"
#import "ChoiceSchoolViewController.h"
#import "MyNewsListViewController.h"
#import "MyCardViewController.h"
#import "MyFriendsListViewController.h"
#import "PersonalSettingViewController.h"
#import "NSData+ImageCache.h"

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

@interface PersonalViewController ()<ZHPickViewDelegate>

//背景滚动视图
@property (strong, nonatomic) UIScrollView * backScrollView;

//背景图
@property (strong, nonatomic) CustomImageView * backImageView;
//背景透明的按钮
@property (strong, nonatomic) CustomButton * backImageBtn;
//头像
@property (strong, nonatomic) CustomButton * headImageBtn;
//姓名
@property (strong, nonatomic) CustomLabel * nameLabel;
//性别
@property (strong, nonatomic) CustomImageView * sexImageView;
//学校
@property (strong, nonatomic) CustomLabel * schoolLabel;

//个人资料label
@property (strong, nonatomic) UILabel * informationLabel;

//我的状态背景按钮
@property (strong, nonatomic) CustomButton * newsImageBackView;
//新闻imageView1
@property (strong, nonatomic) UIImageView * newsImageView1;
//新闻imageView2
@property (strong, nonatomic) UIImageView * newsImageView2;
//新闻imageView3
@property (strong, nonatomic) UIImageView * newsImageView3;

//最近来访背景点击
@property (strong, nonatomic) UIButton * visitBackView;
////最近来访头像1
//@property (strong, nonatomic) CustomImageView * visitHeadImage1;
////最近来访头像2
//@property (strong, nonatomic) CustomImageView * visitHeadImage2;
////最近来访头像3
//@property (strong, nonatomic) CustomImageView * visitHeadImage3;
//好友数量label
@property (nonatomic, strong) CustomLabel * visitCountLabel;

//我的好友点击背景按钮
@property (strong, nonatomic) UIButton * myFriendsBackView;
////我的好友头像1
//@property (strong, nonatomic) CustomImageView * myFriendsImage1;
////我的好友头像2
//@property (strong, nonatomic) CustomImageView * myFriendsImage2;
////我的好友头像3
//@property (strong, nonatomic) CustomImageView * myFriendsImage3;
//好友数量label
@property (nonatomic, strong) CustomLabel * friendCountLabel;

//个人信息
@property (strong, nonatomic) UITableView * infomationTableView;
//数组
@property (strong, nonatomic) NSArray * informationArr;
//生日选择
@property (nonatomic, strong) UIDatePicker * datePicker;
//生日选择textField
@property (nonatomic, strong) UITextField * dateTextField;
//city选择
@property (nonatomic, strong) ZHPickView * cityPicker;
//city选择textField
@property (nonatomic, strong) UITextField * cityTextField;

//当前需要换得图片
@property (nonatomic, assign) NSInteger currentImageStyle;

@end

@implementation PersonalViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    [self initWidget];
    //编辑UI
    [self configUI];
    //初始化生日
    [self initDate];
    //初始化城市
    [self initCity];
    //初始化列表
    [self initTable];

}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //刷新UI
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{

}

#pragma mark- layout
- (void)initDate
{
    
    //生日
    self.datePicker                 = [[UIDatePicker alloc] init];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode  = UIDatePickerModeDate;
    if ([UserService sharedService].user.birthday.length > 9) {
        NSDate * date = [ToolsManager dateFromString:[UserService sharedService].user.birthday andFormatter:@"yyyy-MM-dd"];
        if (date != nil) {
            self.datePicker.date            = date;
        }
    }
    //生日挂件view
    UIView * accessoryView                = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 30)];
    accessoryView.backgroundColor         = [UIColor whiteColor];
    //保存按钮
    CustomButton * saveBtn = [[CustomButton alloc] initWithFontSize:15];
    [saveBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake(self.viewWidth-60, 10, 40, 20);
    [saveBtn addTarget:self action:@selector(saveBirthClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:StringCommonSave forState:UIControlStateNormal];
    [accessoryView addSubview:saveBtn];
    
    //取消按钮
    CustomButton * cancelBtn = [[CustomButton alloc] initWithFontSize:15];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:ColorDeepBlack] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(20, 10, 40, 20);
    [cancelBtn addTarget:self action:@selector(cancelBirthClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:StringCommonCancel forState:UIControlStateNormal];
    [accessoryView addSubview:cancelBtn];

    //生日textField
    self.dateTextField                    = [[UITextField alloc] initWithFrame:CGRectMake(0, self.viewHeight, 0, 0)];
    self.dateTextField.inputView          = self.datePicker;
    self.dateTextField.inputAccessoryView = accessoryView;
    [self.view addSubview:self.dateTextField];
    
}

- (void)initCity
{
    self.cityPicker = [[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
    [self.cityPicker setPickViewColer:[UIColor whiteColor]];
    self.cityPicker.delegate=self;

    //生日textField
    self.cityTextField                    = [[UITextField alloc] initWithFrame:CGRectMake(0, self.viewHeight, 0, 0)];
    self.cityTextField.inputView          = self.cityPicker;
    [self.view addSubview:self.cityTextField];
    
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
    
    //设置内容大小
    self.backScrollView.contentSize = CGSizeMake(0, self.infomationTableView.bottom);
}

- (void)initWidget
{
    //背景滚动视图
    self.backScrollView    = [[UIScrollView alloc] init];
    
    //背景图
    self.backImageView     = [[CustomImageView alloc] init];
    self.backImageBtn      = [[CustomButton alloc] init];
    //头像
    self.headImageBtn      = [[CustomButton alloc] init];
    //姓名
    self.nameLabel         = [[CustomLabel alloc] init];
    //性别
    self.sexImageView      = [[CustomImageView alloc] init];
    //学校
    self.schoolLabel       = [[CustomLabel alloc] init];
    //我的状态
    self.newsImageBackView = [[CustomButton alloc] init];
    self.newsImageView1    = [[CustomImageView alloc] init];
    self.newsImageView2    = [[CustomImageView alloc] init];
    self.newsImageView3    = [[CustomImageView alloc] init];

    //最近来访
    self.visitBackView     = [[CustomButton alloc] init];
    self.visitCountLabel   = [[CustomLabel alloc] init];
    
    //好友
    self.myFriendsBackView = [[CustomButton alloc] init];
    self.friendCountLabel  = [[CustomLabel alloc] init];

    self.informationLabel  = [[CustomLabel alloc] init];
    
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.backImageBtn];
    [self.backScrollView addSubview:self.nameLabel];
    [self.backScrollView addSubview:self.sexImageView];
    [self.backScrollView addSubview:self.schoolLabel];
    [self.backScrollView addSubview:self.headImageBtn];
    [self.backScrollView addSubview:self.newsImageBackView];
    
    [self.newsImageBackView addSubview:self.newsImageView1];
    [self.newsImageBackView addSubview:self.newsImageView2];
    [self.newsImageBackView addSubview:self.newsImageView3];
    
    [self.backScrollView addSubview:self.visitBackView];
    [self.visitBackView addSubview:self.visitCountLabel];
    
    [self.backScrollView addSubview:self.myFriendsBackView];
    [self.myFriendsBackView addSubview:self.friendCountLabel];
    [self.backScrollView addSubview:self.informationLabel];
    
    //事件
    //点击事件
    [self.headImageBtn addTarget:self action:@selector(headImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageBtn addTarget:self action:@selector(backImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myFriendsBackView addTarget:self action:@selector(myFriendClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.newsImageBackView addTarget:self action:@selector(myNewsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.visitBackView addTarget:self action:@selector(visitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) sself             = self;
    //左上角名片
    [self.navBar setLeftBtnWithContent:@"" andBlock:^{
        MyCardViewController * mcVC = [[MyCardViewController alloc] init];
        [sself pushVC:mcVC];
    }];
    //右上角设置
    [self.navBar setRightBtnWithContent:@"" andBlock:^{
        PersonalSettingViewController * psVC = [[PersonalSettingViewController alloc] init];
        [sself pushVC:psVC];
    }];
}

- (void)configUI
{
    //背景滚动视图
    self.backScrollView.frame                        = CGRectMake(0, 0, self.viewWidth, self.viewHeight-kTabBarHeight);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    
    //顶部栏设置部分
    self.navBar.backgroundColor           = [UIColor clearColor];
    self.navBar.leftBtn.hidden            = NO;
    [self.navBar.leftBtn setImage:nil forState:UIControlStateNormal];
    //名片和设置
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"my_card"] forState:UIControlStateNormal];
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"my_card_selected"] forState:UIControlStateHighlighted];
    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"setting_btn"] forState:UIControlStateNormal];
    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"setting_btn_selected"] forState:UIControlStateHighlighted];
    [self.view bringSubviewToFront:self.navBar];
    
    //头像
    self.headImageBtn.layer.cornerRadius      = 35;
    self.headImageBtn.layer.masksToBounds     = YES;
    self.headImageBtn.layer.borderColor       = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    self.headImageBtn.layer.borderWidth       = 3;

    self.backImageView.contentMode            = UIViewContentModeScaleAspectFill;
    self.backImageView.layer.masksToBounds    = YES;

    //调整Mode
    self.newsImageView1.contentMode  = UIViewContentModeScaleAspectFill;
    self.newsImageView2.contentMode  = UIViewContentModeScaleAspectFill;
    self.newsImageView3.contentMode  = UIViewContentModeScaleAspectFill;
    //mask
    self.newsImageView1.layer.masksToBounds  = YES;
    self.newsImageView2.layer.masksToBounds  = YES;
    self.newsImageView3.layer.masksToBounds  = YES;
    //默认三图片隐藏
    self.newsImageView1.hidden = YES;
    self.newsImageView2.hidden = YES;
    self.newsImageView3.hidden = YES;

    //背景图
    self.backImageView.frame               = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    //用于点击的透明背景
    self.backImageBtn.frame                = CGRectMake(0, 0, self.viewWidth, 200);
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

    //根据型号放大
    CGFloat width                          = self.viewWidth/4.0;
    //我的状态
    self.newsImageBackView.frame           = CGRectMake(0, self.backImageBtn.bottom, self.viewWidth, 40+width);
    self.newsImageBackView.backgroundColor = [UIColor whiteColor];
    //图标
    CustomImageView * newsIconImageView    = [[CustomImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    newsIconImageView.image                = [UIImage imageNamed:@"my_images_icon"];
    [self.newsImageBackView addSubview:newsIconImageView];
    CustomLabel * newsLabel                = [[CustomLabel alloc] initWithFrame:CGRectMake(newsIconImageView.right+5, newsIconImageView.y, 150, 20)];
    newsLabel.font                         = [UIFont systemFontOfSize:FontPersonalTitle];
    newsLabel.textColor                    = [UIColor colorWithHexString:ColorBrown];
    newsLabel.text                         = @"生活小点滴  (●′ω`●)";
    [self.newsImageBackView addSubview:newsLabel];
    //箭头
    CustomImageView * arrowImageView       = [[CustomImageView alloc] initWithFrame:CGRectMake(self.viewWidth-30, 7, 10, 15)];
    arrowImageView.image                   = [UIImage imageNamed:@"right_arrow"];
    [self.newsImageBackView addSubview:arrowImageView];
    //其余
    self.newsImageView1.frame              = CGRectMake(15, newsIconImageView.bottom+10, width, width);
    self.newsImageView2.frame              = CGRectMake(self.newsImageView1.right+10, self.newsImageView1.y, width, width);
    self.newsImageView3.frame              = CGRectMake(self.newsImageView2.right+10, self.newsImageView1.y, width, width);

    //中间分割线
    UIView * lineView                      = [[UIView alloc] initWithFrame:CGRectMake(0, self.newsImageBackView.bottom, self.viewWidth, 10)];
    lineView.backgroundColor               = [UIColor colorWithHexString:ColorLightWhite];
    [self.backScrollView addSubview:lineView];

    //最近来访部分
    self.visitBackView.frame               = CGRectMake(0, lineView.bottom, self.viewWidth/2, 90);
    self.visitBackView.backgroundColor     = [UIColor colorWithHexString:ColorWhite];

    //最近来访底部
    CGFloat strWidth                       = [ToolsManager getSizeWithContent:@"谁来看过我" andFontSize:FontPersonalTitle andFrame:CGRectMake(0, 0, 200, 0)].width;
    //位置计算
    CGFloat positionX                      = (self.visitBackView.width-strWidth-5-20)/2;
    CustomImageView * visitIconImageView   = [[CustomImageView alloc] initWithFrame:CGRectMake(positionX, self.visitBackView.height-30, 20, 17)];
    visitIconImageView.image               = [UIImage imageNamed:@"my_visit_icon"];
    CustomLabel * visitLabel               = [[CustomLabel alloc] initWithFrame:CGRectMake(visitIconImageView.right+5, visitIconImageView.y, 170, 20)];
    visitLabel.text                        = @"谁来看过我";
    visitLabel.font                        = [UIFont systemFontOfSize:FontPersonalTitle];
    visitLabel.textColor                   = [UIColor colorWithHexString:ColorBrown];
    [self.visitBackView addSubview:visitIconImageView];
    [self.visitBackView addSubview:visitLabel];

    //中间分割竖线
    UIView * verticalLineView              = [[UIView alloc] initWithFrame:CGRectMake(self.viewWidth/2, lineView.bottom+5, 1, 80)];
    verticalLineView.backgroundColor       = [UIColor colorWithHexString:ColorLightWhite];
    [self.backScrollView addSubview:verticalLineView];

    //好友部分
    self.myFriendsBackView.frame           = CGRectMake(self.viewWidth/2, lineView.bottom, self.viewWidth/2, 90);
    self.myFriendsBackView.backgroundColor = [UIColor whiteColor];
    CustomImageView * myFriendImageView    = [[CustomImageView alloc] initWithFrame:CGRectMake(positionX, self.myFriendsBackView.height-30, 20, 17)];
    myFriendImageView.image                = [UIImage imageNamed:@"my_friends_icon"];
    CustomLabel * myFriendLabel            = [[CustomLabel alloc] initWithFrame:CGRectMake(myFriendImageView.right+5, myFriendImageView.y, 170, 20)];
    myFriendLabel.text                     = @"我的朋友们";
    myFriendLabel.font                     = [UIFont systemFontOfSize:FontPersonalTitle];
    myFriendLabel.textColor                = [UIColor colorWithHexString:ColorBrown];
    [self.myFriendsBackView addSubview:myFriendImageView];
    [self.myFriendsBackView addSubview:myFriendLabel];

    //来访数
    self.visitCountLabel.frame             = CGRectMake(0, 20, self.viewWidth/2, 30);
    self.visitCountLabel.font              = [UIFont systemFontOfSize:25];
    self.visitCountLabel.textColor         = [UIColor colorWithHexString:ColorBrown];
    self.visitCountLabel.textAlignment     = NSTextAlignmentCenter;
    //好友数
    self.friendCountLabel.frame            = CGRectMake(0, 20, self.viewWidth/2, 30);
    self.friendCountLabel.font             = [UIFont systemFontOfSize:25];
    self.friendCountLabel.textColor        = [UIColor colorWithHexString:ColorBrown];
    self.friendCountLabel.textAlignment     = NSTextAlignmentCenter;
    
    //我的信息
    self.informationLabel.frame            = CGRectMake(0, self.myFriendsBackView.bottom, self.viewWidth, 30);
    self.informationLabel.backgroundColor  = [UIColor colorWithHexString:ColorLightWhite];
    self.informationLabel.textColor        = [UIColor colorWithHexString:ColorCharGary];
    self.informationLabel.font             = [UIFont systemFontOfSize:12];
    self.informationLabel.text             = @"   我的资料";
}

- (void)refreshUI
{
    //头像
    NSURL * headUrl         = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.head_image]];
    [self.headImageBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    //背景
    NSURL * backUrl         = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.background_image]];
    [self.backImageView sd_setImageWithURL:backUrl placeholderImage:[UIImage imageNamed:@"default_back_image"]];
    //姓名
    self.nameLabel.text     = [UserService sharedService].user.name;
    CGSize size             = [ToolsManager getSizeWithContent:[UserService sharedService].user.name andFontSize:FontInformation andFrame:CGRectMake(0, 0, 300, 20)];
    //重新布局
    self.nameLabel.frame    = CGRectMake(kCenterOriginX(size.width)-10, self.headImageBtn.bottom+5, size.width, 20);
    self.sexImageView.frame = CGRectMake(self.nameLabel.right+5, self.headImageBtn.bottom+8, 15, 15);
    //性别
    if ([UserService sharedService].user.sex == SexBoy) {
        self.sexImageView.image = [UIImage imageNamed:@"sex_boy"];
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"sex_girl"];
    }
    self.schoolLabel.text = [UserService sharedService].user.school;
//    NSArray * friendArr = [IMGroupModel findHasAddAll];
//    NSArray * friends = @[self.myFriendsImage1, self.myFriendsImage2, self.myFriendsImage3];
//    //最多三张
//    NSInteger num = 0;
//    if (friendArr.count > 3) {
//        num = 3;
//    }
//    //遍历设置图片
//    for (int i=0; i<num; i++) {
//        IMGroupModel * group        = friendArr[i];
//        CustomImageView * imageView = friends[i];
//        NSURL * url                 = [NSURL URLWithString:[kAttachmentAddr stringByAppendingString:group.avatarPath]];
//        [imageView sd_setImageWithURL:url];
//        imageView.hidden = NO;
//    }
//    
//    //设置数量
//    if (friendArr.count > 0) {
//        self.friendCountLabel.text = [NSString stringWithFormat:@"%ld", friendArr.count];
//    }else{
//        self.friendCountLabel.text = @"";
//    }
    
    //状态更新
    [self getNewsImages];
    [self getVisitImages];
    [self getFriendImages];
}

#pragma mark- ZHPickViewDelegate
//保存城市
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    debugLog(@"%@", resultString);
    CustomLabel * contentLabel = [self getCellContentLabelWith:ContentCity];
    contentLabel.text          = [resultString stringByReplacingOccurrencesOfString:@"," withString:@""];
    [self updateDataInformationWithField:@"city" andValue:resultString];
    [self.cityTextField resignFirstResponder];
}
-(void)toobarCancelBtnHaveClick:(ZHPickView *)pickView
{
    [self.cityTextField resignFirstResponder];
}

#pragma mark- UITableViewDelegate
#define ContentTag 100
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.informationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell     = [tableView dequeueReusableCellWithIdentifier:@"personalCell"];
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

    //右边的箭头
    CustomImageView * arrowImageView       = [[CustomImageView alloc] initWithFrame:CGRectMake(self.viewWidth-30, 15, 10, 15)];
    arrowImageView.image                   = [UIImage imageNamed:@"right_arrow"];
    [cell.contentView addSubview:arrowImageView];
    
    //底部线
    UIView * lineView          = [[UIView alloc] initWithFrame:CGRectMake(10, 44, self.viewWidth, 1)];
    lineView.backgroundColor   = [UIColor colorWithHexString:ColorLightGary];
    [cell.contentView addSubview:lineView];

    NSString * content         = @"未填";
    UserModel * user           = [UserService sharedService].user;
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
        NSString * sign                 = [UserService sharedService].user.sign;
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
    CustomLabel * contentLabel = [self getCellContentLabelWith:indexPath.row];
    
    //点击
    UserModel * user = [UserService sharedService].user;
    //内容
    switch (indexPath.row) {
        case ContentName:
            {
                //姓名
                InformationChangeViewController * icvc = [[InformationChangeViewController alloc] init];
                icvc.changeType = ContentName;
                icvc.content    = user.name;
                [icvc setChangeBlock:^(NSString *content) {
                    [self updateDataInformationWithField:@"name" andValue:content];
                    contentLabel.text = @"";
                    contentLabel.text = content;
                    self.nameLabel.text = content;
                }];
                [self pushVC:icvc];
            }
            break;
        case ContentSign:
            {
                //签名
                InformationChangeViewController * icvc = [[InformationChangeViewController alloc] init];
                icvc.changeType = ContentSign;
                icvc.content    = user.sign;
                [icvc setChangeBlock:^(NSString *content) {
                    contentLabel.text = @"";                    
                    contentLabel.text = content;
                    [self updateDataInformationWithField:@"sign" andValue:content];
                }];
                [self pushVC:icvc];
            }
            break;
        case ContentBirthday:
            {
                [self.dateTextField becomeFirstResponder];
            }
            
            break;
        case ContentSex:
            {
                UIAlertView * sexAlertView = [[UIAlertView alloc] initWithTitle:@"性别" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"男孩纸",@"女孩纸",@"取消", nil];
                [sexAlertView show];
            }
            
            break;
        case ContentSchool:
            {
                ChoiceSchoolViewController * csvc = [[ChoiceSchoolViewController alloc] init];
                csvc.notRegister = YES;
                [csvc setChoickBlock:^(NSString *school) {
                    contentLabel.text     = school;
                    self.schoolLabel.text = school;
                }];
                [self pushVC:csvc];
            }
            
            break;
        case ContentCity:
            {
                
                [self.cityTextField becomeFirstResponder];

            }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    CustomLabel * contentLabel = [self getCellContentLabelWith:ContentSex];
    
    NSString * sexStr = @"0";
    if (buttonIndex == SexBoy) {
        contentLabel.text = @"男孩纸";
        self.sexImageView.image = [UIImage imageNamed:@"sex_boy"];
        sexStr = @"0";
    }
    if (buttonIndex == SexGirl) {
        contentLabel.text = @"女孩纸";
        self.sexImageView.image = [UIImage imageNamed:@"sex_girl"];
        sexStr = @"1";
    }
    
    [self updateDataInformationWithField:@"sex" andValue:sexStr];
}


#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //当前图片
    self.currentImageStyle = actionSheet.tag;
    //选照片
    if (buttonIndex != 2) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        //如果是头像 则裁剪
        if (self.currentImageStyle == HeadImage) {
            picker.allowsEditing = YES;
        }
        if (buttonIndex == 0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }
        if (buttonIndex == 1) {
            
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [ImageHelper getBigImage:info[UIImagePickerControllerEditedImage]];
    if (self.currentImageStyle == HeadImage) {
        image = [ImageHelper getBigImage:info[UIImagePickerControllerEditedImage]];
    }else{
        image = [ImageHelper getBigImage:info[UIImagePickerControllerOriginalImage]];
    }
    
    [self imageUploadWithImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- method response
//背景图
- (void)backImageClick:(id)sender {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"背景图" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    sheet.tag = BackgroundImage;
    [sheet showInView:self.view];
    [self.dateTextField resignFirstResponder];
}

//头像
- (void)headImageClick:(id)sender {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"头像" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    sheet.tag = HeadImage;
    [sheet showInView:self.view];
    [self.dateTextField resignFirstResponder];
}

//姓名
- (void)nameClick:(id)sender {
    [self.dateTextField resignFirstResponder];
}
//我的状态
- (void)myNewsClick:(id)sender {

    MyNewsListViewController * mnlvc = [[MyNewsListViewController alloc] init];
    [self pushVC:mnlvc];
    
    [self.dateTextField resignFirstResponder];
}
//最近来访
- (void)visitClick:(id)sender {
    
    VisitListViewController * vlvc = [[VisitListViewController alloc] init];
    vlvc.uid                       = [UserService sharedService].user.uid;
    [self pushVC:vlvc];
    
}
//好友列表
- (void)myFriendClick:(id)sender {
    
    MyFriendsListViewController * flVC = [[MyFriendsListViewController alloc] init];
    [self pushVC:flVC];
    
}

//保存生日
- (void)saveBirthClick:(id)sender
{
    CustomLabel * contentLabel = [self getCellContentLabelWith:ContentBirthday];
    contentLabel.text = [ToolsManager StringFromDate:self.datePicker.date andFormatter:@"yyyy-MM-dd"];
    [self updateDataInformationWithField:@"birthday" andValue:contentLabel.text];
    [self.dateTextField resignFirstResponder];
}

//取消
- (void)cancelBirthClick:(id)sender
{
    [self.dateTextField resignFirstResponder];
}
#pragma mark- private method
- (void)imageUploadWithImage:(UIImage *)image
{
    NSString * field = @"";
    NSInteger nowStyle = self.currentImageStyle;
    
    if (self.currentImageStyle == HeadImage) {
        field = @"head_image";
    }else{
        field = @"background_image";
    }
    
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"field":field};
    NSString * fileName;
    NSArray * files;
    
    //头像处理或者背景
    if (image != nil) {
        fileName = [ToolsManager getUploadImageName];
        files = @[@{FileDataKey:UIImageJPEGRepresentation(image,0.9),FileNameKey:fileName}];
    }
    
    debugLog(@"%@ %@", kChangeInformationImagePath, params);
    [self showLoading:nil];
    [HttpService postFileWithUrlString:kChangeInformationImagePath params:params files:files andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
//        debugLog(@"%@", responseData);
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            NSString * path = responseData[@"result"][@"image"];
            [self hideLoading];
            
            if (nowStyle == HeadImage) {
                [UserService sharedService].user.head_image     = path;
                [UserService sharedService].user.head_sub_image = responseData[@"result"][@"head_sub_image"];
                //缓存头像
                [UIImageJPEGRepresentation(image, 0.9) cacheImageWithUrl:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.head_image]];
                //设置图片
                [self.headImageBtn setBackgroundImage:image forState:UIControlStateNormal];
            }else{
                [UserService sharedService].user.background_image = path;
                //缓存背景
                [UIImageJPEGRepresentation(image, 0.9) cacheImageWithUrl:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.background_image]];
                
                //设置图片
                self.backImageView.image = image;
            }
            
            //数据缓存
            [[UserService sharedService] saveAndUpdate];
            
        }else{
            
            [self showWarn:responseData[@"msg"]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}

- (CustomLabel *)getCellContentLabelWith:(NSInteger)index
{
    UITableViewCell *cell = [self.infomationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    CustomLabel * contentLabel = (CustomLabel *)[cell.contentView viewWithTag:ContentTag];
    
    return contentLabel;
}

//上传用户信息
- (void)updateDataInformationWithField:(NSString *)field andValue:(NSString *)value
{
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"field":field,
                              @"value":value};

    debugLog(@"%@ %@", kChangePersonalInformationPath, params);
    [HttpService postWithUrlString:kChangePersonalInformationPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
        }
        
        [[UserService sharedService].user setValue:value forKey:field];
        //数据缓存
        [[UserService sharedService] saveAndUpdate];
        [self.infomationTableView reloadData];
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取三张最新状态的图片
- (void)getNewsImages
{
    //kGetNewsImagesPath
    NSString * path = [kGetNewsImagesPath stringByAppendingFormat:@"?uid=%ld", [UserService sharedService].user.uid];
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            NSArray * imageList = responseData[HttpResult][HttpList];
            NSArray * images = @[self.newsImageView1, self.newsImageView2, self.newsImageView3];
            
            //遍历设置图片
            for (int i=0; i<imageList.count; i++) {
                NSDictionary * dic = imageList[i];
                CustomImageView * imageView = images[i];
                NSURL * url = [NSURL URLWithString:[kAttachmentAddr stringByAppendingString:dic[@"sub_url"]]];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
                imageView.hidden = NO;
            }
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取来访人数 不在获取图片
- (void)getVisitImages
{
    //kGetNewsImagesPath
    NSString * path = [kGetVisitImagesPath stringByAppendingFormat:@"?uid=%ld", [UserService sharedService].user.uid];
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            NSInteger visitCount = [responseData[HttpResult][@"visit_count"] integerValue];
            //设置数量
            if (visitCount > 0) {
                self.visitCountLabel.text = [NSString stringWithFormat:@"%ld人", visitCount];
            }else{
                self.visitCountLabel.text = @"0人";
            }
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取好友人数
- (void)getFriendImages
{
    //kGetNewsImagesPath
    NSString * path = [kGetFriendsImagePath stringByAppendingFormat:@"?user_id=%ld", [UserService sharedService].user.uid];
    debugLog(@"%@", path);
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            NSInteger visitCount = [responseData[HttpResult][@"friend_count"] integerValue];
            //设置数量
            if (visitCount > 0) {
                self.friendCountLabel.text = [NSString stringWithFormat:@"%ld人", visitCount];
            }else{
                self.friendCountLabel.text = @"0人";
            }
        }else{
            if (self.friendCountLabel.text.length < 1) {
                self.friendCountLabel.text = @"0人";
            }
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.dateTextField resignFirstResponder];
}

@end
