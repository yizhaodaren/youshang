//
//  MOLMessageViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMessageViewController.h"
#import "MOLMessageView.h"
#import "MOLMessageViewModel.h"
#import "MOLUserRelationViewController.h"
#import "MOLMessageListModel.h"
#import "EDBaseMessageModel.h"

@interface MOLMessageViewController ()<NIMConversationManagerDelegate>
@property (nonatomic, strong) MOLMessageViewModel *messageViewModel;
@property (nonatomic, weak) MOLMessageView *messageView;
@end

@implementation MOLMessageViewController

- (BOOL)showNavigationLine
{
    return YES;
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.messageViewModel = [[MOLMessageViewModel alloc] init];
    [self setupMessageViewControllerUI];
    [self setupNavigation];
    
    [self bindingMessageViewModel];
    
    [self request_getMessageListWithMore:NO];
    
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login_success) name:MOL_SUCCESS_USER_LOGIN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(check_notiSettings) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)check_notiSettings
{
    [self.messageView NotificationSettings];
}

- (void)login_success
{
    [self request_getMessageListWithMore:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 获取数目展示
    NSString *key1 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_FOCUS];
    NSString *key2 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_LIKE];
    NSString *key3 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_COMMENT];
    NSString *key4 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_PUBLISH_REWARD_PRODUCTION];
    NSString *key5 = [NSString stringWithFormat:@"%@_%@",[MOLUserManagerInstance user_getUserId],MOL_NOTI_COUNT_AT];
    NSInteger fans = [[NSUserDefaults standardUserDefaults] integerForKey:key1];
    NSInteger like = [[NSUserDefaults standardUserDefaults] integerForKey:key2];
    NSInteger comment = [[NSUserDefaults standardUserDefaults] integerForKey:key3];
    NSInteger production = [[NSUserDefaults standardUserDefaults] integerForKey:key4];
    NSInteger at = [[NSUserDefaults standardUserDefaults] integerForKey:key5];
    
    if (fans > 0) {
        self.messageView.fansNotiCountLabel.hidden = NO;
        self.messageView.fansNotiCountLabel.text = [NSString stringWithFormat:@"%ld",fans];
    }else{
        self.messageView.fansNotiCountLabel.hidden = YES;
    }
    if (like > 0) {
        self.messageView.likeNotiCountLabel.hidden = NO;
        self.messageView.likeNotiCountLabel.text = [NSString stringWithFormat:@"%ld",like];
    }else{
        self.messageView.likeNotiCountLabel.hidden = YES;
    }
    if (comment > 0) {
        self.messageView.commentNotiCountLabel.hidden = NO;
        self.messageView.commentNotiCountLabel.text = [NSString stringWithFormat:@"%ld",comment];
    }else{
        self.messageView.commentNotiCountLabel.hidden = YES;
    }
    if (production > 0) {
//        self.messageView.examineNotiCountLabel.hidden = NO;
//        self.messageView.examineNotiCountLabel.text = [NSString stringWithFormat:@"%ld",production];
        self.messageView.examineContentLabel.text = @"有新发布的悬赏作品了";
        [self.messageView.examineContentLabel sizeToFit];
    }else{
//        self.messageView.examineNotiCountLabel.hidden = YES;
        self.messageView.examineContentLabel.text = @"暂无新作品";
        [self.messageView.examineContentLabel sizeToFit];
    }
    
    if (at > 0) {
        self.messageView.atNotiCountLabel.hidden = NO;
        self.messageView.atNotiCountLabel.text = [NSString stringWithFormat:@"%ld",at];
    }else{
        self.messageView.atNotiCountLabel.hidden = YES;
    }
}

#pragma mark - NIMConversationManagerDelegate
/**
 *  增加最近会话的回调
 */
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount
{

    NSMutableArray *users = [NSMutableArray array];
    NSMutableArray *messageList = [NSMutableArray array];
    
    MOLMessageListModel *model = [self recentSession_changeWithRecent:recentSession];
    [users addObject:recentSession.session.sessionId];
    [messageList addObject:model];
    
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange: NSMakeRange(0, messageList.count)];
    [self.messageView.dataSourceArray insertObjects:messageList atIndexes:set];
    [self.messageView.tableView reloadData];
    
    // 获取用户信息
    [self recentSession_getUserInfo:users];
    
}
/**
 *  最近会话修改的回调
 */
- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    NSString *userId = [recentSession.session.sessionId stringByReplacingOccurrencesOfString:@"reward" withString:@""];
    
    [self.messageView.dataSourceArray enumerateObjectsUsingBlock:^(MOLMessageListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([userId isEqualToString:obj.userId]) {
            
            obj.read = !recentSession.unreadCount;
            NIMRecentSession *recent = recentSession;
            NIMMessage *message = recent.lastMessage;
            
            if (message.messageType == NIMMessageTypeText) {
                obj.messageBody = message.text;
            }else if (message.messageType == NIMMessageTypeImage){
                obj.messageBody = @"图片";
            }else if (message.messageType == NIMMessageTypeCustom){
                NIMCustomObject *msgobj = (NIMCustomObject *)message.messageObject;
                EDBaseMessageModel *att = (EDBaseMessageModel *)msgobj.attachment;
                obj.messageBody = att.content;
            }
            
            NSString *time = [NSString stringWithFormat:@"%f",message.timestamp * 1000];
            obj.createTime = [NSString moli_timeGetMessageTimeWithTimestamp:time];
            
            *stop = YES;
            
            [self.messageView.tableView reloadData];
        }
    }];
}

- (MOLMessageListModel *)recentSession_changeWithRecent:(NIMRecentSession *)recentSession
{
    NIMRecentSession *recent = recentSession;
    NIMMessage *message = recent.lastMessage;
    MOLMessageListModel *model = [[MOLMessageListModel alloc] init];
    if (message.messageType == NIMMessageTypeText) {
        model.messageBody = message.text;
    }else if (message.messageType == NIMMessageTypeImage){
        model.messageBody = @"图片";
    }else if (message.messageType == NIMMessageTypeCustom){
        NIMCustomObject *obj = (NIMCustomObject *)message.messageObject;
        EDBaseMessageModel *att = (EDBaseMessageModel *)obj.attachment;
        model.messageBody = att.content;
    }
    model.recent = recent;
    
    model.read = !recent.unreadCount;
    
    NSString *time = [NSString stringWithFormat:@"%f",message.timestamp * 1000];
    model.createTime = [NSString moli_timeGetMessageTimeWithTimestamp:time];
    
    NSString *userId = [recentSession.session.sessionId stringByReplacingOccurrencesOfString:@"reward" withString:@""];
    
    if ([userId isEqualToString:@"0"] ||
        [userId isEqualToString:@"00"]) {
        model.offic = YES;
    }else{
        model.offic = NO;
    }
    
    
    model.userId = [recent.session.sessionId stringByReplacingOccurrencesOfString:@"reward" withString:@""];
    
    return model;
}

- (void)recentSession_getUserInfo:(NSArray *)users
{
    // 获取用户信息
    [[MOLYXManager shareYXManager] yx_getUserInfo:users complete:^(NSArray<NIMUser *> * _Nullable users) {
        for (NSInteger i = 0; i < users.count; i++) {
            NIMUser *user = users[i];
            NSString *userId = [user.userId stringByReplacingOccurrencesOfString:@"reward" withString:@""];
            for (NSInteger j = 0; j < self.messageView.dataSourceArray.count; j++) {
                MOLMessageListModel *model = self.messageView.dataSourceArray[j];
                if ([userId isEqualToString:model.userId]) {
                    model.name = user.userInfo.nickName;
                    model.image = user.userInfo.avatarUrl;
                    model.userId = [user.userId stringByReplacingOccurrencesOfString:@"reward" withString:@""];
                }
            }
        }
        [self.messageView.tableView reloadData];
    }];
}

#pragma mark - 网络请求
- (void)request_getMessageListWithMore:(BOOL)isMore
{
    
    if (!isMore) {
        [self.messageView.dataSourceArray removeAllObjects];
    }
    
    [self.messageViewModel.messageListCommand execute:nil];
}

#pragma mark - bindingMessageViewModel
- (void)bindingMessageViewModel
{
    @weakify(self);
    [self.messageViewModel.messageListCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        NSArray *arr = (NSArray *)x;
        
        NSMutableArray *users = [NSMutableArray array];
        
        NSMutableArray *messageList = [NSMutableArray array];
        
        for (NSInteger i = 0; i < arr.count; i++) {
            NIMRecentSession *recent = arr[i];
            MOLMessageListModel *model = [self recentSession_changeWithRecent:recent];
            [users addObject:recent.session.sessionId];
            [messageList addObject:model];
        }
        
        [self.messageView.dataSourceArray addObjectsFromArray:messageList];
        [self.messageView.tableView reloadData];
        
        // 获取用户信息
        [self recentSession_getUserInfo:users];
    }];
}

#pragma mark - 按钮的点击
- (void)button_clickContact
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    MOLUserRelationViewController *vc = [[MOLUserRelationViewController alloc] init];
    vc.relationType = MOLUserRelationType_focus;
    vc.userId = user.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 导航条
- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"消息" titleColor:HEX_COLOR(0xffffff)];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithCustomTitle:@"联系人" color:HEX_COLOR(0xffffff) font:MOL_MEDIUM_FONT(14) imageName:@"message_shape" targat:self action:@selector(button_clickContact) imageTitleStyle:ButtonImageTitleStyleRight];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupMessageViewControllerUI
{
    MOLMessageView *messageView = [[MOLMessageView alloc] init];
    _messageView = messageView;
    [self.view addSubview:messageView];
}

- (void)calculatorMessageViewControllerFrame
{
    self.messageView.frame = self.view.bounds;
    self.messageView.y = MOL_StatusBarAndNavigationBarHeight;
    self.messageView.height = self.view.height - self.messageView.y;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorMessageViewControllerFrame];
}

@end
