//
//  CutImageView2.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/10.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "CutImageView.h"

@interface CutImageView()

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, assign) CGPoint lastOffset;

@property (nonatomic, strong) CustomImageView * imageView;

@property (nonatomic, assign) CGRect originRect;

@end

@implementation CutImageView

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
    self.imageView.image        = self.image;

    //原始rect
    self.originRect             = [self getRectWithSize:self.image.size];
    //处理contentSize
    CGFloat startY              = self.originRect.size.height-CutImageHeight+[DeviceManager getDeviceHeight]+1;
    self.scrollView.contentSize = CGSizeMake([DeviceManager getDeviceWidth]+1, startY);

    //imageView frame
    CGRect updateRect           = self.originRect;
    CGFloat newY                = ([DeviceManager getDeviceHeight]-CutImageHeight)/2;
    updateRect.origin.y         = newY;
    self.imageView.frame        = updateRect;
    
    //offset
    self.scrollView.contentOffset = CGPointMake(0, newY-self.originRect.origin.y);
}

- (void) initWidget {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.imageView  = [[CustomImageView alloc] init];
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
}
- (void) configUI {
    
    self.imageView.userInteractionEnabled = YES;

    UIPinchGestureRecognizer * pinch      = [[UIPinchGestureRecognizer alloc] init];
    [pinch addTarget:self action:@selector(pinchGes:)];
    [self.imageView addGestureRecognizer:pinch];
    
}

- (void)pinchGes:(UIPinchGestureRecognizer *)ges
{
    
    CGFloat originWidth  = self.originRect.size.width;
    CGFloat originHeight = self.originRect.size.height;

    CGFloat newY         = ([DeviceManager getDeviceHeight]-CutImageHeight)/2;
    CGFloat contentY     = ges.view.frame.size.height-CutImageHeight+[DeviceManager getDeviceHeight];

    ges.view.transform   = CGAffineTransformScale(ges.view.transform, ges.scale, ges.scale);
    ges.scale            = 1.0f;
    
    //frame
    CGRect rect    = ges.view.frame;
    CGRect oriRect = rect;
    if (rect.origin.x<0 || (rect.origin.x>0 && rect.size.width > [DeviceManager getDeviceWidth])) {
        rect.origin.x = 0;
    }
    rect.origin.y  = newY;
    ges.view.frame = rect;
    
    //contentSize
    CGSize size = CGSizeMake([DeviceManager getDeviceWidth], contentY);
    if (ges.view.frame.size.width>[DeviceManager getDeviceWidth]) {
        size.width = ges.view.frame.size.width;
    }
    self.scrollView.contentSize = size;
    
    //contentOffset
    CGFloat x = self.scrollView.contentOffset.x - oriRect.origin.x/2;
    CGFloat y = self.scrollView.contentOffset.y - (oriRect.origin.y-newY)/2;
    if (x < 0) {
        x=0;
    }
    if (y < 0) {
        y=0;
    }
    
    self.scrollView.contentOffset = CGPointMake(x, y);
    //设置超出范围时候的offset
    if (rect.size.width >= originWidth*2) {
        if (self.lastOffset.x == 0 && self.lastOffset.y == 0) {
            self.lastOffset = CGPointMake(x, y);
        }
    }
    
    //end
    if (ges.state == UIGestureRecognizerStateEnded) {
        
        //最小原比例
        if (ges.view.frame.size.width < originWidth) {
            [UIView animateWithDuration:0.3f animations:^{
                ges.view.frame                = CGRectMake(self.originRect.origin.x, newY, originWidth, originHeight);
                CGFloat oriContentY           = self.originRect.size.height-CutImageHeight+[DeviceManager getDeviceHeight]+1;
                //contentSize
                CGSize size                   = CGSizeMake(rect.size.width, oriContentY);
                self.scrollView.contentSize   = size;
                self.scrollView.contentOffset = CGPointMake(0, newY-self.originRect.origin.y);
            }];
        }
        
        //最大2倍
        if (rect.size.width > originWidth*2) {
            rect.size.width  = originWidth*2;
            rect.size.height = originHeight*2;
            rect.origin.y    = newY;
            if (rect.origin.y < 0) {
                rect.origin.y = 0;
            }
            contentY = rect.size.height-CutImageHeight+[DeviceManager getDeviceHeight];
            
            [UIView animateWithDuration:0.3f animations:^{
                ges.view.frame                = rect;
                //contentSize
                CGSize size                   = CGSizeMake(rect.size.width, contentY);
                self.scrollView.contentSize   = size;
                self.scrollView.contentOffset = self.lastOffset;
                self.lastOffset               = CGPointZero;
            }];
            
            
        }
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
