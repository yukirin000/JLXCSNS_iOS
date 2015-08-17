//
//  RegisterViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/12.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

/*! 注册用户或者找回密码*/
@interface RegisterViewController : BaseViewController

//如果是从找回密码进来的
@property (nonatomic, assign) BOOL isFindPwd;

@property (nonatomic, copy) NSString * phoneNumber;

@end
