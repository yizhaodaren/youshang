//
//  UIImageView+Rotate.m
//  reward
//
//  Created by xujin on 2018/10/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "UIImageView+Rotate.h"

@implementation UIImageView (Rotate)

- (void)startRotating{
    CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];   // 旋转一周
    rotateAnimation.duration = 10.0;                                 // 旋转时间10秒
    rotateAnimation.repeatCount = MAXFLOAT;                          // 重复次数，这里用最大次数
    rotateAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:rotateAnimation forKey:nil];
    
}

- (void)stopRotating{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;                                          // 停止旋转
    self.layer.timeOffset = pausedTime;
    
}

- (void)resumeRotate{
    if (self.layer.timeOffset == 0) {
        [self startRotating];
        return;
    }
    
    CFTimeInterval pausedTime = self.layer.timeOffset;
    self.layer.speed = 1.0;                                         // 开始旋转
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;                                             // 恢复时间
    self.layer.beginTime = timeSincePause;

}

@end
