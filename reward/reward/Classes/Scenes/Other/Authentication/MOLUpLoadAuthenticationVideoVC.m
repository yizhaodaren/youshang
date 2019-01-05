//
//  MOLUpLoadAuthenticationVideoVC.m
//  reward
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLUpLoadAuthenticationVideoVC.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "MOLLoginRequest.h"

@interface MOLUpLoadAuthenticationVideoVC ()<PLShortVideoUploaderDelegate>

@property (nonatomic,strong) PLPlayer *player;// 视频播放
@property (strong, nonatomic) PLShortVideoUploader *shortVideoUploader;//视频上传

@property(nonatomic,strong)UIButton *upLoadBtn;

// 的进度
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation MOLUpLoadAuthenticationVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initPlayer];
    [self setupUpLoad];
}

#pragma mark -- 播放器初始化
- (void)initPlayer {
    if (!self.url) {
        return;
    }
    // 初始化 PLPlayerOption 对象
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
    //    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    
    // 初始化 PLPlayer
    self.player = [PLPlayer playerWithURL:self.url option:option];
    self.player.loopPlay = YES;
    // 设定代理 (optional)
//    self.player.delegate = self;
    //获取视频输出视图并添加为到当前 UIView 对象的 Subview
    self.player.playerView.frame = self.view.bounds;
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view insertSubview:self.player.playerView atIndex:0];
    [self.player play];
}
- (void)initUI {
    [self.view addSubview:self.upLoadBtn];
    
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


-(void)setupUpLoad{
    MJWeakSelf
    [[MOLUploadManager shareUploadManager] getQNAudioTokenSuccessBlock:^(NSString *token, NSString *key) {
        PLSUploaderConfiguration * uploadConfig = [[PLSUploaderConfiguration alloc] initWithToken:token videoKey:key https:YES recorder:nil];
        weakSelf.shortVideoUploader = [[PLShortVideoUploader alloc] initWithConfiguration:uploadConfig];
        weakSelf.shortVideoUploader.delegate = self;
        //上传
    }];
    
}

-(UIButton *)upLoadBtn{
    if (!_upLoadBtn) {
        _upLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upLoadBtn addTarget:self action:@selector(videoAuthAction:) forControlEvents:UIControlEventTouchUpInside];
        _upLoadBtn.x = 15;
        _upLoadBtn.y = MOL_SCREEN_HEIGHT - MOL_TabbarSafeBottomMargin - 20 - 44;
        _upLoadBtn.width = MOL_SCREEN_WIDTH - 30;
        _upLoadBtn.height = 44;
        _upLoadBtn.backgroundColor =HEX_COLOR(0xFACE15);
        _upLoadBtn.layer.cornerRadius = 5;
        _upLoadBtn.clipsToBounds = YES;
        [_upLoadBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_upLoadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _upLoadBtn;
}
-(void)videoAuthAction:(UIButton *)sender{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(uploadAction) object:nil];
    [self performSelector:@selector(uploadAction) withObject:nil afterDelay:0.5];
}

-(void)uploadAction{
    MJWeakSelf
    if (!self.shortVideoUploader) {
        [[MOLUploadManager shareUploadManager] getQNAudioTokenSuccessBlock:^(NSString *token, NSString *key) {
            PLSUploaderConfiguration * uploadConfig = [[PLSUploaderConfiguration alloc] initWithToken:token videoKey:key https:YES recorder:nil];
            weakSelf.shortVideoUploader = [[PLShortVideoUploader alloc] initWithConfiguration:uploadConfig];
            weakSelf.shortVideoUploader.delegate = self;
            [weakSelf loadActivityIndicatorView];
            [weakSelf.shortVideoUploader uploadVideoFile:self.url.path];
        }];
        return;
    }
    //上传视频
    [self loadActivityIndicatorView];
    [self.shortVideoUploader uploadVideoFile:self.url.path];
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

#pragma mark - PLShortVideoUploaderDelegate 视频上传
- (void)shortVideoUploader:(PLShortVideoUploader *)uploader completeInfo:(PLSUploaderResponseInfo *)info uploadKey:(NSString *)uploadKey resp:(NSDictionary *)resp {
    
    [MBProgressHUD hideHUD];
    if(info.error){
        [MBProgressHUD showMessageAMoment:@"网络不好，上传失败，请重新上传!"];
        [self removeActivityIndicatorView];
        return ;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", kURLPrefix, uploadKey];
    [self videoAuthWith:urlString];

}
- (void)shortVideoUploader:(PLShortVideoUploader *)uploader uploadKey:(NSString *)uploadKey uploadPercent:(float)uploadPercent {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = [NSString stringWithFormat:@"上传进度:%d%%", (int)(uploadPercent * 100)];
    });
    NSLog(@"uploadKey: %@",uploadKey);
    NSLog(@"uploadPercent: %.2f",uploadPercent);
}

-(void)videoAuthWith:(NSString *)urlStr{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"audioUrl"] = urlStr;
    dic[@"authType"] = @2;// 1身份认证 2视频认证
    MOLLoginRequest *r =    [[MOLLoginRequest alloc] initRequest_videoAuthWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        [self removeActivityIndicatorView];
        if (code == MOL_SUCCESS_REQUEST) {
            [MBProgressHUD showMessageAMoment:@"我们将在1-3个工作日反馈审核结果"];
              [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    } failure:^(__kindof MOLBaseNetRequest *request) {
          [self removeActivityIndicatorView];
         [MBProgressHUD showMessageAMoment:@"网络不好，上传失败，请重新上传!"];
    }];
}
@end
