//
//  PLPlayViewController.m
//  NiuPlayer
//
//  Created by hxiongan on 2018/3/9.
//  Copyright © 2018年 hxiongan. All rights reserved.
// https://juejin.im/post/5b4d60c7e51d4519511327ce

#import "PLPlayViewController.h"
#import "UIView+Alert.h"
#import "UIButton+Animate.h"
#import "HomeFunctionMenuView.h"
#import "HomePublisherView.h"
#import "HomeGiftView.h"
#import "HomeShareView.h"
#import "HomeCommentView.h"
#import "MOLVideoOutsideModel.h"

#import "MOLVideoModel.h"
#import "MOLExamineCardModel.h"
#import "HomePageRequest.h"
#import "MOLActionRequest.h"
#import "UIImageView+Rotate.h"
#import <AFHTTPSessionManager.h>
#import "UIView+Alert.h"
#import "HomeCommentModel.h"

#import "JAGrowingTextView.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
#import "RewardDetailViewController.h"
#import "MOLHomeViewController.h"
#import "RecommendViewController.h"
#import "DMHeartFlyView.h"

#import "MOLStatistics.h"
#import "STSystemHelper.h"
#import "UnLikeView.h"
#import "AnimateView.h"
#import "RecommendViewController.h"

#import "RegexKitLite.h"
#import "MOLCallFriendsViewController.h"
#import "OMGAttributedLabel.h"
#import "SendedRewardView.h"

#import "MOLMusicDetailViewController.h"

#import "MOLLaunchADManager.h"

static const NSInteger kMaxChar =80;

@interface PLPlayViewController ()<HomeShareViewDelegate,HomeCommentViewDelegate,JAGrowingTextViewDelegate,YYTextKeyboardObserver,UIGestureRecognizerDelegate,TYAttributedLabelDelegate>
{
    dispatch_semaphore_t _semaphore;
}

//@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, assign) BOOL isDisapper;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) HomePublisherView *publisherView;

@property (nonatomic, strong) SendedRewardView *sendedRewardView;

//发布者名称
@property (nonatomic, strong) UILabel *nameLable;

//发布者描述

@property (nonatomic, strong) OMGAttributedLabel *desLable;

@property (nonatomic, strong) HomeGiftView *giftView;
@property (nonatomic, strong) UIImageView *audioImageView;
@property (nonatomic, strong) MOLVideoModel *storyVO;
@property (nonatomic, strong) MOLExamineCardModel *rewardVO;

@property (nonatomic,strong)JAGrowingTextView *textView;  // 文本框
@property (nonatomic,strong)UIView *textBgView;
@property (nonatomic,strong)UIView *keyBoardView;
@property (nonatomic,strong)UIButton *sendContentBtn; //发送
@property (nonatomic,assign)BOOL isKeyBoardShow;
@property (nonatomic,strong)NSMutableAttributedString *place;
@property (nonatomic,assign)CGFloat originalH;
@property (nonatomic,strong)UIView *contentLine;
@property (nonatomic,assign)BOOL isHiddenStatus;
@property (nonatomic,assign)BOOL isNetEnd;
@property (nonatomic,strong)NSDate *upDate;
@property (nonatomic,weak)AnimateView *animateView;

////////////////////////
// @的匹配信息
@property (nonatomic, strong) NSMutableDictionary *atInfo;
// 文字选择或光标位置

@property (nonatomic, assign) NSRange textRange;

///////////////////////



@end

@implementation PLPlayViewController

- (void)viewDidLoad {
    
    //蒙层修改
    UIImageView *bottomShadow=[UIImageView new];
    [bottomShadow setImage: [UIImage imageNamed:@"bottom_shadow"]];
    [bottomShadow setFrame:CGRectMake(0,MOL_SCREEN_HEIGHT-290, MOL_SCREEN_WIDTH,290)];
    [self.view addSubview:bottomShadow];
    
    [super viewDidLoad];
    [self initData];
    [self layoutNavigationBar];
    [self layoutUI];
    AVAudioSession *session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self notification];
}

#pragma mark -
#pragma mark ----打断当前播放

- (void)handleInterruption:(NSNotification *)notification{
    NSDictionary * info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
//    //中断开始和中断结束
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //当被电话等中断的时候，调用这个方法，停止播放

        if (self.player.playing) {

           [self.player pause];

        }


    } else {
        /**
         *  中断结束，userinfo中会有一个InterruptionOption属性，
         *  该属性如果为resume，则可以继续播放功能
         */
                AVAudioSessionInterruptionOptions option = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        
                if (option == AVAudioSessionInterruptionOptionShouldResume) {
        
                    [self.player resume];
        
                }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    
    // app将进入到前台UIApplicationWillEnterForegroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //监测电话呼入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    if (self.fromViewController != 100) {
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:@"MOLCallFriendsViewController" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showedAD) name:MOL_SUCCESS_SHOWAD object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // app退到后台
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    // app将进入到前台UIApplicationWillEnterForegroundNotification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //监测电话呼入
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];

    if (self.fromViewController != 100) {
        [[YYTextKeyboardManager defaultManager] removeObserver:self];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MOLCallFriendsViewController" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MOL_SUCCESS_SHOWAD object:nil];
}

- (void)show{
    if (self.textView) {
        if (!self.textView.isFirstResponder) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.textView becomeFirstResponder];
            }];
        }
    }
}

/**
 * 应用将要进入到前台
 */
- (void)appDidEnterForeground{
//     NSLog(@"appDidEnterForeground%@",_url);
//    if (![self isDisplayedInScreen]) {
//        return;
//    }
    if (![self.player isPlaying]) {
        [self.player resume];
    }
    
    [self.audioImageView resumeRotate];
    [self.animateView resumeAnimate];
    

}
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return NO;
    }
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect newFrame = [keyWindow convertRect:self.view.frame fromView:self.view.superview];
    CGRect winBounds = keyWindow.bounds;
    
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.view.isHidden && self.view.alpha > 0.01 && self.view.window == keyWindow && intersects;
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
//    NSLog(@"appDidEnterBackground%@",_url);
    
    if (self.player.playing) {
        [self.player pause];
    }
    
    [self.audioImageView stopRotating];
    [self.animateView stopAnimate];

}
- (void)reachableViaWWAN
{
    if (self.player.playing) {
        [self.player pause];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前为非WIFI环境\n已为你暂停播放" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"继续播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.player resume];
            
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"暂停播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancleAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] presentViewController:alertController animated:YES completion:nil];
        });
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.fromViewController != 100) {
        [[YYTextKeyboardManager defaultManager] removeObserver:self];
    }
    
#if    !OS_OBJECT_USE_OBJC
    dispatch_release(_semaphore);
#endif
}

- (void)notification{
    /// 关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusEventNotif:) name:MOL_SUCCESS_USER_FOCUS object:nil];
    
    /// 评论
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentEvent:) name:MOL_SEND_COMMENT object:nil];
    
    //检测网路
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachableViaWWAN) name:MOL_ReachableViaWWAN object:nil];
    
}

- (void)commentEvent:(NSNotification *)notif{
    if (notif.object) {
        if (self.model.contentType ==1) {//悬赏
            self.homeMenuView.comment =[NSString stringWithFormat:@"%ld",self.model.rewardVO.commentCount];
        }else if (self.model.contentType ==2){//作品
            self.homeMenuView.comment =[NSString stringWithFormat:@"%ld",self.model.storyVO.commentCount];
        }
    }
    
}

- (void)focusEventNotif:(NSNotification *)notif{
    
    if (notif.object) {
        NSArray *arr =[NSArray new];
        arr =(NSArray *)notif.object;
        if (arr.count<2) { //表示关注必须存在userid和关注状态
            return;
        }
        
        BOOL isFocus =[arr[1] boolValue];
        
        if (isFocus==1) { //表示关注
            if (self.model.contentType ==1) { //悬赏
                self.model.rewardVO.userVO.isFriend =1;
            }else if (self.model.contentType ==2){ //作品
                self.model.storyVO.userVO.isFriend =1;
            }
            [self.homeMenuView focusHidden: YES];
        }else{//表示取消关注
            if (self.model.contentType ==1) { //悬赏
                self.model.rewardVO.userVO.isFriend =0;
            }else if (self.model.contentType ==2){ //作品
                self.model.storyVO.userVO.isFriend =0;
            }
            [self.homeMenuView focusHidden: NO];
        }
        
    }
    
}


- (void)initData{
    _atInfo =[NSMutableDictionary dictionary];
     _semaphore = dispatch_semaphore_create(1);
    self.isNetEnd =NO;
    self.storyVO =[MOLVideoModel new];
    self.rewardVO =[MOLExamineCardModel new];
    
}

- (void)layoutNavigationBar{
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)layoutUI{
    _closeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_closeButton setTintColor:[UIColor whiteColor]];
    [_closeButton setImage:[UIImage imageNamed:@"close"] forState:(UIControlStateNormal)];
    [_closeButton addTarget:self action:@selector(clickCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
    [_closeButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:.5]];
    _closeButton.layer.cornerRadius = 22;
    
    self.thumbImageView = [[UIImageView alloc] init];
   
    self.thumbImageView.clipsToBounds = YES;
    
    self.thumbImageView.contentMode = [BMSHelpers getPlayerContentMode: self.model];
    
    if (self.thumbImageURL) {
        [self.thumbImageView sd_setImageWithURL:self.thumbImageURL placeholderImage:self.thumbImageView.image];
    }
    if (self.thumbImage) {
        self.thumbImageView.image = self.thumbImage;
    }
    
    [self.view addSubview:self.thumbImageView];
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.playButton = [[UIButton alloc] init];
    self.playButton.hidden = YES;
    [self.playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:(UIControlEventTouchUpInside)];
    //  [self.playButton setImage:[UIImage imageNamed:@"play3"] forState:(UIControlStateNormal)];
    [self.playButton setImage:[UIImage imageNamed:@"home page to suspend"] forState:UIControlStateNormal];
    [self.view addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.center.equalTo(self.view);
    }];
    self.isHiddenStatus =self.playButton.isHidden;
    
    [self.view addSubview:_closeButton];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
//    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    [self.thumbImageView addSubview:_effectView];
//    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.thumbImageView);
//    }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    singleTap.numberOfTapsRequired =1;
    singleTap.delegate =self;
    [self.view addGestureRecognizer:singleTap ];
    
    UITapGestureRecognizer *waveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHeardShape:)];
    waveTap.numberOfTapsRequired = 2;
    waveTap.delegate =self;
    [self.view addGestureRecognizer:waveTap];
    
    [singleTap requireGestureRecognizerToFail:waveTap];
    
    
    if (self.fromViewController == 100) {
        UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
        
        [self.view addGestureRecognizer:longPressGest];
    }
    

    [self setupPlayer];
    
    self.enableGesture = YES;
    
    /////////////////////////////////////////////////////////
    self.homeMenuView =[HomeFunctionMenuView new];
    [self.homeMenuView setFrame:CGRectMake(MOL_SCREEN_WIDTH-48-10-10,MOL_SCREEN_HEIGHT-MOL_TabbarHeight-100-((48+17)*4+20*3)+40-5,48+10+10,(48+17)*4+20*3-60)];
    [self.view addSubview:self.homeMenuView];
    __weak typeof(self) wself = self;
    self.homeMenuView.homeFunctionMenuViewBlock = ^(HomeFunctionMenuViewType type, id parameter, UIButton *sender) {
        
        MOLVideoOutsideModel *parameterModel =[MOLVideoOutsideModel new];
        parameterModel =(MOLVideoOutsideModel *)parameter;
        
        switch (type) {
            case HomeFunctionMenuViewAvatars://发布者头像
            {
                
                if (parameterModel.contentType ==1) { //悬赏
                    if ([[MOLGlobalManager shareGlobalManager] isUserself:parameterModel.rewardVO.userVO]) {
                        MOLMineViewController *mineView =[MOLMineViewController new];
                        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:mineView animated:YES];
                        
                    }else{
                        MOLOtherUserViewController *otherView =[MOLOtherUserViewController new];
                        otherView.userId = parameterModel.rewardVO.userVO.userId?parameterModel.rewardVO.userVO.userId:@"";
                        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:otherView animated:YES];
                        
                    }
                }else{
                    if ([[MOLGlobalManager shareGlobalManager] isUserself:parameterModel.storyVO.userVO]) {
                        MOLMineViewController *mineView =[MOLMineViewController new];
                        
                        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:mineView animated:YES];
                    }else{
                        MOLOtherUserViewController *otherView =[MOLOtherUserViewController new];
                        otherView.userId =parameterModel.storyVO.userVO.userId?parameterModel.storyVO.userVO.userId:@"";
                        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:otherView animated:YES];
                    }
                }
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"PLPlayViewControllerHomeFunctionMenuViewAvatars" object:parameter];
            }
                break;
            case HomeFunctionMenuViewAttention:// 关注
            {
                NSMutableDictionary *dic =[NSMutableDictionary new];
                
                if (parameterModel.contentType ==1) {//悬赏
                    [dic setObject:[NSString stringWithFormat:@"%@",parameterModel.rewardVO.userVO.userId?parameterModel.rewardVO.userVO.userId:@""] forKey:@"toUserId"];
                }else{ //作品
                    [dic setObject:[NSString stringWithFormat:@"%@",parameterModel.storyVO.userVO.userId?parameterModel.storyVO.userVO.userId:@""] forKey:@"toUserId"];
                }
                
                
                [[[MOLActionRequest alloc] initRequest_focusActionWithParameter:@{} parameterId:dic[@"toUserId"]?dic[@"toUserId"]:@""] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                    //NSLog(@"self %@ --- paramer %@---%@",wself.model,parameterModel,parameter);
                   
                    if (code  == MOL_SUCCESS_REQUEST) {
                      // sender.selected =YES;
                        
                        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            sender.transform = CGAffineTransformMakeRotation(45 * M_PI/180.0);
                        } completion:^(BOOL finished) {
                            sender.selected =YES;
                            sender.transform = CGAffineTransformMakeRotation(0 * M_PI/180.0);
                            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                sender.alpha =0;
                            } completion:^(BOOL finished) {
                                sender.selected =NO;
                            }];
                        }];
                     
                        if (wself.model.contentType ==1) {//悬赏
                            wself.model.rewardVO.userVO.isFriend =1;
                            
                        }else{ //作品
                            wself.model.storyVO.userVO.isFriend =1;
                        }
                    }
                    
                    [sender setUserInteractionEnabled:YES];
                } failure:^(__kindof MOLBaseNetRequest *request) {
                    [sender setUserInteractionEnabled:YES];
                }];
//                [sender setEnabled:YES];
            }
                break;
            case HomeFunctionMenuViewPraise:// 赞👍
            {
                [wself praiseEvent:0];
                
            }
                break;
            case HomeFunctionMenuViewComments:// 评论
            {
                HomeCommentView *commentView =[HomeCommentView new];
                [commentView cottent:parameterModel];
                commentView.delegate =wself;
                [wself.view addSubview:commentView];
            }
                break;
                
            case HomeFunctionMenuViewShare:// 分享
            {
                HomeShareView *shareView =[HomeShareView new];
                shareView.dto =parameterModel;
                [shareView setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
                
                MOLUserModel *userDto =[MOLUserModel new];
                if (parameterModel.contentType ==1) { //悬赏
                    userDto =parameterModel.rewardVO.userVO;
                }else{//作品
                    userDto =parameterModel.storyVO.userVO;
                }
                
                
                if ([[MOLGlobalManager shareGlobalManager] isUserself:userDto]) {//自己
                    if (parameterModel.contentType ==1) { //悬赏
                        shareView.currentBusinessType = HomeShareViewBusinessOneselfRecommendRewardType;
                        [shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo",@"fuzhi",@"baocunbendi",@"hepai"] ];
                    }else{//作品
                        if (!parameterModel.storyVO.rewardVO) {//自由作品
                            shareView.currentBusinessType = HomeShareViewBusinessOneselfRecommendOtherType;
                            [shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo",@"delete",@"fuzhi",@"baocunbendi",@"hepai"] ];
                        }else{//悬赏作品
                            shareView.currentBusinessType = HomeShareViewBusinessOneselfRecommendRewardType;
                            [shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo",@"fuzhi",@"baocunbendi",@"hepai"]];
                        }
                        
                    }
                }else{//非自己
                    shareView.currentBusinessType = HomeShareViewBusinessOtherRecommendType;
                    [shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo",@"jubao",@"fuzhi",@"baocunbendi",@"buganxingqu",@"hepai"]];
                }
                
                
                shareView.delegate =wself;
                [wself.view addSubview:shareView];
            }
                break;
        }
    };
    
    if (!self.nameLable) {
        self.nameLable =[UILabel new];
    }
    
    //[self.nameLable setFont:MOL_MEDIUM_FONT(16)];
    [self.nameLable setFont:MOL_MEDIUM_FONT(17)];
    [self.nameLable setTextColor:HEX_COLOR(0xffffff)];
    [self.nameLable setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpUser:)];
    [self.nameLable addGestureRecognizer:tap];
    [self.view addSubview:self.nameLable];
    /////////////////////////////////////////////////////////
    
    if (!self.desLable) {
        self.desLable =[OMGAttributedLabel new];
    }

    [self.desLable setBackgroundColor: [UIColor clearColor]];
    //[self.desLable setFont:MOL_MEDIUM_FONT(13)];
    [self.desLable setFont:MOL_MEDIUM_FONT(15)];
    [self.desLable setTextColor:HEX_COLOR_ALPHA(0xffffff, 1)];
    [self.desLable setNumberOfLines:0];
    //[self.desLable setPreferredMaxLayoutWidth:247];
    self.desLable.delegate =self;
    [self.view addSubview:self.desLable];
    

    /////////////////////////////////////////////////////////
    
    if (self.model.contentType==1 || self.model.storyVO.rewardVO) {//悬赏 或者悬赏作品
        
        /////////////////////////////////////////////////////////
            if (self.model.storyVO.rewardVO) {//表示悬赏作品
                if (!self.publisherView) {
                    self.publisherView =[HomePublisherView new];
                }
                UITapGestureRecognizer *publisherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publisherTapAction:)];
                [self.publisherView addGestureRecognizer:publisherTap];
                
                [self.view addSubview:self.publisherView];
                
            }else{//悬赏
                if (!self.sendedRewardView) {
                    self.sendedRewardView =[SendedRewardView new];
                }
            
                [self.view addSubview:self.sendedRewardView];
                
            }
        
        
        
        
        /////////////////////////////////////////////////////////
        
        if (!self.giftView) {
            self.giftView =[HomeGiftView new];
            [self.giftView setFrame:CGRectMake(MOL_SCREEN_WIDTH-80,MOL_SCREEN_HEIGHT-80-49 - MOL_TabbarSafeBottomMargin, 80, 80)];
            //[self.giftView setBackgroundColor: [UIColor redColor]];
        }
        UITapGestureRecognizer *giftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giftTapAction:)];
        [self.giftView addGestureRecognizer:giftTap];
        [self.view addSubview:self.giftView];
        
        AnimateView *animate = [[AnimateView alloc] initWithFrame:CGRectMake(MOL_SCREEN_WIDTH-85,self.homeMenuView.bottom+15+5, self.giftView.width, self.giftView.height) withTpye:MOLAnimateViewTYPEe_god];
//        [AnimateView new];
//        [animate setFrame:CGRectMake(MOL_SCREEN_WIDTH-85,self.homeMenuView.bottom+15+5, self.giftView.width, self.giftView.height)];
        self.animateView =animate;
           [self.view addSubview:animate];
    }else{//普通作品
        if (!self.audioImageView) {
            self.audioImageView =[UIImageView new];
            [self.audioImageView setFrame:CGRectMake(MOL_SCREEN_WIDTH-50,self.homeMenuView.bottom+100-50+10+5, 50, 50)];
            self.audioImageView.centerX = self.homeMenuView.centerX;

            AnimateView *animate = [[AnimateView alloc] initWithFrame:CGRectMake(MOL_SCREEN_WIDTH-85,self.homeMenuView.bottom+15+5, self.audioImageView.width, self.audioImageView.height) withTpye:MOLAnimateViewTYPEe_flower];
            
            
//            [AnimateView new];
//            [animate setFrame:CGRectMake(MOL_SCREEN_WIDTH-85,self.homeMenuView.bottom+15+5, self.audioImageView.width, self.audioImageView.height)];
           // [animate setBackgroundColor: [UIColor redColor]];
            
            self.animateView =animate;
            
            
            if (!self.model.storyVO.musicCover) { //表示无音乐🎵封面
                [self.audioImageView setImage:[UIImage imageNamed:@"Group 17"]];
            }else{
               [self.audioImageView setImage: [self addImageUrl:self.model.storyVO.musicCover toImage:[UIImage imageNamed:@"Group 17"]]];
            }
 
            [self.view addSubview:self.audioImageView];
            self.audioImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *audioImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audioImageViewTapAction:)];
            [self.audioImageView addGestureRecognizer:audioImageViewTap];
            
            [self.view addSubview:animate];
            
        }
    }
    
    if (self.fromViewController !=100) {
        ///评论界面
        self.keyBoardView =[UIView new];
        UITapGestureRecognizer *keyBoardTag =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapKeyBoardEvent:)];
        [self.keyBoardView addGestureRecognizer:keyBoardTag];
        [self.view addSubview:self.keyBoardView];
        [self.keyBoardView setFrame:CGRectMake(0, self.view.height-MOL_TabbarHeight,MOL_SCREEN_WIDTH, 50)];
        [self.keyBoardView setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.0)];
        
        self.textBgView =[UIView new];
        [self.textBgView setFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH, 50)];
        
        [self.textBgView setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.0)];
        [self.keyBoardView addSubview:self.textBgView];
        
        self.textView = [[JAGrowingTextView alloc] initWithFrame:CGRectMake(15,0,MOL_SCREEN_WIDTH-20*2.0-15.0-30, 49)];
        self.textView.maxNumberOfLines = 5;
        self.textView.minNumberOfLines = 1;
        self.textView.maxNumberOfWords =kMaxChar;
        self.textView.font = MOL_REGULAR_FONT(16);
        self.textView.textColor = HEX_COLOR(0xffffff);
        [self.textView setBackgroundColor: [UIColor clearColor]];
        self.textView.size = [self.textView intrinsicContentSize];
        self.textView.returnKeyType =UIReturnKeySend;
        
        self.place = [[NSMutableAttributedString alloc] initWithString:@"有爱评论，说点好听的～"];
        [self.place addAttributes:@{NSFontAttributeName : MOL_REGULAR_FONT(16), NSForegroundColorAttributeName : HEX_COLOR_ALPHA(0xffffff, 0.6)} range:[@"有爱评论，说点好听的～" rangeOfString:@"有爱评论，说点好听的～"]];
        self.textView.placeholderAttributedText = self.place;
        self.textView.textViewDelegate = self;
        [self.textBgView addSubview:self.textView];
        
       self.textView.y =(self.textBgView.height-self.textView.height)/2.0;
        
        self.originalH =self.textView.height;
        
        self.contentLine =[UIView new];
        [self.contentLine setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, 1)];
        [self.contentLine setBackgroundColor:HEX_COLOR_ALPHA(0xffffff, 0.1)];
        [self.textBgView addSubview:self.contentLine];
        
        self.sendContentBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.sendContentBtn setFrame:CGRectMake(self.textBgView.width-20-30, self.textView.y+(44-30)/2.0, 30, 30)];
        [self.sendContentBtn setImage:[UIImage imageNamed:@"comment1"] forState:UIControlStateNormal];
        [self.sendContentBtn addTarget:self action:@selector(sendCommentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.textBgView addSubview:self.sendContentBtn];
    }
    
}

#pragma mark-
#pragma mark 点赞事件触发
- (void)praiseEvent:(NSInteger)type{
  //type 0 为 点击赞事件   1 为点击手势赞

    __weak typeof(self) wself = self;
    UIButton *sender =self.homeMenuView.praiseButton;
    if (type ==1) {
        sender.selected =!sender.selected;
    }
    
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"1" forKey:@"operateType"];
    
    if (self.model.contentType ==1) {//悬赏
        [dic setObject:@"1" forKey:@"recordType"];
        [dic setObject:[NSString stringWithFormat:@"%@",self.model.rewardVO.rewardId?self.model.rewardVO.rewardId:@""] forKey:@"typeId"];
    }else{ //作品
        [dic setObject:@"2" forKey:@"recordType"];
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.model.storyVO.storyId] forKey:@"typeId"];
    }
    
    
    
    [[[HomePageRequest alloc] initRequest_PraiseParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        NSInteger type = [request.responseObject[@"resBody"] integerValue];
        if (code  != MOL_SUCCESS_REQUEST) {
            if (type !=1) {//表示点击手势
                sender.selected =!sender.selected;
            }
            if (wself.model.contentType ==1) {//悬赏
                [wself.homeMenuView setPraise:[NSString stringWithFormat:@"%ld",(long)wself.model.rewardVO.favorCount]];
            }else{ //作品
                [wself.homeMenuView setPraise:[NSString stringWithFormat:@"%ld",(long)wself.model.storyVO.favorCount]];
            }
        }else{
            
//            if (type ==1) {//表示点击手势
//                sender.selected =!sender.selected;
//            }
            
            if (type) { //表示点赞成功
                if (wself.model.contentType ==1) {//悬赏
                    wself.model.rewardVO.isFavor =YES;
                    wself.model.rewardVO.favorCount+=1;
                    
                    if (type == 1) {//表示点击手势
                        [wself.homeMenuView setPraise:[NSString stringWithFormat:@"%ld",(long)wself.model.rewardVO.favorCount]];
                        [wself.homeMenuView currentModelSyn:wself.model];
                        
                    }
                    
                }else{ //作品
                    wself.model.storyVO.isFavor =YES;
                    wself.model.storyVO.favorCount+=1;
                    if (type == 1) {//表示点击手势
                        [wself.homeMenuView setPraise:[NSString stringWithFormat:@"%ld",(long)wself.model.storyVO.favorCount]];
                        [wself.homeMenuView currentModelSyn:wself.model];
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_LIKE object:nil];
            }else{ //表示取消点赞
                if (wself.model.contentType ==1) {//悬赏
                    wself.model.rewardVO.isFavor =NO;
                    wself.model.rewardVO.favorCount-=1;
                }else{ //作品
                    wself.model.storyVO.isFavor =NO;
                    wself.model.storyVO.favorCount-=1;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_LIKE_cancle object:nil];
            }
        }
        
        
        sender.selected = type;
        sender.userInteractionEnabled = YES;
        self.isNetEnd =NO;
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        sender.userInteractionEnabled = YES;
        self.isNetEnd =NO;
    }];
}

- (void)showHeardShape:(UITapGestureRecognizer *)tap
{
    NSLog(@"双击事件触发");
    //
    BOOL isPrise =NO;
   // dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
    if (self.model.contentType ==1) {//悬赏
        isPrise = self.model.rewardVO.isFavor;
    }else{//作品
        isPrise = self.model.storyVO.isFavor;
    }
   // dispatch_semaphore_signal(self->_semaphore);
    
    
    if (!isPrise) { //未点赞
        
        if ([MOLUserManagerInstance user_isLogin]) {
            if (!self.isNetEnd) { //表示网络请求成功
                self.isNetEnd =YES;
                [self praiseEvent:1];
            }
            
        }
    }
   // NSLog(@"多击事件触发");
    
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, 70, 60)];
    heart.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:heart];
    CGPoint winPoint = [tap locationInView:self.view];
    heart.center = CGPointMake(winPoint.x, winPoint.y - heart.height * 0.7);
    [heart animateInView:[UIApplication sharedApplication].keyWindow];
    
    self.upDate =[NSDate date];
}

///长按手势
-(void)longPressView:(UILongPressGestureRecognizer *)longPressGest{
    
    if (longPressGest.state==UIGestureRecognizerStateBegan) {
//        NSLog(@"长按手势开始");
        UnLikeView *unlikeView =[UnLikeView new];
        [unlikeView content:self.model];
        [unlikeView setFrame:self.view.frame];
        [self.view addSubview:unlikeView];
        return;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setThumbImage:(UIImage *)thumbImage {
    _thumbImage = thumbImage;
    self.thumbImageView.image = thumbImage;
}

- (void)setThumbImageURL:(NSURL *)thumbImageURL {
    _thumbImageURL = thumbImageURL;
    [self.thumbImageView sd_setImageWithURL:thumbImageURL placeholderImage:self.thumbImageView.image];
}

- (void)setModel:(MOLVideoOutsideModel *)model{
    
    _model =model;
    
    if (!model) {
        return;
    }
    
    if (model) {
        if (model.contentType == 1) { //悬赏
            self.rewardVO =[MOLExamineCardModel new];
            self.rewardVO =model.rewardVO;
            
        }else{
            self.storyVO =[MOLVideoModel new];
            self.storyVO =model.storyVO;
        }
    }
    
    if (!self.publisherView) {
        self.publisherView =[HomePublisherView new];
    }
    /////////////////////////////////////////////////////////
    if (!self.nameLable) {
        self.nameLable =[UILabel new];
    }
    
    /////////////////////////////////////////////////////////
    if (!self.desLable) {
        self.desLable =[OMGAttributedLabel new];
    }
    
    
    CGSize desSize;
    
    NSMutableAttributedString *desStr = [OMGAttributedLabel getJoinerCommonAttributedStr:model];
    
    OMGAttributedLabelImageType imageType =OMGAttributedLabelImageType_Undefined;
     if (model.contentType == 1) { //悬赏
         if (model.rewardVO.isJoiner) {//是合拍
             imageType = OMGAttributedLabelImageType_InTune;
         }
     }
    

   // self.desLable.attributedText =desStr;
  
    [self.desLable setTextContainer:[self.desLable textContainerContents:model imageType:imageType]];
    
    desSize.height = [desStr mol_getAttributedTextHeightWithMaxWith:247 font:MOL_MEDIUM_FONT(15)];
    
    desSize.height =ceil(desSize.height);
    
    if (desSize.height>22*4) {//限制4行
        desSize.height =22*4;
    }else if (desSize.height<22){
        desSize.height=22;
    }
    
    [self.desLable setFrame:CGRectMake(14,MOL_SCREEN_HEIGHT-MOL_TabbarHeight-10-desSize.height,247, desSize.height)];
    

    
    if (self.model.contentType ==1) { //悬赏
        NSString *detailStr=@"发布赏金";
        
        NSMutableAttributedString *desStr1 = [STSystemHelper attributedContent:[NSString stringWithFormat:@" %@",detailStr] color:HEX_COLOR_ALPHA(0xFFEC00,1) font:MOL_MEDIUM_FONT(12)];
        
        YYAnimatedImageView *desImage= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"mine_money"]];
        desImage.frame = CGRectMake(0, 0, 14, 14);
        
        NSMutableAttributedString *attachDes =[NSMutableAttributedString yy_attachmentStringWithContent:desImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:desImage.size alignToFont:MOL_MEDIUM_FONT(12) alignment:YYTextVerticalAlignmentCenter];
        
        [desStr1 appendAttributedString:attachDes];
        
        NSMutableAttributedString *desStr2 = [STSystemHelper attributedContent:[NSString stringWithFormat:@"%@ ",[STSystemHelper countNumAndChangeformat:[NSString stringWithFormat:@"%ld",model.rewardVO.rewardAmount]]] color:HEX_COLOR_ALPHA(0xFFEC00,1) font:MOL_MEDIUM_FONT(12)];
        [desStr1 appendAttributedString:desStr2];
       
        
        if (!self.sendedRewardView) {
            self.sendedRewardView =[SendedRewardView new];
        }
        
        CGSize strSize = [[desStr1 string] boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_MEDIUM_FONT(12)} context:nil].size;
        
    
        
       
        CGFloat introWidth = strSize.width+15;
        if (introWidth>MOL_SCREEN_WIDTH-15-48) {
            introWidth =MOL_SCREEN_WIDTH-15-48;
        }
        [self.sendedRewardView setFrame:CGRectMake(15,self.desLable.top-17-15 ,introWidth, 16)];
        [self.sendedRewardView setClipsToBounds:YES];
        [self.sendedRewardView.layer setCornerRadius:2];
        [self.sendedRewardView.layer setBorderWidth:0.5];
        [self.sendedRewardView.layer setBorderColor: HEX_COLOR_ALPHA(0xffffff,0.4).CGColor];
        [self.sendedRewardView setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.2)];
        [self.nameLable setFrame:CGRectMake(14, self.sendedRewardView.top-5-17,247,17)];
    }
    else{
       [self.nameLable setFrame:CGRectMake(14, self.desLable.top-17-17,247,17)];
    }
    
    
    if (self.model.contentType==2) { //作品
        if (self.model.storyVO.rewardVO) {//表示悬赏作品
            NSString *questionStr =@"";
            questionStr =self.model.storyVO.rewardVO.content?self.model.storyVO.rewardVO.content:@"";
            
            NSMutableAttributedString *questionAttStr = [STSystemHelper attributedContent:[NSString stringWithFormat:@"%@%@", self.model.storyVO.rewardVO.isJoiner?@" ":@"",questionStr] color:HEX_COLOR_ALPHA(0xffffff, 1) font:MOL_MEDIUM_FONT(13)];
            
            if (model.rewardVO.isJoiner) {//是合拍
                YYAnimatedImageView *questionImage= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"InTune"]];
                questionImage.frame = CGRectMake(0, 0, 19, 18);
                
                NSMutableAttributedString *attachQuestion =[NSMutableAttributedString yy_attachmentStringWithContent:questionImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:questionImage.size alignToFont:MOL_MEDIUM_FONT(13) alignment:YYTextVerticalAlignmentCenter];
                
                [questionAttStr insertAttributedString:attachQuestion atIndex:0];
            }
            
            
            CGSize size;
            
            size.height = [desStr mol_getAttributedTextHeightWithMaxWith:214 font:MOL_MEDIUM_FONT(13)];
            
            if (size.height>60) { //限制2行
                size.height=60;
            }else if(size.height<30){
                size.height=30;
            }
            
            [self.publisherView setFrame:CGRectMake(14,self.nameLable.top-20-55, 270, 55)];
            [self.publisherView setBackgroundColor:HEX_COLOR_ALPHA(0x000000,0.3)];
            [self.publisherView.layer setMasksToBounds:YES];
            [self.publisherView.layer setCornerRadius:3];
        }
    }
    
    
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *nameText =@"";
        
        if (model.contentType == 1) { //悬赏

            nameText = [NSString stringWithFormat:@"@%@",model.rewardVO.userVO.userName?model.rewardVO.userVO.userName:@""];
            [wself.sendedRewardView content: model];
            
        }else{//作品
           
            nameText = [NSString stringWithFormat:@"@%@",model.storyVO.userVO.userName?model.storyVO.userVO.userName:@""];
            
        }
        
        
        [wself.nameLable setText:nameText?nameText:@""];
        [wself.homeMenuView content:model];
        
        if (wself.model.contentType==2) { //作品
            if (wself.model.storyVO.rewardVO) {//表示悬赏作品
                [wself.publisherView content:model];
            }
        }
        
        if (model.contentType==1 || model.storyVO.rewardVO) {//悬赏
            [wself.giftView content:model];
        }
        
    });
    
    
}

- (UIImage *)addImageUrl:(NSString *)imageUrl toImage:(UIImage *)image2
{
    //将底部的一张的大小作为所截取的合成图的尺寸
    //UIGraphicsBeginImageContext(image2.size);
    UIGraphicsBeginImageContextWithOptions(image2.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw image2，底下的
    [image2 drawInRect:CGRectMake(0, 0, 50, 50)];
    
    
    // Draw image1，上面的，坐标适当的调整
    
    UIImage *image1 =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl?imageUrl:@""]]];
    
    // 矩形框
    CGRect rect = CGRectMake((50-30)/2.0,(50-30)/2.0, 30, 30);
    // 添加一个圆
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪(裁剪成刚才添加的图形形状)
    CGContextClip(ctx);
    [image1 drawInRect:rect];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

- (void)setUrl:(NSURL *)url {
    if ([_url.absoluteString isEqualToString:url.absoluteString]) return;
    _url = url;
    [self.audioImageView startRotating];
    if (self.player) {
        [self stop];
        [self setupPlayer];
        [self.player play];
    }
}

- (void) setupPlayer {
    
    NSLog(@"播放地址: %@", _url.absoluteString);
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    NSString *urlString = _url.absoluteString.lowercaseString;
    if ([urlString hasSuffix:@"mp4"]) {
        format = kPLPLAY_FORMAT_MP4;
    } else if ([urlString hasPrefix:@"rtmp:"]) {
        format = kPLPLAY_FORMAT_FLV;
    } else if ([urlString hasSuffix:@".mp3"]) {
        format = kPLPLAY_FORMAT_MP3;
    } else if ([urlString hasSuffix:@".m3u8"]) {
        format = kPLPLAY_FORMAT_M3U8;
    }
    [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:_url option:option];
    [self.view insertSubview:self.player.playerView atIndex:0];
    __weak typeof(self) wself = self;
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself.view);
       // make.bottom.mas_equalTo(-MOL_TabbarSafeBottomMargin);
    }];
    self.player.delegateQueue = dispatch_get_main_queue();
    
    self.player.playerView.contentMode =  [BMSHelpers getPlayerContentMode:self.model];
    self.player.delegate = self;
    self.player.loopPlay = YES;
}

- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
   // NSLog(@"%@",[[MOLGlobalManager shareGlobalManager] global_currentViewControl]);
    
    if ([[[MOLGlobalManager shareGlobalManager] global_currentViewControl]  isKindOfClass:[MOLHomeViewController class]] ||
        [[[MOLGlobalManager shareGlobalManager] global_currentViewControl]  isKindOfClass:[RecommendViewController class]]) {
        self.isHiddenStatus =YES;
        
    }else{
        self.isHiddenStatus = self.playButton.isHidden;
    }
    
    
    self.isDisapper = YES;
    [self stop];
    [self.audioImageView stopRotating];
    [self.animateView stopAnimate];
    [super viewDidDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   // NSLog(@"%@",[[MOLGlobalManager shareGlobalManager] global_currentViewControl]);
    if([[[MOLGlobalManager shareGlobalManager] global_currentViewControl]  isKindOfClass:[MOLHomeViewController class]] ||
       [[[MOLGlobalManager shareGlobalManager] global_currentViewControl]  isKindOfClass:[RecommendViewController class]]){
        
        self.isDisapper = NO;
       
       
        if (![self.player isPlaying]) {
            if (self.isHiddenStatus && ![MOLLaunchADManager shareInstance].isShowing) {
                 [self.player play];
                 [self.audioImageView resumeRotate];
                 [self.animateView resumeAnimate];
            }
        }
    }
    
}
-(void)showedAD{
    if (![self.player isPlaying]) {
        if (self.isHiddenStatus) {
            [self.player play];
            [self.audioImageView resumeRotate];
            [self.animateView resumeAnimate];
        }
    }
}


- (void)singleTapAction:(UITapGestureRecognizer *)gesture {

    if (!self.upDate) { //表示第一次单击
        [self singleEvent];
    }else{
        NSTimeInterval timeInterger = [[NSDate date] timeIntervalSinceDate:self.upDate]*1000;//表示毫秒
        if (timeInterger>1000) {//大于1000毫秒时间段表示单击，否则为其它事件
            //单击事件
            [self singleEvent];
        }
    }
   
}

///单击事件
- (void)singleEvent{
    if ([self.player isPlaying]) {
        [self.player pause];
        [self.audioImageView stopRotating];
        [self.animateView pauseAnimate];
    } else {
        [self.player resume];
        [self.audioImageView resumeRotate];
        [self.animateView resumeAnimate];
    }
}

- (void)clickPlayButton:(UIButton *)button {
    [self.player resume];
    [self.audioImageView resumeRotate];
    [self.animateView resumeAnimate];
}

- (void)stop {
    [self.player stop];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)showWaiting {
    [self.playButton hide];
    [self.view showFullLoading];
    [self.view bringSubviewToFront:self.closeButton];
}

- (void)hideWaiting {
    [self.view hideFullLoading];
    if (PLPlayerStatusPlaying != self.player.status) {
        [self.playButton show];
    }
}

- (void)setEnableGesture:(BOOL)enableGesture {
    if (_enableGesture == enableGesture) return;
    _enableGesture = enableGesture;
    
    if (nil == self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    }
    if (enableGesture) {
        if (![[self.view gestureRecognizers] containsObject:self.panGesture]) {
            [self.view addGestureRecognizer:self.panGesture];
        }
    } else {
        [self.view removeGestureRecognizer:self.panGesture];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture {
    
    if (UIGestureRecognizerStateChanged == panGesture.state) {
        CGPoint location  = [panGesture locationInView:panGesture.view];
        CGPoint translation = [panGesture translationInView:panGesture.view];
        [panGesture setTranslation:CGPointZero inView:panGesture.view];
        
#define FULL_VALUE 200.0f
        CGFloat percent = translation.y / FULL_VALUE;
        if (location.x > self.view.bounds.size.width / 2) {// 调节音量
            
            CGFloat volume = [self.player getVolume];
            volume -= percent;
            if (volume < 0.01) {
                volume = 0.01;
            } else if (volume > 3) {
                volume = 3;
            }
            [self.player setVolume:volume];
        } else {// 调节亮度f
            CGFloat currentBrightness = [[UIScreen mainScreen] brightness];
            currentBrightness -= percent;
            if (currentBrightness < 0.1) {
                currentBrightness = 0.1;
            } else if (currentBrightness > 1) {
                currentBrightness = 1;
            }
            [[UIScreen mainScreen] setBrightness:currentBrightness];
        }
    }
}

#pragma mark - PLPlayerDelegate

- (void)playerWillBeginBackgroundTask:(PLPlayer *)player {
}

- (void)playerWillEndBackgroundTask:(PLPlayer *)player {
}

- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state
{
    
//    NSLog(@"player :%@",player);
    
    if (self.isDisapper) {
        [self stop];
        [self hideWaiting];
        return;
    }
    
    if (state == PLPlayerStatusPlaying ||
        state == PLPlayerStatusPaused ||
        state == PLPlayerStatusStopped ||
        state == PLPlayerStatusError ||
        state == PLPlayerStatusUnknow ||
        state == PLPlayerStatusCompleted) {
        [self hideWaiting];
    } else if (state == PLPlayerStatusPreparing ||
               state == PLPlayerStatusReady ||
               state == PLPlayerStatusCaching) {
        [self showWaiting];
    } else if (state == PLPlayerStateAutoReconnecting) {
        [self showWaiting];
    }
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error
{
    [self hideWaiting];
    NSString *info = error.userInfo[@"NSLocalizedDescription"];
    [self.view showTip:info];
}

- (void)player:(nonnull PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator {
    dispatch_main_async_safe(^{
        if (![UIApplication sharedApplication].isIdleTimerDisabled) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
    });
    
}

- (AudioBufferList *)player:(PLPlayer *)player willAudioRenderBuffer:(AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat{
    return audioBufferList;
}

- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
        self.thumbImageView.hidden = YES;
    }
    
    // 统计-播放
    if (firstRenderType == PLPlayerFirstRenderTypeVideo) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"operateType"] = @"1";
        dic[@"recordType"] = @(self.model.contentType);
        if (self.model.contentType == 1) {
            dic[@"typeId"] = self.model.rewardVO.rewardId;
        }else{
            dic[@"typeId"] = [NSString stringWithFormat:@"%ld",self.model.storyVO.storyId];
        }
        
        [MOLStatistics statistics_play:dic];
    }
}

- (void)player:(nonnull PLPlayer *)player SEIData:(nullable NSData *)SEIData {
    
}

- (void)player:(PLPlayer *)player codecError:(NSError *)error {
    
    NSString *info = error.userInfo[@"NSLocalizedDescription"];
    [self.view showTip:info];
    
    [self hideWaiting];
}

- (void)player:(PLPlayer *)player loadedTimeRange:(CMTimeRange)timeRange {}

#pragma mark -
#pragma mark HomeShareViewDelegate
- (void)homeShareView:(MOLVideoOutsideModel *)model businessType:(HomeShareViewBusinessType)businessType type:(HomeShareViewType)shareType;{
    
    switch (shareType) {
        case HomeShareViewWechat: //朋友圈
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
        case HomeShareViewWeixin: //微信好友
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        }
            break;
        case HomeShareViewMqMzone: //QQ空间
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
        }
            break;
        case HomeShareViewQQ: //QQ
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
        }
            break;
        case HomeShareViewSinaweibo: //微博
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
        }
            break;
        case HomeShareViewReport: //举报
        {
            
            if (![MOLUserManagerInstance user_isLogin]) {
                [[MOLGlobalManager shareGlobalManager] global_modalLogin];
                return ;
            }
            
            NSArray *titleButtons = @[@"色情低俗",@"垃圾广告",@"政治敏感",@"抄袭复制",@"违规内容"];
            @weakify(self);
            LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:5 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
                @strongify(self);
                if (buttonIndex >= titleButtons.count) {
                    return;
                }
                NSString *title = titleButtons[buttonIndex];
                NSMutableDictionary *dic =[NSMutableDictionary new];
                [dic setObject:[NSString stringWithFormat:@"%@",title?title:@""] forKey:@"cause"];
                
                if (model.contentType ==1) {//悬赏
                    [dic setObject:@"1" forKey:@"reportType"];
                    [dic setObject:[NSString stringWithFormat:@"%@",model.rewardVO.rewardId?model.rewardVO.rewardId:@""] forKey:@"typeId"];
                }else{ //作品
                    [dic setObject:@"2" forKey:@"reportType"];
                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.storyVO.storyId] forKey:@"typeId"];
                }
                [[[HomePageRequest alloc] initRequest_ReportParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                    if (code  != MOL_SUCCESS_REQUEST) {
                        [OMGToast showWithText:message];
                    }else{
                        [OMGToast showWithText:@"举报成功"];
                    }
                    
                } failure:^(__kindof MOLBaseNetRequest *request) {
                    
                }];
                
            }];
            [actionS show];
        }
            break;
        case HomeShareViewCopyUrl: //复制链接
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            if (model.contentType == 1) {//悬赏
                pasteboard.string =model.rewardVO.audioUrl?model.rewardVO.audioUrl:@"";
            }else{//作品
                pasteboard.string =model.storyVO.audioUrl?model.storyVO.audioUrl:@"";
            }
            
            [OMGToast showWithText:@"复制链接成功"];
        }
            break;
        case HomeShareViewSave: //保存本地
        {
            [self playerDownload:model];
            
        }
            break;
        case HomeShareViewUnLike: //不感兴趣
        {
            [OMGToast showWithText:@"将减少此类视频推荐"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PLPlayViewControllerLoseInterest" object:model];
        }
            break;
        case HomeShareViewCancel: //取消
        {
            
        }
            break;
        case HomeShareViewDelete: //删除
        {
            if (![MOLUserManagerInstance user_isLogin]) {
                [[MOLGlobalManager shareGlobalManager] global_modalLogin];
                return;
            }
            
            if (model.contentType ==2) { //作品
                if (model.storyVO.isReward==1) { //已经获得奖金不能删除
                    [OMGToast showWithText:@"已获得奖励的视频无法删除"];
                }else{
                    [[[HomePageRequest alloc] initRequest_DeleteStoryParameter:@{} parameterId:[NSString stringWithFormat:@"%ld",model.storyVO.storyId]] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                        if (code  != MOL_SUCCESS_REQUEST) {
                            [OMGToast showWithText:message];
                        }else{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"PLPlayViewControllerLoseInterest" object:model];
                            //删除作品后刷新
                            [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_PUBLISH_PRODUCTION object:nil];
                        }
                        
                    } failure:^(__kindof MOLBaseNetRequest *request) {
                        
                    }];
                    
                }
            }
            
        }
            break;
        case HomeShareViewInTune: //合拍
        {
            if (![MOLUserManagerInstance user_isLogin]) {
                [[MOLGlobalManager shareGlobalManager] global_modalLogin];
                return;
            }
            NSURL *audioUrl;
            if (model.contentType ==1) {//悬赏
                audioUrl =[NSURL URLWithString:model.rewardVO.audioUrl?model.rewardVO.audioUrl:@""];
                [[MOLRecordManager manager] loadMaterialResourcesWith:audioUrl WithRewardID:model.rewardVO.rewardId.integerValue];
            }else{//作品
                audioUrl =[NSURL URLWithString:model.storyVO.audioUrl?model.storyVO.audioUrl:@""];
                [[MOLRecordManager manager] loadMaterialResourcesWith:audioUrl WithRewardID:0];
            }
            
           
        }
            break;
    }
    
}

//-----下载视频--
- (void)playerDownload:(MOLVideoOutsideModel *)playDto{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.bezelView.style=MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor =[UIColor blackColor];
    hud.contentColor =[UIColor whiteColor];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    [hud showAnimated:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *audioUrl =@"";
    NSString *audioId =@"";
    if (playDto.contentType == 1) {//悬赏
        audioUrl =playDto.rewardVO.audioUrl?playDto.rewardVO.audioUrl:@"";
        audioId =playDto.rewardVO.rewardId?playDto.rewardVO.rewardId:@"";
    }else{//作品
        audioUrl =playDto.storyVO.audioUrl?playDto.storyVO.audioUrl:@"";
        audioId =[NSString stringWithFormat:@"%ld",playDto.storyVO.storyId];
    }
    
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:audioUrl forKey:@"url"];
    
    [[[HomePageRequest alloc] initRequest_palyDownLoadUrlParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {

        if (code  == MOL_SUCCESS_REQUEST) {
            NSString  *fullPath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory,audioId];
            NSString *markUrl = request.responseObject[@"resBody"];
            NSURL *urlNew = [NSURL URLWithString:markUrl?markUrl:@""];
            NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
            NSURLSessionDownloadTask *task =
            [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                hud.progressObject = downloadProgress;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.label.text = downloadProgress.localizedDescription;
                });
    
                //  NSLog(@"%@",downloadProgress.localizedDescription);
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:fullPath];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [hud hideAnimated:YES];
                [self saveVideo:fullPath];
            }];
            
            [task resume];
        }else{
            [hud hideAnimated:YES];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
       [hud hideAnimated:YES];
    }];

}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

#pragma mark-
#pragma mark 保存视频完成之后的回调

- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
       // NSLog(@"保存视频失败%@", error.localizedDescription);
        [OMGToast showWithText:@"视频保存失败"];
    }
    else {
       // NSLog(@"保存视频成功");
        [OMGToast showWithText:@"保存成功,请到系统相册查看"];
        
        // 统计-下载
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"operateType"] = @"3";
        dic[@"recordType"] = @(self.model.contentType);
        if (self.model.contentType == 1) {
            dic[@"typeId"] = self.model.rewardVO.rewardId;
        }else{
            dic[@"typeId"] = [NSString stringWithFormat:@"%ld",self.model.storyVO.storyId];
        }
        [MOLStatistics statistics_downLoad:dic];
    }
}

#pragma mark-
#pragma mark 分享实现
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  @"";
    NSString* title =@"";
    NSString* content =@"";
    NSString* webpageStr =@"";
    if (self.model.contentType ==1) {//悬赏
        thumbURL =self.model.rewardVO.shareMsgVO.shareImg?self.model.rewardVO.shareMsgVO.shareImg:@"";
        title =self.model.rewardVO.shareMsgVO.shareTitle?self.model.rewardVO.shareMsgVO.shareTitle:@"";
        content =self.model.rewardVO.shareMsgVO.shareContent?self.model.rewardVO.shareMsgVO.shareContent:@"";
        webpageStr =self.model.rewardVO.shareMsgVO.shareUrl?self.model.rewardVO.shareMsgVO.shareUrl:@"";
    }else{ //作品
        thumbURL =self.model.storyVO.shareMsgVO.shareImg?self.model.storyVO.shareMsgVO.shareImg:@"";
        title =self.model.storyVO.shareMsgVO.shareTitle?self.model.storyVO.shareMsgVO.shareTitle:@"";
        content =self.model.storyVO.shareMsgVO.shareContent?self.model.storyVO.shareMsgVO.shareContent:@"";
        webpageStr =self.model.storyVO.shareMsgVO.shareUrl?self.model.storyVO.shareMsgVO.shareUrl:@"";
    }
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = webpageStr;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            
            // 统计-分享
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"operateType"] = @"2";
            dic[@"recordType"] = @(self.model.contentType);
            if (self.model.contentType == 1) {
                dic[@"typeId"] = self.model.rewardVO.rewardId;
            }else{
                dic[@"typeId"] = [NSString stringWithFormat:@"%ld",self.model.storyVO.storyId];
            }
            [MOLStatistics statistics_share:dic];

            if (self.model.contentType == 1) {
                self.model.rewardVO.shareCount += 1;
                NSString *count = [STSystemHelper getNum:self.model.rewardVO.shareCount];
                self.homeMenuView.share = count;
            }else{
                self.model.storyVO.shareCount += 1;
                NSString *count = [STSystemHelper getNum:self.model.storyVO.shareCount];
                self.homeMenuView.share = count;
            }
            
        }
    }];
}
#pragma mark 点击音乐转盘
-(void)audioImageViewTapAction:(UITapGestureRecognizer *)tap{
    //WSC
    if (self.model.storyVO.musicId > 0) {
        MOLMusicDetailViewController * rewardDetail = [MOLMusicDetailViewController new];
        rewardDetail.musicId = self.model.storyVO.musicId;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
    }
  
}
- (void)giftTapAction:(UITapGestureRecognizer *)tap{
    //    if (![MOLUserManagerInstance user_isLogin]) {
    //        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
    //        return ;
    //    }
    
    
   // NSLog(@"触发礼品事件");
    
    if (self.model.contentType ==1 || ((self.model.contentType == 2) && self.model.storyVO.rewardVO)) {
        RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
        if (self.model.contentType == 1) {//悬赏
            rewardDetail.rewardModel =self.model;
        }else if (self.model.contentType == 2){//作品
            if (self.model.storyVO.rewardVO) {//悬赏作品
                rewardDetail.rewardId =[NSString stringWithFormat:@"%ld",self.model.storyVO.rewardVO.rewardId];
            }
        }
        
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
    }
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"PLPlayViewControllerReward" object:self.model];
    
}

- (void)publisherTapAction:(UITapGestureRecognizer *)tap{
   // NSLog(@"触发悬赏者事件");
    //    if (![MOLUserManagerInstance user_isLogin]) {
    //        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
    //        return ;
    //    }
    
    if ((self.model.contentType == 2) && self.model.storyVO.rewardVO) {//悬赏z作品-悬赏者
        RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
        rewardDetail.rewardId =[NSString stringWithFormat:@"%ld",self.model.storyVO.rewardVO.rewardId];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
    }
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"PLPlayViewControllerReward" object:self.model];
}

#pragma mark -
#pragma mark HomeCommentViewDelegate
- (void)homeCommentViewEvent:(HomeCommentModel *)modle eventType:(CommentCellEventType)type{
   // NSLog(@"跳转到用户个人页面");
    
}

- (void)tapKeyBoardEvent:(UITapGestureRecognizer *)tap{
    [self.textView resignFirstResponder];
}

#pragma mark - YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition
{
    
    CGRect kbFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    self.isKeyBoardShow =transition.toVisible;
    // __weak typeof(self) wself = self;
    
    if (self.isKeyBoardShow) {
        [self.keyBoardView setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, self.view.height)];
        CGRect containerFrame = self.textBgView.frame;
      //  containerFrame.origin.y = self.view.height- kbFrame.size.height- containerFrame.size.height;
        containerFrame.origin.y = self.view.height- kbFrame.size.height- containerFrame.size.height+MOL_TabbarSafeBottomMargin;
        self.textBgView.frame = containerFrame;
       // self.textView.y =0;
        // [self.textView setFrame:CGRectMake(15,0,MOL_SCREEN_WIDTH-15*2.0, 49)];;
       // [self.keyBoardView setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.5)];
        
    }else{
        
        [self.keyBoardView setFrame:CGRectMake(0, self.view.height-self.textBgView.height, MOL_SCREEN_WIDTH, self.textBgView.height)];
        self.textBgView.y =0;
        //[self.textBgView setFrame: CGRectMake(0, 0, self.keyBoardView.width, self.keyBoardView.height)];
       // self.textView.y =0;
        //[self.textView setFrame:CGRectMake(15,0,MOL_SCREEN_WIDTH-15*2.0,self.textBgView.height)];
       // [self.keyBoardView setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.0)];
    }
    
//    if (self.isKeyBoardShow) {
//        [self.sendContentBtn setAlpha:1];
//        [self.homeMenuView setAlpha:0];
//    }else{
//        [self.sendContentBtn setAlpha:0];
//        [self.homeMenuView setAlpha:1];
//    }
    
    self.textView.y =(self.textBgView.height-self.textView.height)/2.0;
    
}

#pragma mark - JAGrowingTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(JAGrowingTextView *)growingTextView{
    if (![MOLUserManagerInstance user_isLogin]) {
        [self.textView resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[self cancelUI];
            [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        });
    }
    return YES;
}

- (void)didChangeHeight:(CGFloat)height
{
    //当前高度   需要重新设置输入框的Y值 用变化高度-当前高度
    float diff = height-self.textBgView.height;
    CGRect frame = self.textBgView.frame;
    frame.origin.y -=diff;
    frame.size.height +=diff;
    if (self.originalH != self.textBgView.height) {
        self.originalH = self.textBgView.height;
    }
    
    if (frame.size.height<49) {
        frame.origin.y -= (49 -frame.size.height);
        frame.size.height =49;
    }
    [self.textBgView setFrame:frame];
    self.textView.y =(self.textBgView.height-self.textView.height)/2.0;

    
}
- (void)textViewDidChange:(JAGrowingTextView *)growingTextView
{
//    if (!growingTextView.text.length) { //表示无数据
//       // [self.sendContentBtn setSelected:NO];
//        [self.sendContentBtn setUserInteractionEnabled:NO];
//    }else{//表示有数据
//      //  [self.sendContentBtn setSelected:YES];
//        [self.sendContentBtn setUserInteractionEnabled:YES];
//    }
    
}

// 发送文本
- (BOOL)growingTextView:(JAGrowingTextView*)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText
{
    //////////////////////////////////////////////////////
    if ([replacementText isEqualToString:@"@"]) { //@事件
        [self callFriendsEvent];
    }
    //////////////////////////////////////////////////////
    // 退格
    if (replacementText.length == 0) {
        if (range.length == 1) {
            return [self backspace];
        } else {
            return YES;
        }
    }else if ([replacementText isEqualToString:@"\n"]) {

        // 发送
        if (self.textView.text.length) {
            [self getCommentList];
            [self.textView resignFirstResponder];
            
        }
        
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark @功能
// 得到@Range数组
- (NSArray *)atRangeArray {
    NSArray *allKeys = self.atInfo.allKeys;
    if (!allKeys || allKeys.count == 0) {
        return nil;
    }
    
    NSString *pattern = [allKeys componentsJoinedByString:@"|"];
    
    NSMutableArray *atRanges = [NSMutableArray array];
    [self.textView.text enumerateStringsMatchedByRegex:pattern
                                            usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings,
                                                         const NSRange *capturedRanges, volatile BOOL *const stop) {
                                                if ((*capturedRanges).length == 0) return;
                                                [atRanges addObject:[NSValue valueWithRange:*capturedRanges]];
                                            }];
    return atRanges;
}

// 解决@某人后，光标位置保持在@某人后面
- (void)resetTextViewSelectedRange {
    NSRange selectedRange = self.textView.selectedRange;
    self.textRange = self.textView.selectedRange;
    __weak UITextView *tempTextView = self.textView.textView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tempTextView.selectedRange = selectedRange;
    });
}





// 定位光标位置，@标签内部不允许编辑
- (void)textViewDidChangeSelection:(JAGrowingTextView *)growingTextView{
    if (self.atInfo && self.atInfo.count > 0) {
        
        if (!growingTextView.textView.selectedRange.length) {
            NSArray *rangeArray = [self atRangeArray];
            for (NSInteger i = 0; i < rangeArray.count; i++) {
                NSRange range = [rangeArray[i] rangeValue];
                NSRange selectedRange = growingTextView.textView.selectedRange;
                
                if (selectedRange.location > range.location &&
                    selectedRange.location < range.location + range.length / 2) {
                    growingTextView.textView.selectedRange = NSMakeRange(range.location, selectedRange.length);
                    break;
                } else if (selectedRange.location >= range.location + range.length / 2 &&
                           selectedRange.location < range.location + range.length) {
                    growingTextView.textView.selectedRange = NSMakeRange(range.location + range.length, selectedRange.length);
                    break;
                }
            }
        }else{
            
            NSArray *rangeArray = [self atRangeArray];
            for (NSInteger i = 0; i < rangeArray.count; i++) {
                NSRange range = [rangeArray[i] rangeValue];
                NSRange selectedRange = growingTextView.textView.selectedRange;
                
                if ((selectedRange.location > range.location &&
                     selectedRange.location < range.location + range.length / 2) || ((selectedRange.location + selectedRange.length) > range.location && (selectedRange.location +selectedRange.length) < range.location + range.length / 2)) {
                    growingTextView.textView.selectedRange = NSMakeRange(range.location, selectedRange.length);
                    break;
                } else if ((selectedRange.location >= range.location + range.length / 2 &&
                            selectedRange.location < range.location + range.length) || (((selectedRange.location +selectedRange.length) >= (range.location + range.length /2)) && ((selectedRange.location + selectedRange.length) < (range.location + range.length)))) {
                    growingTextView.textView.selectedRange = NSMakeRange(range.location + range.length, selectedRange.length);
                    break;
                }
            }
        }
    }
    self.textRange = growingTextView.textView.selectedRange;
}

- (BOOL)backspace {
    JAGrowingInternalTextView *intextView = self.textView.textView;
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
                NSRange newRange = [_textView.text rangeOfString:temp];
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

- (BOOL)textInputShouldReplaceTextInRange:(UITextRange *)range replacementText:(NSString *)replacementText {
    BOOL shouldChange = YES;
    
    NSInteger startOffset = [self.textView.textView offsetFromPosition:self.textView.textView.beginningOfDocument toPosition:range.start];
    NSInteger endOffset = [self.textView.textView offsetFromPosition:self.textView.textView.beginningOfDocument toPosition:range.end];
    NSRange replacementRange = NSMakeRange((NSUInteger)startOffset, (NSUInteger)(endOffset - startOffset));
    
    NSMutableString *newValue = [self.textView.textView.text mutableCopy];
    
    [newValue replaceCharactersInRange:replacementRange withString:replacementText];
    
    return shouldChange;
}

- (void)replaceTextInRange:(UITextRange *)range withText:(NSString *)text {
    if (range && [self textInputShouldReplaceTextInRange:range replacementText:text]) {
        [self.textView.textView replaceRange:range withText:text];
    }
}


#pragma mark -
#pragma mark
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
            
            if (self.textView.textView.text.length + strName.length > kMaxChar) {
                return;
            }
            [self.atInfo setObject:model forKey:strName];
            [self.textView.textView insertText:strName];
            [self resetTextViewSelectedRange];
        }else{
            [OMGToast showWithText:@"不能@自己呦"];
        }
        
    };
    
}
- (void)sendCommentButtonEvent:(UIButton *)sender{

    if (![MOLUserManagerInstance user_isLogin]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        });
    }
    [self callFriendsEvent];
}



- (void)getCommentList {
    
    
    
    [self.view showLoadingHUD];
    __weak typeof(self) wself = self;
    NSMutableDictionary *dic =[NSMutableDictionary new];
    id r ;
    
    
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.model.contentType] forKey:@"commentType"];
    
    
    /// 数组对象
    
    NSLog(@"@");
    
    [dic setObject:[BMSHelpers getContent:self.textView.text?self.textView.text:@"" userSet:self.atInfo] forKey:@"contents"];
    
    if (self.model.contentType == 1) {//悬赏
        [dic setObject:self.model.rewardVO.rewardId?self.model.rewardVO.rewardId:@"" forKey:@"typeId"];
        
    }else if (self.model.contentType ==2){//作品
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.model.storyVO.storyId] forKey:@"typeId"];
    }
    r = [[HomePageRequest alloc] initRequest_SendCommentParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [wself.view hideLoadingHUD];
        
        if (code  == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                
                // 解析数据
                if (wself.model.contentType ==1) {//悬赏
                    wself.model.rewardVO.commentCount +=1;
                    [wself.homeMenuView setComment:[NSString stringWithFormat:@"%ld",(long)wself.model.rewardVO.commentCount]];
                }else{ //作品
                    wself.model.storyVO.commentCount +=1;
                    [wself.homeMenuView setComment:[NSString stringWithFormat:@"%ld",(long)wself.model.storyVO.commentCount]];
                }
                wself.textView.text =@"";
                
                
            }
        }else{
            [OMGToast showWithText: message];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}


- (void)jumpUser:(UITapGestureRecognizer *)sender{
    [self avatarEvent];
}

- (void)avatarEvent{
    NSLog(@"跳转到用户事件响应");
    
    if (self.model.contentType ==1) { //悬赏
        [self jumpToUser:self.model.rewardVO.userVO];
    }else{
        [self jumpToUser:self.model.storyVO.userVO];
    }
    
}


- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]])
    {
        ContentsItemModel *model = ((TYLinkTextStorage*)textStorage).linkData;
        if (model && [model isKindOfClass: [ContentsItemModel class]] && model.type == 2) {
            
            MOLUserModel *userVO =[MOLUserModel new];
            userVO.userId = [NSString stringWithFormat:@"%ld",model.typeId];
            [self jumpToUser:userVO];
        }
    }
}

- (void)jumpToUser:(MOLUserModel *)userModel{
    if ([[MOLGlobalManager shareGlobalManager] isUserself:userModel]) {
        MOLMineViewController *mineView =[MOLMineViewController new];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:mineView animated:YES];
        
    }else{
        MOLOtherUserViewController *otherView =[MOLOtherUserViewController new];
        otherView.userId = userModel.userId?userModel.userId:@"";
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:otherView animated:YES];
        
    }
}
@end
