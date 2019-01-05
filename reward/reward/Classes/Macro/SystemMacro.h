//
//  SystemMacro.h
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#ifndef SystemMacro_h
#define SystemMacro_h

//****************************** 系统 ***************************** //
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS11 (SYSTEM_VERSION >= 11.0)?YES:NO
#define iOS10 (SYSTEM_VERSION >= 10.0)?YES:NO
#define iOS9 (SYSTEM_VERSION >= 9.0)?YES:NO
#define iOS8 (SYSTEM_VERSION >= 8.0)?YES:NO
#define iOS7 (SYSTEM_VERSION >= 7.0)?YES:NO
#define iOS6 (SYSTEM_VERSION >= 6.0)?YES:NO

//****************************** 设备类型 ***************************** //
#define iPhoneX   ((MOL_SCREEN_HEIGHT>=812)?YES:NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iTouch ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ((MOL_SCREEN_WIDTH==414)?YES:NO)
#define iPhone6   ((MOL_SCREEN_WIDTH==375)?YES:NO)
#define iPhone320 ((MOL_SCREEN_WIDTH==320)?YES:NO)
#define iPhone4 ((MOL_SCREEN_HEIGHT==480)?YES:NO)


//****************************** 屏幕 ***************************** //
// 尺寸适配
#define MOL_SCREEN_ADAPTER(w) lrintf(1.0*MOL_SCREEN_WIDTH/375.0f*(w))
//屏幕宽度
#define MOL_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
// 屏幕高
#define MOL_SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
// 比例
#define MOL_SCREEN_SCALE      ([UIScreen mainScreen].scale)
//适配（以iPhone6为基准传入高，得出当前设备应该有的高度）
#define MOL_SCALEHeight(height)  ((height) *MOL_SCREEN_WIDTH/375.0f)
#define MOL_SCALEWidth(width) ((width) *MOL_SCREEN_WIDTH/375.0f)


// 状态栏

#define MOL_STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height  // 状态栏高度

// Status bar height.
#define  MOL_StatusBarHeight      (iPhoneX ? 44.f : 20.f)
// Navigation bar height.
#define  MOL_NavigationBarHeight  44.f
// Tabbar height.
#define  MOL_TabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define  MOL_TabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
// Status bar & navigation bar height.
#define  MOL_StatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)

// 常用宏
#define MOLAppDelegateWindow [UIApplication sharedApplication].delegate.window

#define MOL_IOS @"iOS"
#define MOL_APPStore @"App Store"


//字体
#define MOL_FONT(f)   [UIFont systemFontOfSize:(f)]
#define MOL_LIGHT_FONT(size) [UIFont mol_systemFontOfSize:size fontWithName:@"PingFangSC-Light"]
#define MOL_REGULAR_FONT(size) [UIFont mol_systemFontOfSize:size fontWithName:@"PingFangSC-Regular"]
#define MOL_MEDIUM_FONT(size) [UIFont mol_systemFontOfSize:size fontWithName:@"PingFangSC-Medium"]

#endif /* SystemMacro_h */
