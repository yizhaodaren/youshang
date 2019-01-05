//
//  MOLSelectCoverView.h
//  reward
//
//  Created by apple on 2018/11/16.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLBasePushView.h"
#import "MOLClipMovieView.h"

#define TEMP_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define TEMP_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define TEMP_MinImageCount 8   // 显示的图片最少个数
#define TEMP_LineW 4         // 线宽
#define TEMP_LRDistance 20.f //左右边距

#define TEMP_DragViewW 15.f //拖动View的宽度

#define TEMP_DragViewH (TEMP_ImagesViewH + TEMP_LineW*2) //拖动View的高度
#define TEMP_LRAddDragWDis (TEMP_LRDistance + TEMP_DragViewW) //距离➕拖动View的宽度


#define TEMP_EffectiveScreenW (TEMP_SCREEN_WIDTH - TEMP_LRDistance * 2)//有效屏幕的宽度
#define TEMP_ImagesVIewW (TEMP_EffectiveScreenW / TEMP_MinImageCount) // 图片宽度
#define TEMP_ImagesViewH (TEMP_ImagesVIewW * 3.0 /2.0 ) // 预览图高度
@class MOLClipMovieWhenEditView;

@protocol MOLSelectCoverViewDelegate <NSObject>

@optional

@end


@interface MOLSelectCoverView : MOLBasePushView
@property (nonatomic, weak) id<MOLSelectCoverViewDelegate> delegate;
@property (nonatomic,strong)UIImageView *coverImageView;//封面
- (instancetype)initWithMovieAsset:(AVAsset *)asset minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration withCustomH:(CGFloat)height showBottom:(BOOL) isShowBottom;

@end
