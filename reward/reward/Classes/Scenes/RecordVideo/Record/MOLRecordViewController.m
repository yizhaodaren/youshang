//
//  MOLRecordViewController.m
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLRecordViewController.h"
#import "MOLRecordManager.h"
#import "MOLProgressBar.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "MOLEditViewController.h"
#import "MOLVideoPickViewController.h"
#import "MOLSupLinkeViewController.h"
#import "MOLRateButtonView.h"
#import "MOLAudioCountDownView.h"
#import "MOLTimeJumpLable.h"
#import "MOLClipMovieViewController.h"
#import "MOLBeautifyView.h"
#import "MOLSelectMusicViewController.h"
#define AlertViewShow(msg) [[[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"%@", msg] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
#define PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG 10001

#define btnHaflWidth  MOL_SCALEWidth(33.0) //录制的原的半径

@interface MOLRecordViewController ()<PicktedVoidDelegate,MOLRateButtonViewDelegate,PLShortVideoRecorderDelegate>

//******************************************传值****************************************//
@property(nonatomic,assign)NSInteger currentMusicID;//音乐ID（以视频的最后一次添加音乐的ID为准）
//**********************************************************************************//

//短视频录制的核心类。
@property(nonatomic,strong)PLShortVideoRecorder *shortVideoRecorder;
@property(nonatomic,strong) NSURL *selectedAudioUrl; //选中的配乐
@property(nonatomic,assign) CGFloat recordedTime;//当前已录制时间
@property(nonatomic,assign) CGFloat stopRecordTime; //设置的停止录制时间
//上
@property(nonatomic,strong)UIView *topToolboxView;//头部部
@property(nonatomic,strong) MOLProgressBar *progressBar; //特定的进度条
@property(nonatomic,strong) UILabel *durationLabel;
@property(nonatomic,strong) UIButton *backButton;//返回
@property(nonatomic,strong) UIButton *selectedMusicBtn;//音乐选择

//右
@property(nonatomic,strong)UIView *rightToolboxView;//底部
//下
@property(nonatomic,strong)UIView *bottomToolboxView;//底部
@property(nonatomic,strong)MOLRateButtonView *rateButtonView;//速率
@property(nonatomic,strong)UIButton *recordButton;//录制按钮
@property(nonatomic,strong)CAShapeLayer*layer;
@property(nonatomic,strong)CAShapeLayer*layer2;

@property(nonatomic,strong)UIButton *filterButton;//滤镜按钮
@property(nonatomic,strong)UIButton *deleteButton;//删除按钮
@property(nonatomic,strong)UIButton *endButton;//完成录制按钮
@property(nonatomic,strong)UIButton *photoAlbumButton;//相册按钮
@property(nonatomic,strong)UIButton *linkButton;//外链按钮
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
//******************************************滤镜****************************************//
@property(nonatomic,assign) BOOL isUseFilterWhenRecording;// 录制时是否使用滤镜
@property(nonatomic,strong) PLSFilter *currentFilter;//当前滤镜

//美化
@property(nonatomic,strong)MOLBeautifyView *beautifyView;
@property(nonatomic,strong) UIAlertView *alertView;
@property(nonatomic,assign)BOOL isHidenTaBar;
@end

@implementation MOLRecordViewController
-(BOOL)showNavigation{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRecored];
    [self initUI];
    [self setupOriginalMusic];//设置默认音乐
    [self setUpBeautifyView];

  if ([MOLReleaseManager manager].rewardID == -1) {
      self.photoAlbumButton.hidden = YES;
      self.linkButton.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //视频认证
                [MBProgressHUD showMessageAMoment:@"请勿赤裸上身拍摄,否则不予通过（此规则不包含游泳健身等运动类型）"];
        });
   }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self setUpBeautifyView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.shortVideoRecorder startCaptureSession];
    
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    statusBar.alpha = 0.0;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.shortVideoRecorder stopCaptureSession];
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    statusBar.alpha = 1.0;
}
-(void)setupRecored{
    self.shortVideoRecorder = [MOLRecordManager initRecorder];
    self.shortVideoRecorder.delegate = self;
    [self.view addSubview:self.shortVideoRecorder.previewView];
    self.stopRecordTime = self.shortVideoRecorder.maxDuration + 0.1;
}
//处理录制按钮事件
-(void)recordEvent{
    if (self.shortVideoRecorder.isRecording) {
        [self.shortVideoRecorder stopRecording];
    }else{
        [self.shortVideoRecorder startRecording];
    }
    
}
-(void)initUI{
    //上部UI
    [self setupTopToolboxView];
    //右侧UI
    [self setupRightToolboxView];
    //下部UI
    [self setupBottomToolboxView];
    // 展示加载动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}
-(void)setupTopToolboxView{
    CGFloat HDis = iPhoneX ? 44 : 5;
    self.topToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, HDis, MOL_SCREEN_WIDTH, 20)];
    self.topToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topToolboxView];
    // 视频录制进度条
    self.progressBar = [[MOLProgressBar alloc] initWithFrame:CGRectMake(20, 0, MOL_SCREEN_WIDTH -40, 8)];
    [self.progressBar setMinTime:MOL_RecordMinTime AndMaxTime:MOL_RecordMaxTime];
    
    [self.topToolboxView addSubview:self.progressBar];
    //时间
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake((MOL_SCREEN_WIDTH - 150)/2, 20, 150, 20)];
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", self.shortVideoRecorder.getTotalDuration];
    self.durationLabel.textAlignment = NSTextAlignmentRight;
    // [self.topToolboxView addSubview:self.durationLabel];
    // 返回
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(10, CGRectGetMaxY(self.topToolboxView.frame), MOL_SCALEWidth(40), MOL_SCALEWidth(40));
    [self.backButton setImage:[UIImage imageNamed:@"rc_close"] forState:UIControlStateNormal];
//    [self.backButton setBackgroundImage:[UIImage imageNamed:@"rc_close"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    //音乐选择
    self.selectedMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectedMusicBtn.frame = CGRectMake(0, CGRectGetMaxY(self.topToolboxView.frame), 200, 35);
    [self.selectedMusicBtn setImage:[UIImage imageNamed:@"rc_music"] forState:UIControlStateNormal];
    [self.selectedMusicBtn setTitle:@"选择音乐" forState:UIControlStateNormal];
    self.selectedMusicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.selectedMusicBtn.centerX = self.topToolboxView.centerX;
     [self.selectedMusicBtn addTarget:self action:@selector(endButtonMusicEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.selectedMusicBtn];
    
    //topShadow
    UIImageView *topBackShadow=[UIImageView new];
    [topBackShadow setImage: [UIImage imageNamed:@"top_shadow"]];
    [topBackShadow setFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH, self.selectedMusicBtn.bottom)];
    [self.view insertSubview:topBackShadow atIndex:0];
}
-(void)setupRightToolboxView{
    
    CGFloat w = MOL_SCALEWidth(40.f);
    CGFloat h = MOL_SCALEWidth(40.f);
    CGFloat d = 20.f;
    self.rightToolboxView = [[UIView alloc] initWithFrame:CGRectMake(MOL_SCREEN_WIDTH - w - 10, CGRectGetMaxY(self.topToolboxView.frame) + 5, w, h*4 + d*3)];
    self.rightToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.rightToolboxView];
    //反转相机
    UIButton *turnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [turnBtn addTarget:self action:@selector(turnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [turnBtn setTitle:@"翻转" forState:UIControlStateNormal];
    [turnBtn setImage:[UIImage imageNamed:@"rc_reverse"] forState:UIControlStateNormal];

    turnBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [turnBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
    [self.rightToolboxView addSubview:turnBtn];
    
    //快慢速
    UIButton *rateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, h+d, w, h)];
    [rateBtn addTarget:self action:@selector(rateBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rateBtn setTitle:@"快慢速" forState:UIControlStateNormal];
    [rateBtn setImage:[UIImage imageNamed:@"rc_speed"] forState:UIControlStateNormal];
  
    rateBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [rateBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
    [self.rightToolboxView addSubview:rateBtn];
    //美化
    UIButton *beautifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2*(h +d), w, h)];
    [beautifyBtn addTarget:self action:@selector(beautifyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [beautifyBtn setTitle:@"美化" forState:UIControlStateNormal];
    [beautifyBtn setImage:[UIImage imageNamed:@"rc_beautify"] forState:UIControlStateNormal];

    beautifyBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [beautifyBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
    [self.rightToolboxView addSubview:beautifyBtn];
    //倒计时
    UIButton *countdownBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 3*(h+d), w, h)];
    [countdownBtn addTarget:self action:@selector(countdownBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [countdownBtn setTitle:@"倒计时" forState:UIControlStateNormal];
    [countdownBtn setImage:[UIImage imageNamed:@"rc_countdown"] forState:UIControlStateNormal];

    countdownBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [countdownBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
    [self.rightToolboxView addSubview:countdownBtn];
    
}
-(void)setupBottomToolboxView{
//    66 + 15 + 120 +10 + 50
    CGFloat y = MOL_SCREEN_HEIGHT - (MOL_SCALEHeight(40 + 15 + 100 + 50 -10)  + MOL_TabbarSafeBottomMargin);

    //bottom_shadow
    UIImageView *bottomShadow=[UIImageView new];
    [bottomShadow setImage: [UIImage imageNamed:@"bottom_shadow"]];
    [bottomShadow setFrame:CGRectMake(0,y, MOL_SCREEN_WIDTH,MOL_SCREEN_HEIGHT- y)];
    [self.view addSubview:bottomShadow];
    
    //
    self.bottomToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, y, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT- y)];
    [self.view addSubview:self.bottomToolboxView];
    
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
    [self.recordButton addTarget:self action:@selector(recordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolboxView addSubview:self.recordButton];
    //layer
    // 贝塞尔曲线(创建一个圆)
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(btnHaflWidth, btnHaflWidth) radius:btnHaflWidth + 4.1 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    // 创建一个shapeLayer1
    self.layer= [CAShapeLayer layer];
    self.layer.frame         = CGRectMake(buttonWidth/2 - btnHaflWidth,buttonHeight/2- btnHaflWidth, btnHaflWidth *2 , btnHaflWidth*2);//self.recordButton.bounds;
    // 与showView的frame一致
    self.layer.strokeColor   = [[UIColor whiteColor]colorWithAlphaComponent:0.8].CGColor;   // 边缘线的颜色
    self.layer.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    self.layer.lineCap       = kCALineCapSquare;               // 边缘线的类型
    self.layer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
    self.layer.lineWidth     = 4.0f;                           // 线条宽度
    self.layer.strokeStart   = 0.0f;
    self.layer.strokeEnd     = 1.0f;
    [self.recordButton.layer addSublayer:self.layer];

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
    [self.filterButton addTarget:self action:@selector(filterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomToolboxView addSubview:self.filterButton];

    
    // 音乐 结束录制的按钮
    self.endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endButton.frame = CGRectMake(0,0, Width, Height);
    self.endButton.center = CGPointMake(CGRectGetMaxX(self.recordButton.frame)+Width/2+BtnDis, self.recordButton.center.y);
    
    
    //切换音乐为结束
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"rc_next_step"] forState:UIControlStateNormal];
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"rc_next_step"] forState:UIControlStateDisabled];
    [self.endButton addTarget:self action:@selector(endButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
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
    [self.photoAlbumButton addTarget:self action:@selector(photoAlbumEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolboxView addSubview:self.photoAlbumButton];
    
    
    
    //外链
    self.linkButton =[[UIButton alloc] init];
    self.linkButton.frame =CGRectMake(CGRectGetMaxX(self.deleteButton.frame)  + dis , CGRectGetMinY(self.deleteButton.frame), w, h);
    [self.linkButton setImage:[UIImage imageNamed:@"btn_del_a"] forState:UIControlStateNormal];
     [self.linkButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1] forState:UIControlStateNormal];
    [self.linkButton setTitle:@"外链" forState:UIControlStateNormal];
    self.linkButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.linkButton addTarget:self action:@selector(linkButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolboxView addSubview:self.linkButton];
    
}

-(void)setUpBeautifyView{
    MJWeakSelf
    _beautifyView = [[MOLBeautifyView alloc] initWithCustomH:143 showBottom:NO];
    _beautifyView.exfoliatingSelIndex = MOL_BeautifyLevel;//默认磨皮等级
    _beautifyView.dismissBlock = ^{
        [weakSelf hideAll:NO];
    };
    _beautifyView.filterConfirmBlock = ^(PLSFilter *filter) {
        weakSelf.currentFilter = filter;
        weakSelf.isUseFilterWhenRecording = YES;
    };
    _beautifyView.BeautifyConfirmBlock = ^(float value) {
         [weakSelf.shortVideoRecorder setBeautifyModeOn:YES];
         [weakSelf.shortVideoRecorder setBeautify:value];
    };
    [_beautifyView setOptionFilter];//设置默认滤镜
    
}
// 返回上一层
- (void)backButtonEvent:(id)sender {
    if ([self.shortVideoRecorder getFilesCount] > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"放弃这个视频(共%ld个视频段)?", (long)[self.shortVideoRecorder getFilesCount]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        //灰
        [cancelAction setValue:HEX_COLOR_ALPHA(0x221E1E, 0.6) forKey:@"titleTextColor"];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self discardRecord];
        }];
        //红
        [sureAction setValue:HEX_COLOR(0xFE6257) forKey:@"titleTextColor"];
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
      

    } else {
        [self.shortVideoRecorder cancelRecording];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 相机反转
-(void)turnBtnAction{
    [self.shortVideoRecorder toggleCamera];
}
#pragma mark 快慢速率
-(void)rateBtnBtnAction{
    self.rateButtonView.hidden = !self.rateButtonView.hidden;
}
#pragma mark 美颜
-(void)beautifyBtnAction:(UIButton *)sender{
    
   [self hideAll:YES];
    [self.beautifyView showInView:self.view];
    
}
#pragma mark 倒计时
-(void)countdownBtnAction{
    
    [self hideAll:YES];
    MOLAudioCountDownView *musicView = [[MOLAudioCountDownView alloc] initWithMusicURL:self.selectedAudioUrl startTime:_recordedTime];
    musicView.dismissBlock = ^{
          [self hideAll:NO];
    };
     __weak typeof(self) wself = self;
    musicView.confirmBlock = ^(float startTime, float endTime) {
        
        MOLTimeJumpLable *lable = [[MOLTimeJumpLable alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
        lable.Block = ^(void){
             [self hideAll:NO];
            [wself recordButtonEvent:self.recordButton];
        };
        [wself.view addSubview:lable];
        [lable startCount];
         wself.stopRecordTime = endTime;//设置停止录制时间
    };
    [musicView showInView:self.view];

}
#pragma mark 录制按钮事件
-(void)recordButtonEvent:(UIButton *)button{
    //友盟统计录制按钮
    [MobClick event:ST_c_circle_video_button];
    if (_recordedTime >= self.shortVideoRecorder.maxDuration) {
        AlertViewShow(@"拍摄满了，请删除一段再拍摄");
        return;
    }
    
    
    [self recordEvent];
    button.selected = !button.selected;
    if (button.selected) {
        //录制动画
        [self animationSart];
    }else{
        //停止录制
        [self animationStop];
       //手动停止录制的时候把设定的倒计时清除掉。
        self.stopRecordTime = self.shortVideoRecorder.maxDuration + 0.1;
    }
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
        [self.deleteButton addTarget:self action:@selector(deleteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
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
        [self.deleteButton removeTarget:self action:@selector(deleteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
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
    [self.layer addAnimation:pathAnimation forKey:@"scale"];

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
    [self.layer addAnimation:pathAnimation forKey:@"scale"];

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
#pragma mark 取消录制按钮事件
- (void)discardRecord {
    [self.shortVideoRecorder cancelRecording];
    [_progressBar deleteAllProgress];
     _recordedTime = 0;
    self.selectedMusicBtn.enabled = YES;
    //录制时间不足最短录制时间
     self.endButton.hidden = YES;
    //删除完了
    [self updateUIWithEndRecod:NO];
}
#pragma mark 滤镜按钮事件
-(void)filterButtonEvent:(UIButton *)button{
    button.selected = !button.selected;

}
#pragma mark 删除按钮事件
-(void)deleteButtonEvent:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认删除上一段视频?" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    //灰
     [cancelAction setValue:HEX_COLOR_ALPHA(0x221E1E, 0.6) forKey:@"titleTextColor"];
     UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.shortVideoRecorder deleteLastFile];
        [self.progressBar deleteLastProgress];
        self.recordedTime = self.shortVideoRecorder.getTotalDuration;
        //录制时间不足最短录制时间
        if (self.recordedTime < MOL_RecordMinTime) {
            self.endButton.hidden = YES;
        }
        //删除完了
        if (self.shortVideoRecorder.getFilesCount < 1) {
            [self updateUIWithEndRecod:NO];
        }
    }];
    //红
    [sureAction setValue:HEX_COLOR(0xFE6257) forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    

}
#pragma mark 相册按钮事件
-(void)photoAlbumEvent:(UIButton *)button{
    //友盟统计
    [MobClick event:ST_c_photo_button];
    
    MOLVideoPickViewController *pick = [[MOLVideoPickViewController alloc] init];
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:nil];
//    [self.navigationController pushViewController:pick animated:YES];
}
#pragma mark 外链按钮事件
-(void)linkButtonEvent:(UIButton *)button{
    //友盟统计
    [MobClick event:ST_c_outside_button];
    
    MOLSupLinkeViewController *linkVC = [[MOLSupLinkeViewController alloc] initWithNibName:@"MOLSupLinkeViewController" bundle:nil];
    linkVC.ishowWarn = YES;
    [self.navigationController pushViewController:linkVC animated:YES];
}
#pragma mark 选择音乐
-(void)endButtonMusicEvent:(UIButton *)button{
    
    MOLSelectMusicViewController *selMusic = [[MOLSelectMusicViewController alloc] init];
    MJWeakSelf
    selMusic.selectedBlock = ^(NSURL *musicUrl, MOLMusicModel *music) {
        [weakSelf.selectedMusicBtn setTitle:music.name forState:UIControlStateNormal];
        weakSelf.selectedAudioUrl = musicUrl;
        weakSelf.currentMusicID = music.musicId;
        [weakSelf.shortVideoRecorder mixAudio:musicUrl];
    };
    [self presentViewController:selMusic animated:YES completion:nil];
    
}
-(void)setupOriginalMusic{
    if (self.originalMusicModel && self.originalMusicUrl) {
        [self.selectedMusicBtn setTitle:self.originalMusicModel.name forState:UIControlStateNormal];
        self.selectedAudioUrl = self.originalMusicUrl;
        self.currentMusicID = self.originalMusicModel.musicId;
        [self.shortVideoRecorder mixAudio:self.originalMusicUrl];
    }
  
}
#pragma mark 完成录制按钮事件
-(void)endButtonEvent:(UIButton *)button{
    // 获取当前会话的所有的视频段文件
    NSArray *filesURLArray = [self.shortVideoRecorder getAllFilesURL];
    NSLog(@"filesURLArray:%@", filesURLArray);
    __block AVAsset *movieAsset = self.shortVideoRecorder.assetRepresentingAllFiles;
    
    
    //如果选择了背景音乐，把原音抹掉
    if (self.selectedAudioUrl) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self loadActivityIndicatorView];
        // MusicVolume：0.5，videoVolume:0.0 即完全丢弃掉拍摄时的所有声音，只保留背景音乐的声音
        [self.shortVideoRecorder mixWithMusicVolume:MOL_audioVolume videoVolume:0.0 completionHandler:^(AVMutableComposition * _Nullable composition, AVAudioMix * _Nullable audioMix, NSError * _Nullable error) {
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
            NSURL *outputPath = [self exportAudioMixPath];
            exporter.outputURL = outputPath;
            exporter.outputFileType = AVFileTypeMPEG4;
            exporter.shouldOptimizeForNetworkUse= YES;
            exporter.audioMix = audioMix;
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                switch ([exporter status]) {
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"audio mix failed：%@", [[exporter error] description]);
                        AlertViewShow([[exporter error] description]);
                    } break;
                    case AVAssetExportSessionStatusCancelled: {
                        NSLog(@"audio mix canceled");
                    } break;
                    case AVAssetExportSessionStatusCompleted: {
                        NSLog(@"audio mix success");
                        movieAsset = [AVAsset assetWithURL:outputPath];
                    } break;
                    default: {

                    } break;
                }
                dispatch_semaphore_signal(semaphore);
            }];
        }];
        [self removeActivityIndicatorView];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }

    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    

    plsMovieSettings[PLSAssetKey] = movieAsset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.shortVideoRecorder getTotalDuration]];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:MOL_audioVolume];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    MOLEditViewController *videoEditViewController = [[MOLEditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    videoEditViewController.filesURLArray = filesURLArray;
    videoEditViewController.currentMusicID = self.currentMusicID;
    videoEditViewController.source = 1;//相机
    [self.navigationController pushViewController:videoEditViewController animated:NO];
}
#pragma mark - 输出路径
- (NSURL *)exportAudioMixPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *fileName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_mix.mp4",nowTimeStr]];
    return [NSURL fileURLWithPath:fileName];
}

// 加载拼接视频的动画
- (void)loadActivityIndicatorView {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
    }
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

// 移除拼接视频的动画
- (void)removeActivityIndicatorView {
    [self.activityIndicatorView removeFromSuperview];
    [self.activityIndicatorView stopAnimating];
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
        
        if (_recordedTime >= MOL_RecordMinTime) {
            self.endButton.hidden = NO;
        }else{
            self.endButton.hidden = YES;
        }
        
    }
}

#pragma mark -- MOLRateButtonViewDelegate
- (void)rateButtonView:(MOLRateButtonView *)rateButtonView didSelectedTitleIndex:(NSInteger)titleIndex{
    switch (titleIndex) {
        case 0:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateTopSlow;
            break;
        case 1:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateSlow;
            break;
        case 2:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateNormal;
            break;
        case 3:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateFast;
            break;
        case 4:
            self.shortVideoRecorder.recoderRate = PLSVideoRecoderRateTopFast;
            break;
        default:
            break;
    }
}

#pragma mark -- PLShortVideoRecorderDelegate 摄像头／麦克风鉴权的回调
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetCameraAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to camera");
    }
}

- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didGetMicrophoneAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to microphone");
    }
}

//#pragma mark - PLShortVideoRecorderDelegate 摄像头对焦位置的回调
//- (void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didFocusAtPoint:(CGPoint)point {
//    NSLog(@"shortVideoRecorder: didFocusAtPoint: %@", NSStringFromCGPoint(point));
//}

#pragma mark - PLShortVideoRecorderDelegate 摄像头采集的视频数据的回调
/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
- (CVPixelBufferRef)shortVideoRecorder:(PLShortVideoRecorder *)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    //此处可以做美颜/滤镜等处理
    // 是否在录制时使用滤镜，默认是关闭的，NO
    if (self.isUseFilterWhenRecording && self.currentFilter!= nil) {
        PLSFilter *filter = self.currentFilter;
        pixelBuffer = [filter process:pixelBuffer];
    }
    return pixelBuffer;
}
#pragma mark -- PLShortVideoRecorderDelegate 视频录制回调
//开始录制一段视频
-(void)shortVideoRecorder:(PLShortVideoRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL{
    
    [self.progressBar addProgressView];
    [self.progressBar startShining];
    
}
//正在录制中
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didRecordingToOutputFileAtURL:(NSURL * _Nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration{
    
    //设置进度条的进度
    [_progressBar setLastProgressToWidth:fileDuration / self.shortVideoRecorder.maxDuration * _progressBar.frame.size.width];
    //设置录制的时长
    _durationLabel.text = [NSString stringWithFormat:@"%.2f",totalDuration];
    //到达指定时间停止录制
    if (totalDuration >= self.stopRecordTime && totalDuration > 0.1) {
        [self recordButtonEvent:self.recordButton];
        _recordedTime = totalDuration;
        self.stopRecordTime = self.shortVideoRecorder.maxDuration + 0.1;
    }
}
//删除了某段视频
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didDeleteFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration{
    //设置录制的时长
    _durationLabel.text = [NSString stringWithFormat:@"%.2f",totalDuration];
    _recordedTime = totalDuration;
    
}
//完成一段视频的录制
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didFinishRecordingToOutputFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration{
    
    _recordedTime = totalDuration;
    [_progressBar stopShining];
    [self updateUIWithEndRecod:YES];
    
    //录制到了时间自动结束
    if (totalDuration >= self.shortVideoRecorder.maxDuration) {
        
        //拍摄满以后不提示
        _recordedTime = 0;
         [self recordButtonEvent:self.recordButton];
        _recordedTime = totalDuration;
        [self endButtonEvent:self.endButton];
    }

}

// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoRecorder startRecording]，那么会立即执行该回调。该回调功能是用于页面跳转
- (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration{
    
}
#pragma mark 选择视频的代理方法
- (void)picktedVoideWith:(NSURL *)url{
    
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    AVAsset *asset = [AVAsset assetWithURL:url];
    plsMovieSettings[PLSURLKey] = url;
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    
    NSNumber *num = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)];
    plsMovieSettings[PLSDurationKey] = num;
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    MOLClipMovieViewController *clipMovieViewController = [[MOLClipMovieViewController alloc] init];
    clipMovieViewController.settings = outputSettings;
    clipMovieViewController.source = 2;//相册
    [self.navigationController pushViewController:clipMovieViewController animated:YES];
}

#pragma mark 控制状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}


@end
