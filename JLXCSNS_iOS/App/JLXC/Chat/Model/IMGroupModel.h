//
//  IMGroupModel.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/27.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

enum {
    /*! 群组已添加 */
    GroupHasAdd = 1,
    /*! 群组未添加 */    
    GroupNotAdd = 0
};

/*! 自助管理IM组*/
@interface IMGroupModel : NSObject

/*!
 @property
 @brief 群组ID 就是targetID
 */
@property (nonatomic, copy) NSString *groupId;

/*!
 @property
 @brief 群组的标题
 */
@property (nonatomic, copy) NSString *groupTitle;

/*!
 @property
 @brief 群组的备注
 */
@property (nonatomic, copy) NSString * groupRemark;

/*!
 @property
 @brief 会话群类型
 */
@property (nonatomic,assign) int type;

/*!
 @property
 @brief 当前的状态 0是已添加 1是未添加
 */
@property (nonatomic,assign) int currentState;

/*!
 @property
 @brief 是否已读 未读的在新的列表按钮上有提示
 */
@property (nonatomic,assign) BOOL isRead;

/*!
 @property
 @brief 是否是新的 新的在新朋友里能查询出来
 */
@property (nonatomic,assign) BOOL isNew;

/*!
 @property
 @brief 会话群头像
 */
@property (nonatomic,copy) NSString *avatarPath;

/*!
 @property
 @brief 所有者
 */
@property (nonatomic,assign) NSInteger owner;


/*!
 @property
 @brief 添加时间 暂时只用于存储 对方推送过来的添加时间
 */
@property (nonatomic,copy) NSString * addDate;


/**
 * 保存聊天历史的数据
 *
 * @param userNames 该聊天群对应的联系人列表
 */
- (void)save;

/**
 *删除表中数据
 **/
+ (void)deleteData;

/**
 * 更新聊天群组
 */
- (void)update;

/**
 * 删除聊群组
 */
- (void)remove;

/**
 * 从数据库中查出所有的群组
 *
 * @return NSMutableArray 数据
 */
+ (NSMutableArray *)findAll;

/**
 * 从数据库中查出前三个好友
 *
 * @return NSMutableArray 数据
 */
+ (NSMutableArray *)findCoverThree;

/**
 * 从数据库中查出所有已经添加的群组 (好友列表)
 * #########取全部数量先从这里取 以后优化###############
 * @return NSMutableArray 数据
 */
+ (NSMutableArray *)findHasAddAll;


/**
 * 从数据库中查出新的朋友群组 最近的三条没有被添加的人
 *
 * @return NSMutableArray 数据
 */
+ (NSMutableArray *)findThreeNewFriends;

/**
 * 从数据库中查出全部新的朋友群组
 *
 * @return NSMutableArray 数据
 */
+ (NSMutableArray *)findAllNewFriends;

/**
 * @return NSInteger 数字
 */
+ (NSInteger)unReadNewFriendsCount;

/**
 * !
 * @brief将所有未读设置为已读
 *
 */
+ (void)hasRead;


/**
 * 更新群ID找到群组
 *
 * @param groupId
 */
+ (IMGroupModel *)findByGroupId:(NSString *)groupId;


@end
