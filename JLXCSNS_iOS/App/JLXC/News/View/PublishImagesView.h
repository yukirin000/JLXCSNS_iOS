//
//  PublishImagesView.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/14.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishImagesView : UIView

- (instancetype)initWithFrame:(CGRect)frame andMaxNum:(NSInteger)num;

- (NSArray *)getImages;

@end
