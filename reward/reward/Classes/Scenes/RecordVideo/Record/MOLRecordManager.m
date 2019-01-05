//
//  MOLRecordManager.m
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLRecordManager.h"
#import "MOLRecordViewController.h"
#import "MOLMixRecordViewController.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import <PLShortVideoKit/PLShortVideoRecorder.h>
#import <PLShortVideoKit/PLSVideoMixRecorder.h>
#import <AFHTTPSessionManager.h>

@interface MOLRecordManager()
@property(nonatomic,copy)NSString  *locationUrlStr;
@end

@implementation MOLRecordManager

+(instancetype)manager{
    static  MOLRecordManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager  = [[MOLRecordManager alloc] init];
    });
    return manager;
}
+(PLShortVideoRecorder *)initRecorder{
    PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    videoConfiguration.position = AVCaptureDevicePositionFront;
    videoConfiguration.videoFrameRate = 25;
    videoConfiguration.averageVideoBitRate = 4000*1024;
    videoConfiguration.sessionPreset = AVCaptureSessionPreset1920x1080;
    videoConfiguration.videoSize =  CGSizeMake(540 * 2, 960 * 2);
    NSString * deviceModel = [STSystemHelper getDeviceModel];
    
    if ([deviceModel hasPrefix:@"iPhone 4"]||[deviceModel hasPrefix:@"iPhone 5"] ||[deviceModel hasPrefix:@"iPhone 6"]) {
        videoConfiguration.averageVideoBitRate = 2000*1024;
        videoConfiguration.sessionPreset = AVCaptureSessionPreset1280x720;
        videoConfiguration.videoSize =  CGSizeMake(540, 960);
    }
 
    
    videoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;
    PLSAudioConfiguration *audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    PLShortVideoRecorder *shortVideoRecorder = [[PLShortVideoRecorder alloc] initWithVideoConfiguration:videoConfiguration audioConfiguration:audioConfiguration];
    //默认前置摄像头
    shortVideoRecorder.captureDevicePosition = AVCaptureDevicePositionFront;
    //1.5 最大拍摄时长
    shortVideoRecorder.maxDuration = MOL_RecordMaxTime;
    //最小拍摄时长
    shortVideoRecorder.minDuration = MOL_RecordMinTime;
    //默认
    [shortVideoRecorder setBeautifyModeOn:YES];
    [shortVideoRecorder setBeautify:MOL_BeautifyValue];
    
    //1.6 是否根据设备方向自动确定竖屏 横屏拍摄
//    shortVideoRecorder.adaptationRecording = YES;
    //1.7默认为YES 从后台进入前台自动开始录制
    shortVideoRecorder.backgroundMonitorEnable = YES;
    shortVideoRecorder.recoderRate = PLSVideoRecoderRateNormal;
    shortVideoRecorder.outputFileType = PLSFileTypeMPEG4; //录制视频的保存类型
    shortVideoRecorder.innerFocusViewShowEnable = YES; // 显示 SDK 内部自带的对焦动画
    shortVideoRecorder.streamMirrorFrontFacing = YES;//输出时候镜像
    
    AVCaptureDevice *device = shortVideoRecorder.captureDeviceInput.device;
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        [device setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    [device unlockForConfiguration];
//    [UIScreen mainScreen].brightness = 0.8;
  
    return shortVideoRecorder;

}
//    videoConfiguration.videoSize = CGSizeMake(720, 640);
//    videoConfiguration.cameraVideoFrame = CGRectMake(0, 0, 360, 640);
//    videoConfiguration.sampleVideoFrame = CGRectMake(360, 0, 360, 640);

//初始化合拍类
+(PLSVideoMixRecorder *)initMixRecorderWith:(CGSize)videosSize{
    PLSVideoMixConfiguration *videoConfiguration = [PLSVideoMixConfiguration defaultConfiguration];
    videoConfiguration.position = AVCaptureDevicePositionFront;
    videoConfiguration.videoOrientation = AVCaptureVideoOrientationPortrait;
    videoConfiguration.videoFrameRate = 25;
    videoConfiguration.averageVideoBitRate = 1024*4000;
    videoConfiguration.sessionPreset = AVCaptureSessionPreset1920x1080;
    NSString * deviceModel = [STSystemHelper getDeviceModel];
       if ([deviceModel hasPrefix:@"iPhone 4"]||[deviceModel hasPrefix:@"iPhone 5"] ||[deviceModel hasPrefix:@"iPhone 6"]){
        videoConfiguration.averageVideoBitRate = 2000*1024;
        videoConfiguration.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
        videoConfiguration.videoSize = CGSizeMake(720, 640);
        videoConfiguration.cameraVideoFrame = CGRectMake(0, 0, 360, 640);

    
    
    CGFloat ratio = (videosSize.width / videosSize.height);
    CGFloat minRatio = 8.0/16;
    CGFloat maxRatio = 10.0/16.0;
    
    if (ratio > minRatio  &&  ratio < maxRatio) {
        videoConfiguration.sampleVideoFrame = CGRectMake(360, 0, 360, 640);
    }else if (ratio > maxRatio) {
        CGFloat height = 360 * videosSize.height /videosSize.width;
        videoConfiguration.sampleVideoFrame = CGRectMake(360, (640 - height)/2, 360, height);
    }else{
        CGFloat width = 640 * videosSize.width / videosSize.height;
         videoConfiguration.sampleVideoFrame = CGRectMake(360, 0, (360 - width)/2, 640);
    }

//    videoConfiguration.videoSize = CGSizeMake(videosSize.width * 2, videosSize.height);
//    videoConfiguration.cameraVideoFrame = CGRectMake(0, 0, videosSize.width, videosSize.height);
//    videoConfiguration.sampleVideoFrame = CGRectMake(videosSize.width, 0, videosSize.width, videosSize.height);
    
    
    PLSAudioMixConfiguration *audioConfiguration = [PLSAudioMixConfiguration defaultConfiguration];
    audioConfiguration = [PLSAudioMixConfiguration defaultConfiguration];
    audioConfiguration.sampleVolume = 0.6;
    audioConfiguration.microphoneVolume = 0.6;
    audioConfiguration.acousticEchoCancellationEnable = NO;
    audioConfiguration.numberOfChannels = 1;
    audioConfiguration.disableSample = NO;
    audioConfiguration.disableMicrophone = YES;
    
    PLSVideoMixRecorder *videoMixRecorder = [[PLSVideoMixRecorder alloc] initWithVideoConfiguration:videoConfiguration audioConfiguration:audioConfiguration];
    videoMixRecorder.captureDevicePosition = AVCaptureDevicePositionFront;  //默认前置摄像头
    //默认磨皮
    [videoMixRecorder setBeautifyModeOn:YES];
    [videoMixRecorder setBeautify:MOL_BeautifyValue];
    videoMixRecorder.outputFileType = PLSFileTypeMPEG4; //录制视频的保存类型
    videoMixRecorder.innerFocusViewShowEnable = YES; // 显示 SDK 内部自带的对焦动画
    videoMixRecorder.backgroundMonitorEnable = YES; //1.7默认为YES 从后台进入前台自动开始录制
    videoMixRecorder.streamMirrorFrontFacing = YES;
    videoMixRecorder.fillMode = PLSVideoFillModePreserveAspectRatio;
    return videoMixRecorder;
}

-(void)loadMaterialResourcesWith:(NSURL *)mixURL WithRewardID:(NSInteger)rewardID{
     [MOLReleaseManager manager].rewardID = rewardID;//悬赏ID为0 代表自发的作品没有悬赏
    NSString *str = [mixURL.absoluteString componentsSeparatedByString:@"_"].lastObject;
    NSString *filePath =[MOLCacheFileManager getCacheVideoFilePath:str];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {//如果不存在就存储 存在就不存
        [self DownloadMaterialResourcesWithURL:mixURL WithPath:filePath];
    }else{
        self.locationUrlStr = filePath;
   
        [self setupRecored];
    }
}
//-----下载视频--
- (void)DownloadMaterialResourcesWithURL:(NSURL *)mixURL WithPath:(NSString *)voidFilePath{
    
    UIViewController *topvc =  [CommUtls topViewController];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:topvc.view animated:YES];
    hud.bezelView.style=MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor =[UIColor blackColor];
    hud.contentColor =[UIColor whiteColor];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"资源加载...";
    hud.label.font = MOL_FONT(12);
    [hud showAnimated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:mixURL];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        hud.progressObject = downloadProgress;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString * hudProgress = [NSString stringWithFormat:@"资源加载%2.f%%",downloadProgress.fractionCompleted * 100];
            hud.label.text = hudProgress;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:voidFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        if (error) {
            [MBProgressHUD showMessageAMoment:@"资源加载失败"];
            [[NSFileManager defaultManager] removeItemAtPath:voidFilePath error:nil];
            return;
        }
        self.locationUrlStr = voidFilePath;
        [self setupRecored];
    }];
    [task resume];
}

-(void)setupRecored{
    
    //检查资源
    AVAsset *currentAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:self.locationUrlStr]];
    if (currentAsset.pls_videoSize.height < 1) {
        [[NSFileManager defaultManager] removeItemAtPath:self.locationUrlStr error:nil];
        [MBProgressHUD showMessageAMoment:@"资源加载失败"];
        return;
    }

    MOLMixRecordViewController *vc = [[MOLMixRecordViewController alloc] initWith:[NSURL fileURLWithPath:self.locationUrlStr]];
    UIViewController *topvc =  [CommUtls topViewController];
    [topvc.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)getRecorderMaxTime{
    MOLUserModel * user =  [[MOLUserManager shareUserManager ] user_getUserInfo];
    if (user.authInfoVO.audioAuth == 2) {
        return 30;
    }
    return 15;
}
@end
