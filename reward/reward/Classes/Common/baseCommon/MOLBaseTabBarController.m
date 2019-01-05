//
//  MOLBaseTabBarController.m
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseTabBarController.h"
#import "MOLBaseNavigationController.h"
#import "MOLMineViewController.h"
#import "MOLMessageViewController.h"
#import "MOLHomeViewController.h"
#import "MOLDiscoverViewController.h"
#import "EDChatViewController.h"

#import <AFNetworkReachabilityManager.h>
#import "STSystemHelper.h"
#import "MOLAppStartRequest.h"
#import "MOLUpdateView.h"

#import "MOLSelectReleaseView.h"
#import "MOLPostRewardVC.h"
#import "MOLStartRecordViewController.h"
#import "MOLReleaseViewController.h"
#import "MOLAccountViewModel.h"

#import "MOLPrivacyView.h"

#import "MOLRecordViewController.h"

@interface MOLBaseTabBarController()<UITabBarControllerDelegate, NIMLoginManagerDelegate,NIMConversationManagerDelegate,NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate>
@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;

@property (nonatomic, strong) MOLHomeViewController *homeViewController;
@property (nonatomic, strong) MOLBaseNavigationController *homeViewControllerNav;

@property (nonatomic, strong) MOLDiscoverViewController *discoverViewController;
@property (nonatomic, strong) MOLBaseNavigationController *discoverViewControllerNav;

@property (nonatomic, strong) UIViewController *middleViewControl;

@property (nonatomic, strong) MOLMineViewController *mineViewController;
@property (nonatomic, strong) MOLBaseNavigationController *mineViewControllerNav;

@property (nonatomic, strong) MOLMessageViewController *messageViewController;
@property (nonatomic, strong) MOLBaseNavigationController *messageViewControllerNav;

@property (nonatomic, weak) UIButton *recordButton;
@property (nonatomic,strong) MOLSelectReleaseView *releaseview;

@property (nonatomic, assign) BOOL hasWork;
@property (nonatomic, weak) MOLUpdateView *updateView;  // 更新view
@end

@implementation MOLBaseTabBarController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self listenNetWorkingPort];  // 网络监听
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    [self tab_addSubViewContrller];
    [self tab_setCustomTabBar];
    [self initReleaseView];
    self.delegate = self;
    
    [self bindingViewModel];
    
    // 如果登录获取用户资料
    [self request_getUserInfo];
    
    // 监听登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:MOL_SUCCESS_USER_LOGIN object:nil];
    
    // 首页刷新成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshImageView_endRefresh) name:MOL_HOME_REFRESHED object:nil];
 
    // 自动登录云信
    [[MOLYXManager shareYXManager] yx_autoLoginYXWithCurrentViewControl:self];
    
    [self launch_checkVersionUpdate];
    [self checkFront];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - 网络监听
- (void)listenNetWorkingPort
{
    self.hasWork = YES;
    // 设置网络状态变化回调
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                self.hasWork = NO;
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if (self.hasWork == NO) {
                    self.hasWork = YES;
                    [self launch_checkVersionUpdate];
                    [self checkFront];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MOL_ReachableViaWWAN" object:nil];
                });
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (self.hasWork == NO) {
                    self.hasWork = YES;
                    [self launch_checkVersionUpdate];
                    [self checkFront];
                }
                break;
            default:
                break;
        }
    }];
    // 启动网络状态监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - Update
- (void)launch_checkVersionUpdate
{
    // 获取当前版本
    NSString *version = [STSystemHelper getApp_version];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"platForm"] = MOL_IOS;
    dic[@"version"] = version;
    MOLAppStartRequest *r = [[MOLAppStartRequest alloc] initRequest_versionCheckWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        if (code == MOL_SUCCESS_REQUEST) {
            NSDictionary *dic = request.responseObject[@"resBody"];
            // 跟新内容
            NSString *content = [dic mol_jsonString:@"content"];
            
            // 最新版本号
            NSString *ver_new = [dic mol_jsonString:@"version"];
            
            // 判断是否需要跟新
            if ([ver_new compare:version options:NSNumericSearch] == NSOrderedDescending) { // 需要更新
                
                BOOL forceUpdate = [dic mol_jsonBool:@"isImpose"];
                
                [self.updateView removeFromSuperview];
                MOLUpdateView *updateV = [[MOLUpdateView alloc] init];
                self.updateView = updateV;
                updateV.width = MOL_SCREEN_WIDTH;
                updateV.height = MOL_SCREEN_HEIGHT;
                [updateV showUpdateWithVersion:ver_new content:content force:forceUpdate];
                [[[[MOLGlobalManager shareGlobalManager] global_rootNavigationViewControl] view] addSubview:updateV];
            }else{
                
            }
        }
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

#pragma mark - 审核
- (void)checkFront
{
//    @weakify(self);
//    [[MOLSwitchManager shareSwitchManager] switch_check:^{
//        @strongify(self);
//        if ([MOLSwitchManager shareSwitchManager].normalStatus) {
//
//        }
//    }];
}
#pragma mark - NIMLoginManagerDelegate
// 自动登录的回调
- (void)onLogin:(NIMLoginStep)step
{
    switch (step) {
        case NIMLoginStepLinkOK:
            NSLog(@"云信连接服务器成功");
            break;
        case NIMLoginStepLinkFailed:
            NSLog(@"云信连接服务器失败");
            break;
        case NIMLoginStepLoginOK:
            NSLog(@"云信自动登录成功");
        {
            // 设置监听
            [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
            [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
            [[NIMSDK sharedSDK].chatManager removeDelegate:self];
            [[NIMSDK sharedSDK].conversationManager addDelegate:self];
            [[NIMSDK sharedSDK].chatManager addDelegate:self];
            [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
            
            
            // 获取云信未读数量
            NSString *key1 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_FOCUS];
            NSString *key2 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_LIKE];
            NSString *key3 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_COMMENT];
            NSString *key4 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_PUBLISH_REWARD_PRODUCTION];
            NSString *key5 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_AT];
            NSInteger count = [[MOLYXManager shareYXManager] yx_getChatSessionUnreadCount];
            NSInteger fans = [[NSUserDefaults standardUserDefaults] integerForKey:key1];
            NSInteger like = [[NSUserDefaults standardUserDefaults] integerForKey:key2];
            NSInteger comment = [[NSUserDefaults standardUserDefaults] integerForKey:key3];
            NSInteger production = [[NSUserDefaults standardUserDefaults] integerForKey:key4];
            NSInteger at = [[NSUserDefaults standardUserDefaults] integerForKey:key5];
            if (count || fans || like || comment || production || at) {
                [self.tabBar showBadgeOnItemIndex:3];
            }
        }
            break;
        case NIMLoginStepLoginFailed:
            NSLog(@"云信自动登录失败");
            break;
        default:
            break;
    }
}

// 账号被T
-(void)onKick:(NIMKickReason)code
   clientType:(NIMLoginClientType)clientType
{
    //被服务器剔除
    if (code == NIMKickReasonByServer) {
        [MBProgressHUD showMessageAMoment:@"您的账号被封了"];
    }else{
        [MBProgressHUD showMessageAMoment:@"您的账号已在其他设备登录"];
    }
    // 退出登录
    [[MOLGlobalManager shareGlobalManager] global_loginOut];
}

// 增加最近会话的回调
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount
{
    // 红点
    UIViewController *vc = [[MOLGlobalManager shareGlobalManager] global_currentViewControl];
    if ([vc isKindOfClass:[MOLMessageViewController class]] ||
        [vc isKindOfClass:[EDChatViewController class]]) {
        return;
    }
    [self.tabBar showBadgeOnItemIndex:3];
}

/**
 *  收到消息回调
 *
 *  @param messages 消息列表,内部为NIMMessage
 */
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages
{
    // 红点
    UIViewController *vc = [[MOLGlobalManager shareGlobalManager] global_currentViewControl];
    if ([vc isKindOfClass:[MOLMessageViewController class]] ||
        [vc isKindOfClass:[EDChatViewController class]]) {
        return;
    }
    [self.tabBar showBadgeOnItemIndex:3];
}

/**
 *  所有消息已读的回调
 */
- (void)allMessagesRead
{
    // 清除红点
}

// 收到自定义通知
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    NSString *key1 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_FOCUS];
    NSString *key2 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_LIKE];
    NSString *key3 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_COMMENT];
    NSString *key4 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_PUBLISH_REWARD_PRODUCTION];
    
    NSString *key5 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_AT];
    
    UIViewController *vc = [[MOLGlobalManager shareGlobalManager] global_currentViewControl];
    if ([vc isKindOfClass:[MOLMessageViewController class]] ||
        [vc isKindOfClass:[EDChatViewController class]]) {
        return;
    }
    [self.tabBar showBadgeOnItemIndex:3];
    
    NSDictionary *dic = [self dictionaryWithJsonString:notification.content];
    NSString *type = [dic mol_jsonString:@"type"];
    
    if ([type isEqualToString:@"FAVOR"]) {  // 喜欢
        NSInteger like = [[NSUserDefaults standardUserDefaults] integerForKey:key2];
        like += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:like forKey:key2];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }else if ([type isEqualToString:@"COMMENT"]){  // 评论
        NSInteger comment = [[NSUserDefaults standardUserDefaults] integerForKey:key3];
        comment += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:comment forKey:key3];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if ([type isEqualToString:@"FRIEND"]){  // 关注
        NSInteger fans = [[NSUserDefaults standardUserDefaults] integerForKey:key1];
        fans += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:fans forKey:key1];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_NOTI_USER_FOCUS object:nil];
        
    }else if ([type isEqualToString:@"PUBLICSTORY"]){  // 悬赏作品
        
        NSInteger production = [[NSUserDefaults standardUserDefaults] integerForKey:key4];
        production += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:production forKey:key4];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if ([type isEqualToString:@"ATUSER"]){  // @
        
        NSInteger at = [[NSUserDefaults standardUserDefaults] integerForKey:key5];
        at += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:at forKey:key5];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    [self.accountViewModel.userInfoCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        MOLUserModel *user = (MOLUserModel *)x;
        if (user.code == MOL_SUCCESS_REQUEST) {
            [MOLUserManagerInstance user_saveUserInfoWithModel:user isLogin:NO];
        }
    }];
}

#pragma mark - 登录成功
- (void)loginSuccess
{
    // 自动登录云信
    [[MOLYXManager shareYXManager] yx_autoLoginYXWithCurrentViewControl:self];
}


#pragma mark - 获取用户资料
- (void)request_getUserInfo
{
    if ([MOLUserManagerInstance user_isLogin]) {
        MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
        NSString *paraId = user.userId;
        [self.accountViewModel.userInfoCommand execute:paraId];
    }
}

#pragma mark - 替换自定义的tabbar
- (void)tab_setCustomTabBar
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"video_release"] forState:UIControlStateNormal];
    _recordButton = btn;
    [btn addTarget:self action:@selector(jumpRecord) forControlEvents:UIControlEventTouchUpInside];
    _recordButton.width = self.tabBar.width / 5;
    _recordButton.height = 49;
    _recordButton.center = CGPointMake(MOL_SCREEN_WIDTH * 0.5, 49 * 0.5);
    [self.tabBar addSubview:btn];
}
#pragma mark - 发布作品悬赏
-(void)initReleaseView{
    self.releaseview = [[MOLSelectReleaseView alloc] initWithCustomH:210.0f showBottom:NO];
    self.releaseview.releaseWorkBlock = ^{
            UIViewController *topVc =  [CommUtls topViewController];
            MOLStartRecordViewController *vc = [[MOLStartRecordViewController alloc] init];
            [topVc.navigationController pushViewController:vc animated:YES];
        
    };
    self.releaseview.releaseRewardBlock = ^{
        if (![MOLUserManagerInstance user_isLogin]) {
            [[MOLGlobalManager shareGlobalManager] global_modalLogin];
            return;
        }
        UIViewController *topVc =  [CommUtls topViewController];
//        MOLPostRewardViewController  *vc = [[MOLPostRewardViewController alloc] init];
         MOLPostRewardVC  *vc = [[MOLPostRewardVC alloc] init];
        [topVc.navigationController pushViewController:vc animated:YES];
    };
}
- (void)jumpRecord
{

    
//    if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
//
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [self.releaseview showInView:window];
//    }else{
//
//        if (![MOLUserManagerInstance user_isLogin]) {
//            [[MOLGlobalManager shareGlobalManager] global_modalLogin];
//            return;
//
    
//}
//        UIViewController *topVc =  [CommUtls topViewController];
//        [MOLReleaseManager manager].rewardID = 0;
//        MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
//        [topVc.navigationController pushViewController:vc animated:YES];
//    }
    
    
   
}

- (void)tab_addSubViewContrller
{
    self.homeViewController = [[MOLHomeViewController alloc] init];
    UIImage *image = [[UIImage imageNamed:@"home_selecte"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage = [[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.homeViewControllerNav = [[MOLBaseNavigationController alloc] initWithRootViewController:self.homeViewController];
    self.homeViewControllerNav.tabBarItem.image = image;
    self.homeViewControllerNav.tabBarItem.selectedImage = selectImage;
    self.homeViewControllerNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    self.discoverViewController = [[MOLDiscoverViewController alloc] init];
    UIImage *image1 = [[UIImage imageNamed:@"discover_selecte"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage1 = [[UIImage imageNamed:@"discover_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.discoverViewControllerNav = [[MOLBaseNavigationController alloc] initWithRootViewController:self.discoverViewController];
    self.discoverViewControllerNav.tabBarItem.image = image1;
    self.discoverViewControllerNav.tabBarItem.selectedImage = selectImage1;
    self.discoverViewControllerNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    self.middleViewControl = [[UIViewController alloc] init];
    
    self.messageViewController = [[MOLMessageViewController alloc] init];
    UIImage *image3 = [[UIImage imageNamed:@"message_selecte"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage3 = [[UIImage imageNamed:@"message_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.messageViewControllerNav = [[MOLBaseNavigationController alloc] initWithRootViewController:self.messageViewController];
    self.messageViewController.tabBarItem.image = image3;
    self.messageViewController.tabBarItem.selectedImage = selectImage3;
    self.messageViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    self.mineViewController = [[MOLMineViewController alloc] init];
    UIImage *image2 = [[UIImage imageNamed:@"mine_selecte"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage2 = [[UIImage imageNamed:@"mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.mineViewControllerNav = [[MOLBaseNavigationController alloc] initWithRootViewController:self.mineViewController];
    self.mineViewControllerNav.tabBarItem.image = image2;
    self.mineViewControllerNav.tabBarItem.selectedImage = selectImage2;
    self.mineViewControllerNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    self.viewControllers = @[
                             self.homeViewControllerNav,
                             self.discoverViewControllerNav,
                             self.middleViewControl,
                             self.messageViewControllerNav,
                             self.mineViewControllerNav,
                             ];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ((tabBarController.selectedIndex != 0 && tabBarController.selectedIndex != 1) && ![MOLUserManagerInstance user_isLogin]) {
        tabBarController.selectedIndex = 0;
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
    }
    
    if (tabBarController.selectedIndex == 3) {
        [self.tabBar hideBadgeOnItemIndex:3];
    }
    
    
    if (tabBarController.selectedIndex == 0 && self.currentIndex == tabBarController.selectedIndex) {
        
        UIView *animationView;
        for (UIView *subView in tabBarController.tabBar.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                animationView = subView;
                for (UIView *subView2 in subView.subviews) {
                    if ([subView2 isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                        self.alpView = subView2;
                        // 动画开始
                           [self refreshImageView_beginWithSuperView:animationView];
                        return;
                    }
                }
            }
            
        }
    }else{
        [self refreshImageView_endRefresh];
    }
    
    self.currentIndex = tabBarController.selectedIndex;
    
}

- (void)refreshImageView_beginWithSuperView:(UIView *)supView
{
    // 通知刷
    [[NSNotificationCenter defaultCenter] postNotificationName:MOL_HOME_REFRESH object:nil];

    self.alpView.alpha = 0;
    if (self.refreshImageView == nil) {
        self.refreshImageView = [[UIButton alloc] init];
        self.refreshImageView.backgroundColor = [UIColor clearColor];
        self.refreshImageView.frame = supView.bounds;
        self.refreshImageView.center = CGPointMake(supView.width * 0.5, supView.height * 0.5);
        [self.refreshImageView setImage:[UIImage imageNamed:@"home_refresh"]forState:UIControlStateNormal];
        [supView addSubview:self.refreshImageView];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat: M_PI *2];
        animation.duration = 1;
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
        [self.refreshImageView.layer addAnimation:animation forKey:nil];
    }
}

- (void)refreshImageView_endRefresh
{
    if (self.alpView) {
        self.alpView.alpha = 1;
    }
    if (self.refreshImageView) {
        [self.refreshImageView.layer removeAllAnimations];
        [self.refreshImageView removeFromSuperview];
        self.refreshImageView = nil;

    }
}
@end
