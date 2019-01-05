//
//  MOLInviteAttendRewardViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.

/*
    邀请参加悬赏
 */

#import "MOLInviteAttendRewardViewController.h"

#import "MOLInviteAttendRewardView.h"
#import "MOLUserPageRequest.h"

@interface MOLInviteAttendRewardViewController ()<NIMChatManagerDelegate>

@property (nonatomic, weak) MOLInviteAttendRewardView *inviteAttendRewardView;

@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MOLInviteAttendRewardViewController

- (BOOL)showNavigation
{
    return NO;
}

-(void)dealloc
{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupInviteAttendRewardViewControllerUI];
    
    @weakify(self);
    self.inviteAttendRewardView.tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_getInviteAttendExamineData:YES];
    }];
    self.inviteAttendRewardView.tableView.mj_footer.hidden = YES;
    
    [self request_getInviteAttendExamineData:NO];
    
    self.inviteAttendRewardView.userId = self.userId;
    
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
}

#pragma mark - NIMChatManagerDelegate
/**
 *  发送消息完成回调
 *
 *  @param message 当前发送的消息
 *  @param error   失败原因,如果发送成功则error为nil
 */
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(nullable NSError *)error
{
    //    [MBProgressHUD showMessageAMoment:@"消息发送成功"];
    
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    
    if (message.messageType == NIMMessageTypeText) {
        
    }else if (message.messageType == NIMMessageTypeImage){
        
    }else if (message.messageType == NIMMessageTypeCustom){
        
    }
    
    
}

/**
 *  收到消息回调
 *
 *  @param messages 消息列表,内部为NIMMessage
 */
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages
{
    [MBProgressHUD showMessageAMoment:@"收到消息了"];
}

#pragma mark - 网络请求
- (void)request_getInviteAttendExamineData:(BOOL)isMore
{
    if (!isMore) {
        self.currentPage = 1;
    }
    
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentPage);
    dic[@"pageSize"] = @(MOL_REQUEST_COUNT_VEDIO);
    dic[@"userId"] = user.userId;
    dic[@"isFinish"] = @(0);
    
    MOLUserPageRequest *r = [[MOLUserPageRequest alloc] initRequest_getRewardListWithParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.inviteAttendRewardView.tableView.mj_footer endRefreshing];
        
        // 解析数据
        MOLVideoOutsideGroupModel *groupModel = (MOLVideoOutsideGroupModel *)responseModel;
        
        if (!isMore) {
            [self.inviteAttendRewardView.dataSourceArray removeAllObjects];
        }
        
        // 添加到数据源
        [self.inviteAttendRewardView.dataSourceArray addObjectsFromArray:groupModel.resBody];
        
        [self.inviteAttendRewardView.tableView reloadData];
        
        if (self.inviteAttendRewardView.dataSourceArray.count >= groupModel.total) {
            self.inviteAttendRewardView.tableView.mj_footer.hidden = YES;
        }else{
            self.inviteAttendRewardView.tableView.mj_footer.hidden = NO;
            self.currentPage += 1;
        }
     
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [self.inviteAttendRewardView.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - UI
- (void)setupInviteAttendRewardViewControllerUI
{
    MOLInviteAttendRewardView *inviteAttendRewardView = [[MOLInviteAttendRewardView alloc] init];
    _inviteAttendRewardView = inviteAttendRewardView;
    [self.view addSubview:inviteAttendRewardView];
}

- (void)calculatorInviteAttendRewardViewControllerFrame
{
    self.inviteAttendRewardView.width = self.view.width;
    self.inviteAttendRewardView.height = self.view.height - MOL_StatusBarHeight;
    self.inviteAttendRewardView.y = MOL_StatusBarHeight;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.inviteAttendRewardView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.inviteAttendRewardView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.inviteAttendRewardView.backgroundColor = HEX_COLOR(0xffffff);
    self.inviteAttendRewardView.layer.mask = maskLayer;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorInviteAttendRewardViewControllerFrame];
}
@end
