//
//  MOLLaunchADManager.m
//  reward
//
//  Created by apple on 2018/12/1.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLLaunchADManager.h"
#import "MOLWebViewController.h"
#import "RewardRequest.h"
#import "MOLBannerSetModel.h"
#import "BannerModel.h"
#import "RewardDetailViewController.h"

@interface MOLLaunchADManager ()
@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, assign) NSInteger downCount;
@property (nonatomic, weak) UIButton* downCountButton;

@property(nonatomic,strong)BannerModel  *currentModel;
@property(nonatomic,strong)UIImage  *currentImage;
@end

@implementation MOLLaunchADManager
///在load 方法中，启动监听，可以做到无注入
+ (void)load
{
    [self shareInstance];
}
+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        ///如果是没啥经验的开发，请不要在初始化的代码里面做别的事，防止对主线程的卡顿，和 其他情况
        ///应用启动, 首次开屏广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            ///要等DidFinished方法结束后才能初始化UIWindow，不然会检测是否有rootViewController
            if (self.currentImage && self.currentModel) {
                 [self show];
            }
           
        }];
//        ///进入后台
//        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//            [self requestBannerData];
//        }];
//        ///后台启动,二次开屏广告
//        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
////            [self checkAD];
//        }];
    }
    return self;
}
-(void)setADDate:(BannerModel *)model{
    self.currentModel = model;
    NSURL *imageUrl = [NSURL URLWithString:model.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    self.currentImage = [UIImage imageWithData:imageData];
}

- (void)show
{
    self.isShowing = YES;
    ///初始化一个Window， 做到对业务视图无干扰。
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    ///广告布局
    [self setupSubviews:window];
    
    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;
    
    ///防止释放，显示完后  要手动设置为 nil
    self.window = window;
}

- (void)letGo
{
     [self hide];
    if (self.currentModel.bannerType.integerValue==1) {//跳转到商品详情
        RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
        rewardDetail.rewardId =self.currentModel.typeInfo?self.currentModel.typeInfo:@"";
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
    }else if(self.currentModel.bannerType.integerValue==0){ //web页面
        MOLWebViewController *web =[MOLWebViewController new];
        web.urlString =self.currentModel.typeInfo?self.currentModel.typeInfo:@"";
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:web animated:YES];
    }
   
}
- (void)goOut
{
    [self hide];
}
- (void)hide
{
    
    self.isShowing = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_SHOWAD object:nil];//发送开屏广告展示完成的通知
    
    ///来个渐显动画
    [UIView animateWithDuration:0.3 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.window.hidden = YES;
        self.window = nil;
      
    }];
}

///初始化显示的视图， 可以挪到具
- (void)setupSubviews:(UIWindow*)window
{
    ///随便写写
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:window.bounds];
    imageView.image = self.currentImage;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    
    ///给非UIControl的子类，增加点击事件
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(letGo)];
    [imageView addGestureRecognizer:tap];
    
    [window addSubview:imageView];
    
    ///增加一个倒计时跳过按钮
    self.downCount = 3;
    
    UIButton * goout = [[UIButton alloc] initWithFrame:CGRectMake(window.bounds.size.width - 100 - 20, MOL_StatusBarHeight, 100, 60)];
    goout.layer.cornerRadius = 30;
    goout.layer.borderWidth = 1;
    goout.layer.borderColor = (__bridge CGColorRef _Nullable)([[UIColor whiteColor] colorWithAlphaComponent:0.8]);
    [goout setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [goout addTarget:self action:@selector(goOut) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:goout];
    
    self.downCountButton = goout;
    [self timer];
}
- (void)timer
{
    [self.downCountButton setTitle:[NSString stringWithFormat:@"跳过:%ld",(long)self.downCount] forState:UIControlStateNormal];
    if (self.downCount <= 0) {
        [self hide];
    }
    else {
        self.downCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self timer];
        });
    }
}
@end
