//
//  MOLFilterGroup.h
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLShortVideoKit/PLShortVideoKit.h"

@interface MOLFilterGroup : NSObject

/**
 @abstract 所有滤镜的信息，NSDictionary 的 key 为 name，coverImagePath，colorImagePath，分别为一个滤镜的名称，封面，滤镜图片
 */
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *filtersInfo;

/**
 @abstract 当前使用的滤镜在滤镜组中的索引
 */
@property (assign, nonatomic) NSInteger filterIndex;

/**
 @abstract 当前使用的滤镜的颜色表图的路径
 */
@property (strong, nonatomic) NSString *colorImagePath;

/**
 @abstract 当前使用的滤镜
 */
@property (strong, nonatomic) PLSFilter *currentFilter;

/**
 @abstract 使用 inputImage 作为滤镜的封面图
 */
- (instancetype)initWithImage:(UIImage *)inputImage;

@end
