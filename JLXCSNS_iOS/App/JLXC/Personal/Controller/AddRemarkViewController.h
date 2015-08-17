//
//  AddRemarkViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/31.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RemarkBlock) (NSString * content);
/*! 增加备注页面*/
@interface AddRemarkViewController : BaseViewController<UITextFieldDelegate>

//群组id
@property (nonatomic, assign) NSInteger frinedId;

////设置回调Block
//- (void)setChangeBlock:(RemarkBlock)block;

@end
