//
//  EwQRcodeViewController
//  MyQrCode
//
//  Created by Geoffrey on 13-12-21.
//  Copyright (c) 2013年 NN. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
/*!
    二维码扫描页面
 */
@interface QRcodeViewController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    UIView *_borderView;
}
@property (strong, nonatomic)AVCaptureDevice *device;
@property (strong, nonatomic)AVCaptureDeviceInput *input;
@property (strong, nonatomic)AVCaptureMetadataOutput *output;
@property (strong, nonatomic)AVCaptureSession *session;
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *preview;

@end
