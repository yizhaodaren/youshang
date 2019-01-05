//
//  AudioCountDownView.h
//  reward
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 reward. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^ConfirmBlock) (float startTime,float endTime);

@interface MOLAudioCountDownView : UIView

//初始化


- (instancetype)initWithMusicURL:(NSURL *)url startTime:(float)startTime;
- (instancetype)initWithMusicPath:(NSString *)path startTime:(float )startTime;

//合拍使用
- (instancetype)initWithMusicMaxTime:(CGFloat)maxtime startTime:(float)startTime;
- (void)showInView:(UIView *)view;
- (void)hide;


@property (strong,nonatomic)NSString  *musicPath;
@property (assign,nonatomic)float startTime;
@property (assign,nonatomic)float endTime;


@property (strong,nonatomic)dispatch_block_t dismissBlock;
@property (strong,nonatomic)ConfirmBlock confirmBlock;
@end
