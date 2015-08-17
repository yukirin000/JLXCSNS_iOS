//
//  CreateChatRoomViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "CreateChatRoomViewController.h"
#import "CreateChatRoomTagViewController.h"
#import "ImageCutViewController.h"
@interface CreateChatRoomViewController ()

//背景图片
@property (nonatomic, strong) CustomImageView * backImageView;
//当前背景图
@property (nonatomic, strong) UIImage * currentImage;
//标题tv
@property (nonatomic, strong) UITextField * textField;

//下一级穿件聊天室页面
@property (nonatomic, strong) CreateChatRoomTagViewController * chatRoomTagVC;


@end

@implementation CreateChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:@"下一步" andBlock:^{
        [sself continueCreateChatRoom];
    }];
    
    [self createWidget];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)createWidget
{
    self.backImageView  = [[CustomImageView alloc] init];
    self.textField      = [[UITextField alloc] init];
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.textField];
}

- (void)configUI
{
    
    self.backImageView.frame           = CGRectMake(10, kNavBarAndStatusHeight+10, self.viewWidth-20, 100);
    self.backImageView.image           = [UIImage imageNamed:@"testimage"];
    self.backImageView.backgroundColor = [UIColor grayColor];
    
    self.textField.frame               = CGRectMake(kCenterOriginX(260), self.backImageView.y+30, 260, 30);
    self.textField.placeholder         = @"请输入聊天主题poi";
    self.textField.borderStyle         = UITextBorderStyleRoundedRect;
    self.textField.delegate            = self;
    
    //图库点击按钮
    CustomButton * imageBtn            = [[CustomButton alloc] initWithFontSize:15];
    imageBtn.frame                     = CGRectMake([DeviceManager getDeviceWidth]-70, self.backImageView.bottom+10, 60, 20);
    [imageBtn addTarget:self action:@selector(imageChooseClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageBtn setTitle:@"图库" forState:UIControlStateNormal];
    [imageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:imageBtn];
    
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image          = [ImageHelper getBigImage:info[UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:^{
        //图片裁剪
        ImageCutViewController * icvc = [[ImageCutViewController alloc] init];
        icvc.image                    = image;
        [icvc setImageCutBlock:^(UIImage *cutImage) {
            self.backImageView.image = cutImage;
            self.currentImage        = cutImage;
        }];
        [self pushVC:icvc];
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //选照片
    if (buttonIndex != 2) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        //相机
        if (buttonIndex == 0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }
        //相册
        if (buttonIndex == 1) {
            
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

#pragma mark- method response
- (void)imageChooseClick:(id)sender
{
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"背景图" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [sheet showInView:self.view];
    [self.textField resignFirstResponder];
}

//点击下一步
- (void)continueCreateChatRoom
{
    if ([[self.textField.text trim] length] < 1) {
        ALERT_SHOW(StringCommonPrompt, @"标题不能为空..");
        return;
    }
    //下一步
    if (self.chatRoomTagVC == nil) {
        self.chatRoomTagVC = [[CreateChatRoomTagViewController alloc] init];
    }
    self.chatRoomTagVC.image     = self.currentImage;
    self.chatRoomTagVC.roomTitle = [self.textField.text trim];
    [self pushVC:self.chatRoomTagVC];
    
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
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
