//
//  MOLReleaseViewController.m
//  reward
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLReleaseViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import <PLShortVideoKit/PLShortVideoKit.h>
#import <UITextView+ZWPlaceHolder.h>
#import "MOLReleaseRequest.h"
#import "MOLWorksModel.h"
#import "MOLShowGiftView.h"
#import "MOLCallFriendsViewController.h"
#import "MOLWebViewController.h"
#import "RegexKitLite.h"
#define edgeW 15.0f
#define MAX_LIMIT_NUMS 60//行数限制



@interface MOLReleaseViewController ()<UITextViewDelegate,PLShortVideoUploaderDelegate,PLPlayerDelegate>

////////////////////////
// @的匹配信息
@property (nonatomic, strong) NSMutableDictionary *atInfo;
// 文字选择或光标位置
@property (nonatomic, assign) NSRange textRange;
///////////////////////


@property (nonatomic,strong)AVAsset *currentAsset;
//@property (nonatomic,strong)UIImage *coverImage;//封面
@property (nonatomic,strong)NSString *converImageUrl;

@property (nonatomic,strong) PLPlayer *player;// 视频播放
@property (strong, nonatomic) PLShortVideoUploader *shortVideoUploader;//视频上传

@property(nonatomic,strong)UIButton *backButton;


@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UITextView *upTextView;
@property(nonatomic,strong)UIButton *addUserButton;
@property(nonatomic,strong)UILabel *textNumLab;
@property(nonatomic,strong)UIView *voideView;

//悬赏金币
@property (nonatomic, strong) UIView *RewardGoldView;
@property (nonatomic, strong) MOLShowGiftView *showGiftView;

//悬赏时间
@property (nonatomic, strong) UIView *RewardTimeView;
@property (nonatomic, strong) UILabel *timeLable;//悬赏的时间
@property (nonatomic, strong) UILabel *dueToTimeLable;//结束时间

//红包个数
@property (nonatomic, strong) UIView *RewardMoneyView;
@property (nonatomic,strong) UIView *baseToolboxView;// 工具视图
@property (nonatomic,strong) UIButton *uploadButton;//上传
@property (nonatomic,strong) UIButton *saveToDraftBtn;//保存草稿
@property (nonatomic,strong) UIButton *saveToPhotoAlbumBtn;//保存相册





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

@property (assign, nonatomic)BOOL isFirst;



// 的进度
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;


@end

@implementation MOLReleaseViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MOLCallFriendsViewController" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:@"MOLCallFriendsViewController" object:nil];
    self.atInfo = [NSMutableDictionary dictionary];
    [self initUI];
//    [self initPlayer];
    //如果有视频
    if (self.url) {
        [self setupMoveSeting];
        [self setupUpLoad];
    }else{
      
        //如果没有视频改变UI
        self.voideView.width = 0;
        self.upTextView.width = MOL_SCREEN_WIDTH - 20;

        //保存发布按钮改变UI
        self.saveToPhotoAlbumBtn.hidden = YES;
        self.uploadButton.x = self.saveToPhotoAlbumBtn.x;
        self.uploadButton.width = MOL_SCREEN_WIDTH - self.saveToPhotoAlbumBtn.x - 20;
//        [self.upTextView addSubview:self.textNumLab];
        self.textNumLab.frame = CGRectMake(_upTextView.width + 10 - 50,_upTextView.height - 15, 50, 15);
 
    }
}

- (void)show{
    if (self.upTextView) {
        if (!self.upTextView.isFirstResponder) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.upTextView becomeFirstResponder];
            }];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //友盟统计
     if ([MOLReleaseManager manager].currentReleaseType == ReleaseType_reward) {
         [MobClick beginLogPageView:ST_pv_publish_work];
         [MobClick event:ST_pv_publish_work];
     }else{
        [MobClick beginLogPageView:ST_pv_publish_reward];
        [MobClick event:ST_pv_publish_reward];
     }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //友盟统计
    if ([MOLReleaseManager manager].currentReleaseType == ReleaseType_reward) {
        [MobClick endLogPageView:ST_pv_publish_work];
    }else{
        [MobClick endLogPageView:ST_pv_publish_reward];
    }
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
    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];

    // 初始化 PLPlayer
    self.player = [PLPlayer playerWithURL:self.url option:option];
    self.player.loopPlay = YES;
    // 设定代理 (optional)
    self.player.delegate = self;
    //获取视频输出视图并添加为到当前 UIView 对象的 Subview
    self.player.playerView.frame = self.voideView.bounds;
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    [self.voideView addSubview:self.player.playerView];
    [self.player play];
}
#pragma mark -- 视图配置
- (void)initUI {
    [self basevc_setCenterTitle:@"发布" titleColor:[UIColor whiteColor]];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.baseToolboxView];
    [self.topView addSubview:self.upTextView];
    [self.topView addSubview:self.voideView];
   
    //发布
    [self.baseToolboxView addSubview:self.uploadButton];
    //草稿箱
    //[self.baseToolboxView addSubview:self.saveToDraftBtn];
    //本地保存
    [self.baseToolboxView addSubview:self.saveToPhotoAlbumBtn];
    
    if ([MOLReleaseManager manager].currentReleaseType == ReleaseType_work) {
         [self.topView addSubview:self.addUserButton];
        //作品
//        self.RewardGoldView.hidden = YES;
//        self.RewardTimeView.hidden = YES;
//        self.RewardMoneyView.hidden = YES;
    }else{
             //悬赏
        [self.view addSubview:self.RewardGoldView];
        [self.view addSubview:self.RewardTimeView];
        [self.view addSubview:self.RewardMoneyView];
   

        MOLRewardModel *model = [MOLReleaseManager manager].currentRewardModel;
        self.upTextView.text = model.content;

        [[MOLAltHelper shared] changeAltColorWith:self.upTextView WithOriginalFont:nil AndFontColor:nil];

        if (model.rewardType == 1) {
            //红包悬赏
          self.RewardTimeView.hidden = YES;
        }else{
            //排名悬赏
          self.RewardMoneyView.hidden = YES;
        }
        self.upTextView.editable = NO;
        self.textNumLab.hidden = YES;
    }
    
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
-(void)setupMoveSeting{
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
    
    // 原始视频
    [self.movieSettings addEntriesFromDictionary:self.settings[PLSMovieSettingsKey]];
    self.movieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0];
    
}
-(void)setupUpLoad{
    MJWeakSelf
    [[MOLUploadManager shareUploadManager] getQNAudioTokenSuccessBlock:^(NSString *token, NSString *key) {
        PLSUploaderConfiguration * uploadConfig = [[PLSUploaderConfiguration alloc] initWithToken:token videoKey:key https:YES recorder:nil];
        weakSelf.shortVideoUploader = [[PLShortVideoUploader alloc] initWithConfiguration:uploadConfig];
        weakSelf.shortVideoUploader.delegate = self;
        //上传
    }];

    
    //显示封面
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.coverImage];
    imageView.frame = self.voideView.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.voideView addSubview:imageView];
}

#pragma mark 上传
-(void)uploadButtonClick{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(uploadAction) object:nil];
    [self performSelector:@selector(uploadAction) withObject:nil afterDelay:0.5];
}
-(void)uploadAction{
    self.uploadButton.enabled = NO;
    if ([MOLReleaseManager manager].currentReleaseType == ReleaseType_reward) {
        [MobClick event:ST_c_publish_work_button];
    }else{
        [MobClick event:ST_c_reward_publish_button];
    }
    
    if (!self.url) {
        [MBProgressHUD showMessage:@"发布中..."];
        [self startReleaseWithDic:[NSMutableDictionary dictionary]];
        return;
    }
    MJWeakSelf
    if (!self.shortVideoUploader) {
        [[MOLUploadManager shareUploadManager] getQNAudioTokenSuccessBlock:^(NSString *token, NSString *key) {
            PLSUploaderConfiguration * uploadConfig = [[PLSUploaderConfiguration alloc] initWithToken:token videoKey:key https:YES recorder:nil];
            weakSelf.shortVideoUploader = [[PLShortVideoUploader alloc] initWithConfiguration:uploadConfig];
            weakSelf.shortVideoUploader.delegate = self;
            [weakSelf uploadCorverImage];
        }];
        return;
    }
    [self uploadCorverImage];
}
 //上传封面
-(void)uploadCorverImage{
    MJWeakSelf
    [[MOLUploadManager shareUploadManager] qiNiu_uploadImage:self.coverImage complete:^(NSString *name) {
        if (!name) {
              self.uploadButton.enabled = YES;
            [MBProgressHUD showMessage:@"上传失败"];
            return;
        }
        //保存图片URL
        self.converImageUrl = name;
        
        [weakSelf loadActivityIndicatorView];
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"上传进度:%d%%", (int)(0 * 100)];
        //上传视频
        [weakSelf.shortVideoUploader uploadVideoFile:weakSelf.url.path];
    }];
}
#pragma mark 存草稿
-(void)saveToDraftAction{
    
    MOLWorksModel *work =  [[MOLWorksModel alloc] init];
    work.audioUrl = [MOLCacheFileManager manager].lastSaveUrl.absoluteString;
    work.contextText = @"fdf";
    NSData * data = [NSData dataWithContentsOfURL:[MOLCacheFileManager manager].lastSaveUrl];
    work.audioData = data;
    [work saveToDB];
    //
    //    MOLWorksModel *work = [MOLCacheFileManager getLastDraft];
    //
    //    NSURL *url = [NSURL fileURLWithPath:[MOLCacheFileManager getRandomDraftAudioFilePath]];
    //    [work.audioData writeToURL:url atomically:YES];
    //
    //
    //    self.url = url;
    //    AVAsset *asset = [AVAsset assetWithURL:url];
    //
    //   UIImage *image =  [self getVideoPreViewImage:asset];
    //
    //    UIImageView *vew = [[UIImageView alloc] initWithImage:image];
    //    vew.frame = CGRectMake(0, 0, 300, 300);
    //    vew.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:vew];
}
#pragma mark 存相册
-(void)saveToPhotoAlbumAction{
    [MBProgressHUD showMessage:@"保存中..."];
    AVAsset *asset = [AVAsset assetWithURL:self.url];
    PLSAVAssetExportSession *exportSession = [[PLSAVAssetExportSession alloc] initWithAsset:asset];
    exportSession.outputFileType = PLSFileTypeMPEG4;
    exportSession.outputURL = [NSURL fileURLWithPath:[MOLCacheFileManager getTempVideoFilePath]];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputSettings = self.outputSettings;
    exportSession.isExportMovieToPhotosAlbum = YES;
    exportSession.outputVideoSize = asset.pls_videoSize;
    [exportSession setCompletionBlock:^(NSURL *url) {
        NSLog(@"Asset Export Completed");
        dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"保存成功");
             [MBProgressHUD hideHUD];
             [MBProgressHUD showMessageAMoment:@"保存成功"];
            
        });
    }];
    [exportSession setFailureBlock:^(NSError *error) {
        NSLog(@"Asset Export Failed: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showMessageAMoment:@"保存失败"];
        });
    }];
    [exportSession setProcessingBlock:^(float progress) {
        // 更新进度 UI
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD showMessage:[NSString stringWithFormat:@"保存中%.0f /%",progress]];
        });
        
        NSLog(@"Asset Export Progress: %f", progress);

    }];
    [exportSession exportAsynchronously];
}
#pragma mark - PLShortVideoUploaderDelegate 视频上传
- (void)shortVideoUploader:(PLShortVideoUploader *)uploader completeInfo:(PLSUploaderResponseInfo *)info uploadKey:(NSString *)uploadKey resp:(NSDictionary *)resp {
    
    [MBProgressHUD hideHUD];
    if(info.error){
        [MBProgressHUD showError:[NSString stringWithFormat:@"上传失败，error: %@", info.error]];
          self.uploadButton.enabled = YES;
        [self removeActivityIndicatorView];
        return ;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", kURLPrefix, uploadKey];
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = urlString;
//    [self showAlertWithMessage:[NSString stringWithFormat:@"上传成功，地址：%@ 已复制到系统剪贴板", urlString]];
    NSLog(@"uploadInfo: %@",info);
    NSLog(@"uploadKey:%@",uploadKey);
    NSLog(@"resp: %@",resp);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"audioUrl"] = urlString;
    dic[@"coverImage"] = self.converImageUrl;
    AVAsset *asset = [AVAsset assetWithURL:self.url];
    dic[@"audioWidth"] = @(round(asset.pls_videoSize.width));
    dic[@"audioHeight"]= @(round(asset.pls_videoSize.height));
    //视频有musicID要传musicID
    if (self.currentMusicID > 0) {
          dic[@"musicId"] = @(self.currentMusicID);
    }else{
         CGFloat time = CMTimeGetSeconds(asset.duration);
         dic[@"musicTime"] = [NSString stringWithFormat:@"%f",time];
    }
    [self startReleaseWithDic:dic];
}
//发布
-(void)startReleaseWithDic:(NSMutableDictionary*)dic{
    if ([MOLReleaseManager manager].currentReleaseType == ReleaseType_reward) {
        //发布悬赏
        MOLRewardModel *model = [MOLReleaseManager manager].currentRewardModel;
//        dic[@"content"] =  self.upTextView.text;
        
        dic[@"contents"] = model.contentStr;
        dic[@"source"] = @(self.source);//(1=相机,2=相册,3=外链)
        dic[@"finishTime"] = model.finishTime;
        dic[@"giftId"] = @(model.gift.giftId);
        dic[@"giftNum"] = @(model.gitfNum);
        dic[@"rewardType"] = @(model.rewardType);
        dic[@"awardNum"] = @(model.redEnvelopeNum);
        dic[@"isJoiner"] = @(model.isJoiner);
        if ([MOLReleaseManager manager].h5ReleaseBlock) {
            [self gotoH5UploadWith:dic];
            return;
        }
        MOLReleaseRequest *r = [[MOLReleaseRequest alloc] initRequest_releaseRewardWithParameter:dic];
        [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
              self.uploadButton.enabled = YES;
            [MBProgressHUD hideHUD];
             [self removeActivityIndicatorView];
            if (code == MOL_SUCCESS_REQUEST) {
                [MBProgressHUD showMessageAMoment:@"发布成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_PUBLISH_REWARD object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_PUBLISHED object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
               
            }else{
                [MBProgressHUD showMessageAMoment:message];
            }
        } failure:^(__kindof MOLBaseNetRequest *request) {
              self.uploadButton.enabled = YES;
             [MBProgressHUD hideHUD];
             [self removeActivityIndicatorView];
             [MBProgressHUD showMessageAMoment:@"发布失败"];
        }];
    }else{
        //发布作品
//        dic[@"content"] = self.upTextView.text;
        dic[@"contents"] =  [BMSHelpers getContent:self.upTextView.text userSet:self.atInfo];
        dic[@"rewardId"] = @([MOLReleaseManager manager].rewardID);
        dic[@"source"] = @(self.source);//(1=相机,2=相册,3=外链)
        
        if ([MOLReleaseManager manager].h5ReleaseBlock) {
            [self gotoH5UploadWith:dic];
            return;
        }
        MOLReleaseRequest *r = [[MOLReleaseRequest alloc] initRequest_releaseWorkWithParameter:dic];
        [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
              self.uploadButton.enabled = YES;
             [self removeActivityIndicatorView];
            if (code == MOL_SUCCESS_REQUEST) {
                [MBProgressHUD showMessageAMoment:@"发布成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_PUBLISH_PRODUCTION object:nil];

                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_PUBLISHED object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD showMessageAMoment:message];
            }
        } failure:^(__kindof MOLBaseNetRequest *request) {
              self.uploadButton.enabled = YES;
             [self removeActivityIndicatorView];
            [MBProgressHUD showMessageAMoment:@"发布失败"];
        }];
    }
}
//传值到H5
-(void)gotoH5UploadWith:(NSMutableDictionary *)dic{
    [MOLReleaseManager manager].h5ReleaseBlock(dic);
    [MOLReleaseManager manager].h5ReleaseBlock = nil;
    [self removeActivityIndicatorView];
    [MBProgressHUD hideHUD];
    //POP到指定的webVC
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MOLWebViewController class]]) {
            MOLWebViewController *A =(MOLWebViewController *)controller;
            [self.navigationController popToViewController:A animated:YES];
        }
    }
}
- (void)shortVideoUploader:(PLShortVideoUploader *)uploader uploadKey:(NSString *)uploadKey uploadPercent:(float)uploadPercent {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = [NSString stringWithFormat:@"上传进度:%d%%", (int)(uploadPercent * 100)];
    });
    NSLog(@"uploadKey: %@",uploadKey);
    NSLog(@"uploadPercent: %.2f",uploadPercent);
}
#pragma mark textViewDelegate
//self.textNumLab为显示剩余字数的label#pragma mark -限制病情描述输入字数(最多不超过255个字)
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    //////////////////////////////////////////////////////
    if ([text isEqualToString:@"@"]) { //@事件
        [self callFriendsEvent];
    }else if ([text isEqualToString:@"\n"]){
        [self.upTextView resignFirstResponder];
    }
    // 退格
    if (text.length == 0) {
        if (range.length == 1) {
            return [self backspace];
        } else {
            return YES;
        }
    }
    //////////////////////////////////////////////////////
    //不支持系统表情的输入
    if ([[textView textInputMode] primaryLanguage]==nil||[[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen =MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >=0){
        return YES;
    } else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时,使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0){
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }else{
                __block NSInteger idx = 0;
                __block NSString *trimString = @"";//截取出的字串
                //使用字符串遍历,这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange,NSRange enclosingRange, BOOL* stop) {
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break,提高效率
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          idx++;
                                      }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了,哪一定是最大限制了。
            self.textNumLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)MAX_LIMIT_NUMS,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}
#pragma mark -显示当前可输入字数/总字数
- (void)textViewDidChange:(UITextView *)textView{
    [[MOLAltHelper shared] changeAltColorWith:textView WithOriginalFont:nil AndFontColor:nil];
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变,就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum >MAX_LIMIT_NUMS){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    //    不让显示负数?
    self.textNumLab.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,existTextNum),MAX_LIMIT_NUMS];

}
#pragma mark 懒加载
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, MOL_StatusBarAndNavigationBarHeight, MOL_SCREEN_WIDTH,MOL_SCALEHeight(132))];
        
        UIView *linview  = [[UIView alloc] initWithFrame:CGRectMake(10, MOL_SCALEHeight(132)-1, MOL_SCREEN_WIDTH- 20, 1)];
        linview.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.1);

        [_topView addSubview:linview];
        
        UIView *linview1  = [[UIView alloc] initWithFrame:CGRectMake(0,1, MOL_SCREEN_WIDTH, 1)];
        linview1.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.1);
        [_topView addSubview:linview1];
     
    }
    return _topView;
}
-(UIView *)voideView{
    if (!_voideView) {
        _voideView  = [[UIView alloc] initWithFrame:CGRectMake(MOL_SCREEN_WIDTH - MOL_SCALEWidth(84) - 10, 10, MOL_SCALEWidth(84), _topView.height - 10 - 10)];
        _voideView.backgroundColor = [UIColor whiteColor];
    
    }
    return _voideView;
}
-(UITextView *)upTextView{
    if (!_upTextView) {
        _upTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, MOL_SCREEN_WIDTH - self.voideView.width - 30, self.voideView.height - 5)];
        _upTextView.font = MOL_FONT(15);
        _upTextView.backgroundColor = [UIColor clearColor];
        _upTextView.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
        _upTextView.zw_placeHolder = @"请输入视频描述,能让更多的人看到～";
        _upTextView.delegate = self;
        _upTextView.returnKeyType = UIReturnKeyDone;
        [_topView addSubview:self.textNumLab];
      
    }
    return _upTextView;
}
-(UIButton *)addUserButton{
    if (!_addUserButton) {
        _addUserButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _topView.height - 40, 80, 40)];
        [_addUserButton setImage:[UIImage imageNamed:@"addUser"] forState:UIControlStateNormal];
        [_topView addSubview:_addUserButton];
        [_addUserButton addTarget:self action:@selector(CallFriendsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addUserButton;
}
//限制字数
-(UILabel *)textNumLab{
    if (!_textNumLab) {
        _textNumLab = [[UILabel alloc] initWithFrame:CGRectMake(_upTextView.width + 10 - 50,_topView.height - 15, 50, 15)];
        _textNumLab.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
        _textNumLab.textAlignment = NSTextAlignmentRight;
        _textNumLab.text = [NSString stringWithFormat:@"0/%d",MAX_LIMIT_NUMS];
        _textNumLab.font = [UIFont systemFontOfSize:12];
        
    }
    
    return  _textNumLab;
}
//悬赏金币
-(UIView *)RewardGoldView{
    if (!_RewardGoldView) {
        _RewardGoldView = [[UIView alloc] initWithFrame:CGRectMake(edgeW,CGRectGetMaxY(self.topView.frame) + 20,  MOL_SCREEN_WIDTH - 2 * edgeW, MOL_SCALEHeight(50))];
        _RewardGoldView.layer.cornerRadius = 5;
        _RewardGoldView.backgroundColor = HEX_COLOR_ALPHA(0x777575, 0.1);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(MOL_SCALEWidth(15), 0, 60, 20)];
        lable.centerY = _RewardGoldView.height/2;
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = @"悬赏金币";
        lable.textColor = [UIColor whiteColor];
        [_RewardGoldView addSubview:lable];
        //礼物
        self.showGiftView.frame = CGRectMake(CGRectGetMaxX(lable.frame), 0, _RewardGoldView.width -CGRectGetMaxX(lable.frame) ,_RewardGoldView.height);
        [_RewardGoldView addSubview:self.showGiftView];
        
    }
    return _RewardGoldView;
}
-(MOLShowGiftView *)showGiftView{
    if (!_showGiftView) {
        _showGiftView = [[[NSBundle mainBundle] loadNibNamed:@"MOLShowGiftView" owner:nil options:nil] firstObject];
        _showGiftView.backgroundColor = [UIColor clearColor];
    }
    return _showGiftView;
}
//悬赏时间
-(UIView *)RewardTimeView{
    if (!_RewardTimeView) {
        _RewardTimeView = [[UIView alloc] initWithFrame:CGRectMake(edgeW,CGRectGetMaxY(self.RewardGoldView.frame) + 10,  MOL_SCREEN_WIDTH - 2 * edgeW, MOL_SCALEHeight(60))];
        _RewardTimeView.layer.cornerRadius = 5;
        _RewardTimeView.backgroundColor = HEX_COLOR_ALPHA(0x777575, 0.1);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(MOL_SCALEWidth(15), 0, 60, 20)];
        lable.centerY = _RewardTimeView.height/2;
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = @"悬赏时间";
        lable.textColor = [UIColor whiteColor];
        [_RewardTimeView addSubview:lable];
        
        self.timeLable.centerY = lable.centerY;
        self.timeLable.x = CGRectGetMaxX(lable.frame) + 5;
        [_RewardTimeView addSubview:self.timeLable];
        [_RewardTimeView addSubview:self.dueToTimeLable];
    }
    return _RewardTimeView;
}
-(UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
        _timeLable.text = [MOLReleaseManager manager].currentRewardModel.finishDate;
        _timeLable.textColor = HEX_COLOR(0xFFEC00);
        _timeLable.font = [UIFont systemFontOfSize:14];
    }
    return _timeLable;
}
-(UILabel *)dueToTimeLable{
    if (!_dueToTimeLable) {
        CGRect rect = CGRectMake(CGRectGetMaxX(_timeLable.frame), 0,_RewardTimeView.width - CGRectGetMaxX(_timeLable.frame) -15, 20);
        _dueToTimeLable = [[UILabel alloc] initWithFrame:rect];
        _dueToTimeLable.centerY = _RewardTimeView.height/2;
        _dueToTimeLable.text = [MOLReleaseManager manager].currentRewardModel.finishDateStr;
        _dueToTimeLable.textAlignment = NSTextAlignmentRight;
        _dueToTimeLable.textColor = HEX_COLOR(0xFE6257);
        _dueToTimeLable.font = [UIFont systemFontOfSize:14];
        if (iPhone5) {
            _dueToTimeLable.font = [UIFont systemFontOfSize:13];
        }
    }
    return  _dueToTimeLable;
}
//红包个数
-(UIView *)RewardMoneyView{
    if (!_RewardMoneyView) {
        _RewardMoneyView = [[UIView alloc] initWithFrame:CGRectMake(edgeW,CGRectGetMaxY(self.RewardGoldView.frame) + 10,  MOL_SCREEN_WIDTH - 2 * edgeW, MOL_SCALEHeight(60))];
        _RewardMoneyView.layer.cornerRadius = 5;
        _RewardMoneyView.backgroundColor = HEX_COLOR_ALPHA(0x777575, 0.1);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(MOL_SCALEWidth(15), 0, 60, 20)];
        lable.centerY = _RewardMoneyView.height/2;
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = @"红包个数";
        lable.textColor = [UIColor whiteColor];
        [_RewardMoneyView addSubview:lable];
        
        UILabel *labe2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable.frame) + 15, 0, MOL_SCALEWidth(50), 20)];
        labe2.centerY = _RewardMoneyView.height/2;
        labe2.font = [UIFont systemFontOfSize:14];
        labe2.text =[NSString stringWithFormat:@"%ld个",(long)[MOLReleaseManager manager].currentRewardModel.redEnvelopeNum];
        labe2.textColor = HEX_COLOR(0xFE6257);
        labe2.textAlignment = NSTextAlignmentLeft;
        [_RewardMoneyView addSubview:labe2];
    }
    return _RewardMoneyView;
}

#pragma mark 底部
-(UIView *)baseToolboxView{
    if (!_baseToolboxView) {
        _baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, MOL_SCREEN_HEIGHT - MOL_SCALEHeight(40)- 20 - MOL_TabbarSafeBottomMargin, MOL_SCREEN_WIDTH, MOL_SCALEHeight(40))];
    }
    return _baseToolboxView;
}

-(UIButton *)saveToDraftBtn{
    if (!_saveToDraftBtn) {
        _saveToDraftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveToDraftBtn setImage:[UIImage imageNamed:@"rc_beautify"] forState:UIControlStateNormal];
        [_saveToDraftBtn setImage:[UIImage imageNamed:@"rc_beautify"] forState:UIControlStateHighlighted];
        [_saveToDraftBtn setTitle:@"存草稿" forState:UIControlStateNormal];
        [_saveToDraftBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
        [_saveToDraftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveToDraftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        _saveToDraftBtn.frame =  CGRectMake(10, 0, self.baseToolboxView.height, self.baseToolboxView.height);
        _saveToDraftBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_saveToDraftBtn addTarget:self action:@selector(saveToDraftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveToDraftBtn;
}
-(UIButton *)saveToPhotoAlbumBtn{
    if (!_saveToPhotoAlbumBtn) {
        UIButton *PhotoAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [PhotoAlbumBtn setImage:[UIImage imageNamed:@"rc_local"] forState:UIControlStateNormal];
        [PhotoAlbumBtn setImage:[UIImage imageNamed:@"rc_local"] forState:UIControlStateHighlighted];
        [PhotoAlbumBtn setTitle:@"存本地" forState:UIControlStateNormal];
        [PhotoAlbumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [PhotoAlbumBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        PhotoAlbumBtn.frame = CGRectMake(20, 0, self.baseToolboxView.height, self.baseToolboxView.height);
         PhotoAlbumBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [PhotoAlbumBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:7];
        [PhotoAlbumBtn addTarget:self action:@selector(saveToPhotoAlbumAction) forControlEvents:UIControlEventTouchUpInside];
        _saveToPhotoAlbumBtn = PhotoAlbumBtn;
    }
    return _saveToPhotoAlbumBtn;
}

-(UIButton *)uploadButton{
    if (!_uploadButton) {
        _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadButton setTitle:@"发布" forState:UIControlStateNormal];
        [_uploadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _uploadButton.backgroundColor = HEX_COLOR(0xFFEC00);
        _uploadButton.frame = CGRectMake(CGRectGetMaxX(self.saveToPhotoAlbumBtn.frame) + 20, 0,MOL_SCREEN_WIDTH - CGRectGetMaxX(self.saveToPhotoAlbumBtn.frame) - 40, self.baseToolboxView.height);
        _uploadButton.layer.cornerRadius = 3;
        _uploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_uploadButton addTarget:self action:@selector(uploadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadButton;
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)prefersStatusBarHidden{
    
    if (!_isFirst) {
        self.navigationController.navigationBar.frame = CGRectMake(0, MOL_StatusBarHeight, self.navigationController.navigationBar.frame.size.width, 44);
    }else{
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 64);
    }
    
    return  NO;    
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

#pragma mark -
#pragma mark @功能
- (void)callFriendsEvent{
    [MOLCallFriendsViewController show].selectedBlock = ^(MOLMsgUserModel *model) {
        NSLog(@"%@",model.userVO.userName);
        
        if (![[MOLGlobalManager shareGlobalManager] isUserself:model.userVO]) {
            NSString *strName = [NSString stringWithFormat:@"\b@%@\b", model.userVO.userName];
            if (self.atInfo.count) {
                if (self.atInfo[strName]) {
                    [OMGToast showWithText:@"你已经@过了"];
                    return;
                }
            }
            
            
            if (self.upTextView.text.length + strName.length > MAX_LIMIT_NUMS) {
                return;
            }
            [self.atInfo setObject:model forKey:strName];
            [self.upTextView insertText:strName];
            [self resetTextViewSelectedRange];
            
        }else{
            [OMGToast showWithText:@"不能@自己呦"];
        }
    };
    
}
-(void)CallFriendsAction:(UIButton *)sender{
    [self callFriendsEvent];
}
// 得到@Range数组
- (NSArray *)atRangeArray {
    NSArray *allKeys = self.atInfo.allKeys;
    if (!allKeys || allKeys.count == 0) {
        return nil;
    }
    
    NSString *pattern = [allKeys componentsJoinedByString:@"|"];
    
    NSMutableArray *atRanges = [NSMutableArray array];
    
    
    [self.upTextView.text enumerateStringsMatchedByRegex:pattern
                                              usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings,
                                                           const NSRange *capturedRanges, volatile BOOL *const stop) {
                                                  if ((*capturedRanges).length == 0) return;
                                                  [atRanges addObject:[NSValue valueWithRange:*capturedRanges]];
                                              }];
    return atRanges;
}

// 解决@某人后，光标位置保持在@某人后面
- (void)resetTextViewSelectedRange {
    NSRange selectedRange = self.upTextView.selectedRange;
    self.textRange = self.upTextView.selectedRange;
    __weak UITextView *tempTextView = self.upTextView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tempTextView.selectedRange = selectedRange;
    });
}





// 定位光标位置，@标签内部不允许编辑
-(void)textViewDidChangeSelection:(UITextView *)textView{
    if (self.atInfo && self.atInfo.count > 0) {
        if (!textView.selectedRange.length) {
            NSArray *rangeArray = [self atRangeArray];
            for (NSInteger i = 0; i < rangeArray.count; i++) {
                NSRange range = [rangeArray[i] rangeValue];
                NSRange selectedRange = textView.selectedRange;
                
                if (selectedRange.location > range.location &&
                    selectedRange.location < range.location + range.length / 2) {
                    textView.selectedRange = NSMakeRange(range.location, selectedRange.length);
                    break;
                } else if (selectedRange.location >= range.location + range.length / 2 &&
                           selectedRange.location < range.location + range.length) {
                    textView.selectedRange = NSMakeRange(range.location + range.length, selectedRange.length);
                    break;
                }
            }
        }else{
            
            NSArray *rangeArray = [self atRangeArray];
            for (NSInteger i = 0; i < rangeArray.count; i++) {
                NSRange range = [rangeArray[i] rangeValue];
                NSRange selectedRange = textView.selectedRange;
                
                if ((selectedRange.location > range.location &&
                     selectedRange.location < range.location + range.length / 2) || ((selectedRange.location + selectedRange.length) > range.location && (selectedRange.location +selectedRange.length) < range.location + range.length / 2)) {
                    textView.selectedRange = NSMakeRange(range.location, selectedRange.length);
                    break;
                } else if ((selectedRange.location >= range.location + range.length / 2 &&
                            selectedRange.location < range.location + range.length) || (((selectedRange.location +selectedRange.length) >= (range.location + range.length /2)) && ((selectedRange.location + selectedRange.length) < (range.location + range.length)))) {
                    textView.selectedRange = NSMakeRange(range.location + range.length, selectedRange.length);
                    break;
                }
            }
        }
    }
    self.textRange = textView.selectedRange;
}

- (BOOL)backspace {
    UITextView *intextView = self.upTextView;
    // Find the last thing we may input and delete it. And RETURN
    NSString *text = [intextView textInRange:[intextView textRangeFromPosition:intextView.beginningOfDocument toPosition:intextView.selectedTextRange.start]];
    NSArray *tempArray = [self.atInfo allKeys];
    for (NSString *temp in tempArray) {
        if ([text hasSuffix:temp]) {
            __block NSUInteger composedCharacterLength = 0;
            [temp enumerateSubstringsInRange:NSMakeRange(0, temp.length)
                                     options:NSStringEnumerationByComposedCharacterSequences
                                  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                      composedCharacterLength++;
                                  }];
            UITextRange *rangeToDelete = [intextView
                                          textRangeFromPosition:[intextView
                                                                 positionFromPosition:intextView.selectedTextRange.start
                                                                 offset:(NSInteger) - composedCharacterLength]
                                          toPosition:intextView.selectedTextRange.start];
            if (rangeToDelete) {
                [self replaceTextInRange:rangeToDelete withText:@""];
                NSRange newRange = [intextView.text rangeOfString:temp];
                if (newRange.location == NSNotFound) {
                    //新的text里面已经没有该@信息了，则从字典中清除掉
                    [self.atInfo removeObjectForKey:temp];
                }
                return NO;
            }
        }
    }
    return YES;
}

- (void)replaceTextInRange:(UITextRange *)range withText:(NSString *)text {
    if (range && [self textInputShouldReplaceTextInRange:range replacementText:text]) {
        [self.upTextView replaceRange:range withText:text];
    }
}
- (BOOL)textInputShouldReplaceTextInRange:(UITextRange *)range replacementText:(NSString *)replacementText {
    BOOL shouldChange = YES;
    NSInteger startOffset = [self.upTextView offsetFromPosition:self.upTextView.beginningOfDocument toPosition:range.start];
    NSInteger endOffset = [self.upTextView offsetFromPosition:self.upTextView.beginningOfDocument toPosition:range.end];
    NSRange replacementRange = NSMakeRange((NSUInteger)startOffset, (NSUInteger)(endOffset - startOffset));
    NSMutableString *newValue = [self.upTextView.text mutableCopy];
    [newValue replaceCharactersInRange:replacementRange withString:replacementText];
    
    return shouldChange;
}


@end

