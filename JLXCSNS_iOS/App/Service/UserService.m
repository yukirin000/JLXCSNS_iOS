//
//  UserService.m
//  UBaby_iOS
//
//  Created by bhczmacmini on 14-10-27.
//  Copyright (c) 2014年 bhczmacmini. All rights reserved.
//

#import "UserService.h"
#import "DatabaseService.h"
@implementation UserService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [[UserModel alloc] init];
    }
    return self;
}

/*! 返回用户服务单例*/
+ (instancetype)sharedService
{

    static UserService * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserService alloc] init];

    });
    
    return instance;
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    //<3ccd76ea 527d5d04 3b743b4c af4e7993 c811c6ca 65b2837b 8e3d47c7 72f9bd6f>
    //token格式处理
    if ([deviceToken hasPrefix:@"<"]) {
        deviceToken = [deviceToken substringFromIndex:1];
    }
    
    if ([deviceToken hasSuffix:@">"]) {
        deviceToken = [deviceToken substringToIndex:deviceToken.length-1];
    }
    
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    _deviceToken = [deviceToken copy];
    
}

- (void)saveDeviceToken
{
    if (self.deviceToken.length > 1) {
        if ([UserService sharedService].user.uid > 0) {
//            NSString * path = kBindDeviceTokenPath;
//            NSDictionary * parameterDic = @{@"user_id":[NSString stringWithFormat:@"%ld", [UserService sharedService].user.id],
//                                            @"ios_device":self.deviceToken};
//            
//            debugLog(@"%@ %@", path, parameterDic);
//            
//            [NetManager managerPostRequest:path withParameter:parameterDic success:^(NSMutableDictionary *dic) {
//                
//            } failed:^(NSString *err) {
//                debugLog(@"成功失败都无返回值");
//            }];
        }
        
    }
}


//保存数据
- (void)saveAndUpdate
{
    
    //清空
    [self clear];
    NSString * insertSql = [NSString stringWithFormat:@"insert into jlxc_user (id,username,name,helloha_id,sex,phone_num,school,school_code,head_image,head_sub_image,age,birthday,city,sign,background_image,login_token,im_token,iosdevice_token) values ('%ld', '%@', '%@', '%@', '%ld', '%@', '%@', '%@', '%@', '%@', '%ld', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", _user.uid, _user.username, _user.name, _user.helloha_id, _user.sex,_user.phone_num, _user.school, _user.school_code,_user.head_image, _user.head_sub_image,_user.age, _user.birthday, _user.city, _user.sign, _user.background_image, _user.login_token, _user.im_token, _user.iosdevice_token];

    //插入
    [[DatabaseService sharedInstance] executeUpdate:insertSql];

}

//获取缓存数据
- (void)find
{
    //(id,free_count,account,dr_cr,name,sex,passwd,mob_no,mailadd,medical_card,idcard_w,image,role_id,level_id)
    NSString * selectSql = @"select * from jlxc_user Limit 1";
    FMResultSet * rs = [[DatabaseService sharedInstance] executeQuery:selectSql];
    
    while (rs.next) {
        _user.uid              = [[rs stringForColumn:@"id"] integerValue];
        _user.username         = [rs stringForColumn:@"username"];
        _user.name             = [rs stringForColumn:@"name"];
        _user.helloha_id       = [rs stringForColumn:@"helloha_id"];
        _user.sex              = [rs intForColumn:@"sex"];
        _user.phone_num        = [rs stringForColumn:@"phone_num"];
        _user.school           = [rs stringForColumn:@"school"];
        _user.school_code      = [rs stringForColumn:@"school_code"];
        _user.head_image       = [rs stringForColumn:@"head_image"];
        _user.head_sub_image   = [rs stringForColumn:@"head_sub_image"];
        _user.age              = [rs intForColumn:@"age"];
        _user.birthday         = [rs stringForColumn:@"birthday"];
        _user.city             = [rs stringForColumn:@"city"];
        _user.sign             = [rs stringForColumn:@"sign"];
        _user.background_image = [rs stringForColumn:@"background_image"];
        _user.login_token      = [rs stringForColumn:@"login_token"];
        _user.im_token         = [rs stringForColumn:@"im_token"];
        _user.iosdevice_token  = [rs stringForColumn:@"iosdevice_token"];
        
        break;
    }
    
    [rs close];
}

- (void)clear
{
    NSString * deleteSql = @"delete from jlxc_user";
    //清空
    [[DatabaseService sharedInstance] executeUpdate:deleteSql];
}

@end
