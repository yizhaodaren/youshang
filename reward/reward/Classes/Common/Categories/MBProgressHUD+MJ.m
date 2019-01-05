//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)

static char _hudSuperChar;

- (void)setHudSuperView:(UIView *)hudSuperView
{
    objc_setAssociatedObject(self, &_hudSuperChar, hudSuperView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView*)hudSuperView
{
    return objc_getAssociatedObject(self, &_hudSuperChar);
}


#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    [self show:text icon:icon view:view isNew:NO];
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view isNew:(BOOL)isNew
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //    hud.labelText = text;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    hud.centerX = view.centerX;
    hud.centerY = view.centerY;
//    hud.yOffset = -50;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
    hud.contentColor = [UIColor whiteColor];

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:1.5];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showError:(NSString *)error toView:(UIView *)view isNew:(BOOL)isNew{
    [self show:error icon:@"error.png" view:view isNew:isNew];
}

+ (void)showBang:(NSString *)bang toView:(UIView *)view{
    [self show:bang icon:@"th.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    if (view == nil) view = [[[UIApplication sharedApplication] delegate] window];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.dimBackground = NO;
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
    hud.contentColor = [UIColor whiteColor];

    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showBang:(NSString *)bang
{
    [self showBang:bang toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    if (view == nil) view = [[[UIApplication sharedApplication] delegate] window];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

// 既不是成功也不是失败 单纯的显示一些信息，2秒后自动消失
+ (MBProgressHUD *)showMessageAMoment:(NSString *)message
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.detailsLabel.text = message;

    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
    hud.contentColor = [UIColor whiteColor];

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:1.5];
    return hud;
}

+ (MBProgressHUD *)showLogoInView:(UIView *)view
{
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
    hud.contentColor = [UIColor whiteColor];
//    UIImageView *imageview = [[UIImageView alloc] init];
//    NSMutableArray *images = [NSMutableArray array];
//    for (int i = 0; i<8; i++) {
//        NSString *imagename = [NSString stringWithFormat:@"%d",i+1];
//        UIImage *image = [UIImage imageNamed:imagename];
//        [images addObject:image];
//    }
//    imageview.animationImages = images;
//    imageview.animationDuration = 1.f;
//    imageview.animationRepeatCount = 0;
//    imageview.frame = CGRectMake(0, 0, 70, 70);
//    imageview.centerX = ScreenSize.width * 0.5;
//    imageview.centerY = ScreenSize.height * 0.5;
//    hud.customView = imageview;
    [hud showAnimated:YES];
//    [imageview startAnimating];
    return hud;

}
@end
