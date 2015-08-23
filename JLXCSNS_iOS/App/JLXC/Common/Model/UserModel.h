//
//  UserModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/12.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

//0男 1女 2不知道
enum{
    SexBoy  = 0,
    SexGirl = 1,
    SexNone = 2
};

/*! 用户模型*/
@interface UserModel : NSObject

/*! 用户id*/
@property (nonatomic, assign) NSInteger uid;

/*! 用户名*/
@property (nonatomic, copy) NSString * username;

/*! 密码*/
@property (nonatomic, copy) NSString * password;

/*! helloha_id*/
@property (nonatomic, copy) NSString * helloha_id;

/*! 姓名*/
@property (nonatomic, copy) NSString * name;

/*! 电话号*/
@property (nonatomic, copy) NSString * phone_num;

/*! 姓别 0男 1女 2不知道*/
@property (nonatomic, assign) NSInteger sex;

/*! 学校*/
@property (nonatomic, copy) NSString * school;

/*! 学校编码*/
@property (nonatomic, copy) NSString * school_code;

/*! 头像地址*/
@property (nonatomic, copy) NSString * head_image;

/*! 头像缩略图地址*/
@property (nonatomic, copy) NSString * head_sub_image;

/*! 年龄*/
@property (nonatomic, assign) NSInteger age;

/*! 生日*/
@property (nonatomic, copy) NSString * birthday;

/*! 城市*/
@property (nonatomic, copy) NSString * city;

/*! 签名*/
@property (nonatomic, copy) NSString * sign;

/*! 背景图片*/
@property (nonatomic, copy) NSString * background_image;

/*! 登录token*/
@property (nonatomic, copy) NSString * login_token;

/*! 融云im_token*/
@property (nonatomic, copy) NSString * im_token;

/*! ios设备token*/
@property (nonatomic, copy) NSString * iosdevice_token;

- (void)setModelWithDic:(NSDictionary *)dic;

@end
