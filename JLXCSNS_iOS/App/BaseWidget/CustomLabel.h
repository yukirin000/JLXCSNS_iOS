//
//  EwUILabel.h
//  MyTest
//
//  Created by 老邢Thierry on 13-9-27.
//  Copyright (c) 2013年 老邢Thierry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel

@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, assign) NSInteger secondTag;

/**
 * 初始化
 *
 * @param fontSize 字体大小
 */
-(id)initWithFontSize:(int) fontSize;

// 设置字体大小
-(void)setFontSize:(CGFloat)size;

// 设置字体为粗体
-(void)setFontBold;

//调整行间距
-(void)setLineSpace:(int)space;

@end
