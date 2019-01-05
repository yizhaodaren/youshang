//
//  CommUtls.m
//  reward
//
//  Created by apple on 2018/9/7.
//  Copyright © 2018年 reward. All rights reserved.
//
#import "CommUtls.h"
#import <CommonCrypto/CommonDigest.h>
@implementation CommUtls

/**
 *    @brief    获取颜色
 *
 *    @param     stringToConvert     取色数值
 *
 *    @return    返回颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(NSString *)getDeviceBounds
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    if (rect.size.width ==480||rect.size.height ==480) {
        return @"4";
    }else if (rect.size.width==568||rect.size.height ==568)
    {
        return @"5";
        
    }else if (rect.size.width==667||rect.size.height ==667)
    {
        return @"6";
        
    }else if (rect.size.width==736||rect.size.height ==736)
    {
        return @"6p";
        
    }
    
    return nil;
    
    
}

//图片尺寸处理
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (NSURL *)getURLFromString:(NSString *)str
{
    NSURL *url =[[NSURL alloc]initWithString:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    return url;
}

/*
 判断JSon解析出来的Object是否为NSNull类型
 输入参数：需要判断的Object
 输出参数：返回一个经过格式化的NSString类型
 */
+(NSString *)checkNullValueForString:(id)object
{
    if([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if(!object)
    {
        return @"";// (NSString *)object;
    }
    else
    {
        return [NSString stringWithFormat:@"%@",object];// (NSString *)object;
    }
}


+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     * 小米:   170,171,172
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[0-9])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    
    NSString * MI = @"^1(7[0-6]|5[256]|8[56])\\d{8}$";
    /**
     30         *小米虚拟China MI
     31         * 170...176
     32         */
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestctmi = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MI];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        ||([regextestctmi evaluateWithObject:mobileNum] ==YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//检测网址是否合法
+(BOOL)isValidateURL:(NSString *)url
{
    BOOL isValidate = YES;
    // http://www.youzhu.com/Public/Uploads/App/2016-04/5720565f16ca7.png
    NSArray *paths = [url componentsSeparatedByString:@":"];
    if ([paths count]>=2)
    {
        NSString *http = [paths objectAtIndex:0];
        if ([http isEqualToString:@"http"]||[http isEqualToString:@"https"])
        {
            isValidate=YES;
        }
        else
        {
            isValidate=NO;
        }
    }else
    {
        isValidate=NO;
    }
    return isValidate;
    
}
+(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

+(void)telePhone
{
    NSString *number = @"4009966566";// 此处读入电话号码
    // NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    
    //    使用这种方式拨打电话时，当用户结束通话后，iphone界面会停留在电话界面。
    //    用如下方式，可以使得用户结束通话后自动返回到应用：
    //    UIWebView*callWebview =[[UIWebView alloc] init];
    //    NSURL *telURL =[NSURL URLWithString:@"tel:10086"];// 貌似tel:// 或者 tel: 都行
    //    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //    //记得添加到view上
    //    [self.view addSubview:callWebview];
}

//- (void) dialPhoneNumber:(NSString *)aPhoneNumber
//{
//    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
//    if ( !phoneCallWebView ) {
//        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    }
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
//}


+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSString *)timeConvertoString:(NSString *)time{//时间戳转换成时间
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:ss"];
    NSString *regStr = [df stringFromDate:dt];
    return regStr;
}

+ (NSString *)getSha1String:(NSString *)srcString{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

+(NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)input,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    return
    outputStr;
}

+(NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,
                                                      [outputStr length])];
    NSString *encode2=   [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return encode2;
    
}
+ (NSString *)toJSONData:(id)theData{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:theData
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
    
}
//当前时间的几天后
+ (NSString *)theDateAfterDays:(NSInteger)day{
    NSDate *date = [NSDate date];
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 * day sinceDate:date];//后一天
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *regStr = [df stringFromDate:nextDay];
    
    return regStr;
}
+ (NSString *)theIntervalDateAfterDays:(NSInteger)day{
    NSDate *date = [NSDate date];
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 * day sinceDate:date];//后一天

    NSTimeInterval tn = [nextDay timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%.0f",tn * 1000];
}

#pragma mark - 时间戳 转 时间 ／解决8小时问题
+(NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp
{
    
    
    double publishLong = [timestamp doubleValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    publishDate = [publishDate  dateByAddingTimeInterval: interval];
    
    NSString *publishString = [formatter stringFromDate:publishDate];
    
    return publishString;
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

// 获取当前最上层的控制器
+(UIViewController *)topViewController {
    UIViewController *resultVC;
    
    
    resultVC = [CommUtls _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [CommUtls _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+(UIViewController *)_topViewController:(UIViewController *)vc{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
//打印字体的类型
+(void)showFontType{
    NSArray * familyNames = [UIFont familyNames];
    for(NSString *  familyName in familyNames)
    {
        NSLog(@"%@", familyName);
        NSArray  * fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString * fontName in fontNames)
        {
            //  NSLog(@"\t%@", fontName);
            printf("%s\n",[fontName UTF8String]);
        }
    }
    
//    设置字体
//      _titleLable.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:24];
}
//把秒转换成 分秒 03:45
+(NSString *)convertToMSStringWithS:(NSTimeInterval)time{
    NSInteger min = time / 60;
    NSInteger sec =(NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
    
}

// 获得Info.plist数据字典
+(NSDictionary *)getInfoDictionary {
    NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
    if (!infoDict || !infoDict.count) {
        infoDict = [NSBundle mainBundle].infoDictionary;
    }
    if (!infoDict || !infoDict.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return infoDict ? infoDict : @{};
}
//获取网络状态
+(NSString *)getNetworkType{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSString *statue;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
            statue = @"无服务";
            break;
            
        case 1:
            NSLog(@"2G");
            statue =@"2G";
            break;
            
        case 2:
            NSLog(@"3G");
            statue=@"3G";
            break;
            
        case 3:
            NSLog(@"4G");
            statue=@"4G";
            break;
            
        case 4:
            NSLog(@"LTE");
            statue=@"LTE";
            break;
            
        case 5:
            NSLog(@"Wifi");
            statue=@"Wifi";
            break;
            
            
        default:
            statue=@"未获取到";
            break;
    }
    return statue;
}
#pragma mark 获取运营商的名称
+(NSString *)getCarrierName{
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    NSString *mobile;
    if (!carrier.isoCountryCode) {
        mobile = @"没卡";
    }else{
        mobile = [carrier carrierName];
    }
    return mobile;
}
//改变图片的颜色
+(UIImage *)Chanage:(UIImage *)image WithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
// 获取视频／音频文件的总时长
+ (CGFloat)getFileDuration:(NSURL*)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:URL options:opts];
    
    CMTime duration = asset.duration;
    float durationSeconds = CMTimeGetSeconds(duration);
    
    return durationSeconds;
}
// 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
