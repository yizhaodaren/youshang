//
//  MOLCodeTimerManager.h
//  aletter
//
//  Created by moli-2017 on 2018/8/20.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLCodeTimerManager : NSObject
+ (instancetype)shareCodeTimerManager;
@property (nonatomic, assign) NSInteger showTime;
// 开启定时器
- (void)codeTimer_beginTimer:(void(^)(NSInteger sec))secondBlock;

// 开启定时器
- (void)codeTimer_beginTimerWithButton:(UIButton *)button timeDownBlock:(void(^)(NSInteger sec))secondBlock;

// 停止定时器
- (void)codeTimer_stopTimer;

@end
