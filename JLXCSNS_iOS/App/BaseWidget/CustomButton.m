//
//  EwUIButton.m
//  EwChat
//
//  Created by 老邢Thierry on 5/25/14.
//  Copyright (c) 2014 老邢Thierry. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _fontSize = 16;
        self.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    }
    return self;
}

- (id)initWithFontSize:(int)fontSize
{
    self       = [super init];
    if (self) {
        // Initialization code
        _fontSize       = fontSize;
        self.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
}

@end
