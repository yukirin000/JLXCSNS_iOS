//
//  YSAlterview.h
//  new
//
//  Created by chinat2t on 14-11-6.
//  Copyright (c) 2014年 chinat2t. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickBlock)(void);

@interface YSAlertView : UIView

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
           showView:(UIView *)view;


- (void)show;

@property (nonatomic, copy) ClickBlock leftBlock;
@property (nonatomic, copy) ClickBlock rightBlock;
//@property (nonatomic, copy) dispatch_block_t dismissBlock;

//+(YSAlertView*)showmessage:(NSString *)message subtitle:(NSString *)subtitle cancelbutton:(NSString *)cancle;

//左边
- (void)setLeftBlock:(ClickBlock)leftBlock;
//右边
- (void)setRightBlock:(ClickBlock)rightBlock;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
