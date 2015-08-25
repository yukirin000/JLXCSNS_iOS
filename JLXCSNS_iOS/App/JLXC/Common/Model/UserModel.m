//
//  UserModel.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/12.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


- (void)setModelWithDic:(NSDictionary *)dic
{
//    "add_date" = 1431439381;
//    age = "<null>";
//    "delete_date" = "<null>";
//    "delete_flag" = 0;
//    "head_image" = "<null>";
//    id = 6;
//    "iosdevice_token" = "<null>";
//    "login_token" = MTM3MzY2NjEyMzQxNDMxNDM5Mzgx;
//    name = "";
//    password = e10adc3949ba59abbe56e057f20f883e;
//    "phone_num" = "";
//    "resume_date" = "<null>";
//    school = "<null>";
//    "school_num" = "<null>";
//    sex = 0;
//    "titi_id" = "<null>";
//    "update_date" = "<null>";
//    username = 13736661234;
    
    self.uid              = [dic[@"id"] intValue];
    self.age              = [dic[@"age"] intValue];
    self.head_image       = dic[@"head_image"];
    self.head_sub_image   = dic[@"head_sub_image"];
    self.name             = dic[@"name"];
    self.password         = dic[@"password"];
    self.username         = dic[@"username"];
    self.phone_num        = dic[@"phone_num"];
    self.school           = dic[@"school"];
    self.school_code      = dic[@"school_code"] ;
    self.sex              = [dic[@"sex"] intValue];
    self.helloha_id       = dic[@"helloha_id"];
    self.birthday         = dic[@"birthday"];
    self.city             = dic[@"city"];
    self.sign             = dic[@"sign"];
    self.background_image = dic[@"background_image"];
    self.login_token      = dic[@"login_token"];
    self.im_token         = dic[@"im_token"];
    self.iosdevice_token  = dic[@"iosdevice_token"];
    
}

@end
