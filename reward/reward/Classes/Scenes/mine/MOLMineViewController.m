//
//  MOLMineViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMineViewController.h"
#import "MOLUserCenterViewModel.h"
#import "MOLMineHeadView.h"

#import "MOLMyLikeViewController.h"
#import "MOLMyProductionViewController.h"
#import "MOLMyRewarViewController.h"

#import "MOLAccountViewModel.h"
#import "MOLMyEditInfoViewController.h"
#import "MOLMySettingViewController.h"
#import "HomeShareView.h"
#import "MOLLoginRequest.h"

@interface MOLMineViewController ()<HomeShareViewDelegate,JAHorizontalPageViewDelegate, SPPageMenuDelegate>
@property (nonatomic, strong) MOLUserCenterViewModel *mineViewModel;

@property (nonatomic, strong) JAHorizontalPageView *pageView;

@property (nonatomic, strong) MOLMineHeadView *infoHeadView;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, weak) UIButton *settingButton;  // 三个点按钮

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, weak) MOLMyProductionViewController *productionVc;
@property (nonatomic, weak) MOLMyRewarViewController *rewardVc;
@property (nonatomic, weak) MOLMyLikeViewController *likeVc;

@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;

@property (nonatomic, strong) HomeShareView *shareView;//分享
@end

@implementation MOLMineViewController

//- (BOOL)showNavigation
//{
//    if (self.navigationController.childViewControllers.count > 1) {
//        return YES;
//    }else{
//        return NO;
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithImageName:@"mine_other_point" highlightImageName:@"mine_other_point" targat:self action:@selector(button_clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    
    self.mineViewModel = [[MOLUserCenterViewModel alloc] init];
    [self setupMineViewControllerUI];
//    [self bindingViewModel];
    
    [self.pageView reloadPage];
    
//    if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
        [self.pageMenu setItems:@[@"作品0",@"悬赏0",@"喜欢0"] selectedItemIndex:0];
//    }else{
//        [self.pageMenu setItems:@[@"作品0",@"喜欢0"] selectedItemIndex:0];
//    }
    
    self.pageMenu.bridgeScrollView = (UIScrollView *)_pageView.horizontalCollectionView;
    
    [self request_userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:MOL_SUCCESS_USER_CHANGEINFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoWithData) name:MOL_SUCCESS_USER_LOGIN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserProduction) name:MOL_SUCCESS_PUBLISH_PRODUCTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserReward) name:MOL_SUCCESS_PUBLISH_REWARD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserLike) name:MOL_SUCCESS_USER_LIKE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserLike_cancle) name:MOL_SUCCESS_USER_LIKE_cancle object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request_getUserInfo];
   
}

- (void)getUserProduction
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    user.storyCount = user.storyCount + 1;
    [MOLUserManagerInstance user_saveUserInfoWithModel:user isLogin:NO];
}

- (void)getUserReward
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    user.rewardCount = user.rewardCount + 1;
    [MOLUserManagerInstance user_saveUserInfoWithModel:user isLogin:NO];
}

- (void)getUserLike
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    user.favorCount = user.favorCount + 1;
    [MOLUserManagerInstance user_saveUserInfoWithModel:user isLogin:NO];
}
- (void)getUserLike_cancle
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    user.favorCount = user.favorCount - 1;
    [MOLUserManagerInstance user_saveUserInfoWithModel:user isLogin:NO];
}

- (void)getUserInfo
{
    [self request_userInfo:nil];
}

- (void)getUserInfoWithData
{
    @weakify(self);
    [self request_userInfo:^{
        @strongify(self);
        MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
        self.productionVc.userId = user.userId;
        self.rewardVc.userId = user.userId;
        self.likeVc.userId = user.userId;
        [self.productionVc getUserProduction];
        [self.rewardVc getUserReward];
        [self.likeVc getUserLike];
    }];
}

-(void)button_clickRightItem{
    NSArray *titleButtons = @[@"分享主页",@"编辑资料",@"设置"];
    @weakify(self);
    LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:-1 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
        @strongify(self);
        if (buttonIndex >= titleButtons.count) {
            return;
        }
        NSString *title = titleButtons[buttonIndex];
        
        if ([title isEqualToString:@"分享主页"]) {
            // 分享
             [self.view addSubview:self.shareView];
            
        }else if ([title isEqualToString:@"编辑资料"]) {
            // 编辑个人资料
            MOLMyEditInfoViewController *vc = [[MOLMyEditInfoViewController alloc] init];
            vc.userModel = [MOLUserManagerInstance user_getUserInfo];
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            
        }else if ([title isEqualToString:@"设置"]){
            // 设置
            MOLMySettingViewController *vc = [[MOLMySettingViewController alloc] init];
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }
    }];
    [actionS show];
}
#pragma mark - 网络请求
- (void)request_userInfo:(void(^)(void))refreshData
{
    MOLUserModel *model = [MOLUserManagerInstance user_getUserInfo];
    
    //计算名字的高度
    CGFloat nameH = [model.userName mol_getTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 36 font:MOL_MEDIUM_FONT(22)];
    
    self.infoHeadView.height = 340 + nameH + [model.signInfo mol_getTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 36 font:MOL_LIGHT_FONT(12)];
    self.infoHeadView.userModel = model;
    [self.infoHeadView layout];
    self.pageMenu.y = self.infoHeadView.bottom;
    self.headView.height = (self.infoHeadView.height) + (self.pageMenu.height) + 1;
    self.backImageView.frame = self.headView.bounds;
    self.backView.frame = self.backImageView.bounds;
    self.lineView.y = self.headView.height - 1;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    NSInteger index = self.pageMenu.selectedItemIndex;
    [self.pageMenu removeAllItems];
    
//    if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
        NSString *name1 = [NSString stringWithFormat:@"作品%ld",model.storyCount];
        NSString *name2 = [NSString stringWithFormat:@"悬赏%ld",model.rewardCount];
        NSString *name3 = [NSString stringWithFormat:@"喜欢%ld",model.favorCount > 0 ? model.favorCount : 0];
        [self.pageMenu setItems:@[name1,name2,name3] selectedItemIndex:index];
//    }else{
//        NSString *name1 = [NSString stringWithFormat:@"作品%ld",model.storyCount];
//
//        NSString *name3 = [NSString stringWithFormat:@"喜欢%ld",model.favorCount > 0 ? model.favorCount : 0];
//        [self.pageMenu setItems:@[name1,name3] selectedItemIndex:index];
//    }

    [self.pageView reloadPage];
    self.infoHeadView.alpha = 1;
    
    if (refreshData) {
        refreshData();
    }
}

#pragma mark - 获取用户资料
- (void)request_getUserInfo
{
    if ([MOLUserManagerInstance user_isLogin]) {
        MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
        NSString *paraId = user.userId;
//        [self.accountViewModel.userInfoCommand execute:paraId];
        [self getUserDataWithUserID:paraId];
    }
}

-(void)getUserDataWithUserID:(NSString *)userID{
    MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_getUserInfoWithParameter:nil parameterId:userID];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        MOLUserModel *model = (MOLUserModel *)responseModel;
        if (model.code == MOL_SUCCESS_REQUEST) {
            [MOLUserManagerInstance user_saveUserInfoWithModel:model isLogin:NO];
            CGFloat nameH = [model.userName mol_getTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 36 font:MOL_MEDIUM_FONT(22)];
            self.infoHeadView.height = 340 + nameH + [model.signInfo mol_getTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 36 font:MOL_LIGHT_FONT(12)];
            self.infoHeadView.userModel = model;
            [self.infoHeadView layout];
            self.pageMenu.y = self.infoHeadView.bottom;
            self.headView.height = (self.infoHeadView.height) + (self.pageMenu.height) + 1;
            self.backImageView.frame = self.headView.bounds;
            self.backView.frame = self.backImageView.bounds;
            self.lineView.y = self.headView.height - 1;
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        
    }];
}

//#pragma mark - bindingViewModel
//- (void)bindingViewModel
//{
//    [self.accountViewModel.userInfoCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
//        MOLUserModel *model = (MOLUserModel *)x;
//        if (model.code == MOL_SUCCESS_REQUEST) {
////            [MOLUserManagerInstance user_saveUserInfoWithModel:user isLogin:NO];
//
////            MOLUserModel *model = [MOLUserManagerInstance user_getUserInfo];
//            CGFloat nameH = [model.userName mol_getTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 36 font:MOL_MEDIUM_FONT(22)];
//            self.infoHeadView.height = 350 + nameH + [model.signInfo mol_getTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 36 font:MOL_LIGHT_FONT(12)];
//            self.infoHeadView.userModel = model;
//            [self.infoHeadView layout];
//            self.pageMenu.y = self.infoHeadView.bottom;
//            self.headView.height = (self.infoHeadView.height) + (self.pageMenu.height) + 1;
//            self.backImageView.frame = self.headView.bounds;
//            self.backView.frame = self.backImageView.bounds;
//            self.lineView.y = self.headView.height - 1;
//            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
//        }
//    }];
//}


#pragma mark - delegate
- (NSInteger)numberOfSectionPageView:(JAHorizontalPageView *)view   // 返回几个控制器
{
//    if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
        return 3;
//    }else{
//        return 2;
//    }
    
}
- (UIScrollView *)horizontalPageView:(JAHorizontalPageView *)pageView viewAtIndex:(NSInteger)index   // 返回每个控制器的view
{
    MOLUserModel *model = [MOLUserManagerInstance user_getUserInfo];
    
//    if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
        if (index == 0) {
            MOLMyProductionViewController *vc = [[MOLMyProductionViewController alloc] init];
            _productionVc = vc;
            vc.showNav = self.showNavigation;
            vc.userId = model.userId;
            vc.view.backgroundColor = [UIColor clearColor];
            [self addChildViewController:vc];
            return (UIScrollView *)vc.collectionView;
        }else if (index == 1){
            MOLMyRewarViewController *vc = [[MOLMyRewarViewController alloc] init];
            _rewardVc = vc;
            vc.showNav = self.showNavigation;
            vc.userId = model.userId;
            vc.isOwner = YES;
            vc.view.backgroundColor = [UIColor clearColor];
            [self addChildViewController:vc];
            return (UIScrollView *)vc.tableView;
        }else{
            MOLMyLikeViewController *vc = [[MOLMyLikeViewController alloc] init];
            _likeVc = vc;
            vc.showNav = self.showNavigation;
            vc.userId = model.userId;
            vc.view.backgroundColor = [UIColor clearColor];
            [self addChildViewController:vc];
            return (UIScrollView *)vc.collectionView;
        }
//    }else{
//        if (index == 0) {
//            MOLMyProductionViewController *vc = [[MOLMyProductionViewController alloc] init];
//            _productionVc = vc;
//            vc.showNav = self.showNavigation;
//            vc.userId = model.userId;
//            vc.view.backgroundColor = [UIColor clearColor];
//            [self addChildViewController:vc];
//            return (UIScrollView *)vc.collectionView;
//        }else{
//            MOLMyLikeViewController *vc = [[MOLMyLikeViewController alloc] init];
//            _likeVc = vc;
//            vc.showNav = self.showNavigation;
//            vc.userId = model.userId;
//            vc.view.backgroundColor = [UIColor clearColor];
//            [self addChildViewController:vc];
//            return (UIScrollView *)vc.collectionView;
//        }
//    }
    
    
}

- (UIView *)headerViewInPageView:(JAHorizontalPageView *)pageView     // 返回头部
{
    return self.headView;
}

- (CGFloat)headerHeightInPageView:(JAHorizontalPageView *)pageView    // 返回头部高度
{
    return self.headView.height;
}

- (CGFloat)topHeightInPageView:(JAHorizontalPageView *)pageView   // 控制在什么地方悬停
{
    return 43 + MOL_StatusBarAndNavigationBarHeight;
}

- (void)horizontalPageView:(JAHorizontalPageView *)pageView scrollTopOffset:(CGFloat)offset   // 滚动的偏移量
{
    if (offset < 0) {
        self.backImageView.y = offset;
        self.backImageView.height = self.headView.height - offset;
    }else{
        self.backImageView.y = 0;
        self.backImageView.height = self.headView.height;
    }
    self.backView.frame = self.backImageView.bounds;
    self.infoHeadView.alpha = 1 - offset/ (self.headView.height - (43 + MOL_StatusBarAndNavigationBarHeight));
    
//    self.nameLabel.alpha = offset / (self.headView.height - (43 + MOL_StatusBarAndNavigationBarHeight));
    
    if (self.infoHeadView.alpha<=0.3) {
        self.nameLabel.alpha = 1;
    }else{
         self.nameLabel.alpha = 0;
    }
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [_pageView scrollToIndex:toIndex];
}

#pragma mark - UI
- (void)setupMineViewControllerUI
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    _pageView = [[JAHorizontalPageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) delegate:self];
    _pageView.horizontalCollectionView.scrollEnabled = NO;
    _pageView.needHeadGestures = YES;
    [self.view addSubview:_pageView];
}

- (void)calculatorMineViewControllerFrame{}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorMineViewControllerFrame];
}

#pragma mark - 懒加载
- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        MOLUserModel *model = [MOLUserManagerInstance user_getUserInfo];
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
        nameLabel.text = model.userName;
        nameLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 1);
        nameLabel.font = MOL_MEDIUM_FONT(17);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.width = 200;
        nameLabel.height = 17;
        nameLabel.y = MOL_StatusBarHeight + 13;
        nameLabel.centerX = self.view.width * 0.5;
        [self.view addSubview:nameLabel];
    }
    return _nameLabel;
}
-(UIButton *)settingButton{
    if (!_settingButton) {
            UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _settingButton = settingButton;
            settingButton.hidden = YES;
            [settingButton setImage:[UIImage imageNamed:@"mine_setting_up"] forState:UIControlStateNormal];
            [settingButton addTarget:self action:@selector(button_clickSetting) forControlEvents:UIControlEventTouchUpInside];

        settingButton.width = 30;
        settingButton.height = 30;
        settingButton.y =  MOL_StatusBarHeight + 13;
        settingButton.x = self.view.width - 30 - 13;
    }
    return _settingButton;
}



- (UIView *)headView
{
    if (_headView == nil) {
        
        _headView = [[UIView alloc] init];
        
        UIImageView *backImageView = [[UIImageView alloc] init];
        _backImageView = backImageView;
        _backImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
        [_headView addSubview:backImageView];
        
//        UIView *backView = [[UIView alloc] init];
//        _backView = backView;
//        backView.backgroundColor = HEX_COLOR_ALPHA(0x0F101C, 0.9);
//        [_backImageView addSubview:backView];
        
//        UIToolbar *toolbar = [[UIToolbar alloc] init];
//        _backView = toolbar;
//        toolbar.barStyle = UIBarStyleBlackOpaque;
//        [backImageView addSubview:toolbar];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _backView = effectView;
        [backImageView addSubview:effectView];
        
        _infoHeadView = [[MOLMineHeadView alloc] init];
        _infoHeadView.width = MOL_SCREEN_WIDTH;
        _infoHeadView.height = 490;
        [_headView addSubview:_infoHeadView];
        
        SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, _infoHeadView.bottom, MOL_SCREEN_WIDTH, 43) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu = pageMenu;
        _pageMenu.backgroundColor = [UIColor clearColor];//HEX_COLOR(0x0E0F1A);
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.itemTitleFont = MOL_MEDIUM_FONT(16);
        _pageMenu.selectedItemTitleColor = HEX_COLOR(0xffffff);
        _pageMenu.unSelectedItemTitleColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
        [_pageMenu setTrackerHeight:3 cornerRadius:0];
        _pageMenu.tracker.backgroundColor = HEX_COLOR(0xFFEC00);
        _pageMenu.needTextColorGradients = NO;
        _pageMenu.dividingLine.hidden = YES;
        _pageMenu.itemPadding = 20;
        _pageMenu.delegate = self;
        [_headView addSubview:_pageMenu];
        
        _headView.width = MOL_SCREEN_WIDTH;
        _headView.height =(_infoHeadView.height) + (_pageMenu.height) + 1;
        
        _backImageView.frame = _headView.bounds;
        _backView.frame = _backImageView.bounds;
        
        UIView *line = [[UIView alloc] init];
        _lineView = line;
        line.backgroundColor = HEX_COLOR_ALPHA(0x0F101C, 0.9);
        line.width = MOL_SCREEN_WIDTH;
        line.height = 1;
        line.y = _headView.height - 1;
        [_headView addSubview:line];
    }
    
    return _headView;
}



#pragma mark -
#pragma mark HomeShareViewDelegate
- (void)homeShareView:(MOLVideoOutsideModel *)model businessType:(HomeShareViewBusinessType)businessType type:(HomeShareViewType)shareType;{
    self.shareView =nil;
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
    }
    
}

#pragma mark-
#pragma mark 分享实现
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  self.infoHeadView.userModel.shareMsgVO.shareImg?self.infoHeadView.userModel.shareMsgVO.shareImg:@"";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.infoHeadView.userModel.shareMsgVO.shareTitle?self.infoHeadView.userModel.shareMsgVO.shareTitle:@"" descr:self.infoHeadView.userModel.shareMsgVO.shareContent?self.infoHeadView.userModel.shareMsgVO.shareContent:@"" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.infoHeadView.userModel.shareMsgVO.shareUrl?self.infoHeadView.userModel.shareMsgVO.shareUrl:@"";
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

        }
    }];
}
- (HomeShareView *)shareView{
    if (!_shareView) {
        _shareView =[HomeShareView new];
        [_shareView setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
        _shareView.currentBusinessType = HomeShareViewBusinessRewardType;
        [_shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo"]];
        _shareView.delegate =self;
    }
    return _shareView;
}
@end
