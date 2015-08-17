//
//  ChatRoomModel.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "ChatRoomModel.h"

@implementation ChatRoomModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tagArr = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
