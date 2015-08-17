//
//  ChatRoomDetailViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/9.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatRoomModel.h"

/*! 聊天室详情页面*/
@interface ChatRoomDetailViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

//聊天室模型
@property (nonatomic, strong) ChatRoomModel * chatRoomModel;

//已加入标示
@property (nonatomic, assign) BOOL hasJoin;

@end
