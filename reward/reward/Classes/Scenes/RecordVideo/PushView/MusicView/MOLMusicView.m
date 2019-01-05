//
//  MOLMusicView.m
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMusicView.h"


@interface MOLMusicView()


@end
@implementation MOLMusicView



-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show{
    self = [super initWithCustomH:height showBottom:show];
    if (self) {
        self.customMV.frame = CGRectMake(0, 0, MOL_SCREEN_WIDTH, height);
        [self customUI];
        [self addAction];
    }
    return self;
}
-(void)customUI{
    [self.customView addSubview:self.customMV];
    self.currentMovieVolume = MOL_audioVolume;
    self.currentMusicVolume = MOL_audioVolume;
    
    self.customMV.movieVolumeSlider.value = self.currentMovieVolume;
    self.customMV.musicVolumeSlider.value = self.currentMusicVolume;
    self.customMV.musicVolumeSlider.enabled = NO;
}

//添加事件
-(void)addAction{
     [self.customMV.movieVolumeSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [self.customMV.musicVolumeSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [self.customMV.Cancelbutton addTarget:self action:@selector(cancenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customMV.musicLabryButton addTarget:self action:@selector(musicLabryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customMV.clipMusicButton addTarget:self action:@selector(clipMusicAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)sliderValueDidChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (slider.tag == 1021) {
        //movie volume
        self.currentMovieVolume = slider.value;
        [_delegate audioVolumeView:self movieVolumeChangedTo:self.currentMovieVolume musicVolumeChangedTo:self.currentMusicVolume];
    }else{
        //music volume
        self.currentMusicVolume = slider.value;
        [_delegate audioVolumeView:self movieVolumeChangedTo:self.currentMovieVolume musicVolumeChangedTo:self.currentMusicVolume];
    }
}

#pragma mark 懒加载
-(MOLCustomMusicView *)customMV{
    if (!_customMV) {
        _customMV = [MOLCustomMusicView createView];
    }
    return _customMV;
}

//-(void)musicCancelBtnDidSelected;
//-(void)musicLibBtnDidSelected;
//-(void)musicClipBtnDidSelected;
//取消
- (void)cancenAction:(id)sender {
    [self dismissView];
    if ([_delegate respondsToSelector:@selector(musicCancelBtnDidSelected)]) {
        [_delegate musicCancelBtnDidSelected];
    }
}

- (void)musicLabryAction:(id)sender {
    [self dismissView];
    if ([_delegate respondsToSelector:@selector(musicLibBtnDidSelected)]) {
        [_delegate musicLibBtnDidSelected];
    }
    
}

- (void)clipMusicAction:(id)sender {
    [self dismissView];
    if ([_delegate respondsToSelector:@selector(musicClipBtnDidSelected)]) {
        [_delegate musicClipBtnDidSelected];
    }
}


@end
