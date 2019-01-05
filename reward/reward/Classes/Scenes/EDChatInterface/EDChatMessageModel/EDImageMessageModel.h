//
//  EDImageMessageModel.h
//  aletter
//
//  Created by moli-2017 on 2018/8/28.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDBaseMessageModel.h"

@interface EDImageMessageModel : EDBaseMessageModel

@property (nonatomic, assign) CGRect imageViewFrame;  // 图片frame

@property (nonatomic, assign) CGFloat cellHeight;
/**
 * 用文字初始化message
 */
- (instancetype)initWithImage:(NSString *)image width:(CGFloat)width height:(CGFloat)height;

- (CGFloat)getCellHeight;
@end
