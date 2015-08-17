//
//  NSString+Expand.m
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/22.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#import "NSString+Expand.h"
#import "PinYin4Objc.h"
@implementation NSString (Expand)

- (NSString *)trim
{
    NSCharacterSet * CharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    
    return [self stringByTrimmingCharactersInSet:CharacterSet];
}

- (NSString *)hanziZhuanPinYin
{

    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:self withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    
    return outputPinyin;
}

@end
