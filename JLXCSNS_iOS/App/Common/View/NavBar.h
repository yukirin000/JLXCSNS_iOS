//
//  NavBar.h
//  UBaby_iOS
//
//  Created by bhczmacmini on 14-10-20.
//  Copyright (c) 2014年 bhczmacmini. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 顶部定制navigationBar公共基类
 
 2014年10月20日 李晓航
 */
//左边的按钮block事件
typedef void(^LeftBlock) (void);
//右边边的按钮block事件
typedef void(^RightBlock) (void);

@interface NavBar : UIView

@property (nonatomic, strong) CustomLabel * titleLabel;
@property (nonatomic, strong) CustomButton * leftBtn;
@property (nonatomic, strong) CustomButton * rightBtn;

/*!设置左边按钮*/
- (void)setLeftBtnWithFrame:(CGRect)rect andContent:(NSString *)content andBlock:(LeftBlock)block;
/*!设置左边按钮不变位置*/
- (void)setLeftBtnWithContent:(NSString *)content andBlock:(LeftBlock)block;

/*!设置右边按钮*/
- (void)setRightBtnWithFrame:(CGRect)rect andContent:(NSString *)content andBlock:(RightBlock)block;
/*!设置右边按钮不变位置*/
- (void)setRightBtnWithContent:(NSString *)content andBlock:(LeftBlock)block;

/*!设置标题*/
- (void)setNavTitle:(NSString *)title;

@end
