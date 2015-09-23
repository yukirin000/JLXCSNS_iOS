//
//  PlaceHolderTextView.m
//  CustomTextView
//
//  Created by bhczmacmini on 14-12-21.
//  Copyright (c) 2014年 bhcz. All rights reserved.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _placeHolderLabel           = [[UILabel alloc] init];
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.font      = [UIFont systemFontOfSize:15];
        [self addSubview:_placeHolderLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andPlaceHolder:(NSString *)placeHolder
{
    self = [self init];
    if (self) {
        self.frame              = frame;
        _placeHolderLabel.frame = CGRectMake(5, 5, CGRectGetWidth(frame)-20, 20);
        _placeHolderLabel.text  = placeHolder;
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    if (text.length > 0) {
        _placeHolderLabel.hidden = YES;
    }else{
        _placeHolderLabel.hidden = NO;
    }
    
    [super setText:text];
}

- (void)setPlaceHidden:(BOOL)hidden
{
    _placeHolderLabel.hidden = hidden;
}

- (void)contentChange:(NSNotification *)notify
{
        
    if (self.text.length > 0) {
        [self setPlaceHidden:YES];
    }else{
        [self setPlaceHidden:NO];
    }
    
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolderLabel.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame)-20, 20);
    _placeHolderLabel.text = placeHolder;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
