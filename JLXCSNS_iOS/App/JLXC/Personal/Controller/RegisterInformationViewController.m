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

@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction)imageClick:(id)sender;
- (IBAction)maleClick:(id)sender;
- (IBAction)femaleClick:(id)sender;
- (IBAction)finishClick:(id)sender;
- (IBAction)skipClick:(id)sender;

@end

@implementation RegisterInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[SDWebImageManager sharedManager] saveImageToCache:nil forURL:@""];
    self.view.backgroundColor = [UIColor grayColor];
    self.sex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [ImageHelper getBigImage:info[UIImagePickerControllerEditedImage]];
    [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
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
            
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        if (buttonIndex == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                 [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }
        
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark- method response
- (IBAction)imageClick:(id)sender {
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"头像" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [sheet showInView:self.view];
    
}

- (IBAction)maleClick:(id)sender {
    if (self.sex == 1) {
        self.maleBtn.backgroundColor = [UIColor greenColor];
        self.femaleBtn.backgroundColor = [UIColor clearColor];
        self.sex = 0;
    }
}

- (IBAction)femaleClick:(id)sender {
    if (self.sex == 0) {
        self.maleBtn.backgroundColor = [UIColor clearColor];
        self.femaleBtn.backgroundColor = [UIColor greenColor];
        self.sex = 1;
    }
}

- (IBAction)finishClick:(id)sender {
    

    if (self.nameTextField.text.length>8) {
        [self showWarn:@"昵称不能超过八个字"];
        return ;
    }
    
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"sex":[NSString stringWithFormat:@"%d", self.sex],
                              @"name":self.nameTextField.text};
    UIImage * headImage;
    NSString * fileName;
    NSArray * files;
    
    //头像处理
    if (self.imageBtn.currentBackgroundImage != nil) {
        headImage = self.imageBtn.currentBackgroundImage;
        fileName = [ToolsManager getUploadImageName];
//        files = @[@{FileDataKey:UIImagePNGRepresentation(headImage),FileNameKey:fileName}];
        files = @[@{FileDataKey:UIImageJPEGRepresentation(headImage, 0.9),FileNameKey:fileName}];
    }
    
    debugLog(@"%@", kSavePersonalInfoPath);
    [self showLoading:nil];
    [HttpService postFileWithUrlString:kSavePersonalInfoPath params:params files:files andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
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
            
            //侧滑
            PPRevealSideViewController * revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
            //设置状态栏背景颜色
            [revealSideViewController setFakeiOS7StatusBarColor:[UIColor clearColor]];
            //    [revealSlideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
            [revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNone];
            [self presentViewController:revealSideViewController animated:YES completion:^{
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

//跳过
- (IBAction)skipClick:(id)sender {
    
    //跳过进入主页
    [CusTabBarViewController reinit];
    CusTabBarViewController * ctbvc = [CusTabBarViewController sharedService];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:ctbvc];
    //侧滑
    PPRevealSideViewController * revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    //设置状态栏背景颜色
    [revealSideViewController setFakeiOS7StatusBarColor:[UIColor clearColor]];
    [revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNone];
    [self presentViewController:revealSideViewController animated:YES completion:^{
        //登录成功 出栈
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
@end
