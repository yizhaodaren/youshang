//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)

@property (strong, nonatomic) UIView* hudSuperView;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view isNew:(BOOL)isNew;
+ (void)showBang:(NSString *)bang toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showBang:(NSString*)bang;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
/**
 *  既不是成功也不是失败 单纯的显示一些信息，2秒后自动消失
 */
+ (MBProgressHUD *)showMessageAMoment:(NSString *)message;
/**
 *  展示logo 动画 消失动画请remove
 */
+ (MBProgressHUD *)showLogoInView:(UIView *)view;


@end
