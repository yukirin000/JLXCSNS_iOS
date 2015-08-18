//
//  EwUIButton.h
//  EwChat
//
//  Created by 老邢Thierry on 5/25/14.
//  Copyright (c) 2014 老邢Thierry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface CustomButton : UIButton

@property (nonatomic, assign) CGFloat fontSize;
//附加tag
@property (nonatomic, assign) NSInteger secondTag;

- (id)initWithFontSize:(int)fontSize;

- (void)setFontSize:(CGFloat)fontSize;

@end
