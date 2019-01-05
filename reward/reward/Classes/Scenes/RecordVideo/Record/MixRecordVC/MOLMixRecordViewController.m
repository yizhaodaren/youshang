//
//  MOLRecordViewController.m
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//
#import "MOLMixRecordViewController.h"
#import "MOLRecordManager.h"
#import "MOLProgressBar.h"
#import "MOLRateButtonView.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "MOLEditViewController.h"
#import "MOLVideoPickViewController.h"
#import "MOLSupLinkeViewController.h"

#import "MOLAudioCountDownView.h"
#import "MOLTimeJumpLable.h"
#import "MOLClipMovieViewController.h"
#import "MOLBeautifyView.h"
#import "MOLSelectMusicViewController.h"

#import "MOLMixRecordView.h"
#define AlertViewShow(msg) [[[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"%@", msg] delegate:nil cancelButtonTitle:@"我知道了!" otherButtonTitles:nil] show]


@interface MOLMixRecordViewController ()< PLSVideoMixRecordererDelegate,PicktedVoidDelegate,MOLRateButtonViewDelegate>

//******************************************传值****************************************//
@property(nonatomic,assign)NSInteger currentMusicID;//音乐ID（以视频的最后一次添加音乐的ID为准）
//**********************************************************************************//

//短视频录制的核心类。
@property(nonatomic,strong)PLSVideoMixRecorder *videoMixRecorder;
@property(nonatomic,strong)MOLMixRecordView  *mixRecordView;
@property(nonatomic,strong) NSURL *selectedAudioUrl; //选中的配乐
@property(nonatomic,assign) CGFloat stopRecordTime; //设置的停止录制时间
//******************************************滤镜****************************************//
@property(nonatomic,assign) BOOL isUseFilterWhenRecording;// 录制时是否使用滤镜
@property(nonatomic,strong) PLSFilter *currentFilter;//当前滤镜

//美化
@property(nonatomic,strong)MOLBeautifyView *beautifyView;
@property(nonatomic,strong) MOLAudioCountDownView *countDownView;//倒计时
@property(nonatomic,strong) UIAlertView *alertView;
@property(nonatomic,assign)BOOL isHidenTaBar;
@property (assign, nonatomic) CGFloat maxDuration;
@property (assign, nonatomic) CGFloat minDuration;

@property(nonatomic,strong)AVAsset  *currentAsset;
// 合拍视频地址 网络URL
@property (nonatomic, strong) NSURL *mixURL;
@end

@implementation MOLMixRecordViewController

- (instancetype)initWith:(NSURL *)mixURL
{
    self = [super init];
    if (self) {
        self.mixURL = mixURL;
    }
    return self;
}

-(BOOL)showNavigation{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initUI];
    [self addAction];
    //初始化录制时间
    MOLMixRCTIME = 0.0f;
    [self setupRecored];
    [self setUpBeautifyView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.videoMixRecorder startCaptureSession];
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    statusBar.alpha = 0.0;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videoMixRecorder stopCaptureSession];
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    statusBar.alpha = 1.0;
}
-(void)initUI{
    self.mixRecordView = [[MOLMixRecordView alloc] initWithFrame:self.view.frame];
    self.mixRecordView.backgroundColor = self.view.backgroundColor;
    self.view = self.mixRecordView;
}

-(void)setupRecored{
    self.currentAsset = [AVAsset assetWithURL:self.mixURL];
    CGSize videosSize = self.currentAsset.pls_videoSize;
    self.videoMixRecorder = [MOLRecordManager initMixRecorderWith:videosSize];
//    CGFloat height = MOL_SCREEN_WIDTH/2 * videosSize.height / videosSize.width;
//    self.videoMixRecorder.previewView.frame = CGRectMake(0, (MOL_SCREEN_HEIGHT - height)/2, MOL_SCREEN_WIDTH, height);
    
    
    
    CGFloat height = MOL_SCREEN_WIDTH/2 *16/9;
    self.videoMixRecorder.previewView.frame = CGRectMake(0, (MOL_SCREEN_HEIGHT - height)/2, MOL_SCREEN_WIDTH, height);
    
    self.videoMixRecorder.delegate = self;
    self.videoMixRecorder.mergeVideoURL = self.mixURL;
    [self.view insertSubview:self.videoMixRecorder.previewView atIndex:0];
}
-(void)setUpBeautifyView{
    MJWeakSelf
    _beautifyView = [[MOLBeautifyView alloc] initWithCustomH:143 showBottom:NO];
    _beautifyView.exfoliatingSelIndex = MOL_BeautifyLevel;//默认磨皮等级
    _beautifyView.dismissBlock = ^{
        [weakSelf.mixRecordView hideAll:NO];
    };
    _beautifyView.filterConfirmBlock = ^(PLSFilter *filter) {
        weakSelf.currentFilter = filter;
        weakSelf.isUseFilterWhenRecording = YES;
    };
    _beautifyView.BeautifyConfirmBlock = ^(float value) {
        [weakSelf.videoMixRecorder setBeautifyModeOn:YES];
        [weakSelf.videoMixRecorder setBeautify:value];
    };
    [_beautifyView setOptionFilter];
}
-(void)setUpCountDownView{
    MJWeakSelf
    self.countDownView = [[MOLAudioCountDownView alloc] initWithMusicMaxTime:self.maxDuration startTime:MOLMixRCTIME];
    self.countDownView.dismissBlock = ^{
        [weakSelf.mixRecordView hideAll:NO];
    };
    __weak typeof(self) wself = self;
    self.countDownView.confirmBlock = ^(float startTime, float endTime) {
        MOLTimeJumpLable *lable = [[MOLTimeJumpLable alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
        lable.Block = ^(void){
            [weakSelf.mixRecordView hideAll:NO];
            [weakSelf recordButtonEvent:weakSelf.mixRecordView.recordButton];
        };
        [wself.view addSubview:lable];
        [lable startCount];
        wself.stopRecordTime = endTime;//设置停止录制时间
    };
}
// 返回上一层
- (void)backButtonEvent:(id)sender {
    if ([self.videoMixRecorder getFilesCount] > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"放弃这个视频(共%ld个视频段)?", (long)[self.videoMixRecorder getFilesCount]] preferredStyle:UIAlertControllerStyleAlert];
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
        [self.videoMixRecorder cancelRecording];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 添加Action
-(void)addAction{
    [self.mixRecordView.backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.mixRecordView.selectedMusicBtn addTarget:self action:@selector(endButtonMusicEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.mixRecordView.turnBtn addTarget:self action:@selector(turnBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.mixRecordView.rateBtn addTarget:self action:@selector(rateBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mixRecordView.beautifyBtn addTarget:self action:@selector(beautifyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mixRecordView.countdownBtn addTarget:self action:@selector(countdownBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.mixRecordView.audioBtn addTarget:self action:@selector(audioBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mixRecordView.recordButton addTarget:self action:@selector(recordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.mixRecordView.filterButton addTarget:self action:@selector(filterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.mixRecordView.endButton addTarget:self action:@selector(endButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.mixRecordView.photoAlbumButton addTarget:self action:@selector(photoAlbumEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.mixRecordView.linkButton addTarget:self action:@selector(linkButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.mixRecordView.deleteButton addTarget:self action:@selector(deleteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
}
//处理录制按钮事件
-(void)recordEvent{
    if (self.videoMixRecorder.isRecording || fabs(MOLMixRCTIME) >= self.maxDuration - 0.1) {
        [self.videoMixRecorder stopRecording];
    }else{
        [self.videoMixRecorder startRecording];
    }
}
#pragma mark 相机反转
-(void)turnBtnAction{
    [self.videoMixRecorder toggleCamera];
}
#pragma mark 快慢速率
-(void)rateBtnBtnAction{
//    self.videoMixRecorder.disableSample = self.
    self.mixRecordView.rateButtonView.hidden = !self.mixRecordView.rateButtonView.hidden;
}
#pragma mark 美颜
-(void)beautifyBtnAction:(UIButton *)sender{

    [self.mixRecordView hideAll:YES];
    [self.beautifyView showInView:self.view];

}
#pragma mark 倒计时
-(void)countdownBtnAction{
    
    if (self.maxDuration > 0) {
        [self setUpCountDownView];
        [self.mixRecordView hideAll:YES];
        [self.countDownView showInView:self.view];
    }
 

}
#pragma mark 声音开关
-(void)audioBtnAction{
    
    self.videoMixRecorder.disableMicrophone = self.mixRecordView.audioBtn.selected;
    self.mixRecordView.audioBtn.selected = !self.mixRecordView.audioBtn.selected;
    
}
#pragma mark 录制按钮事件
-(void)recordButtonEvent:(UIButton *)button{
   
    if (MOLMixRCTIME >= self.maxDuration - 0.1) {
        if (self.maxDuration < 0.1) {
             AlertViewShow(@"素材资源加载失败,请重新加载或者选择其他合拍资源。");
        }else{
             AlertViewShow(@"拍摄满了");
        }
        return;
    }
    [self recordEvent];
    button.selected = !button.selected;
    if (button.selected) {
        //录制动画
        [self.mixRecordView animationSart];
    }else{
        //停止录制
        [self.mixRecordView animationStop];
        //手动停止录制的时候把设定的倒计时清除掉。
        self.stopRecordTime = self.maxDuration;
    }
}

#pragma mark 取消录制按钮事件
- (void)discardRecord {
    [self.videoMixRecorder cancelRecording];
    [self.mixRecordView.progressBar deleteAllProgress];
    MOLMixRCTIME = 0;
    self.mixRecordView.selectedMusicBtn.enabled = YES;
    //录制时间不足最短录制时间
    self.mixRecordView.endButton.hidden = YES;
    //删除完了
    [self.mixRecordView updateUIWithEndRecod:NO];
}
#pragma mark 滤镜按钮事件
-(void)filterButtonEvent:(UIButton *)button{
    button.selected = !button.selected;

}
#pragma mark 删除按钮事件
-(void)deleteButtonEvent:(UIButton *)button{
    
    if ([self.videoMixRecorder getFilesCount] > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定重新录制？" preferredStyle:UIAlertControllerStyleAlert];
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
    }


}
#pragma mark 相册按钮事件
-(void)photoAlbumEvent:(UIButton *)button{

    MOLVideoPickViewController *pick = [[MOLVideoPickViewController alloc] init];
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:nil];
    //    [self.navigationController pushViewController:pick animated:YES];
}
#pragma mark 外链按钮事件
-(void)linkButtonEvent:(UIButton *)button{

    MOLSupLinkeViewController *linkVC = [[MOLSupLinkeViewController alloc] initWithNibName:@"MOLSupLinkeViewController" bundle:nil];
    linkVC.ishowWarn = YES;
    [self.navigationController pushViewController:linkVC animated:YES];
}
#pragma mark 选择音乐
-(void)endButtonMusicEvent:(UIButton *)button{

    MOLSelectMusicViewController *selMusic = [[MOLSelectMusicViewController alloc] init];
    MJWeakSelf
    selMusic.selectedBlock = ^(NSURL *musicUrl, MOLMusicModel *music) {
        [weakSelf.mixRecordView.selectedMusicBtn setTitle:music.name forState:UIControlStateNormal];
        weakSelf.selectedAudioUrl = musicUrl;
        weakSelf.currentMusicID = music.musicId;
//        [weakSelf.videoMixRecorder mixAudio:musicUrl];
    };
    [self presentViewController:selMusic animated:YES completion:nil];

}
#pragma mark 完成录制按钮事件
-(void)endButtonEvent:(UIButton *)button{
    // 获取当前会话的所有的视频段文件
    NSArray *filesURLArray = [self.videoMixRecorder getAllFilesURL];
    NSLog(@"filesURLArray:%@", filesURLArray);
    __block AVAsset *movieAsset = self.videoMixRecorder.assetRepresentingAllFiles;


    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];


    plsMovieSettings[PLSAssetKey] = movieAsset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:[self.videoMixRecorder getTotalDuration]];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:MOL_audioVolume];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;

    MOLEditViewController *videoEditViewController = [[MOLEditViewController alloc] init];
    videoEditViewController.settings = outputSettings;
    videoEditViewController.filesURLArray = filesURLArray;
    videoEditViewController.currentMusicID = self.currentMusicID;
    videoEditViewController.source = 4;//合拍
    [self.navigationController pushViewController:videoEditViewController animated:NO];
}


#pragma mark -- MOLRateButtonViewDelegate
- (void)rateButtonView:(MOLRateButtonView *)rateButtonView didSelectedTitleIndex:(NSInteger)titleIndex{
//    switch (titleIndex) {
//        case 0:
//            self.videoMixRecorder.recoderRate = PLSVideoRecoderRateTopSlow;
//            break;
//        case 1:
//            self.videoMixRecorder.recoderRate = PLSVideoRecoderRateSlow;
//            break;
//        case 2:
//            self.videoMixRecorder.recoderRate = PLSVideoRecoderRateNormal;
//            break;
//        case 3:
//            self.videoMixRecorder.recoderRate = PLSVideoRecoderRateFast;
//            break;
//        case 4:
//            self.videoMixRecorder.recoderRate = PLSVideoRecoderRateTopFast;
//            break;
//        default:
//            break;
//    }
}



#pragma mark -- PLSVideoMixRecorderDelegate 摄像头／麦克风鉴权的回调
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetCameraAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to camera");
    }
}

- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMicrophoneAuthorizationStatus:(PLSAuthorizationStatus)status {
    if (status == PLSAuthorizationStatusAuthorized) {
        [recorder startCaptureSession];
    }
    else if (status == PLSAuthorizationStatusDenied) {
        NSLog(@"Error: user denies access to microphone");
    }
}

#pragma mark - PLSVideoMixRecorderDelegate 摄像头采集的视频数据的回调
/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
- (CVPixelBufferRef)videoMixRecorder:(PLSVideoMixRecorder *)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if (self.isUseFilterWhenRecording && self.currentFilter!= nil) {
        PLSFilter *filter = self.currentFilter;
        pixelBuffer = [filter process:pixelBuffer];
    }
    return pixelBuffer;
}

#pragma mark -- PLSVideoMixRecorderDelegate 视频录制回调
// 素材视频的部分信息回调
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetSampleVideoInfo:(int)videoWith videoHeight:(int)videoheight frameRate:(float)frameRate duration:(CMTime)duration {
 

    self.maxDuration = CMTimeGetSeconds(duration);
    if (self.maxDuration > MOL_RecordMaxTime) {
        self.maxDuration = MOL_RecordMaxTime;
    }
    if (self.maxDuration == 0) {
        [MBProgressHUD showMessageAMoment:@"素材视频加载失败"];
        return;
    }

    [self.mixRecordView.progressBar setMinTime:MOL_RecordMinTime AndMaxTime:self.maxDuration];
    self.stopRecordTime = self.maxDuration;
    NSLog(@"%ld",self.maxDuration);
}
- (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder errorOccur:(NSError *__nonnull)error{
    
}

// 开始录制一段视频时
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {

    [self.mixRecordView.progressBar addProgressView];
    [self.mixRecordView.progressBar startShining];
}

// 正在录制的过程中
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
       MOLMixRCTIME = totalDuration;
    //设置进度条的进度
    [self.mixRecordView.progressBar setLastProgressToWidth:fileDuration / self.maxDuration * self.mixRecordView.progressBar.frame.size.width];
    //设置录制的时长
    self.mixRecordView.durationLabel.text = [NSString stringWithFormat:@"%.2f",totalDuration];
    //到达指定时间停止录制
    if (totalDuration >= self.stopRecordTime && totalDuration > 0.1) {
        [self recordButtonEvent:self.mixRecordView.recordButton];
        self.stopRecordTime = self.maxDuration - 0.01;
     
    }
}

// 完成一段视频的录制时
- (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    MOLMixRCTIME = totalDuration;
    [self.mixRecordView.progressBar stopShining];
    [self.mixRecordView updateUIWithEndRecod:YES];
    //录制到了时间自动结束
    CGFloat dis = totalDuration - self.maxDuration;
    if (dis >= - 0.1) {
        MOLMixRCTIME = -totalDuration;  //拍摄满以后不提示
        [self recordButtonEvent:self.mixRecordView.recordButton];
        MOLMixRCTIME = totalDuration;
        [self endButtonEvent:self.mixRecordView.endButton];
    }
}

////删除了某段视频
//- (void)videoMixRecorder:(PLvideoMixRecorder *__nonnull)recorder didDeleteFileAtURL:(NSURL *__nonnull)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration{
//    //设置录制的时长
//    _durationLabel.text = [NSString stringWithFormat:@"%.2f",totalDuration];
//    MOLMixRCTIME = totalDuration;
//
//}

//
//// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLvideoMixRecorder startRecording]，那么会立即执行该回调。该回调功能是用于页面跳转
//- (void)videoMixRecorder:(PLvideoMixRecorder *__nonnull)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration{
//
//}



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

