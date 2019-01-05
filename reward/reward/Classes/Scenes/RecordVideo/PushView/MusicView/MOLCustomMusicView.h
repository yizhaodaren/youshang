//
//  MOLCustomMusicView.h
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOLCustomMusicView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *Cancelbutton;
@property (weak, nonatomic) IBOutlet UIButton *musicLabryButton;
@property (weak, nonatomic) IBOutlet UIButton *clipMusicButton;
@property (weak, nonatomic) IBOutlet UISlider *movieVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *musicVolumeSlider;



+(instancetype)createView;

@end
