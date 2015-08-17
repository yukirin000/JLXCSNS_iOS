//
//  NewsModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/15.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    /*! 自己*/
    NewsTypeMe           = 1,
    /*! 朋友*/
    NewsTypeFriend       = 2,
    /*! 学校*/
    NewsTypeSchool       = 3,
    /*! 朋友的鹏*/
    NewsTypeFriendFriend = 4,
    /*! 区*/
    NewsTypeDistrict     = 5,
    /*! 城市*/
    NewsTypeCity         = 6
};

/*! 发送状态的模型*/
@interface NewsModel : NSObject

/*! 该条状态的id*/
@property (nonatomic, assign) NSInteger nid;

/*! 用户Id*/
@property (nonatomic, assign) NSInteger uid;

/*! 用户昵称*/
@property (nonatomic, copy) NSString * name;

/*! 头像*/
@property (nonatomic, copy) NSString * head_image;

/*! 头像缩略图*/
@property (nonatomic, copy) NSString * head_sub_image;

/*! 所在学校*/
@property (nonatomic, copy) NSString * school;

/*! 所在学校代码*/
@property (nonatomic, copy) NSString * school_code;

/*! 消息体*/
@property (nonatomic, copy) NSString * content_text;

/*! 是否拥有图片*/
@property (nonatomic, assign) BOOL has_picture;

/*! 是否拥有录像*/
@property (nonatomic, assign) BOOL has_video;

/*! 是否拥有声音*/
@property (nonatomic, assign) BOOL has_voice;

/*! 地址*/
@property (nonatomic, copy) NSString * location;

/*! 评论次数*/
@property (nonatomic, assign) NSInteger comment_quantity;

/*! 浏览次数*/
@property (nonatomic, assign) NSInteger browse_quantity;

/*! 点赞次数*/
@property (nonatomic, assign) NSInteger like_quantity;

/*! 发布日期*/
@property (nonatomic, copy) NSString * publish_date;

/*! 发布时间戳*/
@property (nonatomic, copy) NSString * publish_time;

/*! 图片数组*/
@property (nonatomic, strong) NSMutableArray * image_arr;

/*! 评论数组*/
@property (nonatomic, strong) NSMutableArray * comment_arr;

/*! 点赞数组*/
@property (nonatomic, strong) NSMutableArray * like_arr;

/*! 是否点过赞*/
@property (nonatomic, assign) BOOL is_like;

/*! 类型字典*/
@property (nonatomic, strong) NSDictionary * typeDic;

- (void)setContentWithDic:(NSDictionary *)newsDic;

@end
