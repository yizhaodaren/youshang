//
//  MOLSystemManager.m
//  aletter
//
//  Created by moli-2017 on 2018/8/13.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLSystemManager.h"
#include <sys/sysctl.h>

@implementation MOLSystemManager


#pragma mark sysctlbyname utils
+ (NSString *)getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

#pragma mark platform information
+ (NSString *)platform
{
    return [self getSysInfoByName:"hw.machine"];
}
/// 获取手机平台（模拟机、真机、ipad等）
+ (NSUInteger)system_platformType
{
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])            return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])            return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])            return UIDevice4SiPhone;
    if ([platform hasPrefix:@"iPhone5,3"])          return UIDevice5CiPhone;
    if ([platform hasPrefix:@"iPhone5,4"])          return UIDevice5CiPhone;
    if ([platform hasPrefix:@"iPhone5"])            return UIDevice5iPhone;
    if ([platform hasPrefix:@"iPhone6"])            return UIDevice5SiPhone;
    if ([platform hasPrefix:@"iPhone7,1"])          return UIDevice6PiPhone;
    if ([platform hasPrefix:@"iPhone7,2"])          return UIDevice6iPhone;
    if ([platform hasPrefix:@"iPhone8,1"])          return UIDevice6SiPhone;
    if ([platform hasPrefix:@"iPhone8,2"])          return UIDevice6SPiPhone;
    if ([platform hasPrefix:@"iPhone8,4"])          return UIDeviceSE;
    if ([platform hasPrefix:@"iPhone9,1"])          return UIDevice7iPhone;
    if ([platform hasPrefix:@"iPhone9,2"])          return UIDevice7PiPhone;
    if ([platform hasPrefix:@"iPhone9,3"])          return UIDevice7iPhone;
    if ([platform hasPrefix:@"iPhone9,4"])          return UIDevice7PiPhone;
    if ([platform hasPrefix:@"iPhone10,1"])         return UIDevice8iPhone;
    if ([platform hasPrefix:@"iPhone10,2"])         return UIDevice8PiPhone;
    if ([platform hasPrefix:@"iPhone10,4"])         return UIDevice8iPhone;
    if ([platform hasPrefix:@"iPhone10,5"])         return UIDevice8PiPhone;
    if ([platform hasPrefix:@"iPhone10,3"])         return UIDeviceiPhoneX;
    if ([platform hasPrefix:@"iPhone10,6"])         return UIDeviceiPhoneX;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return UIDevice4GiPod;
    if ([platform hasPrefix:@"iPod5"])              return UIDevice5GiPod;
    if ([platform hasPrefix:@"iPod6"])              return UIDevice6GiPod;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2,5"])            return UIDevice1GiPadmini;
    if ([platform hasPrefix:@"iPad2,6"])            return UIDevice1GiPadmini;
    if ([platform hasPrefix:@"iPad2,7"])            return UIDevice1GiPadmini;
    if ([platform hasPrefix:@"iPad2"])              return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])              return UIDevice3GiPad;
    if ([platform hasPrefix:@"iPad4,4"])            return UIDevice2GiPadmini;
    if ([platform hasPrefix:@"iPad4,5"])            return UIDevice2GiPadmini;
    if ([platform hasPrefix:@"iPad4,6"])            return UIDevice2GiPadmini;
    if ([platform hasPrefix:@"iPad4,7"])            return UIDevice3GiPadmini;
    if ([platform hasPrefix:@"iPad4,8"])            return UIDevice3GiPadmini;
    if ([platform hasPrefix:@"iPad4,9"])            return UIDevice3GiPadmini;
    if ([platform hasPrefix:@"iPad4"])              return UIDevice4GiPad;
    if ([platform hasPrefix:@"iPad5,1"])            return UIDevice4GiPadmini;
    if ([platform hasPrefix:@"iPad5,2"])            return UIDevice4GiPadmini;
    if ([platform hasPrefix:@"iPad5"])              return UIDevice5GiPad;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}
@end
