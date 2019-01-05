//
//  MOLClipMovieView.h
//  PLShortVideoKitDemo
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <PLShortVideoKit/PLShortVideoKit.h>

@interface UIView (PLSExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (assign, nonatomic) CGPoint origion;

@end


@interface MOLClipMovieViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *imageData;
-(void)layoutImageView;
-(void)setBorder;
@end


@class MOLClipMovieView;
@protocol MOLClipMovieViewDelegate <NSObject>

@optional
- (void)didStartDragView;
- (void)clipFrameView:(MOLClipMovieView *)clipFrameView didEndDragLeftView:(CMTime)leftTime rightView:(CMTime)rightTime;

/**
 *  判断clipFrameView中的scrollview是否正在滚动
 *
 *  @param clipFrameView 当前裁剪view
 *  @param scrolling  是否正在滚动
 */
- (void)clipFrameView:(MOLClipMovieView *)clipFrameView isScrolling:(BOOL)scrolling;

-(void)closeButtonAction;
-(void)endButtonAction;

@end

@interface MOLClipMovieView : UIView

@property (nonatomic, weak) id<MOLClipMovieViewDelegate> delegate;

- (instancetype)initWithMovieAsset:(AVAsset *)asset minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration;

- (instancetype)initWithMovieURL:(NSURL *)url minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration;

- (void)resetProgressBarMode;

- (void)setProgressBarPoisionWithSecond:(Float64)second;

@end

