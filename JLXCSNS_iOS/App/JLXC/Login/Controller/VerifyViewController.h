//
//  VerifyViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/8/18.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

@interface VerifyViewController : BaseViewController<UITextFieldDelegate>

//如果是从找回密码进来的
@property (nonatomic, assign) BOOL isFindPwd;

@property (nonatomic, copy) NSString * phoneNumber;

@end
