//
//  BaseUILable.m
//  MyTest
//
//  Created by 老邢Thierry on 13-9-27.
//  Copyright (c) 2013年 老邢Thierry. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _fontSize = 16;
        self.font = [UIFont systemFontOfSize:_fontSize];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFontSize:(int)fontSize
{
    self = [super init];
    if (self) {
        // Initialization code
        _fontSize = fontSize;
        self.font = [UIFont systemFontOfSize:_fontSize];
        
    }
    return self;
}

-(void) setFontBold
{
    self.font = [UIFont boldSystemFontOfSize:_fontSize];
}

//调整行间距
-(void)setLineSpace:(int)space
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self text]];
    NSMutableParagraphStyle *paragraphStyle     = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[self text] length])];
    self.attributedText                         = attributedString;
}

@end
