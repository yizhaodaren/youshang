//
//  MOLMixRecordView.m
//  reward
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMixRecordView.h"
#define btnHaflWidth  MOL_SCALEWidth(30.0) //录制的原的半径
@implementation MOLMixRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    //上部UI
    [self setupTopToolboxView];
    //右侧UI
    [self setupRightToolboxView];
    //下部UI
    [self setupBottomToolboxView];
}
-(void)setupTopToolboxView{
     CGFloat HDis = iPhoneX ? 44 : 5;
    self.topToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, HDis, MOL_SCREEN_WIDTH, 20)];
    self.topToolboxView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topToolboxView];
    // 视频录制进度条
    self.progressBar = [[MOLProgressBar alloc] initWithFrame:CGRectMake(20, 0, MOL_SCREEN_WIDTH -40, 8)];
    [self.topToolboxView addSubview:self.progressBar];
    //时间
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake((MOL_SCREEN_WIDTH - 150)/2, 20, 150, 20)];
    self.durationLabel.textColor = [UIColor whiteColor];
//    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", self.videoMixRecorder.getTotalDuration];
    self.durationLabel.textAlignment = NSTextAlignmentRight;
    // [self.topToolboxView addSubview:self.durationLabel];
    
    // 返回
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(10, CGRectGetMaxY(self.topToolboxView.frame), 35, 35);
    [self.backButton setImage:[UIImage imageNamed:@"rc_close"] forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    
    
    //音乐选择
    self.selectedMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectedMusicBtn.frame = CGRectMake(0, CGRectGetMaxY(self.topToolboxView.frame), 200, 35);
    [self.selectedMusicBtn setImage:[UIImage imageNamed:@"rc_music"] forState:UIControlStateNormal];
    [self.selectedMusicBtn setTitle:@"选择音乐" forState:UIControlStateNormal];
    self.selectedMusicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.selectedMusicBtn.centerX = self.topToolboxView.centerX;
//    [self addSubview:self.selectedMusicBtn];
}
-(void)setupRightToolboxView{
    
    CGFloat w = MOL_SCALEWidth(40.f);
    CGFloat h = MOL_SCALEWidth(40.f);
    CGFloat d = 20.f;
    self.rightToolboxView = [[UIView alloc] initWithFrame:CGRectMake(MOL_SCREEN_WIDTH - w - 10, CGRectGetMaxY(self.topToolboxView.frame) + 5, w, h*4 + d*3)];
    self.rightToolboxView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.rightToolboxView];
    //反转相机
    self.turnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [self.turnBtn setTitle:@"翻转" forState:UIControlStateNormal];
    [self.turnBtn setImage:[UIImage imageNamed:@"rc_reverse"] forState:UIControlStateNormal];
    self.turnBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self.turnBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
    [self.rightToolboxView addSubview:self.turnBtn];
    //快慢速
//    self.rateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, h+d, w, h)];
//    [self.rateBtn setTitle:@"快慢速" forState:UIControlStateNormal];
//    [self.rateBtn setImage:[UIImage imageNamed:@"rc_speed"] forState:UIControlStateNormal];
//    self.rateBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
//    [self.rateBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
//    [self.rightToolboxView addSubview:self.rateBtn];
    //美化
    self.beautifyBtn   = [[UIButton alloc] initWithFrame:CGRectMake(0, 1*(h +d), w, h)];
    [self.beautifyBtn setTitle:@"美化" forState:UIControlStateNormal];
    [self.beautifyBtn setImage:[UIImage imageNamed:@"rc_beautify"] forState:UIControlStateNormal];
    self.beautifyBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self.beautifyBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
    [self.rightToolboxView addSubview:self.beautifyBtn];
    //倒计时
    self.countdownBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2*(h+d), w, h)];
    [self.countdownBtn setTitle:@"倒计时" forState:UIControlStateNormal];
    [self.countdownBtn setImage:[UIImage imageNamed:@"rc_countdown"] forState:UIControlStateNormal];
    self.countdownBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self.countdownBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
    [self.rightToolboxView addSubview:self.countdownBtn];
    //声音
    self.audioBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 3*(h+d), w, h)];
    [self.audioBtn setTitle:@"打开" forState:UIControlStateNormal];
    [self.audioBtn setTitle:@"关闭" forState:UIControlStateSelected];
    [self.audioBtn setImage:[UIImage imageNamed:@"rc_AudioDis"] forState:UIControlStateNormal];
    [self.audioBtn setImage:[UIImage imageNamed:@"rc_AudioEnable"] forState:UIControlStateSelected];
    self.audioBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self.audioBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
    [self.rightToolboxView addSubview:self.audioBtn];
    
}
-(void)setupBottomToolboxView{
    
    
    //    66 + 15 + 120 +10 + 50
    
    CGFloat y = MOL_SCREEN_HEIGHT -(MOL_SCALEHeight(40 + 15 + 100 + 50 - 10)  + MOL_TabbarSafeBottomMargin);
    self.bottomToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, y, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT- y)];
    [self addSubview:self.bottomToolboxView];
    
    
    // 倍数拍摄
    NSArray *titleArray = @[@"极慢", @"慢", @"正常", @"快", @"极快"];
    
    self.rateButtonView = [[MOLRateButtonView alloc] initWithFrame:CGRectMake(MOL_SCALEWidth(33), 0, MOL_SCREEN_WIDTH - MOL_SCALEWidth(66), MOL_SCALEHeight(40)) defaultIndex:2];
    CGFloat countSpace = 200 /titleArray.count / 6;
    self.rateButtonView.space = countSpace;
    self.rateButtonView.staticTitleArray = titleArray;
    self.rateButtonView.rateDelegate = self;
    self.rateButtonView.hidden = YES;
    [self.bottomToolboxView addSubview:_rateButtonView];
    
    
    // 录制视频的操作按钮
    CGFloat buttonWidth = MOL_SCALEWidth(100);
    CGFloat buttonHeight = MOL_SCALEHeight(100);
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = CGRectMake((MOL_SCREEN_WIDTH - buttonWidth) / 2, CGRectGetMaxY(self.rateButtonView.frame) + MOL_SCALEHeight(15) , buttonWidth, buttonHeight);
 
    [self.bottomToolboxView addSubview:self.recordButton];
    //layer
    // 贝塞尔曲线(创建一个圆)
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(btnHaflWidth, btnHaflWidth) radius:btnHaflWidth + 4.1 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    // 创建一个shapeLayer1
    self.layer1= [CAShapeLayer layer];
    self.layer1.frame         = CGRectMake(buttonWidth/2 - btnHaflWidth,buttonHeight/2- btnHaflWidth, btnHaflWidth *2 , btnHaflWidth*2);//self.recordButton.bounds;
    // 与showView的frame一致
    self.layer1.strokeColor   = [[UIColor whiteColor]colorWithAlphaComponent:0.8].CGColor;   // 边缘线的颜色
    self.layer1.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    self.layer1.lineCap       = kCALineCapSquare;               // 边缘线的类型
    self.layer1.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
    self.layer1.lineWidth     = 4.0f;                           // 线条宽度
    self.layer1.strokeStart   = 0.0f;
    self.layer1.strokeEnd     = 1.0f;
    [self.recordButton.layer addSublayer:self.layer1];
    
    // 创建一个shapeLayer2
    self.layer2 = [[CAShapeLayer alloc] init];
    self.layer2.frame = CGRectMake(buttonWidth/2 - btnHaflWidth,buttonHeight/2-btnHaflWidth, btnHaflWidth *2, btnHaflWidth *2);//self.recordButton.bounds;
    self.layer2.backgroundColor = [UIColor yellowColor].CGColor;
    self.layer2.cornerRadius = btnHaflWidth;
    [self.recordButton.layer addSublayer:self.layer2];
    
    CGFloat Width  = MOL_SCALEWidth(btnHaflWidth*2/5*4);
    CGFloat Height = MOL_SCALEWidth(btnHaflWidth*2/5*4);
    CGFloat BtnDis = MOL_SCALEWidth(50);
    // 滤镜按钮
    self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterButton.frame = CGRectMake(0,0, Width, Height);
    self.filterButton.center = CGPointMake(CGRectGetMinX(self.recordButton.frame)-Width/2-BtnDis, self.recordButton.center.y);
    [self.filterButton setBackgroundImage:[UIImage imageNamed:@"rc_stickers"] forState:UIControlStateNormal];
    [self.filterButton setBackgroundImage:[UIImage imageNamed:@"rc_stickers"] forState:UIControlStateDisabled];

    //    [self.bottomToolboxView addSubview:self.filterButton];
    
    
    // 音乐 结束录制的按钮
    self.endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endButton.frame = CGRectMake(0,0, Width, Height);
    self.endButton.center = CGPointMake(CGRectGetMaxX(self.recordButton.frame)+Width/2+BtnDis, self.recordButton.center.y);
    
    
    //切换音乐为结束
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"rc_next_step"] forState:UIControlStateNormal];
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"rc_next_step"] forState:UIControlStateDisabled];
    self.endButton.hidden = YES;
    [self.bottomToolboxView addSubview:self.endButton];
    
    CGFloat w = MOL_SCALEWidth(50.f);
    CGFloat h = MOL_SCALEWidth(50.f);
    CGFloat dis = MOL_SCALEWidth(50.f);
    //删除按钮
    self.deleteButton =[[UIButton alloc] init];
    self.deleteButton.frame = CGRectMake(self.recordButton.center.x - w/2, CGRectGetMaxY(self.recordButton.frame) - MOL_SCALEWidth(10.f), w, h);
    [self.deleteButton setImage:[UIImage imageNamed:@"btn_del_a"] forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.deleteButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"拍摄" forState:UIControlStateNormal];
    //  [self.deleteButton setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.4]];
    [self.bottomToolboxView addSubview:self.deleteButton];
    //相册
    self.photoAlbumButton =[[UIButton alloc] init];
    self.photoAlbumButton.frame = CGRectMake(CGRectGetMinX(self.deleteButton.frame)  - w - dis , CGRectGetMinY(self.deleteButton.frame), w, h);
    [self.photoAlbumButton setImage:[UIImage imageNamed:@"btn_del_a"] forState:UIControlStateNormal];
    [self.photoAlbumButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1] forState:UIControlStateNormal];
    [self.photoAlbumButton setTitle:@"相册" forState:UIControlStateNormal];
    self.photoAlbumButton.titleLabel.font = [UIFont systemFontOfSize:16];

//    [self.bottomToolboxView addSubview:self.photoAlbumButton];
    //外链
    self.linkButton =[[UIButton alloc] init];
    self.linkButton.frame =CGRectMake(CGRectGetMaxX(self.deleteButton.frame)  + dis , CGRectGetMinY(self.deleteButton.frame), w, h);
    [self.linkButton setImage:[UIImage imageNamed:@"btn_del_a"] forState:UIControlStateNormal];
    [self.linkButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1] forState:UIControlStateNormal];
    [self.linkButton setTitle:@"外链" forState:UIControlStateNormal];
    self.linkButton.titleLabel.font = [UIFont systemFontOfSize:16];
  
//    [self.bottomToolboxView addSubview:self.linkButton];
    
}

//更新结束状态和删除全部视频段的UI
-(void)updateUIWithEndRecod:(BOOL)isEnd{
    if (isEnd) {
        
        //禁用音乐选择
        self.selectedMusicBtn.enabled = NO;
        //现实相册和链接按钮
        self.photoAlbumButton.hidden = YES;
        self.linkButton.hidden = YES;
        //切换删除为拍摄
        [self.deleteButton setImage:[UIImage imageNamed:@"rc_delet"] forState:UIControlStateNormal];
        [self.deleteButton setTitle:nil forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1] forState:UIControlStateNormal];
        self.deleteButton.enabled = YES;
    }else{
        //打开音乐按钮的
        self.selectedMusicBtn.enabled = YES;
        //现实相册和链接按钮
        self.photoAlbumButton.hidden = NO;
        self.linkButton.hidden = NO;
        //切换删除为拍摄
        [self.deleteButton setImage:nil forState:UIControlStateNormal];
        [self.deleteButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.deleteButton setTitle:@"拍摄" forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        self.deleteButton.enabled = NO;
    }
}
//播放按钮动画
-(void)animationSart{
    
    CGFloat animationTime = 0.5;
    //self.layer1
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    pathAnimation.duration = animationTime;
    pathAnimation.fillMode =kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.values = @[[NSNumber numberWithFloat:1.0f],[NSNumber numberWithFloat:1.1f],[NSNumber numberWithFloat:1.2f],[NSNumber numberWithFloat:1.3],[NSNumber numberWithFloat:1.4]];
    [self.layer1 addAnimation:pathAnimation forKey:@"scale"];
    
    //self.layer2
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:btnHaflWidth];
    scaleAnimation.toValue = [NSNumber numberWithFloat:5];
    scaleAnimation.fillMode=kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.duration = animationTime;
    [self.layer2 addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    CAKeyframeAnimation *scaleAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.duration = animationTime;
    scaleAnimation2.fillMode =kCAFillModeForwards;
    scaleAnimation2.removedOnCompletion = NO;
    scaleAnimation2.values = @[[NSNumber numberWithFloat:1.0f],[NSNumber numberWithFloat:0.8f],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.5]];
    [self.layer2 addAnimation:scaleAnimation2 forKey:@"scale"];
    
    
    [self hideWhenRecordBtnAction:YES];
    
    
}
//播放按钮动画
-(void)animationStop{
    
    CGFloat animationTime = 0.3;
    
    //self.layer1
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    pathAnimation.duration = animationTime;
    pathAnimation.fillMode =kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.values = @[[NSNumber numberWithFloat:1.4f],[NSNumber numberWithFloat:1.3],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.1],[NSNumber numberWithFloat:1.0]];
    [self.layer1 addAnimation:pathAnimation forKey:@"scale"];
    
    //self.layer2
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:btnHaflWidth];
    scaleAnimation.fillMode=kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.duration = animationTime;
    [self.layer2 addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    CAKeyframeAnimation *scaleAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.duration = animationTime;
    scaleAnimation2.fillMode =kCAFillModeForwards;
    scaleAnimation2.removedOnCompletion = NO;
    scaleAnimation2.values = @[[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:1]];
    [self.layer2 addAnimation:scaleAnimation2 forKey:@"scale"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.recordButton.selected) {//防止快速点击
            [self hideWhenRecordBtnAction:NO];
        }
    });
}

#pragma mark //******************************************hide****************************************//
-(void)hideAll:(BOOL)isHide{
    self.topToolboxView.hidden = isHide;
    self.bottomToolboxView.hidden = isHide;
    self.rightToolboxView.hidden = isHide;
    self.backButton.hidden = isHide;
    self.selectedMusicBtn.hidden = isHide;
}
-(void)hideWhenRecordBtnAction:(BOOL)isHide{
    self.rightToolboxView.hidden = isHide;
    self.backButton.hidden = isHide;
    self.selectedMusicBtn.hidden = isHide;
    self.filterButton.hidden = isHide;
    self.rateButtonView.hidden = isHide;
    self.endButton.hidden = isHide;
    self.photoAlbumButton.hidden = isHide;
    self.deleteButton.hidden = isHide;
    self.linkButton.hidden = isHide;
    
    
    //如果是录制完成
    if (!isHide) {
        self.rateButtonView.hidden = !isHide;
        self.photoAlbumButton.hidden = !isHide;
        self.linkButton.hidden = !isHide;
        NSLog(@"比较时间%f",MOLMixRCTIME);
        if (fabs(MOLMixRCTIME) >= MOL_RecordMinTime) {
            self.endButton.hidden = NO;
        }else{
            self.endButton.hidden = YES;
        }
        
    }
}

@end
