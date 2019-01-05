//
//  MOLClipMovieWhenEditView.h
//  reward
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOLBasePushView.h"
#import "MOLClipMovieView.h"

@class MOLClipMovieWhenEditView;

@protocol MOLClipMovieWhenEditViewDelegate <NSObject>

@optional
- (void)didStartDragView;
- (void)clipFrameView:(MOLClipMovieWhenEditView *)clipFrameView didEndDragLeftView:(CMTime)leftTime rightView:(CMTime)rightTime;

/**
 *  判断clipFrameView中的scrollview是否正在滚动
 *
 *  @param clipFrameView 当前裁剪view
 *  @param scrolling  是否正在滚动
 */
- (void)clipFrameView:(MOLClipMovieWhenEditView *)clipFrameView isScrolling:(BOOL)scrolling;

-(void)closeButtonAction;
-(void)endButtonAction;

@end



@interface MOLClipMovieWhenEditView : MOLBasePushView
@property (nonatomic, weak) id<MOLClipMovieWhenEditViewDelegate> delegate;

- (instancetype)initWithMovieAsset:(AVAsset *)asset minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration withCustomH:(CGFloat)height showBottom:(BOOL) isShowBottom;

- (instancetype)initWithMovieURL:(NSURL *)url minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration withCustomH:(CGFloat)height showBottom:(BOOL) isShowBottom;

- (void)resetProgressBarMode;

- (void)setProgressBarPoisionWithSecond:(Float64)second;
@end
