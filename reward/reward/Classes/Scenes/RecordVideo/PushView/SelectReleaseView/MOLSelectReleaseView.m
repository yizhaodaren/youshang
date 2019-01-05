//
//  MOLSelectReleaseView.m
//  reward
//
//  Created by apple on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLSelectReleaseView.h"

#define SR_WorkBtnW 80.f
#define SR_Topedge 30.f
#define SR_LRedge 80.f

@interface MOLSelectReleaseView()

@property(nonatomic,strong)UIButton *relaeseWorksBtn;//发布作品按钮
@property(nonatomic,strong)UIButton *relaeseRewardBtn;//发布悬赏按钮

@property(nonatomic,strong)UILabel *relaeseWorksLabel;//发布作品
@property(nonatomic,strong)UILabel *relaeseRewardLabel;//发布悬赏
@property(nonatomic,strong)UIButton *closeBtn;//发布悬赏按钮
@end
@implementation MOLSelectReleaseView

-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show{
    self = [super initWithCustomH:height showBottom:show];
    if (self) {
        [self customUI];
    }
    return self;
}

-(void)customUI{
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.contentView.bounds;
    [self.contentView insertSubview:effectView atIndex:0];

    [self.customView addSubview:self.relaeseWorksBtn];
    [self.customView addSubview:self.relaeseRewardBtn];
    
    [self.customView addSubview:self.relaeseWorksLabel];
    [self.customView addSubview:self.relaeseRewardLabel];
    [self.customView addSubview:self.closeBtn];
    
    [self setCornerRadius];
    [self addAction];
    self.contentView.backgroundColor = [UIColor clearColor];
}

-(void)setCornerRadius{
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15,15)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame =self.contentView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}
-(void)addAction{
    [self.relaeseWorksBtn addTarget:self action:@selector(relaeseWorkAction) forControlEvents:UIControlEventTouchUpInside];
    [self.relaeseRewardBtn addTarget:self action:@selector(releaseRewardAction) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)relaeseWorkAction{
    //友盟统计
    [MobClick event:ST_c_publish_button];
    if (self.releaseWorkBlock) {
        self.releaseWorkBlock();
    }
    [self dismissView];
}
-(void)releaseRewardAction{
    //友盟统计
    [MobClick event:ST_c_publish_reward_button];
    
    if (self.releaseRewardBlock) {
        self.releaseRewardBlock();
    }
    [self dismissView];
}
-(void)closeBtnAction{
    [self dismissView];
}

//懒加载
-(UIButton *)relaeseWorksBtn{
    if (!_relaeseWorksBtn) {
        _relaeseWorksBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, SR_Topedge, SR_WorkBtnW, SR_WorkBtnW)];
        _relaeseWorksBtn.centerX = MOL_SCREEN_WIDTH /4;
        [_relaeseWorksBtn setImage:[UIImage imageNamed:@"rc_re_published_works"] forState:UIControlStateNormal];
//        [_relaeseWorksBtn setBackgroundImage:[UIImage imageNamed:@"rc_re_published_works"] forState:UIControlStateNormal];
    }
    return _relaeseWorksBtn;
}
-(UIButton *)relaeseRewardBtn{
    if (!_relaeseRewardBtn) {
        _relaeseRewardBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, SR_Topedge, SR_WorkBtnW, SR_WorkBtnW)];
        _relaeseRewardBtn.centerX = MOL_SCREEN_WIDTH /4*3;
        [_relaeseRewardBtn setImage:[UIImage imageNamed:@"rc_re_post_reward"] forState:UIControlStateNormal];
//        [_relaeseRewardBtn setBackgroundImage:[UIImage imageNamed:@"rc_re_post_reward"] forState:UIControlStateNormal];
    }
    return _relaeseRewardBtn;
}

-(UILabel *)relaeseRewardLabel{
    if (!_relaeseRewardLabel) {
        _relaeseRewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.relaeseRewardBtn.frame), 100, 20)];
        _relaeseRewardLabel.centerX = self.relaeseRewardBtn.centerX;
        _relaeseRewardLabel.text = @"发布悬赏";
        _relaeseRewardLabel.font = [UIFont systemFontOfSize:14];
        _relaeseRewardLabel.textColor = [UIColor whiteColor];
        _relaeseRewardLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _relaeseRewardLabel;
}
-(UILabel *)relaeseWorksLabel{
    if (!_relaeseWorksLabel) {
        _relaeseWorksLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.relaeseRewardBtn.frame), 100, 20)];
        _relaeseWorksLabel.centerX = self.relaeseWorksBtn.centerX;
        _relaeseWorksLabel.text = @"发布作品";
        _relaeseWorksLabel.font = [UIFont systemFontOfSize:14];
        _relaeseWorksLabel.textColor = [UIColor whiteColor];
        _relaeseWorksLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _relaeseWorksLabel;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn   = [[UIButton alloc] initWithFrame:CGRectMake(MOL_SCREEN_WIDTH/2 - 40,self.customView.height - 80, 80, 80)];
        [_closeBtn setImage:[UIImage imageNamed:@"rc_re_close_popup"] forState:UIControlStateNormal];
        
    }
    return _closeBtn;
}

@end
