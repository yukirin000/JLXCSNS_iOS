//
//  CutImageView.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "OldCutImageView.h"

@interface OldCutImageView()

@property (nonatomic, strong) UIScrollView * backScrollView;

@property (nonatomic, strong) CustomImageView * imageView;

@property (nonatomic, assign) CGPoint offset;

@property (nonatomic, assign) CGPoint oriOffset;

@end

@implementation OldCutImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self initWidget];
        [self configUI];
        
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView       = [[CustomImageView alloc] init];
    self.imageView.image = self.image;
    CGFloat y            = ([DeviceManager getDeviceHeight]-100)/2;
    //原始rect
    CGRect originRect    = [self getRectWithSize:self.image.size];
    //需要修改的rect
    CGRect updateRect    = originRect;
    updateRect.origin.y  = y;
    self.imageView.frame = updateRect;
    [self.backScrollView addSubview:self.imageView];
    
    CGSize size                       = self.imageView.frame.size;
    self.backScrollView.contentSize   = CGSizeMake(size.width, size.height-100+[DeviceManager getDeviceHeight]);
    //开始就移动
    self.backScrollView.contentOffset = CGPointMake(0, y-originRect.origin.y);
    self.oriOffset                    = self.backScrollView.contentOffset;
}

#pragma mark- layout
- (void) initWidget {
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.backScrollView];
    
}
- (void) configUI {
    
    self.backScrollView.delegate                       = self;
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.showsVerticalScrollIndicator   = NO;
    self.backScrollView.backgroundColor                = [UIColor clearColor];
    self.backScrollView.maximumZoomScale               = 2.0f;
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
    
//    CGSize endSize         = scrollView.contentSize;
//    endSize.height         = self.imageView.frame.size.height-100+[DeviceManager getDeviceHeight];
//    scrollView.contentSize = endSize;
    
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
    scrollView.contentInset         = UIEdgeInsetsMake(top-(self.offset.y-self.oriOffset.y), left, 0, 0);
    
    
    
//    debugLog(@"%@   %f", NSStringFromCGPoint(scrollView.contentOffset), top);
//    scrollView.contentOffset    =   CGPointMake(-left, -top);
//    CGSize size                     = scrollView.contentSize;
//    debugLog(@"%@", NSStringFromCGRect(scrollView.frame));

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGPoint oPoint = scrollView.contentOffset;
    CGSize endSize           = scrollView.contentSize;
    endSize.height           = view.frame.size.height-100+[DeviceManager getDeviceHeight];
    scrollView.contentSize   = endSize;
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.contentOffset = oPoint;
    
    self.oriOffset                    = self.backScrollView.contentOffset;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.offset = CGPointMake(scrollView.contentOffset.x/scrollView.zoomScale, scrollView.contentOffset.y/scrollView.zoomScale);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
