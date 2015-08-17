//
//  ToolsManager.m
//  UBaby_iOS
//
//  Created by bhczmacmini on 14-10-20.
//  Copyright (c) 2014年 bhczmacmini. All rights reserved.
//

#import "ToolsManager.h"
#import "HttpStatus.h"
#import "IMGroupModel.h"
#import "ChineseToPinyinResource.h"

@interface ToolsManager()


@end

@implementation ToolsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //工具类初始化 初始化拼音转换汉字工具 该工具初始化需要0.3S左右的时间 提前初始化
        [ChineseToPinyinResource getInstance];
    }
    return self;
}

/*! 工具类单例*/
+ (instancetype)sharedManager
{
    
    static ToolsManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ToolsManager alloc] init];
        
    });
    
    return instance;
}

#pragma mark- 正则表达式
//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((17[0-9])|(13[0-9])|(14[0-9])|(15[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[_a-zA-Z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

+ (BOOL) validateAlpha:(NSString *)name
{
    NSString *userNameRegex = @"^[_a-zA-Z]{1}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//银行卡
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
//银行卡后四位
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length != 4) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{4})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
//姓名
+ (BOOL) validateName:(NSString *)name
{
    NSString *nicknameRegex = @"([\u4e00-\u9fa5]{2,20})(&middot;[\u4e00-\u9fa5]{2,20})*";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:name];
}

//网站
+ (BOOL) validateWEB:(NSString *)content
{
    NSString *webRegex = @"(https?|ftp|file)+://[^\\s]*";;
    NSPredicate *webPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",webRegex];
    return [webPredicate evaluateWithObject:content];
}

+ (CGSize)getSizeWithContent:(NSString *)content andFontSize:(CGFloat)fontSize andFrame:(CGRect)frame
{
    CGSize size;
    if ([DeviceManager getDeviceSystem] > 7.0) {

        NSMutableParagraphStyle * para = [[NSMutableParagraphStyle alloc] init];
        para.lineBreakMode = NSLineBreakByCharWrapping;
        
        NSDictionary * dic = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                               NSParagraphStyleAttributeName : para};
        CGRect rect = [content boundingRectWithSize:frame.size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
        size = rect.size;
    }else{
        size = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:frame.size  lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return size;
}

+ (NSMutableAttributedString *)stringTransformToAttributedString:(NSString *)string withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    long number = 0.8;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:NSKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [string length])];
    CFRelease(num);
    
    return attributedString;
}

+ (BOOL)isNet
{
    NetworkStatus status = [HttpStatus getNetStatus];
    
    if (status != NotReachable) {
        debugLog(@"有网 status:%ld", (long)status);
        return YES;
    }else {
        debugLog(@"网掉了");
        return NO;
    }
}

/*!
 拼接附件地址
 */
+ (NSString *)completeUrlStr:(NSString *)url
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@", kAttachmentAddr, url];
    
    return urlStr;
}

/*!
    获取通用用户名 ps:IM 推送使用
 */
+ (NSString *)getCommonGroupId:(NSInteger)user_id
{
    return [NSString stringWithFormat:@"%@%ld", JLXC,user_id];
}

/*!
    获取通用聊天室名
 */
+ (NSString *)getChatroomIMId:(NSInteger)chatroom_id
{
    return [NSString stringWithFormat:@"%@%ld", JLXC_CHATROOM,chatroom_id];
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentTime:(NSString*)str
{
    if (str == nil || str.length < 1) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *compareDate = [ToolsManager dateFromString:str];
    NSInteger oldYear = [self getYearOrMonthOrDay:compareDate isDay:NO isMonth:NO isYear:YES];
    NSInteger nowYear = [self getYearOrMonthOrDay:[NSDate date] isDay:NO isMonth:NO isYear:YES];
    
    NSInteger oldDay = [self getYearOrMonthOrDay:compareDate isDay:YES isMonth:NO isYear:NO];
    NSInteger nowDay = [self getYearOrMonthOrDay:[NSDate date] isDay:YES isMonth:NO isYear:NO];
    
    NSString *result;
    if (nowYear-oldYear == 0) {
        NSInteger dayTag = nowDay - oldDay;
        if (dayTag == 0) {
            [dateFormatter setDateFormat: @"HH:mm"];
            result = [dateFormatter stringFromDate:compareDate];
        }else if (dayTag == 1) {
            result = @"昨天";
        }else if (dayTag<7 && dayTag>1) {
            result = [self GetWeekDay:compareDate];
        }else {
            [dateFormatter setDateFormat: @"yy-MM-dd HH:mm"];
            result = [dateFormatter stringFromDate:compareDate];
        }
    }else {
        [dateFormatter setDateFormat: @"yy-MM-dd HH:mm"];
        result = [dateFormatter stringFromDate:compareDate];
    }
    
    return  result;
}

+ (NSInteger)getYearOrMonthOrDay:(NSDate *)date isDay:(BOOL)isDay isMonth:(BOOL)isMonth isYear:(BOOL)isYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:date];
    NSInteger dt = 0;
    if (isYear) {
        dt = [comps year];
    }
    if (isMonth) {
        dt = [comps month];
    }
    if (isDay) {
        dt = [comps day];
    }
    
    return dt;
}

+ (NSString *)GetWeekDay:(NSDate *)inputDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    comps = [calendar components:NSWeekdayCalendarUnit fromDate:inputDate];
    
    NSInteger week = [comps weekday];
    NSString *strWeek = [self getweek:week];
    
    return strWeek;
}

+ (NSString*)getweek:(NSInteger)week
{
    NSString*weekStr=nil;
    if(week==1)
    {
        weekStr=@"星期日";
    }else if(week==2){
        weekStr=@"星期一";
        
    }else if(week==3){
        weekStr=@"星期二";
        
    }else if(week==4){
        weekStr=@"星期三";
        
    }else if(week==5){
        weekStr=@"星期四";
        
    }else if(week==6){
        weekStr=@"星期五";
        
    }else if(week==7){
        weekStr=@"星期六";
        
    }
    return weekStr;
}

+(int)compareTimeDistance:(NSString*)str{
    NSDate *compareDate = [ToolsManager dateFromString:str];
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    return timeInterval;
}

+(NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString andFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: formatter];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+(NSString *)StringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSString *)StringFromDate:(NSDate *)date andFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: formatter];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSString *)timeInterval:(NSString *)time withSecond:(NSTimeInterval)interval
{
    NSDate *Date0 = [self dateFromString:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [dateFormatter stringFromDate:[Date0 initWithTimeInterval:-interval sinceDate:Date0]];
    return str;
}

+ (NSString *)getRemarkOrOriginalNameWithUid:(NSInteger)uid andOriginalName:(NSString *)name
{
    IMGroupModel * group = [IMGroupModel findByGroupId:[ToolsManager getCommonGroupId:uid]];
    if (group == nil) {
        return name;
    }
    NSString * retName = name;
    if (group.groupRemark != nil && group.groupRemark.length > 0) {
        retName = group.groupRemark;
    }
    return retName;
}

+ (NSString *)getUploadImageName
{
    return [NSString stringWithFormat:@"%ld%d.png", [UserService sharedService].user.uid, (int)[NSDate date].timeIntervalSince1970];
}

//切割图片！！！ 没用上
- (UIImage *)cutImage:(UIImage *)image inRect:(CGRect)rect
{
    // 这个函数的返回值是cgImage!
    CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage * retImage = [UIImage imageWithCGImage:cgImage];
    
    return retImage;
}

@end
