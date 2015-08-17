//
//  MyCardViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/18.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "MyCardViewController.h"
#import "UIImageView+WebCache.h"
@interface MyCardViewController ()

//头像
@property (nonatomic, strong) CustomImageView * headImageView;
//姓名
@property (nonatomic, strong) CustomLabel * nameLabel;
//helloha号
@property (nonatomic, strong) CustomLabel * hellohaLabel;
//设置账号btn
@property (nonatomic, strong) CustomButton * setHelloHaBtn;
//设置账号textField
@property (nonatomic, strong) CustomTextField * setHelloHaTextField;
//保存账号btn
@property (nonatomic, strong) CustomButton * saveBtn;
//我的二维码
@property (nonatomic, strong) CustomImageView * qrcodeImageView;

@end

@implementation MyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createWidget];
    
    [self configUI];
    
    [self getQRCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)createWidget
{
    self.headImageView       = [[CustomImageView alloc] init];
    self.nameLabel           = [[CustomLabel alloc] initWithFontSize:20];
    self.qrcodeImageView     = [[CustomImageView alloc] init];
    self.setHelloHaBtn       = [[CustomButton alloc] initWithFontSize:15];
    self.setHelloHaTextField = [[CustomTextField alloc] init];
    self.hellohaLabel        = [[CustomLabel alloc] initWithFontSize:20];
    self.saveBtn             = [[CustomButton alloc] initWithFontSize:15];
    
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.qrcodeImageView];
    [self.view addSubview:self.setHelloHaBtn];
    [self.view addSubview:self.setHelloHaTextField];
    [self.view addSubview:self.hellohaLabel];
    [self.view addSubview:self.saveBtn];
    
}

- (void)configUI
{
    //头像
    self.headImageView.frame               = CGRectMake(kCenterOriginX(100), kNavBarAndStatusHeight+30, 100, 100);
    self.headImageView.layer.cornerRadius  = self.headImageView.width/2;
    self.headImageView.layer.masksToBounds = YES;
    NSURL * url = [NSURL URLWithString:[ToolsManager completeUrlStr:[UserService sharedService].user.head_image]];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"testimage"]];
    
    //昵称
    self.nameLabel.frame                 = CGRectMake(0, self.headImageView.bottom+5, self.viewWidth, 30);
    self.nameLabel.text                  = [UserService sharedService].user.name;
    self.nameLabel.textColor             = [UIColor blackColor];
    self.nameLabel.textAlignment         = NSTextAlignmentCenter;

    //设置账号
    self.setHelloHaBtn.frame             = CGRectMake(kCenterOriginX(100), self.nameLabel.bottom+10, 100, 20);
    [self.setHelloHaBtn addTarget:self action:@selector(setHelloBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.setHelloHaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.setHelloHaBtn setTitle:@"设置账号" forState:UIControlStateNormal];
    [self.setHelloHaBtn setBackgroundColor:[UIColor greenColor]];

    //设置账号textField 默认隐藏
    self.setHelloHaTextField.frame       = CGRectMake(kCenterOriginX(200), self.nameLabel.bottom+10, 150, 20);
    self.setHelloHaTextField.font        = [UIFont systemFontOfSize:13];
    self.setHelloHaTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.setHelloHaTextField.placeholder = @"请设置号码poi~";
    self.setHelloHaTextField.delegate    = self;
    self.setHelloHaTextField.hidden      = YES;

    //保存helloHa号按钮 默认隐藏
    self.saveBtn.frame                   = CGRectMake(self.setHelloHaTextField.right+10, self.nameLabel.bottom+10, 40, 20);
    self.saveBtn.hidden                  = YES;
    [self.saveBtn addTarget:self action:@selector(saveHelloClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setBackgroundColor:[UIColor greenColor]];
    
    //helloHa号label 默认隐藏
    self.hellohaLabel.frame              = CGRectMake(0, self.nameLabel.bottom+10, self.viewWidth, 20);
    self.hellohaLabel.textColor          = [UIColor blackColor];
    self.hellohaLabel.textAlignment      = NSTextAlignmentCenter;
    self.hellohaLabel.hidden             = YES;
    
    //如果有就不显示
    if ([UserService sharedService].user.helloha_id.length > 0) {
        self.saveBtn.hidden             = YES;
        self.setHelloHaTextField.hidden = YES;
        self.setHelloHaBtn.hidden       = YES;
        self.hellohaLabel.hidden        = NO;
        self.hellohaLabel.text = [NSString stringWithFormat:@"HelloHa号%@",[UserService sharedService].user.helloha_id];
    }
    
    //二维码
    self.qrcodeImageView.frame           = CGRectMake(kCenterOriginX(200), self.setHelloHaBtn.bottom+5, 200, 200);
    self.qrcodeImageView.backgroundColor = [UIColor grayColor];
    //先用本地图片
    NSString * localPath                 = [NSString stringWithFormat:@"%@/qrcode.png", PATH_OF_DOCUMENT];
    UIImage * qrImage                    = [UIImage imageWithContentsOfFile:localPath];
    self.qrcodeImageView.image           = qrImage;
    
    CustomLabel * qrcodeLabel = [[CustomLabel alloc] initWithFontSize:12];
    qrcodeLabel.frame         = CGRectMake(kCenterOriginX(200), self.qrcodeImageView.bottom+5, 200, 20);
    qrcodeLabel.textAlignment = NSTextAlignmentCenter;
    qrcodeLabel.text          = @"扫一扫二维码，加我为HelloHa好友";
    [self.view addSubview:qrcodeLabel];
    
}
#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self setHelloHaId];
    }
}

#pragma mark- override
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.setHelloHaTextField resignFirstResponder];
}

#pragma mark- mehotd response
- (void)setHelloBtnClick:(id)sender
{
    self.saveBtn.hidden             = NO;
    self.setHelloHaTextField.hidden = NO;

    self.setHelloHaBtn.hidden       = YES;
}

- (void)saveHelloClick:(id)sender
{
    if (![ToolsManager validateUserName:self.setHelloHaTextField.text]) {
        
        ALERT_SHOW(@"注意", @"账号只能由6-20位字母数字下划线组成╮(╯_╰)╭");
        return;
    };
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"账号设置后不能更改，你愿意和它相伴一生吗" delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:StringCommonConfirm, nil];
    [alert show];
}

#pragma mark- private method
//二维码
- (void)getQRCode
{
    NSString * path = [kGetUserQRCodePath stringByAppendingFormat:@"?uid=%ld", [UserService sharedService].user.uid];
    debugLog(@"%@", path);
    [HttpService getWithUrlString:path andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            NSString *path = [NSString stringWithFormat:@"%@%@",kRootAddr,responseData[HttpResult]];
            NSURL * url = [NSURL URLWithString:path];
            
            [self.qrcodeImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image != nil) {
                    //加载成功 记录在本地
                    NSData * data = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
                    NSString * localPath = [NSString stringWithFormat:@"%@/qrcode.png", PATH_OF_DOCUMENT];
                    [data writeToFile:localPath atomically:YES];
                }
            }];
            
        }else{
            [self showWarn:responseData[HttpMessage]];
        }
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
    }];
}
//设置helloHa号 一辈子只   能设置一个
- (void)setHelloHaId
{
    self.setHelloHaTextField.enabled = NO;
    
    NSDictionary * params = @{@"uid":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.uid],
                              @"helloha_id":[self.setHelloHaTextField.text trim]};

    [self showLoading:StringCommonUploadData];
    debugLog(@"%@ %@", kSetHelloHaIdPath, params);
    [HttpService postWithUrlString:kSetHelloHaIdPath params:params andCompletion:^(AFHTTPRequestOperation *operation, id responseData) {
        debugLog(@"%@", responseData);
        int status = [responseData[HttpStatus] intValue];
        if (status == HttpStatusCodeSuccess) {
            
            [self showComplete:@"设置成功！"];
            [UserService sharedService].user.helloha_id = [self.setHelloHaTextField.text trim];
            //数据缓存
            [[UserService sharedService] saveAndUpdate];
            //设置成功
            self.hellohaLabel.text = [NSString stringWithFormat:@"HelloHa号%@",[UserService sharedService].user.helloha_id];
            self.hellohaLabel.hidden        = NO;
            self.setHelloHaTextField.hidden = YES;
            self.saveBtn.hidden             = YES;
            
        }else{
            [self showWarn:responseData[HttpMessage]];
            
            if ([responseData[HttpResult][@"flag"] boolValue] == YES) {
                //如果设置过了
                NSString * helloId = responseData[HttpResult][@"helloha_id"];
                if (helloId.length > 0) {
                    self.hellohaLabel.text = [NSString stringWithFormat:@"HelloHa号%@",helloId];
                    self.hellohaLabel.hidden        = NO;
                    self.setHelloHaTextField.hidden = YES;
                    self.saveBtn.hidden             = YES;
                    
                    [UserService sharedService].user.helloha_id = helloId;
                    //数据缓存
                    [[UserService sharedService] saveAndUpdate];
                }
            }

        }
        
        self.setHelloHaTextField.enabled = YES;
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showWarn:StringCommonNetException];
        self.setHelloHaTextField.enabled = YES;
    }];

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
