//
//  MOLMixRecordView.h
//  reward
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLProgressBar.h"
#import "MOLRateButtonView.h"
@interface MOLMixRecordView : UIView
//上
@property(nonatomic,strong)UIView *topToolboxView;//头部部
@property(nonatomic,strong) MOLProgressBar *progressBar; //特定的进度条
@property(nonatomic,strong) UILabel *durationLabel;
@property(nonatomic,strong) UIButton *backButton;//返回
@property(nonatomic,strong) UIButton *selectedMusicBtn;//音乐选择

//右
@property(nonatomic,strong)UIView *rightToolboxView;//底部
@property(nonatomic,strong) UIButton *turnBtn;
@property(nonatomic,strong) UIButton *rateBtn;
@property(nonatomic,strong) UIButton *beautifyBtn;
@property(nonatomic,strong) UIButton *countdownBtn;
@property(nonatomic,strong) UIButton *audioBtn;

//下
@property(nonatomic,strong)UIView *bottomToolboxView;//底部
@property(nonatomic,strong)MOLRateButtonView *rateButtonView;//速率
@property(nonatomic,strong)UIButton *recordButton;//录制按钮
@property(nonatomic,strong)CAShapeLayer*layer1;
@property(nonatomic,strong)CAShapeLayer*layer2;

@property(nonatomic,strong)UIButton *filterButton;//滤镜按钮
@property(nonatomic,strong)UIButton *deleteButton;//删除按钮
@property(nonatomic,strong)UIButton *endButton;//完成录制按钮
@property(nonatomic,strong)UIButton *photoAlbumButton;//相册按钮
@property(nonatomic,strong)UIButton *linkButton;//外链按钮

//更新结束状态和删除全部视频段的UI
-(void)updateUIWithEndRecod:(BOOL)isEnd;

-(void)hideAll:(BOOL)isHide;
//播放按钮动画
-(void)animationSart;
//播放按钮动画
-(void)animationStop;
@end
