//
//  QuestionModel.h
//  UBaby_iOS
//
//  Created by bhczmacmini on 14-11-6.
//  Copyright (c) 2014年 bhczmacmini. All rights reserved.
//

#import <Foundation/Foundation.h>

//1、图片 2、语音 3、视频
enum{
  AttachmentImageType = 1,
  AttachmentVoiceType = 2,
  AttachmentVideoType = 3
};

/*!附件模型*/
@interface AttachmentModel : NSObject

/*!附件id*/
@property (nonatomic, assign) int aid;

/*!附件关联实体id*/
@property (nonatomic, assign) int entity_id;

/*!类型*/
@property (nonatomic, assign) int type;

/*!地址 如果是图片在名字后面加_sub即是缩略图地址*/
@property (nonatomic, copy) NSString * url;

/*!大小*/
@property (nonatomic, assign) float size;

/*!长度 用于音频使用*/
@property (nonatomic, assign) int length;

@end
