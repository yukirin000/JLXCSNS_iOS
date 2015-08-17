//
//  NSString+Encrypt.h
//  EwChat
//
//  Created by Thierry on 9/11/14.
//  Copyright (c) 2014 老邢Thierry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

- (NSString*)MD5;

/**
 *  先加密, 后乱序
 */
- (NSString *)md5Encrypt;

@end


