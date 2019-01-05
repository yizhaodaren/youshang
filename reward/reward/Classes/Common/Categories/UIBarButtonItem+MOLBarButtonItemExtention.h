//
//  UIBarButtonItem+MOLBarButtonItemExtention.h
//  aletter
//
//  Created by moli-2017 on 2018/7/31.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MOLBarButtonItemExtention)
/// 设置自定义view
+ (UIBarButtonItem *)mol_barButtonItemWithCustomTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font imageName:(NSString *)imageName targat:(id)targat action:(SEL)action imageTitleStyle:(ButtonImageTitleStyle)ImageTitleStyle;

/// 设置图片按钮
+ (UIBarButtonItem *)mol_barButtonItemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName targat:(id)targat action:(SEL)action;

/// 设置文字按钮
+ (UIBarButtonItem *)mol_barButtonItemWithTitleName:(NSString *)titleName targat:(id)targat action:(SEL)action;

/// 设置文字按钮(自定义颜色)
+ (UIBarButtonItem *)mol_barButtonItemWithTitleName:(NSString *)titleName
                                              color:(UIColor *)color
                                       disableColor:(UIColor *)disableColor
                                               font:(UIFont *)font
                                             targat:(id)targat
                                             action:(SEL)action;

/// 设置多文字按钮
+ (NSArray *)mol_barButtonItemWithTitleNames:(NSArray *)titleNames targat:(id)targat actions:(NSArray *)actions;

/// 设置多文字按钮(自定义颜色)
+ (NSArray *)mol_barButtonItemWithTitleNames:(NSArray *)titleNames
                                       color:(UIColor *)color
                                        font:(UIFont *)font
                                      targat:(id)targat
                                     actions:(NSArray *)actions;

@end
