//
//
//  Created by 李晓航 on 5/26/14.
//  Copyright (c) 2014 李晓航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hexadecimal)

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert andAlpha:(CGFloat)alpha;
@end
