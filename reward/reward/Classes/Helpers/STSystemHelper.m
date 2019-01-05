//
//  STSystemHelper.m
//  Faith in life
//
//  Created by 王聪 on 16/4/19.
//  Copyright © 2016年 allan. All rights reserved.
//

#import "STSystemHelper.h"
#import "sys/utsname.h"
#import "UUID.h"
#import "Reachability.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation STSystemHelper

+ (NSString *)getDeviceName
{
    NSString *strName = [[UIDevice currentDevice] name];
    
//    NSLog(@"%@",strName);
    return strName;
}

+ (NSString *)getIphoneName
{
    NSString *phoneName = [[UIDevice currentDevice] model];
    
    return phoneName;
}

+ (NSString *)getApp_version
{
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = [NSString stringWithFormat:@"%@", infoDict[@"CFBundleShortVersionString"]];
    return currentVersion;
}

+ (NSString *)getApp_bundleid {
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentBundleId = [NSString stringWithFormat:@"%@", infoDict[@"CFBundleIdentifier"]];
    return currentBundleId;
}

+ (NSString *)getDeviceID
{
//    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    
//    return identifierForVendor;
    
    NSString *gId = [UUID getUUID];
    return gId;
}

// 返回用户ID
+ (NSString *)getUserID
{
//    NSString *uidStr = [NSString stringWithFormat:@"%zd",[DataCenter shareInstance].uid];
//    return uidStr;
    return nil;
}

+ (void)getBatteryMoniter   // 获取系统电量
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIDeviceBatteryLevelDidChangeNotification
     object:nil queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *notification) {
         // Level has changed
         
//         float currentBattery = [UIDevice currentDevice].batteryLevel;
//         
         // 电量在这个区间，尝试发送数据到服务器
//         if (0.50 <= currentBattery <= 0.70) {
//             [STTracker isShouldSend];
//         }
     }];
}


+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

+ (NSString *)iphoneNameAndVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)getDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,2",
                            @"iPhone7,1",
                            @"iPhone8,1",
                            @"iPhone8,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator",
                                @"iPhone Simulator",
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                @"iPhone 6",
                                @"iPhone 6 Plus",
                                @"iPhone 6s",
                                @"iPhone 6s Plus",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    
    //添加的新设备
    if([deviceString isEqualToString:@"iPhone8,4"]) return@"iPhone SE";
    
    if([deviceString isEqualToString:@"iPhone9,1"]) return@"iPhone 7";
    
    if([deviceString isEqualToString:@"iPhone9,2"]) return@"iPhone 7 Plus";
    
    if([deviceString isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([deviceString isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([deviceString isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([deviceString isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([deviceString isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([deviceString isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    
    return modelNameString ? modelNameString : @"iOS";
}


+ (NSString *)getHardParam  // 返回CPU类型
{
    NSMutableString *cpu = [[NSMutableString alloc] init];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_X86)
    {
        [cpu appendString:@"x86 "];
        // check for subtype ...
        
    } else if (type == CPU_TYPE_ARM)
    {
        [cpu appendString:@"ARM"];
        [cpu appendFormat:@",Type:%d",subtype];
    }
    return cpu;
}

+ (NSString *)getTelephonyInfo     // 获取运营商信息
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    
    return mCarrier;
}

+ (NSString *)getIOSID
{
    NSString *strSysName = [[UIDevice currentDevice] systemName];
    return strSysName;
}

+ (NSString *)getiOSSDKVersion
{
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    return strSysVersion;
}


// 获得设备总内存
+ (NSUInteger)getTotalMemoryBytes
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, HW_PHYSMEM};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results/1024/1024;
}

// 异常收集处理
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
}

// 写入异常信息
-(void)writeACrashMessage
{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

// 获取运行中的进程
//+ (NSArray *)getRunningProcesses {
//    
//    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
//    size_t miblen = 4;
//    
//    size_t size;
//    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
//    
//    struct kinfo_proc * process = NULL;
//    struct kinfo_proc * newprocess = NULL;
//    
//    do {
//        
//        size += size / 10;
//        newprocess = realloc(process, size);
//        
//        if (!newprocess){
//            
//            if (process){
//                free(process);
//            }
//            
//            return nil;
//        }
//        
//        process = newprocess;
//        st = sysctl(mib, miblen, process, &size, NULL, 0);
//        
//    } while (st == -1 && errno == ENOMEM);
//    
//    if (st == 0){
//        
//        if (size % sizeof(struct kinfo_proc) == 0){
//            int nprocess = size / sizeof(struct kinfo_proc);
//            
//            if (nprocess){
//                
//                NSMutableArray * array = [[NSMutableArray alloc] init];
//                
//                for (int i = nprocess - 1; i >= 0; i--){
//                    
//                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
//                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
//                    
//                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, nil]
//                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", nil]];
//                    [array addObject:dict];
//                }
//                
//                free(process);
//                return array;
//            }
//        }
//    }
//    
//    
//    return nil;
//}


// 获取网络类型
+(NSString*)getNetworkType
{
        /**
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyGPRS          __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyEdge          __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyWCDMA         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyHSDPA         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyHSUPA         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMA1x        __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMAEVDORev0  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMAEVDORevA  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMAEVDORevB  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyeHRPD         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyLTE           __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     **/
    NSString *netconnType = @"";
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}

//必须在有网的情况下才能获取手机的IP地址
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

// 用于数字转换成万  eg:1.1万
+ (NSString *)getNum:(NSInteger)num{
    NSString *string;
    if (num>10000) {
        return string =[NSString stringWithFormat:@"%ld.%ld万",num/10000,num%10000%10000];
    }else{
        return string =[NSString stringWithFormat:@"%ld",num];
    }
}

#pragma mark -
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


///三个文字一个逗号
+(NSString *)countNumAndChangeformat:(NSString *)num
{
    NSString * string = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:num.longLongValue]
                                                         numberStyle:NSNumberFormatterDecimalStyle];
    return string;
    
    
}

///NSMutableAttributedString
+(NSMutableAttributedString *)attributedContent:(NSString *)content color:(UIColor *)color font:(UIFont *)font{
    if (!content) {
        return [NSMutableAttributedString new];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content?content:@""];
    if (color) {
        str.yy_color = color;
    }
    
    if (font) {
       str.yy_font = font;
    }
    return str;
}



/**
 *   //设备相关信息的获取
 NSString *strName = [[UIDevice currentDevice] name];
 NSLog(@"设备名称：%@", strName);//e.g. "My iPhone"
 
 NSString *strId = [[UIDevice currentDevice] uniqueIdentifier];
 NSLog(@"设备唯一标识：%@", strId);//UUID,5.0后不可用
 
 NSString *strSysName = [[UIDevice currentDevice] systemName];
 NSLog(@"系统名称：%@", strSysName);// e.g. @"iOS"
 
 NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
 NSLog(@"系统版本号：%@", strSysVersion);// e.g. @"4.0"
 
 NSString *strModel = [[UIDevice currentDevice] model];
 NSLog(@"设备模式：%@", strModel);// e.g. @"iPhone", @"iPod touch"
 
 NSString *strLocModel = [[UIDevice currentDevice] localizedModel];
 NSLog(@"本地设备模式：%@", strLocModel);// localized version of model
 */


@end
