//
//  MOLCodeTimerManager.m
//  aletter
//
//  Created by moli-2017 on 2018/8/20.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLCodeTimerManager.h"

@interface MOLCodeTimerManager ()
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) void(^secBlock)(NSInteger sec);
@property (nonatomic, weak) UIButton *button;
@end

@implementation MOLCodeTimerManager

+ (instancetype)shareCodeTimerManager
{
    static MOLCodeTimerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[MOLCodeTimerManager alloc] init];
            instance.showTime = MOL_CODETIME;
        }
    });
    return instance;
}

// 开启定时器
- (void)codeTimer_beginTimer:(void(^)(NSInteger sec))secondBlock
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCodeTime:) userInfo:nil repeats:YES];
    }
    
    self.secBlock = secondBlock;
}

// 开启定时器
- (void)codeTimer_beginTimerWithButton:(UIButton *)button timeDownBlock:(void(^)(NSInteger sec))secondBlock
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCodeTime:) userInfo:nil repeats:YES];
    }
    
    self.button = button;
    
    self.secBlock = secondBlock;
}

- (void)updateCodeTime:(NSTimer *)timer
{
    self.showTime --;
    if (self.showTime <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.showTime = MOL_CODETIME;
        [self.button setTitle:@"重新发送" forState:UIControlStateNormal];
        self.button.enabled = YES;
//        self.button.backgroundColor = HEX_COLOR_ALPHA(0xFFEC00, 1);
    }else{
        [self.button setTitle:[NSString stringWithFormat:@"%lds",self.showTime] forState:UIControlStateDisabled];
        self.button.enabled = NO;
//        self.button.backgroundColor = [UIColor clearColor];
    }
    if (self.secBlock) {
        self.secBlock(self.showTime);
    }
}

// 停止定时器
- (void)codeTimer_stopTimer
{
    self.showTime = MOL_CODETIME;
    [self.timer invalidate];
    self.timer = nil;
}
@end
