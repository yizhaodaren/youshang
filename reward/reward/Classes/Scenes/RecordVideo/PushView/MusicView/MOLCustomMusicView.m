//
//  MOLCustomMusicView.m
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLCustomMusicView.h"


@interface MOLCustomMusicView()


@end
@implementation MOLCustomMusicView



+(instancetype)createView{
    return [[[NSBundle mainBundle] loadNibNamed:@"MOLCustomMusicView"
                                          owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    
    
    self.movieVolumeSlider.tag = 1021;
    self.movieVolumeSlider.minimumTrackTintColor = HEX_COLOR(0xFFEC00);
    [self.movieVolumeSlider setThumbImage:[UIImage imageNamed:@"rc_musicSid_Enable"] forState:UIControlStateNormal];
    [self.movieVolumeSlider setThumbImage:[UIImage imageNamed:@"rc_musicSid_DisAble"] forState:UIControlStateDisabled];
    self.movieVolumeSlider.minimumValue = 0.f;
    self.movieVolumeSlider.maximumValue = 1.f;
   
    
    

    self.musicVolumeSlider.tag = 1022;
    self.musicVolumeSlider.minimumTrackTintColor = HEX_COLOR(0xFFEC00);
    [self.musicVolumeSlider setThumbImage:[UIImage imageNamed:@"rc_musicSid_Enable"] forState:UIControlStateNormal];
    [self.musicVolumeSlider setThumbImage:[UIImage imageNamed:@"rc_musicSid_DisAble"] forState:UIControlStateDisabled];
    self.musicVolumeSlider.minimumValue = 0.f;
    self.musicVolumeSlider.maximumValue = 1.f;

    self.Cancelbutton.enabled = NO;
    self.clipMusicButton.enabled = NO;

    
}


@end
