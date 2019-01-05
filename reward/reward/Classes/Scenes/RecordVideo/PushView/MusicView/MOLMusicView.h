//
//  MOLMusicView.h
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLBasePushView.h"
#import "MOLCustomMusicView.h"


@protocol MOLMusicViewDelegate <NSObject>

@optional
- (void)audioVolumeView:(MOLBasePushView *)volumeView movieVolumeChangedTo:(CGFloat)movieVolume musicVolumeChangedTo:(CGFloat)musicVolume;
-(void)musicCancelBtnDidSelected;
-(void)musicLibBtnDidSelected;
-(void)musicClipBtnDidSelected;

@end


@interface MOLMusicView : MOLBasePushView

@property (assign, nonatomic) CGFloat currentMovieVolume;
@property (assign, nonatomic) CGFloat currentMusicVolume;

@property(nonatomic,strong)MOLCustomMusicView *customMV;
@property (weak, nonatomic) id<MOLMusicViewDelegate> delegate;

-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show;


@end
