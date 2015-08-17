//
//  ZJKQRcodeViewController.m
//  MyQrCode
//
//  Created by Geoffrey on 13-12-21.
//  Copyright (c) 2013年 NN. All rights reserved.
//

#import "QRcodeViewController.h"
#import "OtherPersonalViewController.h"
#import "Base64.h"
#import "WebViewController.h"

@interface QRcodeViewController ()

@end

@implementation QRcodeViewController


static int ScanQRSize = 16;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.navBar setNavTitle:@"扫一扫"];
    
    //扫描框
    _borderView  = [[UIView alloc] initWithFrame:CGRectMake(50, self.navBar.frame.size.height+65, 220, 220)];
    [_borderView setBackgroundColor:[UIColor clearColor]];
    _borderView.layer.borderWidth=1;
    _borderView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view insertSubview:_borderView belowSubview:self.navBar];
    
    for (int i=1; i<=4; i++) {
        UIImageView *cornerView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [cornerView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ScanQR%d",i]]];
        if (i==1) {
            [cornerView setFrame:CGRectMake(_borderView.frame.origin.x-1, _borderView.frame.origin.y-1, ScanQRSize, ScanQRSize)];
        }else if(i==2){
            [cornerView setFrame:CGRectMake(_borderView.frame.origin.x+_borderView.frame.size.width-ScanQRSize+1, _borderView.frame.origin.y-1, ScanQRSize, ScanQRSize)];
        }else if(i==3){
            [cornerView setFrame:CGRectMake(_borderView.frame.origin.x-1, _borderView.frame.origin.y+_borderView.frame.size.height-ScanQRSize+1, ScanQRSize, ScanQRSize)];
        }else if(i==4){
            [cornerView setFrame:CGRectMake(_borderView.frame.origin.x+_borderView.frame.size.width-ScanQRSize+1, _borderView.frame.origin.y+_borderView.frame.size.height-ScanQRSize+1, ScanQRSize, ScanQRSize)];
        }
        [self.view addSubview:cornerView];
    }
    
    [self setupCamera];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [self.session stopRunning];
    self.session=nil;
    self.preview=nil;
}

#pragma mark-
- (void)setupCamera
{
    // Device
    self.device  = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input   = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output  = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
    self.output.metadataObjectTypes = [self.output availableMetadataObjectTypes];
    self.preview                    = [[AVCaptureVideoPreviewLayer alloc] init];
    // Preview
    self.preview                    = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity       = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame              = CGRectMake(0,self.navBar.frame.size.height,self.view.frame.size.width,self.view.frame.size.height);
    [self.view.layer insertSublayer:self.preview below:_borderView.layer];
    [self.session startRunning];
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    [self.session stopRunning];
    
    //如果是添加好友
    if ([stringValue hasPrefix:JLXC]) {
        NSString * uid                        = [[stringValue substringFromIndex:4] base64DecodedString];
        //如果是自己
        if (uid.integerValue == [UserService sharedService].user.uid) {

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"发现" message:@"不要没事扫自己玩(ㅎ‸ㅎ)" delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        OtherPersonalViewController * otherVC = [[OtherPersonalViewController alloc] init];
        otherVC.uid                           = [uid integerValue];
        [self pushVC:otherVC];
        return;
    }
    
    //如果是网页
    if ([ToolsManager validateWEB:stringValue]) {
        WebViewController * webVC = [[WebViewController alloc] init];
        webVC.webURL              = [NSURL URLWithString:stringValue];
        [self pushVC:webVC];
        return;
    }else{
        //什么都没扫到
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"扫到了未知生物" message:[NSString stringWithFormat:@"[%@]是啥？", stringValue] delegate:self cancelButtonTitle:StringCommonCancel otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.session startRunning];
}


@end
