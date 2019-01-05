//
//  MOLMineHeadView.m
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMineHeadView.h"
#import "MOLMySettingViewController.h"
#import "MOLMyEditInfoViewController.h"
#import "MOLInviteAttendRewardViewController.h"

#import "MOLWalletViewController.h"
#import "EDChatViewController.h"
#import "MOLUserRelationViewController.h"

#import "MOLWebViewController.h"

#import "MOLActionRequest.h"
#import "MOLHostHead.h"

#import "MOLVideoAuthenticationVC.h"//视频认证
#import "MOLIdentityAuthentionVC.h"//身份认证
#import "MOLVideoAuthPlayVC.h"

@interface MOLMineHeadView ()
@property (nonatomic, weak) UIView *iconView; // 头像边框
@property (nonatomic, weak) UIImageView *iconImageView;  // 头像

@property (nonatomic, weak) UIButton *authVideoPlay;//认证视频播放
@property (nonatomic, weak) UILabel *nameLabel;  // 名字
@property (nonatomic, weak) UILabel *idLabel;  // id

@property (nonatomic, weak) UIView *authenticationView;//认证View
@property (nonatomic, weak) UIButton *videoAuthenticationBtn;  // 视频认证
@property (nonatomic, weak) UIButton *identityAuthenticationBtn;  //身份认证
@property (nonatomic, weak) UIButton *tagBtn1;
@property (nonatomic, weak) UIButton *tagBtn2;

// mine
@property (nonatomic, weak) UIButton *moneyButton;  // 钱包按钮
@property (nonatomic, weak) UIButton *inviteButton;  // 邀请按钮 h5
//@property (nonatomic, weak) UIButton *settingButton;  // 三个点按钮

// other
@property (nonatomic, weak) UIButton *messageButton;  // 发送消息
@property (nonatomic, weak) UIButton *focusButton;  // 关注 - 取关
@property (nonatomic, weak) UIButton *inviteRewardButton;  // 邀请拍摄悬赏

@property (nonatomic, weak) UIView *lineView;  // 分割线

@property (nonatomic, weak) UILabel *introduceLabel;  // 介绍
@property (nonatomic, weak) UIView *infoView;  // 用户资料view

@property (nonatomic, weak) UILabel *likeLabel;  // 获赞
@property (nonatomic, weak) UILabel *focusLabel;  // 关注
@property (nonatomic, weak) UILabel *fansLabel;  // 粉丝
@end

static CGFloat myleftMargin = 18;

@implementation MOLMineHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMineHeadViewUI];
    }
    return self;
}

#pragma mark - 按钮的点击
- (void)button_clickIcon  // 点击头像
{
    // 获取是不是自己
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    if ([user.userId isEqualToString:self.userModel.userId]) {
        // 编辑个人资料
        MOLMyEditInfoViewController *vc = [[MOLMyEditInfoViewController alloc] init];
        vc.userModel = self.userModel;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        
        if (!self.userModel.avatar.length) {
            return;
        }
        HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
        browser.isNeedLandscape = NO;
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:self.userModel.avatar];
        browser.imageArray = arr;
        [browser show];
    }
}

- (void)button_clickWallet    // 钱包
{
    MOLWalletViewController *vc = [[MOLWalletViewController alloc] init];
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clickinviteButton  // 我的邀请
{
    MOLWebViewController *vc = [[MOLWebViewController alloc] init];
    NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
    offic = MOL_TEST_SERVICE;  // 测试
#endif
    vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/invite/invite.html",offic];
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}
//视频认证
-(void)button_clickvideoAuthenticationBtn{
    if (![self.userModel.userId isEqualToString:[MOLUserManagerInstance user_getUserId]]) {
        //非自己
        
        if (self.userModel.authInfoVO.audioAuth == 2) {
            MOLVideoAuthPlayVC *vc = [[MOLVideoAuthPlayVC alloc] init];
            vc.authInfoModel = self.userModel.authInfoVO;
            vc.isSelf = NO;
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }
        return;
    }
    
    
    //自己
    if (self.userModel.phone.length > 10) {
        //如是审核中或者审核通过
        if (self.userModel.authInfoVO.audioAuth == 2 || self.userModel.authInfoVO.audioAuth == 1 ) {
            MOLVideoAuthPlayVC *vc = [[MOLVideoAuthPlayVC alloc] init];
            vc.authInfoModel = self.userModel.authInfoVO;
            vc.isSelf = YES;
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }else{
            MOLVideoAuthenticationVC *vc = [[MOLVideoAuthenticationVC alloc] init];
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }
        
    }else{
        //提示绑定手机号
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"为保护账号安全，请先绑定手机号" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancenAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            MJWeakSelf
            UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"绑定手机号" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                 [[MOLGlobalManager shareGlobalManager] global_modalBindingPhoneWithAnimate:YES];
            }];
            
            [cancenAc setValue:HEX_COLOR_ALPHA(0x221E1E, 0.6) forKey:@"titleTextColor"];
            [sureAc setValue:HEX_COLOR(0xFE6257) forKey:@"titleTextColor"];
            [alert addAction:cancenAc];
            [alert addAction:sureAc];
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl]  presentViewController:alert animated:YES completion:nil];
    }
}
//身份认证
-(void)button_clickidentityAuthenticationBtn{
    
   if (![self.userModel.userId isEqualToString:[MOLUserManagerInstance user_getUserId]]) {
        return;
    }
    
    if (self.userModel.authInfoVO.realAuth == 1 || self.userModel.authInfoVO.realAuth == 2) {
        MOLIdentityAuthentionVC *vc = [[MOLIdentityAuthentionVC alloc] initWithNibName:@"MOLIdentityAuthentionVC" bundle:nil];
        vc.autnInfoModel = self.userModel.authInfoVO;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        return;
    }
    
    
    if (self.userModel.authInfoVO.audioAuth == 2) {
        MOLIdentityAuthentionVC *vc = [[MOLIdentityAuthentionVC alloc] initWithNibName:@"MOLIdentityAuthentionVC" bundle:nil];
        vc.autnInfoModel = self.userModel.authInfoVO;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        //提示视频认证
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"身份认证前，请先进行视频认证" message:nil preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancenAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        MJWeakSelf
        UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"视频认证" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf button_clickvideoAuthenticationBtn];
        }];

        [cancenAc setValue:HEX_COLOR_ALPHA(0x221E1E, 0.6) forKey:@"titleTextColor"];
        [sureAc setValue:HEX_COLOR(0xFE6257) forKey:@"titleTextColor"];
        [alert addAction:cancenAc];
        [alert addAction:sureAc];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl]  presentViewController:alert animated:YES completion:nil];

    }
}
- (void)button_clickSetting  // 我的设置
{
    NSArray *titleButtons = @[@"编辑资料",@"设置"];
    @weakify(self);
    LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:-1 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
        @strongify(self);
        if (buttonIndex >= titleButtons.count) {
            return;
        }
        NSString *title = titleButtons[buttonIndex];
        if ([title isEqualToString:@"编辑资料"]) {
            // 编辑个人资料
            MOLMyEditInfoViewController *vc = [[MOLMyEditInfoViewController alloc] init];
            vc.userModel = self.userModel;
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            
        }else if ([title isEqualToString:@"设置"]){
            // 设置
            MOLMySettingViewController *vc = [[MOLMySettingViewController alloc] init];
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }
    }];
    [actionS show];
}

- (void)button_clickMessageButton   // other - 发送消息
{
    EDChatViewController *vc = [[EDChatViewController alloc] init];
    vc.session = [[MOLYXManager shareYXManager] yx_creatChatSessionWithUserId:self.userModel.userId];
    vc.userModel = self.userModel;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clickfocusButton   // other - 关注 - 取关
{
    if (![MOLUserManagerInstance user_isLogin]) {
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    if ([self.userModel.userId isEqualToString:[MOLUserManagerInstance user_getUserId]]) {
        [MBProgressHUD showMessageAMoment:@"不能关注自己"];
        return;
    }
    
    self.focusButton.userInteractionEnabled = NO;
    // 关注接口
    MOLActionRequest *r = [[MOLActionRequest alloc] initRequest_focusActionWithParameter:nil parameterId:self.userModel.userId];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
       self.focusButton.userInteractionEnabled = YES;
        
        if (code != MOL_SUCCESS_REQUEST) {
            [MBProgressHUD showMessageAMoment:message];
        }else{
            if (self.userModel.isFriend != 0) {  // 取消关注
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:self.userModel.userId];
                [arr addObject:@(NO)];
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_FOCUS object:arr];
                self.userModel.isFriend = 0;
                self.focusButton.selected = NO;
                self.messageButton.hidden = YES;
                self.userModel.fansCount -= 1;
                self.fansLabel.attributedText = [self attributedString:[NSString stringWithFormat:@"%ld 粉丝",self.userModel.fansCount] word:@"粉丝"];
            }else{
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:self.userModel.userId];
                [arr addObject:@(YES)];
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_FOCUS object:arr];
                self.userModel.isFriend = 1;  //  关注
                self.focusButton.selected = YES;
                self.messageButton.hidden = NO;
                self.userModel.fansCount += 1;
                self.fansLabel.attributedText = [self attributedString:[NSString stringWithFormat:@"%ld 粉丝",self.userModel.fansCount] word:@"粉丝"];
            }
            
            [self layout];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        self.focusButton.userInteractionEnabled = YES;
    }];
}

- (void)button_clickinviteRewardButton  // other - 邀请拍摄悬赏视频
{
    MOLInviteAttendRewardViewController *vc = [[MOLInviteAttendRewardViewController alloc] init];
    vc.userId = self.userModel.userId;
    MOLBaseNavigationController *nav = [[MOLBaseNavigationController alloc] initWithRootViewController:vc];
    [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] presentViewController:nav animated:YES completion:nil];
}

- (void)button_clickLikeLabel  // 获赞
{
    
}

- (void)button_clickFocusLabel  // 关注
{
    MOLUserRelationViewController *vc = [[MOLUserRelationViewController alloc] init];
    vc.userId = self.userModel.userId;
    vc.relationType = MOLUserRelationType_focus;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clickFansLabel  // 粉丝
{
    MOLUserRelationViewController *vc = [[MOLUserRelationViewController alloc] init];
    vc.userId = self.userModel.userId;
    vc.relationType = MOLUserRelationType_fans;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}
#pragma mark - 数据
- (void)setUserModel:(MOLUserModel *)userModel
{
    _userModel = userModel;
    // 根据信息创建按钮
    NSMutableArray *infoArr = [NSMutableArray array];
    if (userModel.city.length) {
        [infoArr addObject:userModel.city];
    }
    if (userModel.gender > 0) {
        [infoArr addObject:userModel.gender == 1 ? @"男" : @"女"];
    }
    if (userModel.age.length) {
        [infoArr addObject:userModel.age];
    }
    if (userModel.constellation.length) {
        [infoArr addObject:userModel.constellation];
    }
    if (!infoArr.count) {
        [infoArr addObject:@"男"];
    }
    [self.infoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat frontW = 0;
    
    for (NSInteger i = 0; i < infoArr.count; i++) {
        
        NSString *t = infoArr[i];
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [infoButton sizeToFit];
        infoButton.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.1);
        infoButton.width += 18;
        infoButton.height = 18;
        infoButton.x = frontW + i * 5;
        frontW = frontW + infoButton.width;
        [infoButton setTitle:t forState:UIControlStateNormal];
        [infoButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
        infoButton.titleLabel.font = MOL_REGULAR_FONT(11);
        infoButton.layer.cornerRadius = infoButton.height * 0.5;
        infoButton.clipsToBounds = YES;
        [self.infoView addSubview:infoButton];
    }
    
    self.introduceLabel.text = userModel.signInfo.length ? userModel.signInfo : @"这家伙很懒，什么都没有留下";
    
    self.nameLabel.text = userModel.userName.length ? userModel.userName : @"加载中...";
    self.idLabel.text = userModel.userUuid.length ? [NSString stringWithFormat:@"ID:%@",userModel.userUuid] : @"ID:000000";
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar]];
    
    // 获取是不是自己
    //如果是自己
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    if ([user.userId isEqualToString:self.userModel.userId]) {
//        if ([MOLSwitchManager shareSwitchManager].normalStatus == 1) {
            self.moneyButton.hidden = NO;
            self.inviteButton.hidden = NO;
//        }else{
//            self.moneyButton.hidden = YES;
//            self.inviteButton.hidden = YES;
//        }
        
//        self.settingButton.hidden = NO;
        
        self.messageButton.hidden = YES;
        self.focusButton.hidden = YES;
        self.inviteRewardButton.hidden = YES;
        
        
        
           //自己的认证显示判断
        self.identityAuthenticationBtn.hidden = NO;
       
        if (userModel.authInfoVO.audioAuth == 1) {
            [_videoAuthenticationBtn setTitle:@" 视频认证中" forState:UIControlStateNormal];
            self.authVideoPlay.hidden = NO;//认证中头像显示认证标识
        }
        //视频认证
        if (userModel.authInfoVO.audioAuth == 2) {
            self.authVideoPlay.hidden = NO;//已经认证显示认证标识
            _videoAuthenticationBtn.selected = YES;
        }else{
            _videoAuthenticationBtn.selected = NO;
        }
        
        //身份认证
        if (userModel.authInfoVO.realAuth == 1) {
            [_identityAuthenticationBtn setTitle:@"身份认证中" forState:UIControlStateNormal];
        }else if(userModel.authInfoVO.realAuth == 2){
            _identityAuthenticationBtn.selected  = YES;
        }else{
             _identityAuthenticationBtn.selected  = NO;
        }
        
    }else{
        //他人
     
        self.focusButton.selected = userModel.isFriend;
        self.moneyButton.hidden = YES;
        self.inviteButton.hidden = YES;
        self.messageButton.hidden = !self.focusButton.selected;  // 查看是否已经关注
        self.focusButton.hidden = NO;
        self.inviteRewardButton.hidden = YES;
        
        
//        他人的认证显示判断
        _tagBtn2.hidden = YES;
        _tagBtn1.hidden = YES;
        
        //他人的认证显示判断
            if (userModel.authInfoVO.audioAuth == 2) {
                self.authVideoPlay.hidden = NO;//如果已经认证显示认证标识
                _videoAuthenticationBtn.selected = YES;
            }else{
                _videoAuthenticationBtn.selected = NO;
            }
        
            if (userModel.authInfoVO.realAuth == 2) {
                _identityAuthenticationBtn.selected  = YES;
                _identityAuthenticationBtn.hidden = NO;
            }

    }
    
    self.likeLabel.attributedText = [self attributedString:[NSString stringWithFormat:@"%ld 获赞",userModel.beFavorCount] word:@"获赞"];
    self.focusLabel.attributedText = [self attributedString:[NSString stringWithFormat:@"%ld 关注",userModel.attentionCount] word:@"关注"];
    self.fansLabel.attributedText = [self attributedString:[NSString stringWithFormat:@"%ld 粉丝",userModel.fansCount] word:@"粉丝"];
    

}

#pragma mark - UI
- (void)setupMineHeadViewUI
{
    UIView *iconView = [[UIView alloc] init];
    _iconView = iconView;
    iconView.backgroundColor = HEX_COLOR(0xffffff);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button_clickIcon)];
    [iconView addGestureRecognizer:tap];
    [self addSubview:iconView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [iconView addSubview:iconImageView];
    
    UIButton * authVideoPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    _authVideoPlay = authVideoPlay;
    [authVideoPlay setImage:[UIImage imageNamed:@"au_paly"] forState:UIControlStateNormal];
    [authVideoPlay addTarget:self action:@selector(button_clickvideoAuthenticationBtn) forControlEvents:UIControlEventTouchUpInside];
    authVideoPlay.hidden = YES;
    [iconView addSubview:authVideoPlay];
    
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @"加载中...";
    nameLabel.textColor = HEX_COLOR(0xffffff);
    nameLabel.font = MOL_MEDIUM_FONT(22);
    nameLabel.numberOfLines = 0;
    [self addSubview:nameLabel];
    
    //ID
    UILabel *idLabel = [[UILabel alloc] init];
    _idLabel = idLabel;
    idLabel.text = @"ID:000000";
    idLabel.textColor = HEX_COLOR(0xffffff);
    idLabel.font = MOL_MEDIUM_FONT(12);
    [self addSubview:idLabel];
    
    //认证
    UIView  *authenticationView =[[UIView alloc] init];
    _authenticationView = authenticationView;

    [self addSubview:authenticationView];
    
    //视频认证
    UIButton *videoAuthenticationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _videoAuthenticationBtn = videoAuthenticationBtn;
//    _videoAuthenticationBtn.backgroundColor = [UIColor redColor];
    [_videoAuthenticationBtn setTitle:@" 视频未认证" forState:UIControlStateNormal];
    [_videoAuthenticationBtn setTitle:@" 视频已认证" forState:UIControlStateSelected];
    [_videoAuthenticationBtn setTitleColor:HEX_COLOR_ALPHA(0xFFFFFF, 0.8) forState:UIControlStateNormal];
    
      [_videoAuthenticationBtn setImage:[UIImage imageNamed:@"iconshipin"] forState:UIControlStateNormal];
      [_videoAuthenticationBtn setImage:[UIImage imageNamed:@"iconshipin1"] forState:UIControlStateSelected];
    
    [_videoAuthenticationBtn addTarget:self action:@selector(button_clickvideoAuthenticationBtn) forControlEvents:UIControlEventTouchUpInside];
    _videoAuthenticationBtn.titleLabel.font = MOL_LIGHT_FONT(12);
    _videoAuthenticationBtn.width = 85;
    _videoAuthenticationBtn.height = 20;
    _videoAuthenticationBtn.x = 0;
    _videoAuthenticationBtn.y = 0;
    [_authenticationView addSubview:_videoAuthenticationBtn];
    
    UIButton *tagBtn1 =  [UIButton buttonWithType:UIButtonTypeCustom];
    _tagBtn1 = tagBtn1;
    [tagBtn1 setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    tagBtn1.x = _videoAuthenticationBtn.right;
    tagBtn1.y = 0;
    tagBtn1.width = 10;
    tagBtn1.height = _videoAuthenticationBtn.height;
    [_authenticationView addSubview:tagBtn1];
    
    
    
    //身份认证
    UIButton *identityAuthenticationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _identityAuthenticationBtn = identityAuthenticationBtn;
//      _identityAuthenticationBtn.backgroundColor = [UIColor redColor];
    [_identityAuthenticationBtn setTitle:@" 身份未认证" forState:UIControlStateNormal];
    [_identityAuthenticationBtn setTitle:@" 身份已认证" forState:UIControlStateSelected];
    [_identityAuthenticationBtn setTitleColor:HEX_COLOR_ALPHA(0xFFFFFF, 0.8) forState:UIControlStateNormal];
     [_identityAuthenticationBtn setImage:[UIImage imageNamed:@"Rectangle"] forState:UIControlStateNormal];
    [_identityAuthenticationBtn setImage:[UIImage imageNamed:@"Rectangle1"] forState:UIControlStateSelected];
    [_identityAuthenticationBtn addTarget:self action:@selector(button_clickidentityAuthenticationBtn) forControlEvents:UIControlEventTouchUpInside];
    _identityAuthenticationBtn.titleLabel.font = MOL_LIGHT_FONT(12);
    _identityAuthenticationBtn.width = 85;
    _identityAuthenticationBtn.height = 20;
    _identityAuthenticationBtn.x = 100;
    _identityAuthenticationBtn.y = 0;
    _identityAuthenticationBtn.hidden = YES;
    [_authenticationView addSubview:_identityAuthenticationBtn];
    
    UIButton *tagBtn2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    _tagBtn2 = tagBtn2;
    [tagBtn2 setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    tagBtn2.x = _identityAuthenticationBtn.right;
    tagBtn2.y = 0;
    tagBtn2.width = 10;
    tagBtn2.height = _identityAuthenticationBtn.height;
    [_authenticationView addSubview:tagBtn2];
    
    

    
    // mine
    UIButton *moneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moneyButton = moneyButton;
    moneyButton.hidden = YES;
    [moneyButton setImage:[UIImage imageNamed:@"mine_the_wallet"] forState:UIControlStateNormal];
    [moneyButton addTarget:self action:@selector(button_clickWallet) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moneyButton];
    
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _inviteButton = inviteButton;
    inviteButton.hidden = YES;
//    [inviteButton setImage:[UIImage imageNamed:@"mine_the_invitation"] forState:UIControlStateNormal];
    [inviteButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    inviteButton.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.2);
    inviteButton.layer.cornerRadius = 4;
    inviteButton.titleLabel.font = MOL_MEDIUM_FONT(14);
    [inviteButton setTitleColor:HEX_COLOR_ALPHA(0xFFFFFF, 0.6) forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(button_clickinviteButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:inviteButton];
//
//    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _settingButton = settingButton;
//    settingButton.hidden = YES;
//    [settingButton setImage:[UIImage imageNamed:@"mine_setting_up"] forState:UIControlStateNormal];
//    [settingButton addTarget:self action:@selector(button_clickSetting) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:settingButton];
    
    // other
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageButton = messageButton;
    [messageButton setImage:[UIImage imageNamed:@"mine_direct_messages"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(button_clickMessageButton) forControlEvents:UIControlEventTouchUpInside];
    messageButton.hidden = YES;
    [self addSubview:messageButton];
    
    UIButton *focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _focusButton = focusButton;
    focusButton.hidden = YES;
    [focusButton setImage:[UIImage imageNamed:@"mine_focus_on"] forState:UIControlStateNormal];
    [focusButton setImage:[UIImage imageNamed:@"mine_cancel"] forState:UIControlStateSelected];
    [focusButton setImage:[UIImage imageNamed:@"mine_cancel"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [focusButton addTarget:self action:@selector(button_clickfocusButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:focusButton];
    
    UIButton *inviteRewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _inviteRewardButton = inviteRewardButton;
    inviteRewardButton.hidden = YES;
    [inviteRewardButton setImage:[UIImage imageNamed:@"mine_other_invitation"] forState:UIControlStateNormal];
    [inviteRewardButton addTarget:self action:@selector(button_clickinviteRewardButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:inviteRewardButton];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.2);
    [self addSubview:lineView];
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    _introduceLabel = introduceLabel;
    introduceLabel.text = @"这家伙儿太懒了，什么都没写";
    introduceLabel.textColor = HEX_COLOR(0xffffff);
    introduceLabel.font = MOL_LIGHT_FONT(12);
    introduceLabel.numberOfLines = 0;
    [self addSubview:introduceLabel];
    
    UIView *infoView = [[UIView alloc] init];
    _infoView = infoView;
    infoView.backgroundColor = [UIColor clearColor];
    [self addSubview:infoView];
    
    UILabel *likeLabel = [[UILabel alloc] init];
    _likeLabel = likeLabel;
    likeLabel.textColor = HEX_COLOR(0xffffff);
    likeLabel.font = MOL_MEDIUM_FONT(20);
    likeLabel.attributedText = [self attributedString:@"0 获赞" word:@"获赞"];
    [self addSubview:likeLabel];
    likeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *taplikeLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button_clickLikeLabel)];
    [likeLabel addGestureRecognizer:taplikeLabel];
    
    UILabel *focusLabel = [[UILabel alloc] init];
    _focusLabel = focusLabel;
    focusLabel.textColor = HEX_COLOR(0xffffff);
    focusLabel.font = MOL_MEDIUM_FONT(20);
    focusLabel.attributedText = [self attributedString:@"0 关注" word:@"关注"];
    [self addSubview:focusLabel];
    focusLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapfocusLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button_clickFocusLabel)];
    [focusLabel addGestureRecognizer:tapfocusLabel];
    
    UILabel *fansLabel = [[UILabel alloc] init];
    _fansLabel = fansLabel;
    fansLabel.textColor = HEX_COLOR(0xffffff);
    fansLabel.font = MOL_MEDIUM_FONT(20);
    fansLabel.attributedText = [self attributedString:@"0 粉丝" word:@"粉丝"];
    [self addSubview:fansLabel];
    fansLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapfansLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button_clickFansLabel)];
    [fansLabel addGestureRecognizer:tapfansLabel];
    
}

- (void)calculatorMineHeadViewFrame
{
    self.iconView.height = 92;
    self.iconView.width = 92;
    self.iconView.layer.cornerRadius = self.iconView.height * 0.5;
//    self.iconView.clipsToBounds = YES;
    self.iconView.x = myleftMargin;
    self.iconView.y = 45 + MOL_StatusBarHeight;
    
    self.iconImageView.width = 90;
    self.iconImageView.height = 90;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.centerX = self.iconView.width * 0.5;
    self.iconImageView.centerY = self.iconView.height * 0.5;
    
    self.authVideoPlay.width = 30;
    self.authVideoPlay.height = 30;
    self.authVideoPlay.x = 62;
    self.authVideoPlay.y = 62;
    
    
//    self.settingButton.width = 38;
//    self.settingButton.height = 38;
//    self.settingButton.centerY = self.iconView.centerY;
//    self.settingButton.right = self.width - 15;
    
    self.inviteButton.width = 80;
    self.inviteButton.height = 38;
    self.inviteButton.centerY = self.iconView.centerY;
    self.inviteButton.right = self.width - 15;
    
    self.moneyButton.width = 80;
    self.moneyButton.height = 38;
    self.moneyButton.centerY = self.iconView.centerY;
    self.moneyButton.right = self.inviteButton.x - 6;
    
    self.inviteRewardButton.width = 38;
    self.inviteRewardButton.height = 38;
    self.inviteRewardButton.centerY = self.iconView.centerY;
    self.inviteRewardButton.right = self.width - 15;
    
    self.focusButton.width = self.focusButton.selected ? 38 : 80;
    self.focusButton.height = 38;
    self.focusButton.centerY = self.inviteRewardButton.centerY;
    self.focusButton.right = self.inviteRewardButton.hidden ? self.width - 15 : self.inviteRewardButton.x - 6;
    
    self.messageButton.width = 80;
    self.messageButton.height = 38;
    self.messageButton.centerY = self.inviteRewardButton.centerY;
    self.messageButton.right = self.focusButton.x - 6;
    
    self.nameLabel.width = self.width - 2 * myleftMargin;
//    self.nameLabel.height = 30;
    [self.nameLabel sizeToFit];
    self.nameLabel.width = self.width - 2 * myleftMargin;
    self.nameLabel.x = myleftMargin;
    self.nameLabel.y = self.iconView.bottom + 20;
    
    self.idLabel.width = self.nameLabel.width;
    self.idLabel.height = 17;
    self.idLabel.x = self.nameLabel.x;
    self.idLabel.y = self.nameLabel.bottom + 2;
    
    
    self.authenticationView.width = MOL_SCREEN_WIDTH;
    self.authenticationView.height = 20;
    self.authenticationView.x = self.idLabel.x;
    self.authenticationView.y = self.idLabel.bottom + 10;
    [self.authenticationView layoutSubviews];
    
    self.lineView.width = self.width - 2 * myleftMargin;
    self.lineView.height = 1;
    self.lineView.x = myleftMargin;
    self.lineView.y = self.authenticationView.bottom + 8;
    
    self.introduceLabel.width = self.width - 2 * myleftMargin;
    [self.introduceLabel sizeToFit];
    self.introduceLabel.width = self.width - 2 * myleftMargin;
    self.introduceLabel.x = myleftMargin;
    self.introduceLabel.y = self.lineView.bottom + 10;
    
    self.infoView.width = self.width - 2 * myleftMargin;
    self.infoView.height = 18;
    self.infoView.x = myleftMargin;
    self.infoView.y = self.introduceLabel.bottom + 7;
    
    [self.likeLabel sizeToFit];
    self.likeLabel.x = myleftMargin;
    self.likeLabel.y = self.infoView.bottom + 14;
    
    [self.focusLabel sizeToFit];
    self.focusLabel.x = self.likeLabel.right + 20;
    self.focusLabel.centerY = self.likeLabel.centerY;
    
    [self.fansLabel sizeToFit];
    self.fansLabel.x = self.focusLabel.right + 20;
    self.fansLabel.centerY = self.likeLabel.centerY;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorMineHeadViewFrame];
}

- (void)layout;
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (NSMutableAttributedString *)attributedString:(NSString *)text word:(NSString *)keyWord
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    // 获取关键字的位置
    NSRange rang = [text rangeOfString:keyWord];
    [attr addAttribute:NSFontAttributeName value:MOL_MEDIUM_FONT(13) range:rang];
    return attr;
}
@end
