//
//  ChatRoomCell.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomModel.h"

/*! 聊天室cell*/
@interface ChatRoomCell : UITableViewCell


- (void)setContentWithModel:(ChatRoomModel *)model;

@end
