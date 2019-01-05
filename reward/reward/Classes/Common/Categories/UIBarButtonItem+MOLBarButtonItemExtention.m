//
//  UIBarButtonItem+MOLBarButtonItemExtention.m
//  aletter
//
//  Created by moli-2017 on 2018/7/31.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "UIBarButtonItem+MOLBarButtonItemExtention.h"

@implementation UIBarButtonItem (MOLBarButtonItemExtention)

/// 设置自定义view
+ (UIBarButtonItem *)mol_barButtonItemWithCustomTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font imageName:(NSString *)imageName targat:(id)targat action:(SEL)action imageTitleStyle:(ButtonImageTitleStyle)ImageTitleStyle
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = font;
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button addTarget:targat action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    [button mol_setButtonImageTitleStyle:ImageTitleStyle padding:3];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    item.imageInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    return item;
}

/// 设置图片按钮
+ (UIBarButtonItem *)mol_barButtonItemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName targat:(id)targat action:(SEL)action
{
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:targat action:action];
    item.imageInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    return item;
}

/// 设置文字按钮
+ (UIBarButtonItem *)mol_barButtonItemWithTitleName:(NSString *)titleName targat:(id)targat action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:titleName style:UIBarButtonItemStyleDone target:targat action:action];
    item.tintColor = HEX_COLOR(0xFFEC00);
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : HEX_COLOR_ALPHA(0xffffff, 0.7)} forState:UIControlStateDisabled];
    return item;
}

/// 设置文字按钮(自定义颜色)
+ (UIBarButtonItem *)mol_barButtonItemWithTitleName:(NSString *)titleName
                                              color:(UIColor *)color
                                       disableColor:(UIColor *)disableColor
                                               font:(UIFont *)font
                                             targat:(id)targat
                                             action:(SEL)action;
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:titleName style:UIBarButtonItemStyleDone target:targat action:action];
    item.tintColor = color;
    [item setTitleTextAttributes:@{NSFontAttributeName : font} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : disableColor} forState:UIControlStateDisabled];
    return item;
}


/// 设置多文字按钮
+ (NSArray *)mol_barButtonItemWithTitleNames:(NSArray *)titleNames targat:(id)targat actions:(NSArray *)actions
{
    if (titleNames.count != actions.count) {
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < titleNames.count; i++) {
        NSString *name = titleNames[i];
        NSString *action = actions[i];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStyleDone target:targat action:NSSelectorFromString(action)];
        item.tintColor = HEX_COLOR(0xffffff);
        [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
        
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        itemSpace.width = 10;
        
        [arr addObject:item];
        [arr addObject:itemSpace];
    }
    
    return arr;
}

/// 设置多文字按钮(自定义颜色)
+ (NSArray *)mol_barButtonItemWithTitleNames:(NSArray *)titleNames
                                       color:(UIColor *)color
                                        font:(UIFont *)font
                                      targat:(id)targat
                                     actions:(NSArray *)actions
{
    if (titleNames.count != actions.count) {
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < titleNames.count; i++) {
        NSString *name = titleNames[i];
        NSString *action = actions[i];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStyleDone target:targat action:NSSelectorFromString(action)];
        item.tintColor = color;
        [item setTitleTextAttributes:@{NSFontAttributeName : font} forState:UIControlStateNormal];
        
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        itemSpace.width = 10;
        
        [arr addObject:item];
        [arr addObject:itemSpace];
    }
    
    return arr;
}
@end
