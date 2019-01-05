//
//  NSString+StringExtention.m
//  reward
//
//  Created by moli-2017 on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "NSString+StringExtention.h"
#import <CommonCrypto/CommonDigest.h>

#define Md5SecretString      @"2CB3147B-D93C-964B-47AE-EEE448C84E3C"
#define TT_MINUTE 60
#define TT_HOUR   (60 * TT_MINUTE)
#define TT_DAY    (24 * TT_HOUR)
#define TT_2_DAYS (2 * TT_DAY)
#define TT_3_DAYS (3 * TT_DAY)
#define TT_WEEK   (7 * TT_DAY)
#define TT_MONTH  (30.5 * TT_DAY)
#define TT_YEAR   (365 * TT_DAY)

@implementation NSString (StringExtention)
- (CGFloat)mol_getTextHeightWithMaxWith:(CGFloat)maxWidth font:(UIFont *)font
{
    
    CGSize maxS = CGSizeMake(maxWidth, MAXFLOAT);
    CGFloat h = [self boundingRectWithSize:maxS options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
    
    return h;
}

+ (NSString*)mol_md5WithSalt:(NSString *)string
{
    NSString *md5Source = [string stringByAppendingFormat:@"%@",Md5SecretString];
    
    const char *cStr = [md5Source UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString * str = [NSString stringWithFormat:
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ];
    return [str lowercaseString];
}
-(NSString*)mol_md5WithSalt
{
    NSString *md5Source = [self stringByAppendingFormat:@"%@",Md5SecretString];
    
    const char *cStr = [md5Source UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString * str = [NSString stringWithFormat:
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ];
    return [str lowercaseString];
    
}

+ (NSString*)mol_md5WithOrigin:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString * str = [NSString stringWithFormat:
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ];
    
    return [str lowercaseString];
}
- (NSString *)mol_md5WithOrigin
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString * str = [NSString stringWithFormat:
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ];
    
    return [str lowercaseString];
}

// 时间戳
// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)mol_timeWithTimestampString:(NSString *)timestampString formatter:(NSString *)formatterString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterString];
    
    NSTimeInterval time=[timestampString doubleValue] / 1000; //传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSString *currentDateStr = [formatter stringFromDate:detailDate];
    return currentDateStr;
}


+ (NSInteger)mol_timeWithTimeString:(NSString *)timeString formatter:(NSString *)formatterString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterString]; //(@"YYYY-MM-dd hh:mm:ss")设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:timeString];
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}

+ (NSInteger)mol_timeWithCurrentTimestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    return timeSp;
}

+ (NSString *)mol_timeWithCurrentTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    NSString *currentDateStr = [formatter stringFromDate:datenow];
    return currentDateStr;
}

// 消息的时间展示
+ (NSString *)moli_timeGetMessageTimeWithTimestamp:(NSString *)timestamp
{
    NSString *s = [NSString mol_timeWithTimestampString:timestamp formatter:@"yyyy年MM月dd日 HH时mm分ss秒"];
    return [self format:s];
}

/// 评论时间展示
+ (NSString *)getCommentMessageTimeWithTimestamp:(NSString *)timestamp{
    double beTime = [timestamp doubleValue]/1000.0;
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"HH:mm"];
//    [df setDateFormat:@"dd"];
    
//    时间展示规则 1分钟之内 刚刚  1小时内 n分钟之前  1天之内  n小时之前  2天之内 n天之前  大于等于3天且一年之内 n月n日  大于1年  年月日
    if (distanceTime < 60 || beTime <= 0){
        //小于一分钟
        distanceStr = @"刚刚";
    }else if (distanceTime <60*60){
        //时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }else if(distanceTime <24*60*60){
        //时间小于一天
        distanceStr = [NSString stringWithFormat:@"%ld小时前",(long)distanceTime/60/60];
    }else if(distanceTime <2*24*60*60){
        distanceStr =@"昨天";
    }else if(distanceTime >2*24*60*60 && distanceTime <365*24*60*60){
        [df setDateFormat:@"MM月dd日"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy年MM月dd日"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

+ (NSString *)getTimeDownWithBeginTimestamp:(NSString *)timestamp endTimestamp:(NSString *)endTimestamp
{
    // 获取当前的时间戳
    timestamp = [NSString stringWithFormat:@"%ld",[NSString mol_timeWithCurrentTimestamp] *1000];
    double beTime = [timestamp doubleValue]/1000.0;
    double endTime = [endTimestamp doubleValue]/1000.0;
    
    double value = endTime - beTime;
    
    if (value > 0) {
        
        NSInteger day = (long)value/60/60/24;
        NSInteger hour = (long)value/60/60%24;
        NSInteger min = (long)value/60%60;
        
        NSString *str = [NSString stringWithFormat:@"%ld天%ld小时%ld分",(long)day,hour,min];
        
        return str;
        
    }else {
        
        return @"0天0小时0分";
    }
}

/// 获取距悬赏结束展示时间 eg:4天 09:30:12
+ (NSString *)timeGetRewardTimeWithTimestamp:(NSString *)timestamp{
    return [self pleaseInsertEndTime:timestamp];
}


+ (NSString *)pleaseInsertEndTime:(NSString *)time2{
    
    //获取结束时间
    NSString *endTime = [self mol_timeWithTimestampString:time2 formatter:@"YYYY-MM-dd HH:mm:ss"];
    
    // 获取当前时间
    NSString *curTime = [self mol_timeWithCurrentTimeString];
    
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:curTime];
    NSDate *date2 = [formatter dateFromString:endTime];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
//    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    
    if (cmps.day == 0) {
        NSString *str = [NSString stringWithFormat:@"%ld时%ld分%ld秒",cmps.hour,cmps.minute,cmps.second];
        return str;
    }else{
        NSString *str = [NSString stringWithFormat:@"%ld天%ld时%ld分",cmps.day,cmps.hour,cmps.minute];
        return str;
    }
    
    
}


// 文件目录
+ (NSString *)mol_homePath
{
    return NSHomeDirectory();
}

+ (NSString *)mol_appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)mol_documentPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)mol_libraryPreferencesPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
}

+ (NSString *)mol_libraryCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)mol_tmpPath
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

/// 创建NSDocument的文件
+ (NSString *)mol_creatNSDocumentFileWithFileName:(NSString *)name
{
    name = [NSString stringWithFormat:@"%@.plist",name];
    NSString *cach_path = [self mol_documentPath];
    NSString *filename = [cach_path stringByAppendingPathComponent:name];
    
    return filename;
}

///// 判断MOLPLIST下文件是否存在
//+ (BOOL)mol_fileExistNSDocumentWithName:(NSString *)fileName
//{
//    fileName = [NSString stringWithFormat:@"%@.plist",fileName];
//    NSString *cach_path = [self mol_documentPath];
//    NSFileManager* fm = [NSFileManager defaultManager];
//    NSString *filename = [cach_path stringByAppendingPathComponent:fileName];
//    if ([fm fileExistsAtPath:filename]) {
//        return YES;
//    }
//    return NO;
//}

/// 创建MOLPLIST文件夹下的文件
+ (NSString *)mol_creatFileWithFileName:(NSString *)name
{
    name = [NSString stringWithFormat:@"%@.plist",name];
    NSString *cach_path = [self mol_libraryCachePath];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString *dic_path = [cach_path stringByAppendingPathComponent:@"MOLPLIST"];
    if (![fm fileExistsAtPath:dic_path]) {
        [fm createDirectoryAtPath:dic_path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *filename = [dic_path stringByAppendingPathComponent:name];
    
    return filename;
}

/// 判断MOLPLIST下文件是否存在
+ (BOOL)mol_fileExistWithName:(NSString *)fileName
{
    fileName = [NSString stringWithFormat:@"%@.plist",fileName];
    NSString *cach_path = [self mol_libraryCachePath];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString *dic_path = [cach_path stringByAppendingPathComponent:@"MOLPLIST"];
    NSString *filename = [dic_path stringByAppendingPathComponent:fileName];
    if ([fm fileExistsAtPath:filename]) {
        return YES;
    }
    return NO;
}




/**
 *  仿QQ空间时间显示
 *  @param string eg:2015年5月24日 02时21分30秒
 */
+ (NSString *)format:(NSString *)string{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSDate*inputDate = [inputFormatter dateFromString:string];
    //NSLog(@"startDate= %@", inputDate);
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //get date str
    NSString *str= [outputFormatter stringFromDate:inputDate];
    //str to nsdate
    NSDate *strDate = [outputFormatter dateFromString:str];
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    NSDate *endDate = [strDate  dateByAddingTimeInterval: interval];
    //NSLog(@"endDate:%@",endDate);
    NSString *lastTime = [self compareDate:endDate];
    
    return lastTime;
}

+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    //修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    //NSLog(@"nowdate=%@\nolddate = %@",localeDate,date);
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    //今年
    NSString *toYears;
    
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateString isEqualToString:todayString]){
            dateContent = [NSString stringWithFormat:@"%@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else{
            return time2;
        }
    }else{
        return dateString;
    }
}


@end
