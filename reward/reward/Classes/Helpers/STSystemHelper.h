//
//  STSystemHelper.h
//  Faith in life
//
//  Created by 王聪 on 16/4/19.
//  Copyright © 2016年 allan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>

@interface STSystemHelper : NSObject

+ (NSString *)getDeviceName;    //获取设备名称

+ (NSString *)getIphoneName;//手机类型

+ (NSString *)getApp_version;   // 获取APP版本号

+ (NSString *)getApp_bundleid;   // 获取APP的BundleID

+ (NSString *)getDeviceID;  // 获取设备ID

+ (NSString *)getUserID;    // 获取用户ID

+ (NSString *)deviceIPAdress;    //  获取IP信息

+ (void)getBatteryMoniter;    // 获取系统电量

+ (NSString *)getCurrentDeviceModel;

+ (NSString *)getDeviceModel;

+ (NSString *)iphoneNameAndVersion; // 获取手机名+系统版本

+ (NSString *)getHardParam;    // 得到硬件参数

+ (NSString *)getTelephonyInfo;     // 获取运营商信息

+ (NSString *)getIOSID;     // 获取IOSID

+ (NSString *)getiOSSDKVersion; // 获取iOS SDK版本

// 获得设备总内存
+ (NSUInteger)getTotalMemoryBytes;

// 获取网络类型
+(NSString*)getNetworkType;

// 用于数字转换成万  eg:1.1万
+ (NSString *)getNum:(NSInteger)num;

#pragma mark -
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color;

///三个文字一个逗号
+(NSString *)countNumAndChangeformat:(NSString *)num;

///NSMutableAttributedString
+(NSMutableAttributedString *)attributedContent:(NSString *)content color:(UIColor *)color font:(UIFont *)font;



@end
