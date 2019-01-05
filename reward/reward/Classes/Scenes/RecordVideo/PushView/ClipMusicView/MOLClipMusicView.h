//
//  MOLClipMusicView.h
//  reward
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBasePushView.h"

typedef void (^updateStartTimeBlock) (float startTime);

@interface MOLClipMusicView : MOLBasePushView

@property (strong,nonatomic)updateStartTimeBlock updateSTBlock;

-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show;

//更新。musicUrl 为音乐的URL duration 为视频的长度
-(void)updateWithMsic:(NSURL *)musicUrl WithVoideDuration:(CGFloat)duration;
-(void)setProgressWithSecond:(Float64)second;
@end
