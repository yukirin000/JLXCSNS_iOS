//
//  ImageFilterViewController.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/6/6.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <TuSDK/TuSDK.h>

typedef void(^BackBlock) (void);

@interface ImageFilterViewController : TuSDKPFEditFilterController

//设置完成block
- (void)setBackBlock:(BackBlock)block;

@end
