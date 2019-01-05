//
//  PLShortPlayerViewController.m
//  NiuPlayer
//
//  Created by hxiongan on 2018/3/1.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "PLShortPlayerViewController.h"
#import "HomeFunctionMenuView.h"


@interface PLShortPlayerViewController ()


@property (nonatomic, strong) UIImageView        *navbarView;
@property (nonatomic, strong) UIImageView   *headerImageView;
@property (nonatomic, strong) UILabel       *descLabel;
@property (nonatomic, strong) UILabel       *nameLabel;

@end

@implementation PLShortPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.closeButton removeFromSuperview];
    
   // [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:self.media.thumbURL]];

    self.enableGesture = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setMedia:(MOLVideoOutsideModel *)media {
    _media = media;
    self.model =media;
    
    if (media.contentType==1) { //悬赏
        self.url = [NSURL URLWithString:media.rewardVO.audioUrl?media.rewardVO.audioUrl:@""];
        self.thumbImageURL = [NSURL URLWithString:media.rewardVO.coverImage?media.rewardVO.coverImage:@""];
    }else{ //作品
        
        self.url = [NSURL URLWithString:media.storyVO.audioUrl?media.storyVO.audioUrl:@""];
        self.thumbImageURL = [NSURL URLWithString:media.storyVO.coverImage?media.storyVO.coverImage:@""];
        
        if (!media.storyVO.rewardVO) { //表示自由作品
            
        }else{//悬赏作品
            
        }
    }

}

@end
