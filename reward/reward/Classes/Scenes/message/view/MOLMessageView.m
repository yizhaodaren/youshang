//
//  MOLMessageView.m
//  reward
//
//  Created by 刘宏亮 on 2018/9/16.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMessageView.h"

#import "MOLMessageListCell.h"

#import "MOLUserRelationViewController.h"
#import "MOLUserAgreeViewController.h"
#import "MOLUserCommentViewController.h"
#import "MOLExamineViewController.h"
#import "MOLOfficNotiViewController.h"
#import "MOLOfficHelperViewController.h"
#import "EDChatViewController.h"
#import "MOLAtUserViewController.h"

@interface MOLMessageView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *notiView;

// 评选小助手
@property (nonatomic, weak) UIImageView *examineImageView;
@property (nonatomic, weak) UIImageView *tagImageView;
@property (nonatomic, weak) UILabel *examineNameLabel;
@property (nonatomic, weak) UIImageView *arrowImageView;
@end

@implementation MOLMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSourceArray = [NSMutableArray array];
        [self setupMessageViewUI];
        [self NotificationSettings];
    }
    return self;
}

- (void)NotificationSettings
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    BOOL isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    if (isEnable) {
        self.notiView.hidden = YES;
        self.tableView.contentInset = UIEdgeInsetsMake(0, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
    }else{
        self.notiView.hidden = NO;
        self.tableView.contentInset = UIEdgeInsetsMake(44, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
    }
}

#pragma mark - 按钮点击
- (void)button_clickfansButton   // 粉丝
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_FOCUS];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    MOLUserRelationViewController *vc = [[MOLUserRelationViewController alloc] init];
    vc.relationType = MOLUserRelationType_msgFans;
    vc.userId = user.userId;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clicklikeButton   // 赞
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_LIKE];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MOLUserAgreeViewController *vc = [[MOLUserAgreeViewController alloc] init];
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clickcommentButton  // 评轮
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_COMMENT];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MOLUserCommentViewController *vc = [[MOLUserCommentViewController alloc] init];
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clickexamineButton  // 评选
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_PUBLISH_REWARD_PRODUCTION];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MOLExamineViewController *vc = [[MOLExamineViewController alloc] init];
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clickatButton  // @我
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_AT];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MOLAtUserViewController *vc = [[MOLAtUserViewController alloc] init];
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clickCloseButton
{
    [UIView animateWithDuration:0.3 animations:^{
        self.notiView.height = 0;
        self.tableView.contentInset = UIEdgeInsetsMake(0, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
    } completion:^(BOOL finished) {
        self.notiView.hidden = YES;
    }];
}

- (void)button_clickOpenNotiButton
{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:url options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [application openURL:url];
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MOLMessageListModel *model = self.dataSourceArray[indexPath.row];
    model.read = YES;
    [tableView reloadData];

    // 跳转聊天
    EDChatViewController *vc = [[EDChatViewController alloc] init];
    vc.session = [[MOLYXManager shareYXManager] yx_creatChatSessionWithUserId:model.userId];
    MOLUserModel *userModel = [MOLUserModel new];
    userModel.userId = model.userId;
    userModel.userName = model.name;
    userModel.avatar = model.image;
    vc.userModel = userModel;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLMessageListModel *model = self.dataSourceArray[indexPath.row];
    MOLMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLMessageListCell_id"];
    cell.messageListModel = model;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除对话
    MOLMessageListModel *model = self.dataSourceArray[indexPath.row];
    [[MOLYXManager shareYXManager] yx_deleteChatSession:model.recent];
    [self.dataSourceArray removeObject:model];
    [tableView reloadData];
}

#pragma mark - 懒加载
- (UIView *)notiView
{
    if (_notiView == nil) {
        _notiView = [[UIView alloc] init];
        _notiView.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.7);
        _notiView.width = MOL_SCREEN_WIDTH;
        _notiView.height = 44;
        _notiView.clipsToBounds = YES;
        _notiView.hidden = YES;
        [self addSubview:_notiView];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"不再错过点赞/关注/评论哦～";
        label.textColor = HEX_COLOR_ALPHA(0xffffff, 0.8);
        label.font = MOL_REGULAR_FONT(14);
        [label sizeToFit];
        label.x = 15;
        label.centerY = _notiView.height * 0.5;
        [_notiView addSubview:label];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"message_shut_down"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(button_clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [closeButton sizeToFit];
        closeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        closeButton.centerY = label.centerY;
        closeButton.right = _notiView.width - 20;
        [_notiView addSubview:closeButton];
        
        UIButton *openNoti = [UIButton buttonWithType:UIButtonTypeCustom];
        [openNoti setTitle:@"立即开启" forState:UIControlStateNormal];
        [openNoti setTitleColor:HEX_COLOR_ALPHA(0xFFEC00, 1) forState:UIControlStateNormal];
        openNoti.titleLabel.font = MOL_MEDIUM_FONT(14);
        [openNoti addTarget:self action:@selector(button_clickOpenNotiButton) forControlEvents:UIControlEventTouchUpInside];
        [openNoti sizeToFit];
        openNoti.right = closeButton.x - 25;
        openNoti.centerY = label.centerY;
        [_notiView addSubview:openNoti];
    }
    
    return _notiView;
}
- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.width = MOL_SCREEN_WIDTH;
        _topView.height = 195;
        
        CGFloat btnW = (_topView.width - 10) / 4;
        CGFloat btnH = 105;
        
        UIButton *fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansButton = fansButton;
        [fansButton setImage:[UIImage imageNamed:@"message_fans"] forState:UIControlStateNormal];
        [fansButton setTitle:@"粉丝" forState:UIControlStateNormal];
        [fansButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.8) forState:UIControlStateNormal];
        fansButton.titleLabel.font = MOL_REGULAR_FONT(14);
        [fansButton addTarget:self action:@selector(button_clickfansButton) forControlEvents:UIControlEventTouchUpInside];
        fansButton.width = btnW;
        fansButton.height = btnH;
        fansButton.x = 5;
        [fansButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:6];
        [_topView addSubview:fansButton];
        
        JAPaddingLabel *fansNotiCountLabel = [[JAPaddingLabel alloc] init];
        _fansNotiCountLabel = fansNotiCountLabel;
        fansNotiCountLabel.backgroundColor = HEX_COLOR(0xFFEC00);
        fansNotiCountLabel.text = @"0";
        fansNotiCountLabel.textColor = HEX_COLOR_ALPHA(0x322200, 1);
        fansNotiCountLabel.font = MOL_MEDIUM_FONT(11);
        fansNotiCountLabel.edgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
        [fansNotiCountLabel sizeToFit];
        fansNotiCountLabel.layer.cornerRadius = fansNotiCountLabel.height * 0.5;
        fansNotiCountLabel.clipsToBounds = YES;
        fansNotiCountLabel.center = CGPointMake(fansButton.imageView.right, fansButton.imageView.y);
        [fansButton addSubview:fansNotiCountLabel];
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton = likeButton;
        [likeButton setImage:[UIImage imageNamed:@"message_praise"] forState:UIControlStateNormal];
        [likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [likeButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.8) forState:UIControlStateNormal];
        likeButton.titleLabel.font = MOL_REGULAR_FONT(14);
        [likeButton addTarget:self action:@selector(button_clicklikeButton) forControlEvents:UIControlEventTouchUpInside];
        likeButton.width = btnW;
        likeButton.height = btnH;
        likeButton.x = fansButton.right;
        [likeButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:6];
        [_topView addSubview:likeButton];
        
        JAPaddingLabel *likeNotiCountLabel = [[JAPaddingLabel alloc] init];
        _likeNotiCountLabel = likeNotiCountLabel;
        likeNotiCountLabel.backgroundColor = HEX_COLOR(0xFFEC00);
        likeNotiCountLabel.text = @"0";
        likeNotiCountLabel.textColor = HEX_COLOR_ALPHA(0x322200, 1);
        likeNotiCountLabel.font = MOL_MEDIUM_FONT(11);
        likeNotiCountLabel.edgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
        [likeNotiCountLabel sizeToFit];
        likeNotiCountLabel.layer.cornerRadius = likeNotiCountLabel.height * 0.5;
        likeNotiCountLabel.clipsToBounds = YES;
        likeNotiCountLabel.center = CGPointMake(likeButton.imageView.right, likeButton.imageView.y);
        [likeButton addSubview:likeNotiCountLabel];
        
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton = commentButton;
        [commentButton setImage:[UIImage imageNamed:@"message_comments"] forState:UIControlStateNormal];
        [commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [commentButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.8) forState:UIControlStateNormal];
        commentButton.titleLabel.font = MOL_REGULAR_FONT(14);
        [commentButton addTarget:self action:@selector(button_clickcommentButton) forControlEvents:UIControlEventTouchUpInside];
        commentButton.width = btnW;
        commentButton.height = btnH;
        commentButton.x = likeButton.right;
        [commentButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:6];
        [_topView addSubview:commentButton];
        
        JAPaddingLabel *commentNotiCountLabel = [[JAPaddingLabel alloc] init];
        _commentNotiCountLabel = commentNotiCountLabel;
        commentNotiCountLabel.backgroundColor = HEX_COLOR(0xFFEC00);
        commentNotiCountLabel.text = @"0";
        commentNotiCountLabel.textColor = HEX_COLOR_ALPHA(0x322200, 1);
        commentNotiCountLabel.font = MOL_MEDIUM_FONT(11);
        commentNotiCountLabel.edgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
        [commentNotiCountLabel sizeToFit];
        commentNotiCountLabel.layer.cornerRadius = commentNotiCountLabel.height * 0.5;
        commentNotiCountLabel.clipsToBounds = YES;
        commentNotiCountLabel.center = CGPointMake(commentButton.imageView.right, commentButton.imageView.y);
        [commentButton addSubview:commentNotiCountLabel];
        
//        UIButton *examineButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _examineButton = examineButton;
//        [examineButton setImage:[UIImage imageNamed:@"message_audit"] forState:UIControlStateNormal];
//        [examineButton setTitle:@"评选" forState:UIControlStateNormal];
//        [examineButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.8) forState:UIControlStateNormal];
//        examineButton.titleLabel.font = MOL_REGULAR_FONT(14);
//        [examineButton addTarget:self action:@selector(button_clickexamineButton) forControlEvents:UIControlEventTouchUpInside];
//        examineButton.width = btnW;
//        examineButton.height = btnH;
//        examineButton.x = commentButton.right;
//        [examineButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:6];
//        [_topView addSubview:examineButton];
//
//        JAPaddingLabel *examineNotiCountLabel = [[JAPaddingLabel alloc] init];
//        _examineNotiCountLabel = examineNotiCountLabel;
//        examineNotiCountLabel.backgroundColor = HEX_COLOR(0xFFEC00);
//        examineNotiCountLabel.text = @"0";
//        examineNotiCountLabel.textColor = HEX_COLOR_ALPHA(0x322200, 1);
//        examineNotiCountLabel.font = MOL_MEDIUM_FONT(11);
//        examineNotiCountLabel.edgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
//        [examineNotiCountLabel sizeToFit];
//        examineNotiCountLabel.layer.cornerRadius = examineNotiCountLabel.height * 0.5;
//        examineNotiCountLabel.clipsToBounds = YES;
//        examineNotiCountLabel.center = CGPointMake(examineButton.imageView.right, examineButton.imageView.y);
//        [examineButton addSubview:examineNotiCountLabel];
        
        UIButton *atButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _atButton = atButton;
        [atButton setImage:[UIImage imageNamed:@"msg_@me"] forState:UIControlStateNormal];
        [atButton setTitle:@"@我" forState:UIControlStateNormal];
        [atButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.8) forState:UIControlStateNormal];
        atButton.titleLabel.font = MOL_REGULAR_FONT(14);
        [atButton addTarget:self action:@selector(button_clickatButton) forControlEvents:UIControlEventTouchUpInside];
        atButton.width = btnW;
        atButton.height = btnH;
        atButton.x = commentButton.right;
        [atButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:6];
        [_topView addSubview:atButton];
        
        JAPaddingLabel *atNotiCountLabel = [[JAPaddingLabel alloc] init];
        _atNotiCountLabel = atNotiCountLabel;
        atNotiCountLabel.backgroundColor = HEX_COLOR(0xFFEC00);
        atNotiCountLabel.text = @"0";
        atNotiCountLabel.textColor = HEX_COLOR_ALPHA(0x322200, 1);
        atNotiCountLabel.font = MOL_MEDIUM_FONT(11);
        atNotiCountLabel.edgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
        [atNotiCountLabel sizeToFit];
        atNotiCountLabel.layer.cornerRadius = atNotiCountLabel.height * 0.5;
        atNotiCountLabel.clipsToBounds = YES;
        atNotiCountLabel.center = CGPointMake(atButton.imageView.right, atButton.imageView.y);
        [atButton addSubview:atNotiCountLabel];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = HEX_COLOR_ALPHA(0xEDEDED, 0.1);
        lineView1.height = 1;
        lineView1.width = _topView.width;
        lineView1.bottom = atButton.bottom - 5;
        [_topView addSubview:lineView1];
        
        UIView *v = [[UIView alloc] init];
        v.width = _topView.width;
        v.height = 80;
        v.y = lineView1.bottom + 15;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button_clickexamineButton)];
        [v addGestureRecognizer:tap];
        [_topView addSubview:v];
        
        UIImageView *examineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_ secretaryIC"]];
        _examineImageView = examineImageView;
        examineImageView.x = 15;
        examineImageView.y = 10;
        [v addSubview:examineImageView];
        
        UIImageView *tagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_ secretary"]];
        _tagImageView = tagImageView;
        tagImageView.x = examineImageView.centerX - 5;
        tagImageView.centerY = examineImageView.bottom;
        [v addSubview:tagImageView];
        
        UILabel *examineNameLabel = [[UILabel alloc] init];
        _examineNameLabel = examineNameLabel;
        examineNameLabel.text = @"私人小秘书";
        examineNameLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 1);
        examineNameLabel.font = MOL_MEDIUM_FONT(15);
        [examineNameLabel sizeToFit];
        examineNameLabel.x = examineImageView.right + 10;
        examineNameLabel.y = examineImageView.y;
        [v addSubview:examineNameLabel];
        
        UILabel *examineContentLabel = [[UILabel alloc] init];
        _examineContentLabel = examineContentLabel;
        examineContentLabel.text = @"暂无新作品";
        examineContentLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.5);
        examineContentLabel.font = MOL_REGULAR_FONT(13);
        [examineContentLabel sizeToFit];
        examineContentLabel.x = examineNameLabel.x;
        examineContentLabel.y = examineNameLabel.bottom + 1;
        [v addSubview:examineContentLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_arrow"]];
        _arrowImageView = arrowImageView;
        arrowImageView.centerY = examineImageView.centerY;
        arrowImageView.right = _topView.width - 15;
        [v addSubview:arrowImageView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HEX_COLOR(0x0E0F1A);
        lineView.height = 10;
        lineView.width = _topView.width;
        lineView.bottom = _topView.height;
        [_topView addSubview:lineView];
    }
    
    return _topView;
}

#pragma mark - UI
- (void)setupMessageViewUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MOLMessageListCell class] forCellReuseIdentifier:@"MOLMessageListCell_id"];
    [self addSubview:tableView];
    
    tableView.tableHeaderView = self.topView;
}

- (void)calculatorMessageViewFrame
{
    self.tableView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorMessageViewFrame];
}

@end
