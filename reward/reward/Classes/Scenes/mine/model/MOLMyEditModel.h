//
//  MOLMyEditModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/14.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MOLMyEditModelType) {
    MOLMyEditModelType_normal,
    MOLMyEditModelType_image,
    MOLMyEditModelType_text,
};

typedef NS_ENUM(NSUInteger, MOLMyEditKeyboardType) {
    MOLMyEditKeyboardType_normal,
    MOLMyEditKeyboardType_id,   //不可编辑  id
    MOLMyEditKeyboardType_sex,  // 不可编辑  sex
    MOLMyEditKeyboardType_birthday,  // 不可编辑 生日
    MOLMyEditKeyboardType_introduction,  // 介绍
};

@interface MOLMyEditModel : NSObject

@property (nonatomic, assign) MOLMyEditModelType cellType;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeholder;  // 占位文字
//@property (nonatomic, strong) NSString *holder;   // 实际文字

@property (nonatomic, assign) MOLMyEditKeyboardType keyboardType;  // 键盘类型

@property (nonatomic, strong) NSString *key;

@property (nonatomic, assign) CGFloat cellHeight;
@end
