//
//  ImageCutViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ImageCutViewController.h"
#import "CutImageView.h"
@interface ImageCutViewController ()

@end

@implementation ImageCutViewController
{
    ImageCutBlock _cutBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- layout
- (void)configUI
{
    self.view.backgroundColor         = [UIColor blackColor];
    self.navBar.backgroundColor       = [UIColor clearColor];
    
    __weak typeof(self) sself = self;
    [self.navBar setRightBtnWithContent:StringCommonConfirm andBlock:^{
        [sself cutOk];
    }];
    
    
    //图片
    CutImageView * cutImageView = [[CutImageView alloc] initWithFrame:self.view.bounds];
    cutImageView.image             = self.image;
    [self.view addSubview:cutImageView];
    
    //设置遮罩
    UIView * topCoverView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, (self.viewHeight-CutImageHeight)/2)];
    topCoverView.backgroundColor           = [UIColor blackColor];
    topCoverView.userInteractionEnabled    = NO;
    topCoverView.alpha                     = 0.5;
    [self.view addSubview:topCoverView];

    //设置遮罩
    UIView * cutCoverView                  = [[UIView alloc] initWithFrame:CGRectMake(0, topCoverView.bottom, self.viewWidth, CutImageHeight)];
    cutCoverView.layer.borderWidth         = 1;
    cutCoverView.layer.borderColor         = [UIColor whiteColor].CGColor;
    cutCoverView.userInteractionEnabled    = NO;
    cutCoverView.backgroundColor           = [UIColor clearColor];
    [self.view addSubview:cutCoverView];

    //设置遮罩
    UIView * bottomCoverView               = [[UIView alloc] initWithFrame:CGRectMake(0, cutCoverView.bottom, self.viewWidth, (self.viewHeight-CutImageHeight)/2)];
    bottomCoverView.alpha                  = 0.5;
    bottomCoverView.userInteractionEnabled = NO;
    bottomCoverView.backgroundColor        = [UIColor blackColor];
    [self.view addSubview:bottomCoverView];
    
    [self.view sendSubviewToBack:topCoverView];
    [self.view sendSubviewToBack:cutCoverView];
    [self.view sendSubviewToBack:bottomCoverView];
    [self.view sendSubviewToBack:cutImageView];
    
}

#pragma mark- private method
- (void)setImageCutBlock:(ImageCutBlock)block
{
    _cutBlock = [block copy];
}

//剪切OK
- (void)cutOk
{
    
    UIImage * cutImage = [self captureView:self.view];
    if (_cutBlock) {
        _cutBlock(cutImage);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(UIImage*)captureView:(UIView *)theView{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef cutCGImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, (self.viewHeight-CutImageHeight)/2, self.viewWidth, CutImageHeight));
    
    
    return [UIImage imageWithCGImage:cutCGImage];
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
