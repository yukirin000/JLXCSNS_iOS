//
//  PublishImagesView.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/14.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "PublishImagesView.h"

@interface PublishImagesView()

/* 能显示的最大数量*/
@property (nonatomic, assign) int maxNum;

/* 数据数组*/
@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation PublishImagesView

- (instancetype)initWithFrame:(CGRect)frame andMaxNum:(NSInteger)num
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (NSArray *)getImages
{
    
    return self.dataArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
