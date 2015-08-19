//
//  InformationChangeViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ChangeBlock) (NSString * content);

@interface InformationChangeViewController : BaseViewController<UITextFieldDelegate>

//0姓名 1签名
@property (nonatomic, assign) NSInteger changeType;

//原内容
@property (nonatomic, copy) NSString * content;

//设置回调Block
- (void)setChangeBlock:(ChangeBlock)block;

@end
