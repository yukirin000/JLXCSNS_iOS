//
//  PersonalViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/20.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "PersonalViewController.h"
#import "IMGroupModel.h"
#import "VisitListViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "InformationChangeViewController.h"
#import "ZHPickView.h"
#import "ChoiceSchoolViewController.h"
#import "MyNewsListViewController.h"
#import "ImageFilterViewController.h"
#import "MyCardViewController.h"
#import "FriendsListViewController.h"
#import "PersonalSettingViewController.h"
#import <TuSDK/TuSDK.h>
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

@interface PersonalViewController ()<ZHPickViewDelegate, TuSDKPFEditFilterControllerDelegate, TuSDKCPComponentErrorDelegate>

//背景滚动视图
@property (strong, nonatomic) UIScrollView * backScrollView;

//背景图
@property (strong, nonatomic) CustomImageView *backImageView;
//背景透明的按钮
@property (strong, nonatomic) CustomButton *backImageBtn;
//头像
@property (strong, nonatomic) CustomButton *headImageBtn;
//姓名
@property (strong, nonatomic) CustomButton *nameBtn;

//个人资料label
@property (strong, nonatomic) UILabel * informationLabel;

//我的状态背景按钮
@property (strong, nonatomic) CustomButton *newsImageBackView;
//新闻imageView1
@property (strong, nonatomic) UIImageView *newsImageView1;
//新闻imageView2
@property (strong, nonatomic) UIImageView *newsImageView2;
//新闻imageView3
@property (strong, nonatomic) UIImageView *newsImageView3;

//最近来访背景点击
@property (strong, nonatomic) UIButton *visitBackView;
//最近来访头像1
@property (strong, nonatomic) CustomImageView *visitHeadImage1;
//最近来访头像2
@property (strong, nonatomic) CustomImageView *visitHeadImage2;
//最近来访头像3
@property (strong, nonatomic) CustomImageView *visitHeadImage3;
//好友数量label
@property (nonatomic, strong) CustomLabel * visitCountLabel;

//我的好友点击背景按钮
@property (strong, nonatomic) UIButton *myFriendsBackView;
//我的好友头像1
@property (strong, nonatomic) CustomImageView *myFriendsImage1;
//我的好友头像2
@property (strong, nonatomic) CustomImageView *myFriendsImage2;
//我的好友头像3
@property (strong, nonatomic) CustomImageView *myFriendsImage3;
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
    [saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake(self.viewWidth-60, 10, 40, 20);
    [saveBtn addTarget:self action:@selector(saveBirthClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:StringCommonSave forState:UIControlStateNormal];
    [accessoryView addSubview:saveBtn];
    
    //取消按钮
    CustomButton * cancelBtn = [[CustomButton alloc] initWithFontSize:15];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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
    
    self.infomationTableView                              = [[UITableView alloc] initWithFrame:CGRectMake(0, self.informationLabel.bottom, self.viewWidth, 181) style:UITableViewStylePlain];
    self.infomationTableView.scrollEnabled                = NO;
//    self.infomationTableView.bounces    = NO;
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
    self.nameBtn           = [[CustomButton alloc] init];
    
    //我的状态
    self.newsImageBackView = [[CustomButton alloc] init];
    self.newsImageView1    = [[CustomImageView alloc] init];
    self.newsImageView2    = [[CustomImageView alloc] init];
    self.newsImageView3    = [[CustomImageView alloc] init];

    //最近来访
    self.visitBackView     = [[CustomButton alloc] init];
    self.visitHeadImage1   = [[CustomImageView alloc] init];
    self.visitHeadImage2   = [[CustomImageView alloc] init];
    self.visitHeadImage3   = [[CustomImageView alloc] init];
    self.visitCountLabel   = [[CustomLabel alloc] initWithFontSize:15];
    
    //好友
    self.myFriendsBackView = [[CustomButton alloc] init];
    self.myFriendsImage1   = [[CustomImageView alloc] init];
    self.myFriendsImage2   = [[CustomImageView alloc] init];
    self.myFriendsImage3   = [[CustomImageView alloc] init];
    self.friendCountLabel  = [[CustomLabel alloc] initWithFontSize:15];

    self.informationLabel  = [[CustomLabel alloc] initWithFontSize:15];
    
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.backImageBtn];
    [self.backScrollView addSubview:self.nameBtn];
    [self.backScrollView addSubview:self.headImageBtn];
    [self.backScrollView addSubview:self.newsImageBackView];
    
    [self.newsImageBackView addSubview:self.newsImageView1];
    [self.newsImageBackView addSubview:self.newsImageView2];
    [self.newsImageBackView addSubview:self.newsImageView3];
    
    [self.backScrollView addSubview:self.visitBackView];
    [self.visitBackView addSubview:self.visitHeadImage1];
    [self.visitBackView addSubview:self.visitHeadImage2];
    [self.visitBackView addSubview:self.visitHeadImage3];
    [self.visitBackView addSubview:self.visitCountLabel];
    
    [self.backScrollView addSubview:self.myFriendsBackView];
    [self.myFriendsBackView addSubview:self.myFriendsImage1];
    [self.myFriendsBackView addSubview:self.myFriendsImage2];
    [self.myFriendsBackView addSubview:self.myFriendsImage3];
    [self.myFriendsBackView addSubview:self.friendCountLabel];
    [self.backScrollView addSubview:self.informationLabel];
    
    //事件
    //点击事件
    [self.backImageBtn addTarget:self action:@selector(backImageClick:) forControlEvents:UIControlEventTouchUpInside];
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
    __weak typeof(self) sself             = self;
    //左上角名片
    [self.navBar setLeftBtnWithContent:@"名片" andBlock:^{
        MyCardViewController * mcVC = [[MyCardViewController alloc] init];
        [sself pushViewController:mcVC animated:YES];
    }];
    [self.navBar.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.navBar.leftBtn setImage:nil forState:UIControlStateHighlighted];
    //右上角设置
    [self.navBar setRightBtnWithContent:@"设置" andBlock:^{
        PersonalSettingViewController * psVC = [[PersonalSettingViewController alloc] init];
        [sself pushVC:psVC];
    }];
    [self.view bringSubviewToFront:self.navBar];
    
    //姓名
    self.nameBtn.enabled                      = NO;
    //头像
    self.headImageBtn.layer.cornerRadius      = 30;
    self.headImageBtn.layer.masksToBounds     = YES;

    self.backImageView.contentMode            = UIViewContentModeScaleAspectFill;
    self.backImageView.layer.masksToBounds    = YES;
    //背景
    self.backImageView.userInteractionEnabled = YES;

    //调整Mode
    self.newsImageView1.contentMode  = UIViewContentModeScaleAspectFill;
    self.newsImageView2.contentMode  = UIViewContentModeScaleAspectFill;
    self.newsImageView3.contentMode  = UIViewContentModeScaleAspectFill;

    self.visitHeadImage1.contentMode = UIViewContentModeScaleAspectFill;
    self.visitHeadImage2.contentMode = UIViewContentModeScaleAspectFill;
    self.visitHeadImage3.contentMode = UIViewContentModeScaleAspectFill;

    self.myFriendsImage1.contentMode = UIViewContentModeScaleAspectFill;
    self.myFriendsImage2.contentMode = UIViewContentModeScaleAspectFill;
    self.myFriendsImage3.contentMode = UIViewContentModeScaleAspectFill;
    //mask
    self.newsImageView1.layer.masksToBounds  = YES;
    self.newsImageView2.layer.masksToBounds  = YES;
    self.newsImageView3.layer.masksToBounds  = YES;
    
    self.visitHeadImage1.layer.masksToBounds = YES;
    self.visitHeadImage2.layer.masksToBounds = YES;
    self.visitHeadImage3.layer.masksToBounds = YES;
    
    self.myFriendsImage1.layer.masksToBounds = YES;
    self.myFriendsImage2.layer.masksToBounds = YES;
    self.myFriendsImage3.layer.masksToBounds = YES;
    //默认三图片隐藏
    self.newsImageView1.hidden = YES;
    self.newsImageView2.hidden = YES;
    self.newsImageView3.hidden = YES;
    
    self.visitHeadImage1.hidden = YES;
    self.visitHeadImage2.hidden = YES;
    self.visitHeadImage3.hidden = YES;
    
    self.myFriendsImage1.hidden = YES;
    self.myFriendsImage2.hidden = YES;
    self.myFriendsImage3.hidden = YES;

    //背景图
    self.backImageView.frame               = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    //用于点击的透明背景
    self.backImageBtn.frame                = CGRectMake(0, 0, self.viewWidth, 200);
    
    self.headImageBtn.frame                = CGRectMake(35, 110, 60, 60);
    [self.headImageBtn addTarget:self action:@selector(headImageClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nameBtn.frame                     = CGRectMake(113, 131, 60, 30);
    
    //我的状态
    self.newsImageBackView.frame           = CGRectMake(0, self.backImageBtn.bottom, self.viewWidth, 65);
    self.newsImageBackView.backgroundColor = [UIColor greenColor];
    [self.newsImageBackView addTarget:self action:@selector(myNewsClick:) forControlEvents:UIControlEventTouchUpInside];
    CustomLabel * newsLabel                = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 23, 70, 20)];
    newsLabel.text                         = @"我的相片";
    [self.newsImageBackView addSubview:newsLabel];
    self.newsImageView1.frame              = CGRectMake(newsLabel.right+10, 5, 55, 55);
    self.newsImageView2.frame              = CGRectMake(self.newsImageView1.right+10, 5, 55, 55);
    self.newsImageView3.frame              = CGRectMake(self.newsImageView2.right+10, 5, 55, 55);

    //最近来访部分
    self.visitBackView.frame               = CGRectMake(0, self.newsImageBackView.bottom, self.viewWidth, 65);
    self.visitBackView.backgroundColor     = [UIColor yellowColor];
    [self.visitBackView addTarget:self action:@selector(visitClick:) forControlEvents:UIControlEventTouchUpInside];
    CustomLabel * visitLabel               = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 23, 70, 20)];
    visitLabel.text                        = @"最近来访";
    [self.visitBackView addSubview:visitLabel];
    self.visitHeadImage1.frame             = CGRectMake(visitLabel.right+10, 5, 55, 55);
    self.visitHeadImage2.frame             = CGRectMake(self.visitHeadImage1.right+10, 5, 55, 55);
    self.visitHeadImage3.frame             = CGRectMake(self.visitHeadImage2.right+10, 5, 55, 55);
    self.visitCountLabel.frame             = CGRectMake(self.visitHeadImage3.right+10, self.visitHeadImage3.y, 30, 30);
    
    //好友部分
    self.myFriendsBackView.frame           = CGRectMake(0, self.visitBackView.bottom, self.viewWidth, 65);
    self.myFriendsBackView.backgroundColor = [UIColor redColor];
    [self.myFriendsBackView addTarget:self action:@selector(myFriendClick:) forControlEvents:UIControlEventTouchUpInside];
    CustomLabel * myFriendLabel            = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 23, 70, 20)];
    myFriendLabel.text                     = @"我的好友";
    [self.myFriendsBackView addSubview:myFriendLabel];
    self.myFriendsImage1.frame             = CGRectMake(myFriendLabel.right+10, 5, 55, 55);
    self.myFriendsImage2.frame             = CGRectMake(self.myFriendsImage1.right+10, 5, 55, 55);
    self.myFriendsImage3.frame             = CGRectMake(self.myFriendsImage2.right+10, 5, 55, 55);
    self.friendCountLabel.frame            = CGRectMake(self.myFriendsImage3.right+10, self.myFriendsImage3.y, 30, 30);
    
    //我的信息
    self.informationLabel.frame            = CGRectMake(0, self.myFriendsBackView.bottom, self.viewWidth, 20);
    self.informationLabel.backgroundColor  = [UIColor blueColor];
    self.informationLabel.text             = @"   个人信息";
    
}

- (void)refreshUI
{
    //头像
    NSURL * headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.head_image]];
    [self.headImageBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DEFAULT_AVATAR]];
    //背景
    NSURL * backUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.background_image]];
    [self.backImageView sd_setImageWithURL:backUrl placeholderImage:[UIImage imageNamed:@"default_back_image"]];
    [self.nameBtn setTitle:[UserService sharedService].user.name forState:UIControlStateNormal];
    
    NSArray * friendArr = [IMGroupModel findHasAddAll];
    NSArray * friends = @[self.myFriendsImage1, self.myFriendsImage2, self.myFriendsImage3];
    //最多三张
    NSInteger num = 0;
    if (friendArr.count > 3) {
        num = 3;
    }
    //遍历设置图片
    for (int i=0; i<num; i++) {
        IMGroupModel * group        = friendArr[i];
        CustomImageView * imageView = friends[i];
        NSURL * url                 = [NSURL URLWithString:[kAttachmentAddr stringByAppendingString:group.avatarPath]];
        [imageView sd_setImageWithURL:url];
        imageView.hidden = NO;
    }
    
    //设置数量
    if (friendArr.count > 0) {
        self.friendCountLabel.text = [NSString stringWithFormat:@"%ld", friendArr.count];
    }else{
        self.friendCountLabel.text = @"";
    }
    
    //获取当前最近的三张状态图片
    [self getNewsImages];
//    [self getVisitImages];
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
    UserModel * user = [UserService sharedService].user;
    //内容
    switch (indexPath.row) {
        case ContentName:
            content = user.name;
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
                    [self.nameBtn setTitle:content forState:UIControlStateNormal];
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
                [csvc setChoickBlock:^(NSString *city) {
                    contentLabel.text = city;
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
        sexStr = @"0";
    }
    if (buttonIndex == SexGirl) {
        contentLabel.text = @"女孩纸";
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

#pragma mark- TuSDKPFEditFilterControllerDelegate
//图片渲染结束
- (void)onTuSDKPFEditFilter:(TuSDKPFEditFilterController *)controller result:(TuSDKResult *)result
{
    UIImage * image = [ImageHelper getBigImage:result.image];
    [self imageUploadWithImage:image];
}

- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error;
{
    lsqLDebug(@"onComponent: controller - %@, result - %@, error - %@", controller, result, error);
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
    
    ImageFilterViewController * ifVC = [[ImageFilterViewController alloc] init];
    ifVC.delegate                    = self;
    ifVC.inputImage                  = image;
    [picker dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:ifVC animated:YES completion:nil];
    }];
//    [self imageUploadWithImage:image];
//    [picker dismissViewControllerAnimated:YES completion:nil];
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
    
    FriendsListViewController * flVC = [[FriendsListViewController alloc] init];
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
//        files = @[@{FileDataKey:UIImagePNGRepresentation(image),FileNameKey:fileName}];
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
                [UserService sharedService].user.head_sub_image = responseData[@"result"][@"head_sub_image"];;
                NSURL * headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.head_image]];
                debugLog(@"%@", headUrl.absoluteString);
                //缓存头像
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:headUrl];
                //设置图片
                [self.headImageBtn setBackgroundImage:image forState:UIControlStateNormal];
            }else{
                [UserService sharedService].user.background_image = path;
                NSURL * backUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.background_image]];
                debugLog(@"%@", backUrl.absoluteString);
                //缓存头像
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:backUrl];
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
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取三张最新状态的图片
- (void)getNewsImages
{
    //kGetNewsImagesPath
    NSString * path = [kGetNewsImagesPath stringByAppendingFormat:@"?uid=%ld", [UserService sharedService].user.uid];
    debugLog(@"%@", path);
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
                [imageView sd_setImageWithURL:url];
                imageView.hidden = NO;
            }
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取三张最近来访的头像
- (void)getVisitImages
{
    //kGetNewsImagesPath
    NSString * path = [kGetVisitImagesPath stringByAppendingFormat:@"?uid=%ld", [UserService sharedService].user.uid];
    debugLog(@"%@", path);
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            NSArray * imageList    = responseData[HttpResult][HttpList];
            NSInteger visitCount = [responseData[HttpResult][@"visit_count"] integerValue];
            NSArray * images       = @[self.visitHeadImage1, self.visitHeadImage2, self.visitHeadImage3];
            
            //设置数量
            if (visitCount > 0) {
                self.visitCountLabel.text = [NSString stringWithFormat:@"%ld", visitCount];
            }else{
                self.visitCountLabel.text = @"";
            }
            
            //遍历设置图片
            for (int i=0; i<imageList.count; i++) {
                NSDictionary * dic = imageList[i];
                CustomImageView * imageView = images[i];
                NSURL * url = [NSURL URLWithString:[kAttachmentAddr stringByAppendingString:dic[@"head_sub_image"]]];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"testimage"]];
                imageView.hidden = NO;
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
