//
//  PlaceHolderTextView.m
//  CustomTextView
//
//  Created by bhczmacmini on 14-12-21.
//  Copyright (c) 2014年 bhcz. All rights reserved.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView
{
    //placeHolder Label
    UILabel * _placeHolderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame andPlaceHolder:(NSString *)placeHolder
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(frame)-20, 20)];
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:15];
        _placeHolderLabel.text = placeHolder;
        [self addSubview:_placeHolderLabel];
        
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

//#pragma mark- placeHolder 使用该控件时需要加上这个代理方法
//- (void)textViewDidChange:(UITextView *)textView
//{
//    
//    if ([textView isKindOfClass:[PlaceHolderTextView class]]) {
//        
//        if (textView.text.length > 0) {
//            [((PlaceHolderTextView *)textView) setPlaceHidden:YES];
//        }else{
//            [((PlaceHolderTextView *)textView) setPlaceHidden:NO];
//        }
//    }
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
