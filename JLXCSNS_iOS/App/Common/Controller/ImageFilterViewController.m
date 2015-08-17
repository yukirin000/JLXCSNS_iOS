//
//  ImageFilterViewController.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/6.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ImageFilterViewController.h"

@interface ImageFilterViewController ()<TuSDKICGPUImageViewDelegate>

@end

@implementation ImageFilterViewController
{
    BackBlock _backBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.onlyReturnFilter                                  = NO;
    self.defaultStyleView.imageView.delegate               = self;
    self.outputCompress                                    = 0.6;
    [self.defaultStyleView.bottomBar.cancelButton addTarget:self action:@selector(cancelTuVC:) forControlEvents:UIControlEventTouchUpInside];
    self.defaultStyleView.imageView.enableTouchCleanFilter = NO;
    
}

- (void)onImageCompleteAtion
{
    
    [super onImageCompleteAtion];   
    [self dismissViewControllerAnimated:YES completion:^{

    }];
    
}

- (void)onTuSDKICGPUImageView:(TuSDKICGPUImageView *)view
                 changeFilter:(TuSDKFilterWrap *)filter
{
    
}

-(UIImage*)captureView:(UIView *)theView{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)cancelTuVC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

//设置完成block
- (void)setBackBlock:(BackBlock)block
{
    _backBlock = [block copy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
