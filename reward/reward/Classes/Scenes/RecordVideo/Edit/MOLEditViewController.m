//
//  MOLEditViewController.m
//  reward
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLEditViewController.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "MOLFilterGroup.h"
#import "MOLReleaseViewController.h"
#import "MOLSelectMusicViewController.h"
#import "MOLClipMovieWhenEditView.h"
#import "MOLUpLoadAuthenticationVideoVC.h"
#import "MOLBeautifyView.h"
#import "MOLClipMusicView.h"
#import "MOLMusicView.h"
#import "MOLSelectCoverView.h"

@interface MOLEditViewController ()<MOLMusicViewDelegate, PLShortVideoEditorDelegate,MOLClipMovieWhenEditViewDelegate>

// 视频的分辨率，设置之后影响编辑时的预览分辨率、导出的视频的的分辨率
@property (assign, nonatomic) CGSize videoSize;
@property (strong, nonatomic) PLShortVideoEditor *shortVideoEditor;// 编辑类
@property (strong,nonatomic) PLSReverserEffect *reverser;// 时光倒流
@property (strong,nonatomic) AVAsset *inputAsset;
@property (strong,nonatomic) NSURL  *currentBgMusicUrl;
@property (nonatomic,assign) float currentMusicStartTime;

// 编辑信息, movieSettings, watermarkSettings, stickerSettingsArray, audioSettingsArray 为 outputSettings 的字典元素
@property (strong, nonatomic) NSMutableDictionary *outputSettings;
// 视频文件信息
@property (strong, nonatomic) NSMutableDictionary *movieSettings;
// 多音频文件作为背景音乐
@property (strong, nonatomic) NSMutableArray *audioSettingsArray;
// 水印
@property (strong, nonatomic) NSMutableDictionary *watermarkSettings;
// 贴纸信息
@property (strong, nonatomic) NSMutableArray *stickerSettingsArray;
// 单一背景音乐的信息，最终要将其添加（addObject）到数组 audioSettingsArray 内
@property (strong, nonatomic) NSMutableDictionary *backgroundAudioSettings;
@property (strong, nonatomic) NSMutableDictionary *originMovieSettings;
@property (assign, nonatomic) PLSVideoRecoderRateType currentRateType;
// 水印
@property (strong, nonatomic) NSURL *watermarkURL;
@property (assign, nonatomic) CGSize watermarkSize;
@property (assign, nonatomic) CGPoint watermarkPosition;
@property (strong, nonatomic) UIImage *watermarkImage;

//******************************************滤镜****************************************//

@property (strong, nonatomic) NSString *colorImagePath;//导出时需要的滤镜资源
// 剪视频试图
@property (strong, nonatomic) MOLClipMovieWhenEditView *clipMovieView;
//预览区域
@property (strong, nonatomic) UIView *editDisplayView;
// 播放/暂停按钮，点击视频预览区域实现播放/暂停功能
@property (strong, nonatomic) UIButton *playButton;

//顶部区域
@property (strong, nonatomic) UIView *upToolboxView;
@property (strong,nonatomic)  UIView *bottomToolboxView;

// 视频合成的进度
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic)MOLMusicView *musicView;//配乐
@property(nonatomic,strong)MOLBeautifyView *beautifyView;//美化
@property(nonatomic,strong)MOLClipMusicView  *clipMusicView;//剪切音乐
@property(nonatomic,strong)MOLSelectCoverView  *selectCoverView;//封面选择
@end

@implementation MOLEditViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置信息初始化
    [self setupShortVideoEditor];
    //初始化编辑也页面
    [self setupEditDisplayView];
    //顶部区域
    [self setupTopToolboxView];
    //底部区域
    [self setupBottomToolboxView];
    //进度
    [self setupMergeToolboxView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //友盟统计进入视频编辑页面
    

    [MobClick beginLogPageView:ST_pv_video_dispose];
    [MobClick event:ST_pv_video_dispose];
     self.navigationController.navigationBar.frame = CGRectMake(0, MOL_StatusBarHeight, self.navigationController.navigationBar.frame.size.width, 44);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //友盟统计
    [MobClick endLogPageView:ST_pv_video_dispose];
}
#pragma mark - 编辑类
- (void)setupShortVideoEditor {
    
    // 编辑
    /* outputSettings 中的字典元素为 movieSettings, audioSettings, watermarkSettings */
    self.outputSettings = [[NSMutableDictionary alloc] init];
    self.movieSettings = [[NSMutableDictionary alloc] init];
    self.watermarkSettings = [[NSMutableDictionary alloc] init];
    self.stickerSettingsArray = [[NSMutableArray alloc] init];
    self.audioSettingsArray = [[NSMutableArray alloc] init];
    
    self.outputSettings[PLSMovieSettingsKey] = self.movieSettings;
    self.outputSettings[PLSWatermarkSettingsKey] = self.watermarkSettings;
    self.outputSettings[PLSStickerSettingsKey] = self.stickerSettingsArray;
    self.outputSettings[PLSAudioSettingsKey] = self.audioSettingsArray;
//    self.outputSettings[plskey]
    
    // 原始视频
    [self.movieSettings addEntriesFromDictionary:self.settings[PLSMovieSettingsKey]];
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:MOL_audioVolume];
    
    // 备份原始视频的信息
    self.originMovieSettings = [[NSMutableDictionary alloc] init];
    [self.originMovieSettings addEntriesFromDictionary:self.movieSettings];
    self.currentRateType = PLSVideoRecoderRateNormal;
    
    // 背景音乐
    self.backgroundAudioSettings = [[NSMutableDictionary alloc] init];
    self.backgroundAudioSettings[PLSVolumeKey] = [NSNumber numberWithFloat:MOL_audioVolume];
    
    // 水印图片路径
    NSString *watermarkPath = [[NSBundle mainBundle] pathForResource:@"qiniu_logo" ofType:@".png"];
    self.watermarkImage = [UIImage imageWithContentsOfFile:watermarkPath];
    self.watermarkURL = [NSURL URLWithString:watermarkPath];
    self.watermarkSize = self.watermarkImage.size;
    self.watermarkPosition = CGPointMake(10, 65);
    // 水印
    self.watermarkSettings[PLSURLKey] = self.watermarkURL;
    self.watermarkSettings[PLSSizeKey] = [NSValue valueWithCGSize:self.watermarkSize];
    self.watermarkSettings[PLSPointKey] = [NSValue valueWithCGPoint:self.watermarkPosition];
    
    
    
   
    
    // 视频编辑类
    AVAsset *movieAsset = self.movieSettings[PLSAssetKey];
    if (!movieAsset) {
        NSURL *movieURL = self.movieSettings[PLSURLKey];
        movieAsset = [AVAsset assetWithURL:movieURL];
        self.movieSettings[PLSAssetKey] = movieAsset;
    }
     // 用来演示如何获取视频的分辨率 videoSize
    self.videoSize = movieAsset.pls_videoSize;
    
    //初始化编辑器
    if (self.playerItem) {
        self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithPlayerItem:self.playerItem videoSize:CGSizeZero];
//    self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithPlayerItem:self.playerItem videoSize:CGSizeMake(540, 960)];
    } else {
//          self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithPlayerItem:self.playerItem videoSize:CGSizeMake(540, 960)];
        self.shortVideoEditor = [[PLShortVideoEditor alloc] initWithAsset:movieAsset videoSize:CGSizeZero];

    }
    self.shortVideoEditor.delegate = self;
    self.shortVideoEditor.loopEnabled = YES;
    
    // 要处理的视频的时间区域
    CMTime start = CMTimeMake([self.movieSettings[PLSStartTimeKey] floatValue] * 1000, 1000);
    CMTime duration = CMTimeMake([self.movieSettings[PLSDurationKey] floatValue] * 1000, 1000);
    self.shortVideoEditor.timeRange = CMTimeRangeMake(start, duration);
    // 视频编辑时，添加水印
    [self.shortVideoEditor setWaterMarkWithImage:self.watermarkImage position:self.watermarkPosition];
    // 视频编辑时，改变预览分辨率
    self.shortVideoEditor.videoSize = self.videoSize;
    //CGSizeZero;
//    = CGSizeMake(540, 960);
//    self.videoSize;
//
}

- (void)setupEditDisplayView {
    self.editDisplayView = [[UIView alloc] initWithFrame:self.view.bounds];

    
    [self.view addSubview:self.editDisplayView];
    
    self.shortVideoEditor.previewView.frame = self.editDisplayView.bounds;


    
    
    if (self.source == 1) {
        //    保持源图像的长宽比，放大它的中心以填充视图
          self.shortVideoEditor.fillMode = PLSVideoFillModePreserveAspectRatioAndFill;
    }else{
        //    维护源图像的长宽比，添加指定背景颜色的条
          self.shortVideoEditor.fillMode = PLSVideoFillModePreserveAspectRatio;
    }
    

  
//    拉伸以填充全视图，这可能会扭曲图像的正常长宽比以外
//    self.shortVideoEditor.fillMode = PLSVideoFillModeStretch;
  
    [self.editDisplayView addSubview:self.shortVideoEditor.previewView];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = self.shortVideoEditor.previewView.frame;
    self.playButton.center = self.shortVideoEditor.previewView.center;
    [self.playButton setImage:[UIImage imageNamed:@"btn_play_bg_a"] forState:UIControlStateSelected];
    self.playButton.selected = YES;
    [self.editDisplayView addSubview:self.playButton];
    [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 视频分辨率
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    
    CGSize vSize = asset.pls_videoSize;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat displayViewWidth = self.editDisplayView.frame.size.width;
    CGFloat displayViewHeight = self.editDisplayView.frame.size.height;
    
    CGFloat width = displayViewWidth;
    CGFloat height = displayViewHeight;
    
    if (vSize.width / vSize.height < displayViewWidth / displayViewHeight) {
        width = vSize.width / vSize.height * displayViewHeight;
        x = (displayViewWidth - width) * 0.5;
    }else if (vSize.width / vSize.height > displayViewWidth / displayViewHeight){
        height = vSize.height / vSize.width * displayViewWidth;
        y = (displayViewHeight - height) * 0.5;
    }
    

}
-(void)setupTopToolboxView{
    self.upToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0,100, MOL_SCREEN_WIDTH, 50)];
    self.upToolboxView.backgroundColor =[UIColor redColor];
    // 关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_a"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_b"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 80, 64);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.upToolboxView addSubview:backButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 64)];
    if (iPhoneX) {
        titleLabel.center = CGPointMake(MOL_SCREEN_WIDTH / 2, 48);
    } else {
        titleLabel.center = CGPointMake(MOL_SCREEN_WIDTH / 2, 32);
    }
    titleLabel.text = @"编辑视频";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.upToolboxView addSubview:titleLabel];
    
    // 下一步
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    nextButton.frame = CGRectMake(MOL_SCREEN_WIDTH - 80, 0, 60, 22);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    nextButton.backgroundColor = HEX_COLOR(0xFFEC00);
    nextButton.layer.cornerRadius = 5;
    
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)setupBottomToolboxView{

    CGFloat BtnW = MOL_SCREEN_WIDTH/5;
    CGFloat BtnH = BtnW;
    
    self.bottomToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, MOL_SCREEN_HEIGHT - BtnH, MOL_SCREEN_WIDTH, BtnH)];
    self.bottomToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bottomToolboxView];
    // 特效
    UIButton *specialEffectsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [specialEffectsButton setImage:[UIImage imageNamed:@"special_effects"] forState:UIControlStateNormal];
    [specialEffectsButton setImage:[UIImage imageNamed:@"btn_bar_next_b"] forState:UIControlStateHighlighted];
    [specialEffectsButton setTitle:@"倒序" forState:UIControlStateNormal];
    specialEffectsButton.titleLabel.font = MOL_FONT(12);
    [specialEffectsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [specialEffectsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    specialEffectsButton.frame = CGRectMake(0, 0, BtnW, BtnH);
    [specialEffectsButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];
    [specialEffectsButton.imageView setContentMode:UIViewContentModeScaleAspectFill];

    [specialEffectsButton addTarget:self action:@selector(specialEffectsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolboxView addSubview:specialEffectsButton];
    
    
    // 配乐
    UIButton *addMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMusicButton setImage:[UIImage imageNamed:@"rc_EditMusic"] forState:UIControlStateNormal];
    [addMusicButton setImage:[UIImage imageNamed:@"rc_EditMusic"] forState:UIControlStateHighlighted];
    [addMusicButton setTitle:@"配乐" forState:UIControlStateNormal];
    addMusicButton.titleLabel.font = MOL_FONT(12);
    [addMusicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addMusicButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    addMusicButton.frame = CGRectMake(BtnW, 0, BtnW, BtnH);
    
    [addMusicButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];

    [addMusicButton addTarget:self action:@selector(addMusicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolboxView addSubview:addMusicButton];
    
    
    // 封面
    UIButton *selectCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectCoverButton setImage:[UIImage imageNamed:@"rc_cover"] forState:UIControlStateNormal];
    [selectCoverButton setImage:[UIImage imageNamed:@"rc_cover"] forState:UIControlStateHighlighted];
    [selectCoverButton setTitle:@"封面" forState:UIControlStateNormal];
    selectCoverButton.titleLabel.font = MOL_FONT(12);
    [selectCoverButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectCoverButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    selectCoverButton.frame = CGRectMake(2*BtnW, 0, BtnW, BtnH);
    
    [selectCoverButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];
    
    [selectCoverButton addTarget:self action:@selector(selectCoverButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolboxView addSubview:selectCoverButton];

    // 裁剪
    UIButton *tailoringButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tailoringButton setImage:[UIImage imageNamed:@"rc_cut_video"] forState:UIControlStateNormal];
    [tailoringButton setImage:[UIImage imageNamed:@"rc_cut_video"] forState:UIControlStateHighlighted];
    [tailoringButton setTitle:@"裁剪" forState:UIControlStateNormal];
    tailoringButton.titleLabel.font = MOL_FONT(12);
    [tailoringButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tailoringButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    tailoringButton.frame = CGRectMake(3 * BtnW, 0, BtnW, BtnH);

    [tailoringButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];

    [tailoringButton addTarget:self action:@selector(tailoringButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolboxView addSubview:tailoringButton];

    // 滤镜
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setImage:[UIImage imageNamed:@"rc_filter"] forState:UIControlStateNormal];
    [filterButton setImage:[UIImage imageNamed:@"rc_filter"] forState:UIControlStateHighlighted];
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    filterButton.titleLabel.font = MOL_FONT(12);
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    filterButton.frame = CGRectMake(4*BtnW, 0, BtnW, BtnH);
    [filterButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];

    [filterButton addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolboxView addSubview:filterButton];
    
    
    
    [self setupBottomActionView];
   
    
}
-(void)setupBottomActionView{
    
    _musicView = [[MOLMusicView alloc] initWithCustomH:160 showBottom:YES];
    _musicView.delegate = self;
    [_musicView setBottomViewTitle:@"配乐"];
    
    MJWeakSelf
    _musicView.dismissBlock = ^{
        weakSelf.bottomToolboxView.hidden = NO;
    };
    
    //剪切音乐
    _clipMusicView = [[MOLClipMusicView alloc] initWithCustomH:160 showBottom:YES];
    [_clipMusicView setBottomViewTitle:@"左右拖动剪音乐"];
    _clipMusicView.updateSTBlock = ^(float startTime) {
        //更新开始时间
        weakSelf.currentMusicStartTime = startTime;
        [weakSelf addMusic:weakSelf.currentBgMusicUrl withStartTime:startTime];
    };
    _clipMusicView.dismissBlock = ^{
        weakSelf.bottomToolboxView.hidden = NO;
    };
    
    // 滤镜
    UIImage *coverImage = [self getVideoPreViewImage:self.movieSettings[PLSAssetKey]];

    _beautifyView = [[MOLBeautifyView alloc] initWithCustomH:100 showBottom:YES withfilterImage:coverImage];
    [_beautifyView hidePageView];
    [_beautifyView setBottomViewTitle:@"滤镜"];
    
    _beautifyView.dismissBlock = ^{
        weakSelf.bottomToolboxView.hidden = NO;
    };
    _beautifyView.filterConfirmBlock = ^(PLSFilter *filter) {
        NSString *colorImagePath = filter.colorImagePath;
        [weakSelf addFilter:colorImagePath];
    };
    
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    
   //封面选择
    _selectCoverView = [[MOLSelectCoverView alloc] initWithMovieAsset:asset minDuration:MOL_RecordMinTime maxDuration:MOL_RecordMaxTime withCustomH:MOL_SCREEN_HEIGHT - MOL_TabbarSafeBottomMargin - 50 + 10 showBottom:YES];
     [_selectCoverView setBottomViewTitle:@"设置封面"];
    _selectCoverView.dismissBlock = ^{
        weakSelf.bottomToolboxView.hidden = NO;
        [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
    
    };
    
    
    //展示裁剪
    _clipMovieView = [[MOLClipMovieWhenEditView alloc] initWithMovieAsset:asset minDuration:MOL_RecordMinTime maxDuration:MOL_RecordMaxTime withCustomH:150 showBottom:YES];
    [_clipMovieView setBottomViewTitle:@"裁剪"];
    _clipMovieView.delegate = self;
    
    _clipMovieView.dismissBlock = ^{
         weakSelf.bottomToolboxView.hidden = NO;
    };
    
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

-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

#pragma mark - 特效按钮事件
- (void)specialEffectsButtonClick {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"倒叙以后视频原声将被消除" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancenAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.shortVideoEditor stopEditing];
        self.playButton.selected = NO;
        
        [self loadActivityIndicatorView];
        
        if (self.reverser.isReversing) {
            NSLog(@"reverser effect isReversing");
            return;
        }
        if (self.reverser) {
            self.reverser = nil;
        }
        
        __weak typeof(self)weakSelf = self;
        AVAsset *asset = self.movieSettings[PLSAssetKey];
        self.reverser = [[PLSReverserEffect alloc] initWithAsset:asset];
        self.inputAsset = self.movieSettings[PLSAssetKey];
        [self.reverser setCompletionBlock:^(NSURL *url) {
            [weakSelf removeActivityIndicatorView];
            
            NSLog(@"reverser effect, url: %@", url);
            
            weakSelf.movieSettings[PLSURLKey] = url;
            weakSelf.movieSettings[PLSAssetKey] = [AVAsset assetWithURL:url];
            
            [weakSelf.shortVideoEditor replaceCurrentAssetWithAsset:weakSelf.movieSettings[PLSAssetKey]];
            [weakSelf.shortVideoEditor startEditing];
            weakSelf.playButton.selected = NO;
        }];
        
        [self.reverser setFailureBlock:^(NSError *error){
            [weakSelf removeActivityIndicatorView];
            
            NSLog(@"reverser effect, error: %@",error);
            
            weakSelf.movieSettings[PLSAssetKey] = weakSelf.inputAsset;
            
            [weakSelf.shortVideoEditor replaceCurrentAssetWithAsset:weakSelf.movieSettings[PLSAssetKey]];
            [weakSelf.shortVideoEditor startEditing];
            weakSelf.playButton.selected = NO;
        }];
        
        [self.reverser setProcessingBlock:^(float progress) {
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
            NSLog(@"reverser effect, progress: %f", progress);
        }];
        
        [self.reverser startReversing];
    }];
    [alert addAction:cancenAc];
    [alert addAction:sureAc];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - 配乐按钮事件
- (void)addMusicButtonClick {
       self.bottomToolboxView.hidden = YES;
       [self.musicView showInView:self.view];
    
}
#pragma mark - 封面选择
-(void)selectCoverButtonClick{
    self.bottomToolboxView.hidden = YES;
      [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.selectCoverView showInView:self.view];
}
#pragma mark - 裁剪视频按钮事件
- (void)tailoringButtonClick {
    self.bottomToolboxView.hidden = YES;
     [self.clipMovieView showInView:self.view];
    
}
#pragma mark - 滤镜按钮事件
- (void)filterButtonClick:(UIButton *)button {
    
    self.bottomToolboxView.hidden = YES;
    [self.beautifyView showInView:self.view];
    
}

#pragma mark - 启动/暂停视频预览
- (void)playButtonClicked:(UIButton *)button {
    if (self.shortVideoEditor.isEditing) {
        [self.shortVideoEditor stopEditing];
        self.playButton.selected = YES;
    } else {
        [self.shortVideoEditor startEditing];
        self.playButton.selected = NO;
    }
}
#pragma mark - 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 下一步
- (void)nextButtonClick:(UIButton *)sender {
    [self.shortVideoEditor stopEditing];
    self.playButton.selected = YES;
    sender.enabled = NO;
    [self loadActivityIndicatorView];
    
    AVAsset *asset = self.movieSettings[PLSAssetKey];
    PLSAVAssetExportSession *exportSession = [[PLSAVAssetExportSession alloc] initWithAsset:asset];
    exportSession.outputFileType = PLSFileTypeMPEG4;
    exportSession.outputURL = [NSURL fileURLWithPath:[MOLCacheFileManager getTempVideoFilePath]];
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    [self.audioSettingsArray insertObject:self.backgroundAudioSettings atIndex:0];
    exportSession.outputSettings = self.outputSettings;
    //exportSession.delegate = self;
    // exportSession.isExportMovieToPhotosAlbum = YES;
    //
    // 设置视频的码率
//        exportSession.bitrate = 3000*1000;
    // 设置视频的输出路径
    
//    [MOLCacheFileManager manager].lastSaveUrl = [NSURL fileURLWithPath:[MOLCacheFileManager getRandomVideoFilePath]];
//    exportSession.outputURL = [MOLCacheFileManager manager].lastSaveUrl;
    
    
    
    // 设置视频的导出分辨率，会将原视频缩放
    exportSession.outputVideoSize =   self.videoSize;

    //旋转视频
    //exportSession.videoLayerOrientation = self.videoLayerOrientation;
    [exportSession addFilter:self.colorImagePath];//添加滤镜
    //[exportSession addMVLayerWithColor:self.colorURL alpha:self.alphaURL];
    __weak typeof(self) weakSelf = self;
    [exportSession setCompletionBlock:^(NSURL *url) {
        NSLog(@"Asset Export Completed");
                dispatch_async(dispatch_get_main_queue(), ^{ 
            [weakSelf joinNextViewController:url];
           sender.enabled = YES;
        });
    }];
    
    [exportSession setFailureBlock:^(NSError *error) {
        NSLog(@"Asset Export Failed: %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeActivityIndicatorView];
            sender.enabled = YES;
        });
    }];
    
    [exportSession setProcessingBlock:^(float progress) {
        // 更新进度 UI
        NSLog(@"Asset Export Progress: %f", progress);
        dispatch_async(dispatch_get_main_queue(), ^{
             weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
            
        });
       
    }];
    
    [exportSession exportAsynchronously];
    

}

#pragma mark - 跳转到下一页面
- (void)joinNextViewController:(NSURL *)url {
    [self removeActivityIndicatorView];
    
    //视频认证
    if ([MOLReleaseManager manager].rewardID == -1) {
        MOLUpLoadAuthenticationVideoVC *vc = [[MOLUpLoadAuthenticationVideoVC alloc] init];
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    MOLReleaseViewController *releaseViewController = [[MOLReleaseViewController alloc] init];
    releaseViewController.url = url;
    AVAsset *asset = [AVAsset assetWithURL:url];
    CGSize size = asset.pls_videoSize;
    releaseViewController.coverImage = self.selectCoverView.coverImageView.image;
    releaseViewController.settings = self.settings;
    releaseViewController.currentMusicID = self.currentMusicID;
    releaseViewController.source = self.source;
    [self.navigationController pushViewController:releaseViewController animated:YES];
    
}


#pragma mark - 音量调节的回调 PLSAudioVolumeViewDelegate
// 调节视频和背景音乐的音量
-(void)audioVolumeView:(MOLBasePushView *)volumeView movieVolumeChangedTo:(CGFloat)movieVolume musicVolumeChangedTo:(CGFloat)musicVolume{
    
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:movieVolume];
    self.backgroundAudioSettings[PLSVolumeKey] = [NSNumber numberWithFloat:musicVolume];
    
    self.shortVideoEditor.volume = movieVolume;
    
    [self updateMusic:kCMTimeRangeZero volume:self.backgroundAudioSettings[PLSVolumeKey]];
}


- (void)updateMusic:(CMTimeRange)timeRange volume:(NSNumber *)volume {
    // 更新 背景音乐 的 播放时间区间、音量
    [self.shortVideoEditor updateMusic:timeRange volume:volume];
    
}
//取消音乐选择
-(void)musicCancelBtnDidSelected{
    self.currentMusicStartTime = 0.f;
    [self addMusic:nil withStartTime:self.currentMusicStartTime];
    self.musicView.customMV.Cancelbutton.enabled = NO;
    self.musicView.customMV.musicVolumeSlider.enabled = NO;
    self.musicView.customMV.clipMusicButton.enabled = NO;
}
//剪切音乐
-(void)musicClipBtnDidSelected{
    [_clipMusicView showInView:self.view];
    //0.3为上个视图消失的动画时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         self.bottomToolboxView.hidden = YES;
    });
    
}
//音乐库
-(void)musicLibBtnDidSelected{
    MOLSelectMusicViewController *selMusic = [[MOLSelectMusicViewController alloc] init];
    MJWeakSelf
    selMusic.selectedBlock = ^(NSURL *musicUrl, MOLMusicModel *music) {
         weakSelf.currentMusicID = music.musicId;
         weakSelf.musicView.customMV.Cancelbutton.enabled = YES;
         weakSelf.musicView.customMV.musicVolumeSlider.enabled = YES;
        
        CGFloat time = CMTimeGetSeconds(self.shortVideoEditor.timeRange.duration);
        if ([CommUtls getFileDuration:musicUrl] > time  ) {
             weakSelf.musicView.customMV.clipMusicButton.enabled = YES;
             [self.clipMusicView updateWithMsic:musicUrl WithVoideDuration:time];
        }
        weakSelf.currentMusicStartTime = 0.f;
        [weakSelf addMusic:musicUrl withStartTime:weakSelf.currentMusicStartTime];
       
    };
    [self.shortVideoEditor stopEditing];
    [self presentViewController:selMusic animated:YES completion:nil];
}

-(void)addMusic:(NSURL *)url withStartTime:(CGFloat)startTime{
    // 音乐
    if (!url) {
        // ****** 要特别注意此处，无音频 URL ******
//        NSDictionary *dic = self.musicsArray[indexPath.row];
//        NSString *musicName = [dic objectForKey:@"audioName"];
        
        self.backgroundAudioSettings[PLSURLKey] = [NSNull null];
        self.backgroundAudioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
        self.backgroundAudioSettings[PLSDurationKey] = [NSNumber numberWithFloat:0.f];
//        self.backgroundAudioSettings[PLSNameKey] = musicName;
        
    } else {
        
//        NSDictionary *dic = self.musicsArray[indexPath.row];
//        NSString *musicName = [dic objectForKey:@"audioName"];
        
        self.backgroundAudioSettings[PLSURLKey] = url;
        self.backgroundAudioSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:startTime];
        self.backgroundAudioSettings[PLSDurationKey] = [NSNumber numberWithFloat:[CommUtls getFileDuration:url]];
//        self.backgroundAudioSettings[PLSNameKey] = musicName;
        
    }
    
    NSURL *musicURL = self.backgroundAudioSettings[PLSURLKey];
    CMTimeRange musicTimeRange= CMTimeRangeMake(CMTimeMake([self.backgroundAudioSettings[PLSStartTimeKey] floatValue] * 1000, 1000), CMTimeMake([self.backgroundAudioSettings[PLSDurationKey] floatValue] * 1000, 1000));
    NSNumber *musicVolume = self.backgroundAudioSettings[PLSVolumeKey];
    [self addBgMusic:musicURL timeRange:musicTimeRange volume:musicVolume loopEnable:YES];

}
- (void)addBgMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume loopEnable:(BOOL)loopEnable {
    if (!self.shortVideoEditor.isEditing) {
        [self.shortVideoEditor startEditing];
        self.playButton.selected = NO;
    }
    
    // 添加／移除 背景音乐
    [self.shortVideoEditor addMusic:musicURL timeRange:timeRange volume:volume loopEnable:loopEnable];
    self.currentBgMusicUrl = musicURL;//保存当前背景音乐
    
    
    if (loopEnable) {
        // 设置背景音乐循环插入到视频中
        self.backgroundAudioSettings[PLSLocationStartTimeKey] = [NSNumber numberWithFloat:0.f];
        self.backgroundAudioSettings[PLSLocationDurationKey] = self.movieSettings[PLSDurationKey];
    } else {
        // 设置背景音乐只插入一次到视频中
        self.backgroundAudioSettings[PLSLocationStartTimeKey] = [NSNumber numberWithFloat:0.f];
        self.backgroundAudioSettings[PLSLocationDurationKey] = self.backgroundAudioSettings[PLSDurationKey];
    }
}

#pragma mark - 裁剪视频的回调 MOLClipMovieWhenEditViewDelegate
- (void)didStartDragView {
    
}

- (void)clipFrameView:(MOLClipMovieWhenEditView *)clipFrameView didEndDragLeftView:(CMTime)leftTime rightView:(CMTime)rightTime {
    CGFloat start = CMTimeGetSeconds(leftTime);
    CGFloat end = CMTimeGetSeconds(rightTime);
    CGFloat duration = end - start;
    
    self.originMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:start];
    self.originMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:duration];
    
    // 每次选段变化之后，将变化的值按照倍速作用到 movieSettings 中
//    float rate = [self getRateNumberWithRateType:self.currentRateType];
    float rate = 1.0;
    float rateStart = start * rate;
    float rateDuration = duration * rate;
    self.movieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:rateStart];
    self.movieSettings[PLSDurationKey] = [NSNumber numberWithFloat:rateDuration];
    
    self.shortVideoEditor.timeRange = CMTimeRangeMake(CMTimeMake(rateStart * 1000, 1000), CMTimeMake(rateDuration * 1000, 1000));
    [self addMusic:self.currentBgMusicUrl withStartTime:self.currentMusicStartTime];
    [self.shortVideoEditor startEditing];
    
  
    
    
    //如果当前存在 背景音乐 判断音乐时长设置是否可以裁剪
     CGFloat time = CMTimeGetSeconds(self.shortVideoEditor.timeRange.duration);
    if (self.currentBgMusicUrl && ([CommUtls getFileDuration:self.currentBgMusicUrl] > time )) {
        self.musicView.customMV.clipMusicButton.enabled = YES;
        [self.clipMusicView updateWithMsic:self.currentBgMusicUrl WithVoideDuration:time];
    }else{
        self.musicView.customMV.clipMusicButton.enabled = NO;
    }
}

- (void)clipFrameView:(MOLClipMovieWhenEditView *)clipFrameView isScrolling:(BOOL)scrolling {
    self.view.userInteractionEnabled = !scrolling;
}

#pragma mark - PLShortVideoEditorDelegate 编辑时处理视频数据，并将加了滤镜效果的视频数据返回
- (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp {
    //此处可以做美颜/滤镜等处理
    
    
    CVPixelBufferRef tempPixelBuffer = pixelBuffer;
    // 更新时间线视图
    CGFloat time = CMTimeGetSeconds(timestamp);
    [self.clipMovieView setProgressBarPoisionWithSecond:time];
    [self.clipMusicView setProgressWithSecond:time];
    
    return tempPixelBuffer;
}
- (void)addFilter:(NSString *)colorImagePath {
    // 添加／移除 滤镜
    self.colorImagePath = colorImagePath;
    [self.shortVideoEditor addFilter:self.colorImagePath];
}



- (void)hideClipMovieView {
    [self.clipMovieView removeFromSuperview];
}



// 获取视频第一帧
- (UIImage *) getVideoPreViewImage:(AVAsset *)asset {
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.maximumSize = asset.pls_videoSize;
//    CGSizeMake(150, 150);
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 控制状态栏
//- (BOOL)prefersStatusBarHidden{
//
//    return  YES;
//}

@end
