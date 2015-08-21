//
//  ChoiceSchollViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/12.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshViewController.h"

typedef void (^ChoiceSchoolBlock) (NSString * school);

/*! 选择学校*/
@interface ChoiceSchoolViewController : RefreshViewController

//非注册时进入
@property (nonatomic, assign) BOOL notRegister;

//设置选中之后的block
- (void)setChoickBlock:(ChoiceSchoolBlock)block;

@end
