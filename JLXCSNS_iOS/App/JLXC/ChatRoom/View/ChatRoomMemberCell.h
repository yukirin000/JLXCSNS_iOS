//
//  ChatRoomMemberCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/13.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomPersonalModel.h"

#define NOTIFY_DELETE_MEMBER @"deleteMember"

//聊天室成员cell
@interface ChatRoomMemberCell : UICollectionViewCell

//设置内容model
- (void)setContentWithModel:(ChatRoomPersonalModel *)model;

//设置点击删除按钮后的'点击删除'按钮状态
- (void)setIsDelete:(BOOL)isDelete;

@end
