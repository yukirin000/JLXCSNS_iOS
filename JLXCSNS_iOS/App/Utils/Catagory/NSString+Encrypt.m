//
//  NSString+Encrypt.m
//  EwChat
//
//  Created by Thierry on 9/11/14.
//  Copyright (c) 2014 老邢Thierry. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encrypt)

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

/**
 *  先加密, 后乱序
 */
- (NSString *)md5Encrypt
{
    NSString *encrypt = [self MD5];
    encrypt = [self disorder:encrypt];
    return encrypt;
//    return self;
}

/**
 *  乱序，再MD5
 */
-(NSString *)disorder:(NSString *)str
{
    NSString *header = [str substringToIndex:4];
    NSString *footer = [str substringFromIndex:4];
    return [[footer stringByAppendingString:header] MD5];
}


@end
