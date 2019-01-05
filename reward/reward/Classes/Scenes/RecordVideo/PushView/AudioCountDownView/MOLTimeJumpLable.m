//
//  MOLTimeJumpLable.m
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLTimeJumpLable.h"

@interface MOLTimeJumpLable()
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation MOLTimeJumpLable


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.font = [UIFont systemFontOfSize:60];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
//开始倒计时
- (void)startCount{
    [self initTimer];
}

- (void)initTimer{
    //如果没有设置，则默认为3
    if (self.count == 0){
        self.count = 3;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown{
    if (_count > 0){
        self.text = [NSString stringWithFormat:@"%d",_count];
        CAKeyframeAnimation *anima2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        //字体变化大小
        
        NSValue *value1 = [NSNumber numberWithFloat:5.0f];
        NSValue *value2 = [NSNumber numberWithFloat:4.0f];
        NSValue *value3 = [NSNumber numberWithFloat:3.0f];
        NSValue *value4 = [NSNumber numberWithFloat:2.0f];
        NSValue *value5 = [NSNumber numberWithFloat:1.0f];
        NSValue *value6 = [NSNumber numberWithFloat:0.7f];
        NSValue *value7 = [NSNumber numberWithFloat:1.0f];
        NSValue *value8 = [NSNumber numberWithFloat:1.3f];
       
        anima2.values = @[value1,value2,value3,value4,value5,value6,value7,value8];
        anima2.duration = 0.5;
        [self.layer addAnimation:anima2 forKey:@"scalsTime"];
        _count -= 1;
    }else {
        [_timer invalidate];
        [self removeFromSuperview];
        if (self.Block)
        {
            self.Block();
        }
    }
}

@end
