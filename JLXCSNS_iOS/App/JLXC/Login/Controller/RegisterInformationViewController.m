//
//  RegisterInformationViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/13.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RegisterInformationViewController.h"
#import "UIImageView+WebCache.h"
#import "CusTabBarViewController.h"
#import "NSData+ImageCache.h"
@interface RegisterInformationViewController ()
//0男 1女
@property (nonatomic, assign) int sex;

//头像
@property (nonatomic, strong) CustomButton * imageBtn;
//男孩
@property (nonatomic, strong) CustomButton * boyBtn;
//女孩
@property (nonatomic, strong) CustomButton * girlBtn;
//昵称
@property (nonatomic, strong) UITextField *nameTextField;
//完成
@property (nonatomic, strong) CustomButton * finishBtn;


@end

@implementation RegisterInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initWidget];
    [self configUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)initWidget
{
    self.imageBtn               = [[CustomButton alloc] init];
    self.girlBtn                = [[CustomButton alloc] init];
    self.boyBtn                 = [[CustomButton alloc] init];
    self.finishBtn              = [[CustomButton alloc] init];
    self.nameTextField          = [[UITextField alloc] init];
    
    self.nameTextField.delegate = self;
    
    [self.view addSubview:self.imageBtn];
    [self.view addSubview:self.girlBtn];
    [self.view addSubview:self.boyBtn];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.finishBtn];
    
    [self.imageBtn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.girlBtn  addTarget:self action:@selector(girlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.boyBtn  addTarget:self action:@selector(boyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishBtn  addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configUI
{
    [self setNavBarTitle:@"填写个人信息~"];
    self.view.backgroundColor          = [UIColor colorWithHexString:ColorLightWhite];
    self.sex                           = SexBoy;

    self.imageBtn.frame                = CGRectMake(kCenterOriginX(100), kNavBarAndStatusHeight+50, 100, 100);
    self.imageBtn.contentMode          = UIViewContentModeScaleAspectFill;
    self.imageBtn.layer.cornerRadius   = 50;
    self.imageBtn.layer.masksToBounds  = YES;
    [self.imageBtn setImage:[UIImage imageNamed:@"default_head_image_btn"] forState:UIControlStateNormal];
    //提示label
    CustomLabel * promptLabel          = [[CustomLabel alloc] initWithFrame:CGRectMake(0, self.imageBtn.bottom+5, self.viewWidth, 20)];
    promptLabel.textAlignment          = NSTextAlignmentCenter;
    promptLabel.text                   = @"选个颜值爆表的头像吧~";
    promptLabel.font                   = [UIFont systemFontOfSize:14];
    promptLabel.textColor              = [UIColor colorWithHexString:ColorDeepGary];
    [self.view addSubview:promptLabel];

    //性别
    self.boyBtn.frame                  = CGRectMake((self.viewWidth/2-80)/2, self.imageBtn.bottom+40, 80, 72);
    [self.boyBtn setBackgroundImage:[UIImage imageNamed:@"register_sex_boy_selected"] forState:UIControlStateNormal];

    self.girlBtn.frame                 = CGRectMake(self.viewWidth/2+self.boyBtn.x, self.imageBtn.bottom+40, 80, 72);
    [self.girlBtn setBackgroundImage:[UIImage imageNamed:@"register_sex_girl_normal"] forState:UIControlStateNormal];


    self.nameTextField.frame           = CGRectMake(kCenterOriginX((self.girlBtn.right - self.boyBtn.x)), self.girlBtn.bottom+30, self.girlBtn.right - self.boyBtn.x, 30);
    self.nameTextField.placeholder     = @"来个爆炸的昵称吧~";
    self.nameTextField.font            = [UIFont systemFontOfSize:15];
    self.nameTextField.textColor       = [UIColor colorWithHexString:ColorDeepBlack];
    self.nameTextField.backgroundColor = [UIColor colorWithHexString:ColorWhite];
    self.nameTextField.leftViewMode    = UITextFieldViewModeAlways;
    UIView * leftSpace                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    self.nameTextField.leftView        = leftSpace;

    //btn样式处理
    self.finishBtn.frame               = CGRectMake(self.nameTextField.x, self.nameTextField.bottom+30, self.nameTextField.width, 38);
    self.finishBtn.layer.cornerRadius  = 3;
    [self.finishBtn setTitleColor:[UIColor colorWithHexString:ColorBrown] forState:UIControlStateNormal];
    self.finishBtn.fontSize            = FontLoginButton;
    self.finishBtn.backgroundColor     = [UIColor colorWithHexString:ColorYellow];
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [ImageHelper getBigImage:info[UIImagePickerControllerEditedImage]];
    [self.imageBtn setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Action Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //选照片
    if (buttonIndex != 2) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
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

#pragma mark- method response
- (void)imageClick:(id)sender {
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"头像" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [sheet showInView:self.view];
    
}

- (void)boyClick:(id)sender {
    if (self.sex == SexGirl) {
        
        [self.boyBtn setBackgroundImage:[UIImage imageNamed:@"register_sex_boy_selected"] forState:UIControlStateNormal];
        [self.girlBtn setBackgroundImage:[UIImage imageNamed:@"register_sex_girl_normal"] forState:UIControlStateNormal];
        self.sex = SexBoy;
    }
}

- (void)girlClick:(id)sender {
    if (self.sex == SexBoy) {
        [self.boyBtn setBackgroundImage:[UIImage imageNamed:@"register_sex_boy_normal"] forState:UIControlStateNormal];
        [self.girlBtn setBackgroundImage:[UIImage imageNamed:@"register_sex_girl_selected"] forState:UIControlStateNormal];
        self.sex = SexGirl;
    }
}

- (void)finishClick:(id)sender {
    

    if (self.nameTextField.text.length>8) {
        [self showWarn:@"昵称不能超过八个字"];
        return ;
    }
    
    //头像处理
    if (self.imageBtn.currentImage == nil) {
        [self showWarn:@"跪求您设置一下头像和昵称..."];
        return;
    }
    
    if (self.nameTextField.text.length < 1) {
        [self showWarn:@"跪求您设置一下头像和昵称..."];
        return;
    }
    
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"sex":[NSString stringWithFormat:@"%d", self.sex],
                              @"name":self.nameTextField.text};
    
    UIImage * headImage = self.imageBtn.currentImage;
    NSString * fileName = [ToolsManager getUploadImageName];
    NSArray * files = @[@{FileDataKey:UIImageJPEGRepresentation(headImage, 0.9),FileNameKey:fileName}];
    
    debugLog(@"%@", kSavePersonalInfoPath);
    [self showLoading:nil];
    [HttpService postFileWithUrlString:kSavePersonalInfoPath params:params files:files andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        int status = [responseData[@"status"] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            [UserService sharedService].user.name           = self.nameTextField.text;
            [UserService sharedService].user.sex            = self.sex;
            [UserService sharedService].user.head_image     = responseData[@"result"][@"head_image"];
            [UserService sharedService].user.head_sub_image = responseData[@"result"][@"head_sub_image"];
            //数据缓存
            [[UserService sharedService] saveAndUpdate];
            [self hideLoading];
            //缓存头像
            [UIImageJPEGRepresentation(headImage, 0.9) cacheImageWithUrl:[NSString stringWithFormat:@"%@%@", kAttachmentAddr, [UserService sharedService].user.head_image]];
            
            //注册成功进入主页
            [CusTabBarViewController reinit];            
            CusTabBarViewController * ctbvc = [CusTabBarViewController sharedService];
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctbvc];
        
            [self presentViewController:nav animated:YES completion:^{
                //登录成功出栈
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
        }else{
            
            [self showWarn:responseData[@"msg"]];
        }
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];

}

////跳过
//- (IBAction)skipClick:(id)sender {
//    
//    //跳过进入主页
//    [CusTabBarViewController reinit];
//    CusTabBarViewController * ctbvc = [CusTabBarViewController sharedService];
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctbvc];
//    //侧滑
//    PPRevealSideViewController * revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
//    //设置状态栏背景颜色
//    [revealSideViewController setFakeiOS7StatusBarColor:[UIColor clearColor]];
//    [revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNone];
//    [self presentViewController:revealSideViewController animated:YES completion:^{
//        //登录成功 出栈
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }];
//}

@end
