//
//  MOLClipMovieViewController.m
//  reward
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLClipMovieViewController.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "MOLEditViewController.h"
#import "MOLClipMovieView.h"


#define ClipViewH 200.f

@interface MOLClipMovieViewController ()<PLShortVideoEditorDelegate,MOLClipMovieViewDelegate>


@property (strong, nonatomic) PLShortVideoEditor *shortVideoEditor;// 编辑类
@property (strong, nonatomic) UIView *editDisplayView;//视频预览区域
@property (strong, nonatomic) MOLClipMovieView *clipView;//视频剪切View


// 编辑信息, movieSettings, watermarkSettings, stickerSettingsArray, audioSettingsArray 为 outputSettings 的字典元素
@property (strong, nonatomic) NSMutableDictionary *outputSettings;
@property (strong, nonatomic) NSMutableDictionary *movieSettings;// 视频文件信息
@property (strong, nonatomic) NSMutableDictionary *originMovieSettings;//原始视频信息设置
@property (assign, nonatomic) PLSVideoRecoderRateType currentRateType;//当前速率
// 视频的分辨率，设置之后影响编辑时的预览分辨率、导出的视频的的分辨率
@property (assign, nonatomic) CGSize videoSize;



// 视频合成的进度
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation MOLClipMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 用来演示如何获取视频的分辨率 videoSize
    NSDictionary *movieSettings = self.settings[PLSMovieSettingsKey];
    AVAsset *movieAsset = movieSettings[PLSAssetKey];
    if (!movieAsset) {
        NSURL *movieURL = movieSettings[PLSURLKey];
        movieAsset = [AVAsset assetWithURL:movieURL];
        self.movieSettings[PLSAssetKey] = movieAsset;
    }
    self.videoSize = movieAsset.pls_videoSize;

    //设置信息初始化
    [self setupShortVideoEditor];
    //播放区域
    [self setupEditDisplayView];
    //进度
    [self setupMergeToolboxView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.frame = CGRectMake(0, MOL_StatusBarHeight, self.navigationController.navigationBar.frame.size.width, 44);
}
#pragma mark - 编辑类
- (void)setupShortVideoEditor {
    // 编辑
    /* outputSettings 中的字典元素为 movieSettings, audioSettings, watermarkSettings */
    self.outputSettings = [[NSMutableDictionary alloc] init];
    self.movieSettings = [[NSMutableDictionary alloc] init];
    self.outputSettings[PLSMovieSettingsKey] = self.movieSettings;

    
    // 原始视频
    [self.movieSettings addEntriesFromDictionary:self.settings[PLSMovieSettingsKey]];

    
    
    //超过最大秒数的设置为最大
    if ([self.movieSettings[PLSDurationKey] floatValue] > MOL_RecordMaxTime ) {
        self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:MOL_RecordMaxTime];
    }

    
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0];
    
    // 备份原始视频的信息
    self.originMovieSettings = [[NSMutableDictionary alloc] init];
    [self.originMovieSettings addEntriesFromDictionary:self.movieSettings];
    
    //当前速率
    self.currentRateType = PLSVideoRecoderRateNormal;
   
    // 视频编辑类
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithAsset:asset videoSize:CGSizeZero];
    self.shortVideoEditor.delegate = self;
    self.shortVideoEditor.loopEnabled = YES;
    
    // 要处理的视频的时间区域
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1000, 1000);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1000, 1000);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    // 视频编辑时，改变预览分辨率
    self.shortVideoEditor.videoSize = self.videoSize;
}

- (void)setupEditDisplayView {
    
    self.editDisplayView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.editDisplayView];
    self.shortVideoEditor.previewView.frame = self.editDisplayView.bounds;
    self.shortVideoEditor.fillMode = PLSVideoFillModePreserveAspectRatio;
    [self.editDisplayView addSubview:self.shortVideoEditor.previewView];
    [self.shortVideoEditor startEditing];

    [self.view addSubview:self.clipView];
    
    
//    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.playButton.frame = self.shortVideoEditor.previewView.frame;
//    self.playButton.center = self.shortVideoEditor.previewView.center;
//    [self.playButton setImage:[UIImage imageNamed:@"btn_play_bg_a"] forState:UIControlStateSelected];
//    [self.editDisplayView addSubview:self.playButton];
//    [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//
    // 视频分辨率
//    AVAsset *asset = self.movieSettings[PLSAssetKey];
//
//    CGSize vSize = asset.pls_videoSize;
//
//    CGFloat x = 0;
//    CGFloat y = 0;
//
//    CGFloat displayViewWidth = self.editDisplayView.frame.size.width;
//    CGFloat displayViewHeight = self.editDisplayView.frame.size.height;
//
//    CGFloat width = displayViewWidth;
//    CGFloat height = displayViewHeight;
//
//    if (vSize.width / vSize.height < displayViewWidth / displayViewHeight) {
//        width = vSize.width / vSize.height * displayViewHeight;
//        x = (displayViewWidth - width) * 0.5;
//    }else if (vSize.width / vSize.height > displayViewWidth / displayViewHeight){
//        height = vSize.height / vSize.width * displayViewWidth;
//        y = (displayViewHeight - height) * 0.5;
//    }
//
//
    // 添加点击手势
//    self.tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchBGView:)];
//    self.tapGes.cancelsTouchesInView = NO;
//    self.tapGes.delegate = self;
//    [self.view addGestureRecognizer:self.tapGes];
}
- (void)setupMergeToolboxView {
    // 展示拼接视频的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // 展示拼接视频的进度
    CGFloat width = self.activityIndicatorView.frame.size.width;
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 45)];
    self.progressLabel.textAlignment =  NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.center = CGPointMake(self.activityIndicatorView.center.x, self.activityIndicatorView.center.y + 40);
    [self.activityIndicatorView addSubview:self.progressLabel];
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

#pragma mark - PLShortVideoEditorDelegate 编辑时处理视频数据，并将加了滤镜效果的视频数据返回
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp {
    
    CVPixelBufferRef tempPixelBuffer = pixelBuffer;
    
    // 更新时间线视图
    CGFloat time = CMTimeGetSeconds(timestamp);
    
//    NSLog(@"currentTime%.4f",time);
    
    [self.clipView setProgressBarPoisionWithSecond:time];
    
    
    return tempPixelBuffer;
}
#pragma mark - 裁剪视频的回调 PLSClipMovieView delegate
- (void)didStartDragView {
    [self.shortVideoEditor stopEditing];

}
- (void)clipFrameView:(MOLClipMovieView *)clipFrameView didEndDragLeftView:(CMTime)leftTime rightView:(CMTime)rightTime {
    CGFloat start = CMTimeGetSeconds(leftTime);
    CGFloat end = CMTimeGetSeconds(rightTime);
    CGFloat duration = end - start;
    
    self.originMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:start];
    self.originMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:duration];
    
    // 每次选段变化之后，将变化的值按照倍速作用到 movieSettings 中
    float rate = [self getRateNumberWithRateType:self.currentRateType];
    float rateStart = start * rate;
    float rateDuration = duration * rate;
    self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:rateStart];
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:rateDuration];
    
    self.shortVideoEditor.timeRange = CMTimeRangeMake(CMTimeMake(rateStart * 1000, 1000), CMTimeMake(rateDuration * 1000, 1000));
    [self.shortVideoEditor startEditing];
}
- (void)clipFrameView:(MOLClipMovieView *)clipFrameView isScrolling:(BOOL)scrolling {
    self.view.userInteractionEnabled = !scrolling;
}

-(void)endButtonAction{
    [self.shortVideoEditor stopEditing];
    [self loadActivityIndicatorView];
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    PLSAVAssetExportSession *exportSession = [[PLSAVAssetExportSession alloc] initWithAsset:asset];
    exportSession.outputFileType = PLSFileTypeMPEG4;
        exportSession.outputURL = [NSURL fileURLWithPath:[MOLCacheFileManager getTempVideoFilePath]];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputSettings = self.outputSettings;
    
    
    
     CMTime cmtime = asset.duration;
    
    float assetTotalSeconds = CMTimeGetSeconds(cmtime);
    float time =[self.movieSettings[PLSDurationKey] floatValue] - assetTotalSeconds;
    float dis = fabsf(time);
    
    //没有裁剪的时候误差大于0.001判定为裁剪过 否则定为没有裁剪 URL视频传过来的时候减小duration默认定为裁剪过
    if (dis < 0.001) {
        // 设置音视频、水印等编辑信息
        NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
        // 待编辑的原始视频素材
        NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
        plsMovieSettings[PLSAssetKey] = asset;
        plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
        plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:assetTotalSeconds];
        
        plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
        outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
        MOLEditViewController *videoEditViewController = [[MOLEditViewController alloc] init];
        videoEditViewController.settings = outputSettings;
        videoEditViewController.source = self.source;
        videoEditViewController.currentMusicID = 0;
        [self removeActivityIndicatorView];
        [self.navigationController pushViewController:videoEditViewController animated:NO];
        return;
    }
    

//    exportSession.isExportMovieToPhotosAlbum = YES;是否保存相册
    //    // 设置视频的码率
    //    exportSession.bitrate = 3000*1000;
    //    // 设置视频的输出路径
    //    exportSession.outputURL = [self getFileURL:@"outputMovie"];
    
    // 设置视频的导出分辨率，会将原视频缩放
    exportSession.outputVideoSize = self.videoSize;    
    // 旋转视频
//    exportSession.videoLayerOrientation = self.videoLayerOrientation;

    __weak typeof(self) weakSelf = self;
    [exportSession setCompletionBlock:^(NSURL *url) {
        NSLog(@"Asset Export Completed");
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf joinNextViewController:url];
        });
    }];
    
    [exportSession setFailureBlock:^(NSError *error) {
        NSLog(@"Asset Export Failed: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeActivityIndicatorView];
        });
    }];
    
    [exportSession setProcessingBlock:^(float progress) {
        // 更新进度 UI
        NSLog(@"Asset Export Progress: %f", progress);
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
    }];
    
    [exportSession exportAsynchronously];
}

#pragma mark - 完成视频合成跳转到下一页面
- (void)joinNextViewController:(NSURL *)url {
    [self removeActivityIndicatorView];
    
    __block AVAsset *movieAsset = [AVAsset assetWithURL:url];
    
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    
    plsMovieSettings[PLSAssetKey] = movieAsset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:CMTimeGetSeconds(movieAsset.duration)];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    MOLEditViewController *editViewController = [[MOLEditViewController alloc] init];
    editViewController.settings = outputSettings;
    editViewController.source = self.source;
    [self.navigationController pushViewController:editViewController animated:YES];
}


-(void)closeButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}


/// 根据速率配置相应倍速后的视频时长
- (CGFloat)getRateNumberWithRateType:(PLSVideoRecoderRateType)rateType {
    CGFloat scaleFloat = 1.0;
    switch (rateType) {
        case PLSVideoRecoderRateNormal:
            scaleFloat = 1.0;
            break;
        case PLSVideoRecoderRateSlow:
            scaleFloat = 1.5;
            break;
        case PLSVideoRecoderRateTopSlow:
            scaleFloat = 2.0;
            break;
        case PLSVideoRecoderRateFast:
            scaleFloat = 0.666667;
            break;
        case PLSVideoRecoderRateTopFast:
            scaleFloat = 0.5;
            break;
        default:
            break;
    }
    return scaleFloat;
}

#pragma mark 懒加载
-(MOLClipMovieView *)clipView{
    if (!_clipView) {
        AVAsset *asset = self.movieSettings[PLSAssetKey];
//        CGFloat duration = CMTimeGetSeconds(asset.duration);
        _clipView = [[MOLClipMovieView alloc] initWithMovieAsset:asset minDuration:MOL_RecordMinTime maxDuration:MOL_RecordMaxTime];
        _clipView.frame = CGRectMake(0, MOL_SCREEN_HEIGHT - 200, MOL_SCREEN_WIDTH, 200);
        _clipView.delegate = self;
    }
    return _clipView;
}



@end
