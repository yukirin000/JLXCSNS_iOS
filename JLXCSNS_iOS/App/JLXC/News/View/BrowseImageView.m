//
//  BrowseImageView.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/4.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BrowseImageView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface BrowseImageView ()<MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD * hudProgress;

@property (nonatomic, strong) UIImage * currentImage;

@property (nonatomic, strong) CustomImageView * imageView;

@end

@implementation BrowseImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor blackColor];
        [self initWidget];
        [self configUI];
        
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.userInteractionEnabled     = YES;
    //长按手势
    UILongPressGestureRecognizer * longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImage:)];
    [self.imageView addGestureRecognizer:longP];
    
    
    [self.backScrollView addSubview:self.imageView];
    
    self.hudProgress = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:_hudProgress];
    
    if (self.image == nil) {

        if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:self.urlStr]) {
            //需要加载
            [self showLoading:@"加载中"];
        }
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self hideLoading];
            
            if (image != nil) {
                self.currentImage = image;
                self.imageView.frame   = [self getRectWithSize:image.size];
            }
        
        }];
        
        
    }else{
        //不需要
        self.imageView.image = self.image;
        self.imageView.frame = [self getRectWithSize:self.image.size];
    }
    
    self.backScrollView.contentSize                    = self.imageView.frame.size;
    
}

#pragma mark- layout
- (void) initWidget {
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.backScrollView];
    
}
- (void) configUI {
    
    self.imageView          = [[CustomImageView alloc] init];
    
    self.backScrollView.delegate                       = self;
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.showsVerticalScrollIndicator   = NO;
    self.backScrollView.backgroundColor                = [UIColor clearColor];
    self.backScrollView.maximumZoomScale               = 5.0f;
    self.backScrollView.minimumZoomScale               = 1.0f;
    
}

#pragma mark- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //返回当前滚动视图处理缩放的视图
    UIView * currentView = [scrollView.subviews objectAtIndex:0];
    return currentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView * currentView = [scrollView.subviews objectAtIndex:0];
    CGRect frame = currentView.frame;
    
    CGFloat top = 0, left = 0;
    if (scrollView.contentSize.width < scrollView.bounds.size.width) {
        left = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5f;
    }
    if (scrollView.contentSize.height < scrollView.bounds.size.height) {
        top = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
    
    CGSize contentSize     = scrollView.contentSize;
    contentSize.height     += -top*2;
    scrollView.contentSize = contentSize;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
//    debugLog(@"%@ size :%@", NSStringFromUIEdgeInsets(scrollView.contentInset),NSStringFromCGSize(scrollView.contentSize));

}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (self.currentImage) {
            UIImageWriteToSavedPhotosAlbum(self.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

#pragma mark- method response
- (void)longPressImage:(UILongPressGestureRecognizer *)ges
{
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:StringCommonCancel destructiveButtonTitle:nil otherButtonTitles:StringCommonSave, nil];
        [sheet showInView:self];
    }
    
}

#pragma mark- private method
//获取合适的比例
- (CGRect)getRectWithSize:(CGSize) size
{
    CGFloat x,y,width,height;
    
    if (size.width > size.height) {
        width  = [DeviceManager getDeviceWidth];
        height = size.height*([DeviceManager getDeviceWidth]/size.width);
        x      = 0;
        y      = ([DeviceManager getDeviceHeight]-height)/2;
        
        
        if (height > [DeviceManager getDeviceHeight]) {
            width = width*([DeviceManager getDeviceHeight]/height);
            height = [DeviceManager getDeviceHeight];
            
            x      = ([DeviceManager getDeviceWidth]-width)/2;
            y      = ([DeviceManager getDeviceHeight]-height)/2;
        }
        
        
    }else{
        height = [DeviceManager getDeviceHeight];
        width  = size.width*([DeviceManager getDeviceHeight]/size.height);
        y      = 0;
        x      = ([DeviceManager getDeviceWidth]-width)/2;
        
        if (width > [DeviceManager getDeviceWidth]) {
            height = height*([DeviceManager getDeviceWidth]/width);
            width = [DeviceManager getDeviceWidth];
            
            y      = ([DeviceManager getDeviceHeight]-height)/2;
            x      = ([DeviceManager getDeviceWidth]-width)/2;
        }
        
    }
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    return rect;
}

- (void) image: (UIImage *) image didFinishSavingWithError: (NSError *) error
   contextInfo: (void *) contextInfo
{
    [self showComplete:@"保存完成╮(╯_╰)╭"];
}

//显示完成
-(void)showComplete:(NSString *)text
{
    _hudProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ToastFinish"]];
    // Set custom view mode
    _hudProgress.mode = MBProgressHUDModeCustomView;
    _hudProgress.delegate = self;
    _hudProgress.labelText = text;
    [_hudProgress show:YES];
    [_hudProgress hide:YES afterDelay:1];
}

//显示有错误
-(void)showWarn:(NSString *)text
{
    _hudProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ToastWarn"]];
    // Set custom view mode
    _hudProgress.mode = MBProgressHUDModeCustomView;
    _hudProgress.delegate = self;
    _hudProgress.labelText = text;
    [_hudProgress show:YES];
    [_hudProgress hide:YES afterDelay:1.5];
}

//显示Loading动画
- (void)showLoading:(NSString *)text
{
    _hudProgress.mode = MBProgressHUDModeIndeterminate;
    _hudProgress.delegate = self;
    _hudProgress.labelText = text;
    [_hudProgress show:YES];
}

//隐藏Loading动画
- (void)hideLoading
{
    [_hudProgress hide:YES];
}


@end
