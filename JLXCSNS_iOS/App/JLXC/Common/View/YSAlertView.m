//
//  YSAlterview.h
//  new
//
//  Created by chinat2t on 14-9-6.
//  Copyright (c) 2014年 chinat2t. All rights reserved.
//

#import "YSAlertView.h"
// 设置警告框的长和宽

#define Alertwidth 250.0f
#define AlertHeight 130.0f
#define Titlegap 15.0f
#define TitleOfHeight 25.0f
#define SingleButtonWidth 160.0f
//        单个按钮时的宽度
#define DoubleButtonWidth 80.0f
//        双个按钮的高度
#define ButtonHeigth 30.0f
//        按钮的高度
#define ButtonBottomgap 15.0f
//        设置按钮距离底部的边距


@interface YSAlertView()
{
    BOOL _leftLeave;
}

@property (nonatomic, strong) UIView *showView;

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftbtn;
@property (nonatomic, strong) UIButton *rightbtn;
@property (nonatomic, strong) UIView *backimageView;

@end

@implementation YSAlertView

+ (CGFloat)alertWidth
{
    return Alertwidth;
}

+ (CGFloat)alertHeight
{
    return AlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//+(YSAlertView*)showmessage:(NSString *)message subtitle:(NSString *)subtitle cancelbutton:(NSString *)cancle
//{
////    YSAlertView *alert = [[YSAlertView alloc] initWithTitle:message contentText:subtitle leftButtonTitle:nil rightButtonTitle:cancle];
////    [alert show];
////    alert.rightBlock = ^() {
////        NSLog(@"right button clicked");
////    };
////    alert.dismissBlock = ^() {
////        NSLog(@"cancel button clicked");
////    };
//    return alert;
//}



- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle showView:(UIView *)view
{
    if (self = [super init]) {
        
        self.showView                        = view;
        
        //自己的位置
        self.frame                           = CGRectMake((CGRectGetWidth(view.bounds) - Alertwidth) * 0.5-30, (CGRectGetHeight(view.bounds) - AlertHeight) * 0.5-20, Alertwidth, AlertHeight);

        //背景图
        UIImageView * backImageView          = [[UIImageView alloc] initWithFrame:self.bounds];
        backImageView.image                  = [UIImage imageNamed:@"alert_dialog_background"];
        [self addSubview:backImageView];

        self.alertTitleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, Titlegap, Alertwidth, TitleOfHeight)];
        self.alertTitleLabel.font            = [UIFont boldSystemFontOfSize:15.0f];
        self.alertTitleLabel.textColor       = [UIColor colorWithHexString:ColorBrown];
        [self addSubview:self.alertTitleLabel];

        self.alertContentLabel               = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.alertTitleLabel.frame)-15, Alertwidth-30, 60)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textColor     = [UIColor colorWithHexString:ColorBrown];
        self.alertContentLabel.font          = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.alertContentLabel];
        //        设置对齐方式
        self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertTitleLabel.text            = title;
        self.alertContentLabel.text          = content;

        CGRect leftbtnFrame                  = CGRectMake((Alertwidth - 2 * DoubleButtonWidth - 20) * 0.5, AlertHeight - ButtonBottomgap - ButtonHeigth, DoubleButtonWidth, ButtonHeigth);

        CGRect rightbtnFrame                 = CGRectMake(CGRectGetMaxX(leftbtnFrame) + 20, AlertHeight - ButtonBottomgap - ButtonHeigth, DoubleButtonWidth, ButtonHeigth);

        self.leftbtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightbtn                        = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftbtn.frame                   = leftbtnFrame;
        self.rightbtn.frame                  = rightbtnFrame;

        [self.rightbtn setBackgroundImage:[UIImage imageNamed:@"alert_dialog_cancel_btn_normal"] forState:UIControlStateNormal];
        [self.leftbtn setBackgroundImage:[UIImage imageNamed:@"alert_dialog_confirm_btn_normal"] forState:UIControlStateNormal];
        [self.rightbtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftbtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftbtn.titleLabel.font         = self.rightbtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftbtn setTitleColor:[UIColor colorWithHexString:ColorDeepBlack] forState:UIControlStateNormal];
        [self.rightbtn setTitleColor:[UIColor colorWithHexString:ColorDeepBlack] forState:UIControlStateNormal];
        [self.leftbtn addTarget:self action:@selector(leftbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightbtn addTarget:self action:@selector(rightbtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftbtn.layer.masksToBounds     = self.rightbtn.layer.masksToBounds = YES;
        self.leftbtn.layer.cornerRadius      = self.rightbtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftbtn];
        [self addSubview:self.rightbtn];
        
        UIButton *xButton                    = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        xButton.frame                        = CGRectMake(Alertwidth - 25, 0, 25, 25);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return self;
}
- (void)leftbtnclicked:(id)sender
{
    
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissAlert];
}

- (void)rightbtnclicked:(id)sender
{
    
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dismissAlert];
}
- (void)show
{   //获取第一响应视图视图
    [self.showView addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
//    if (self.dismissBlock) {
//        self.dismissBlock();
//    }
}



- (void)removeFromSuperview
{
    [self.backimageView removeFromSuperview];
    self.backimageView = nil;
    CGRect afterFrame = CGRectMake((CGRectGetWidth(self.showView.bounds) - Alertwidth) * 0.5+30, (CGRectGetHeight(self.showView.bounds) - AlertHeight) * 0.5-30, Alertwidth, AlertHeight);
    
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        self.alpha=0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}
//添加新视图时调用（在一个子视图将要被添加到另一个视图的时候发送此消息）
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    
    if (!self.backimageView) {
        self.backimageView = [[UIView alloc] initWithFrame:self.showView.bounds];
        self.backimageView.backgroundColor = [UIColor blackColor];
        self.backimageView.alpha = 0.1f;
        self.backimageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)];
        [self.backimageView addGestureRecognizer:tap];
    }
    //    加载背景背景图,防止重复点击
    [self.showView addSubview:self.backimageView];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(self.showView.bounds) - Alertwidth) * 0.5, (CGRectGetHeight(self.showView.bounds) - AlertHeight) * 0.5, Alertwidth, AlertHeight);
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = afterFrame;
        self.alpha=0.95;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}


- (void)setLeftBlock:(ClickBlock)leftBlock
{
    _leftBlock = [leftBlock copy];
}

- (void)setRightBlock:(ClickBlock)rightBlock
{
    _rightBlock = [rightBlock copy];
}

@end


// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
