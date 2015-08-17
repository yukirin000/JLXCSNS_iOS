//
//  ChoiceLocationViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/14.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "RefreshViewController.h"

typedef void (^ChoiceLocationBlock) (NSString * str);

/*! 选择地理位置*/
@interface ChoiceLocationViewController : RefreshViewController

//设置选中之后的block
- (void)setChoickBlock:(ChoiceLocationBlock)block;

@end
