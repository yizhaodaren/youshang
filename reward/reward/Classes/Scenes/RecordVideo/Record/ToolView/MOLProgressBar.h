//
//  MOLProgressBar.h
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    MOLProgressBarProgressStyleNormal,
    MOLProgressBarProgressStyleDelete,
} MOLProgressBarProgressStyle;

@interface MOLProgressBar : UIView

//设置最后一条的类型
- (void)setLastProgressToStyle:(MOLProgressBarProgressStyle)style;
//设置最后一条的宽度
- (void)setLastProgressToWidth:(CGFloat)width;

//删除最后一条
- (void)deleteLastProgress;

//删除所有视频段记录
- (void)deleteAllProgress;
//标最短分割线
- (void)setMinTime:(CGFloat)minTime AndMaxTime:(CGFloat)maxTime;

- (void)addProgressView;
- (void)stopShining;
- (void)startShining;
@end

