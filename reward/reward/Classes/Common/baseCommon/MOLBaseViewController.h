//
//  MOLBaseViewController.h
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//
typedef NS_ENUM(NSInteger, UIBehaviorTypeStyle) {
    UIBehaviorTypeStyle_Normal,     //初始化
    UIBehaviorTypeStyle_Refresh,    //下拉刷新
    UIBehaviorTypeStyle_More,        //上拉加载更多
};

#import <UIKit/UIKit.h>

@interface MOLBaseViewController : UIViewController
@property (nonatomic, assign) BOOL showNavigationLine;
@property (nonatomic, assign) BOOL showNavigation;

- (void)leftBackAction;

- (void)basevc_setNavLeftItemWithTitle:(NSString *)title titleColor:(UIColor *)color;
- (void)basevc_setCenterTitle:(NSString *)title titleColor:(UIColor *)color;

// 显示loading
- (void)basevc_showLoading;
// 隐藏loading
- (void)basevc_hiddenLoading;
// 展示空白页
- (void)basevc_showBlankPageWithY:(CGFloat)localY image:(NSString *)image title:(NSString *)title superView:(UIView *)view;
// 网络请求失败
- (void)basevc_showErrorPageWithY:(CGFloat)localY select:(SEL)select superView:(UIView *)view;

// 隐藏失败
- (void)basevc_hiddenErrorView;
@end
