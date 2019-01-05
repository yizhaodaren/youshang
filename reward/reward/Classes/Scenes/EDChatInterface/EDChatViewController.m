//
//  EDChatViewController.m
//  aletter
//
//  Created by moli-2017 on 2018/8/27.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDChatViewController.h"
#import "EDBaseChatCell.h"
#import "EDInputView.h"

#import "EDBaseMessageModel.h"
#import "EDStoryMessageModel.h"
#import "EDTextMessageModel.h"
#import "EDImageMessageModel.h"
#import "EDTimeMessageModel.h"
#import "MOLYSHelpMessageModel.h"

#import "MOLActionRequest.h"

@interface EDChatViewController ()<UITableViewDelegate,
                                    UITableViewDataSource,
                                    EDChatTableViewDelegate,
                                    EDInputViewDelegate,
                                    YYTextKeyboardObserver,
                                    EDBaseChatCellDelegate,
                                    NIMChatManagerDelegate>

@property (nonatomic, weak) EDInputView *inputView;
/**
 * @brief 聊天界面的tableView
 */
@property (nonatomic, strong) EDChatTableView *chatTableView;
@property (nonatomic, assign) BOOL refreshData;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) NIMMessage *firstNIMMessage;

@property (nonatomic, assign) BOOL canSend;

@property(nonatomic,strong)UIView  *waringView;
@end

@implementation EDChatViewController

-(void)dealloc
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

- (BOOL)showNavigationLine
{
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceArray = [NSMutableArray array];
    
    // 设置导航条
    [self setNavigation];
    [self setupChatViewControllerUI];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eDImageCellEvent:) name:@"EDImageCellTap" object:nil];
    
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    
    [self request_getMessageList:NO];
    
    // 查询好友关旭
    [self request_checkRelation];
    
    // 置为已读
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
    
    //监听别人关注了我 ，拉取列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request_checkRelation) name:MOL_NOTI_USER_FOCUS object:nil];
    
}

// 检查好友关系
- (void)request_checkRelation
{
    if ([self.userModel.userId isEqualToString:@"0"] ||
        [self.userModel.userId isEqualToString:@"00"]) {
        return;
    }
    
    MOLActionRequest *r = [[MOLActionRequest alloc] initRequest_relationActionWithParameter:nil parameterId:self.userModel.userId];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
       
        NSInteger relation = [request.responseObject[@"resBody"] integerValue];
        self.canSend = relation == 2 ? YES : NO;
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

#pragma mark - 按钮的点击
- (void)button_rightButton
{
    if (![MOLUserManagerInstance user_isLogin]) {
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    // 辞去键盘
    [self.inputView inputRegist];
    
    NSArray *titleButtons = @[@"举报",@"拉黑"];
    @weakify(self);
    LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:-1 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
        @strongify(self);
        if (buttonIndex >= titleButtons.count) {
            return;
        }
        NSString *title = titleButtons[buttonIndex];
        if ([title isEqualToString:@"举报"]) {
            
            // 举报原因
            [self report];
            
        }else if ([title isEqualToString:@"拉黑"]){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确定将ta拉进黑名单吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MOLActionRequest *r = [[MOLActionRequest alloc] initRequest_blackUserActionWithParameter:nil parameterId:self.userModel.userId];
                [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                    if (code == MOL_SUCCESS_REQUEST) {
                        [MBProgressHUD showMessageAMoment:@"拉黑成功"];
                    }else{
                        [MBProgressHUD showMessageAMoment:message];
                    }
                } failure:^(__kindof MOLBaseNetRequest *request) {
                    
                }];
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancleAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }];
    [actionS show];
}

- (void)report
{
    NSArray *titleArray = @[
                            @"低俗色情",
                            @"垃圾广告",
                            @"政治敏感",
                            @"其他违规内容",
                            ];
    @weakify(self);
    LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:@"选择举报原因" buttonTitles:titleArray redButtonIndex:-1 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
        @strongify(self);
        if (buttonIndex >= titleArray.count) {
            return;
        }
        
        NSString *str = titleArray[buttonIndex];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"cause"] = str;
        dic[@"reportType"] = @"4";
        dic[@"typeId"] = self.userModel.userId;
        MOLActionRequest *r = [[MOLActionRequest alloc] initRequest_reportUserActionWithParameter:dic];
        [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
            if (code == MOL_SUCCESS_REQUEST) {
                [MBProgressHUD showMessageAMoment:@"举报成功"];
            }else{
                [MBProgressHUD showMessageAMoment:message];
            }
        } failure:^(__kindof MOLBaseNetRequest *request) {
            
        }];
        
    }];
    
    [actionS show];
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
        EDTextMessageModel *model = [[EDTextMessageModel alloc] initWithContent:message.text];
        [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
        [self insertMessageToDataSource:model type:0];
    }else if (message.messageType == NIMMessageTypeImage){
        NIMImageObject *imageObj = (NIMImageObject *)message.messageObject;
        EDImageMessageModel *model = [[EDImageMessageModel alloc] initWithImage:imageObj.url width:0 height:0];
        [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
        [self insertMessageToDataSource:model type:1];
    }else if (message.messageType == NIMMessageTypeCustom){
//        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
//        EDStoryMessageModel *model = (EDStoryMessageModel *)object.attachment;
//        [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
//        [self insertMessageToDataSource:model type:3];
        
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        if ([object.attachment isKindOfClass:[MOLYSHelpMessageModel class]]) {
            MOLYSHelpMessageModel *model = (MOLYSHelpMessageModel *)object.attachment;
            if (model) {
                [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
                // 添加 并 插入时间
                [self insertMessageToDataSource:model type:3];
            }
        }
    }
    
    [self.inputView inputResetText];
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
}

/**
 *  收到消息回调
 *
 *  @param messages 消息列表,内部为NIMMessage
 */
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages
{
    // 如果属于该对话 ，插入数据源
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    NIMMessage *message = messages.firstObject;
    if ([message.session.sessionId isEqualToString:self.session.sessionId]) {
        
        if (message.messageType == NIMMessageTypeText) {
            
            // 构造文字model
            EDTextMessageModel *model = [[EDTextMessageModel alloc] initWithContent:message.text];
            [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
            // 添加 并 插入时间
            [self insertMessageToDataSource:model type:0];
            
        }else if (message.messageType == NIMMessageTypeImage){
            
            // 构造图片model
            NIMImageObject *imageObj = (NIMImageObject *)message.messageObject;
            EDImageMessageModel *model = [[EDImageMessageModel alloc] initWithImage:imageObj.url width:0 height:0];
            [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
            // 添加 并 插入时间
            [self insertMessageToDataSource:model type:1];
        }else if (message.messageType == NIMMessageTypeCustom){
            // 构造悬赏卡片model
//            NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
//            EDStoryMessageModel *model = (EDStoryMessageModel *)object.attachment;
//            if (model) {
//                [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
//                // 添加 并 插入时间
//                [self insertMessageToDataSource:model type:3];
//            }
            
            NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
            if ([object.attachment isKindOfClass:[MOLYSHelpMessageModel class]]) {
                MOLYSHelpMessageModel *model = (MOLYSHelpMessageModel *)object.attachment;
                if (model) {
                    [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
                    // 添加 并 插入时间
                    [self insertMessageToDataSource:model type:3];
                }
            }
        }
        
    }
}

#pragma mark - 获取历史消息
- (void)request_getMessageList:(BOOL)isMore
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    NIMMessage *firstMessage = nil;
    if (isMore) {
        firstMessage = self.firstNIMMessage;
    }
    
    [[MOLYXManager shareYXManager] yx_getUserHistoryMessageWithSession:self.session message:self.firstNIMMessage complete:^(NSError *error, NSArray *messages) {
       
        // 构造自己的model
        for (NSInteger i = 0; i < messages.count; i++) {
            
            NIMMessage *message = messages[i];
            
            if (isMore) {
                self.firstNIMMessage = messages.lastObject;
            }else{
                self.firstNIMMessage = messages.firstObject;
            }
            
            if (message.messageType == NIMMessageTypeText) {
                
                // 构造文字model
                EDTextMessageModel *model = [[EDTextMessageModel alloc] initWithContent:message.text];
                
                [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
                
                // 添加 并 插入时间
                if (isMore) {
                    [self insertMessageToDataSource:model type:0 isTop:0];
                }else{
                    [self insertMessageToDataSource:model type:0];
                }
                
            }else if (message.messageType == NIMMessageTypeImage){
                
                // 构造图片model
                NIMImageObject *imageObj = (NIMImageObject *)message.messageObject;
                EDImageMessageModel *model = [[EDImageMessageModel alloc] initWithImage:imageObj.url width:0 height:0];
                
                [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
                // 添加 并 插入时间
                if (isMore) {
                    [self insertMessageToDataSource:model type:0 isTop:0];
                }else{
                    [self insertMessageToDataSource:model type:0];
                }
            }else if (message.messageType == NIMMessageTypeCustom){
                
                // 构造悬赏卡片model
//                NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
//                EDStoryMessageModel *model = (EDStoryMessageModel *)object.attachment;
//
//                if (model) {
//                    [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
//                    // 添加 并 插入时间
//                    [self insertMessageToDataSource:model type:3];
//                }
                
                NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
                
                if ([object.attachment isKindOfClass:[MOLYSHelpMessageModel class]]) {
                    MOLYSHelpMessageModel *model = (MOLYSHelpMessageModel *)object.attachment;
                    if (model) {
                        [model setupModelWithNIM:message ownUser:user otherUser:self.userModel];
                        // 添加 并 插入时间
                        if (isMore) {
                            [self insertMessageToDataSource:model type:0 isTop:0];
                        }else{
                            [self insertMessageToDataSource:model type:0];
                        }
                    }
                }
                
            }
        }
        
        [self request_finish];
    }];
}

- (void)request_finish
{
    // 结束下拉刷新
    if (self.refreshData == YES) {
        self.refreshData = NO;
        [self.chatTableView finishLoadingTopRefreshView];
        // 刷新列表
        [self.chatTableView reloadData];
    }else{
        // 刷新列表
        [self.chatTableView reloadData];
        
        [self chatTableViewScrolledToBottom:NO];
    }
}

// 滚动到底部
- (void)chatTableViewScrolledToBottom:(BOOL)animate
{
    if (self.dataSourceArray.count && self.refreshData == NO) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSourceArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animate];
    }
}

- (NSInteger)mineSendmsgCount
{
    NSInteger count = 0;
    for (NSInteger i = 0; i < self.dataSourceArray.count; i++) {
        EDBaseMessageModel *model = self.dataSourceArray[i];
        if (model.fromType == MessageFromType_me && ![model isKindOfClass:[EDTimeMessageModel class]]) {
            count += 1;
        }
    }
    return count;
}

#pragma mark - EDInputViewDelegate
- (void)input_sendTextMessage:(NSString *)message  // 发送文本
{
    if (!self.canSend && [self mineSendmsgCount] > 3) {
        [MBProgressHUD showMessageAMoment:@"由于对方没有关注你，你只能发送最多3条消息，需要对方关注后才能恢复正常聊天"];
        return;
    }
    
    
    if (!self.canSend && [self mineSendmsgCount] <= 3) {
        [MBProgressHUD showMessageAMoment:@"由于对方没有关注你，你只能发送最多3条消息，需要对方关注后才能恢复正常聊天"];
    }
    
    // 构造出具体消息
    NIMMessage *messageBody = [[NIMMessage alloc] init];
    messageBody.text        = message;
    // 错误反馈对象
    NSError *error = nil;
    // 发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:messageBody toSession:self.session error:&error];
}

- (void)input_sendImageMessage:(UIImage *)message  // 发送图片
{
    
    if (!self.canSend) {
        [MBProgressHUD showMessageAMoment:@"只有双向关注的好友可以发送图片哦～"];
        return;
    }
    
    UIImage *image = message;
    // 获得图片附件对象
    NIMImageObject *object = [[NIMImageObject alloc] initWithImage:image];
    // 构造出具体消息并注入附件
    NIMMessage *messageBody = [[NIMMessage alloc] init];
    messageBody.messageObject = object;
    // 错误反馈对象
    NSError *error = nil;
    // 发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:messageBody toSession:self.session error:&error];
}

- (void)insertMessageToDataSource:(id)messageBody type:(NSInteger)type  // 0 文本 1图片 2 语音 3 小助手
{
    [self insertMessageTimeSource:messageBody];
    
     [self.dataSourceArray addObject:messageBody];
    
    [self.chatTableView reloadData];
    [self chatTableViewScrolledToBottom:YES];
}

- (void)insertMessageToDataSource:(id)messageBody type:(NSInteger)type isTop:(NSInteger)top  // 0 文本 1图片 2 语音 3 小助手
{
    
    // 该条的时间
    EDBaseMessageModel *msg = (EDBaseMessageModel *)messageBody;
    
    // 获取最后一条消息的时间
    EDBaseMessageModel *lastM = self.dataSourceArray.firstObject;
    
    [self.dataSourceArray insertObject:messageBody atIndex:top];
    
    if (!lastM || (lastM.createTime.integerValue - msg.createTime.integerValue > MOL_TIME_MARGIN * 1000)) {
        // 插入时间
        NSString *t = msg.createTime;
        EDTimeMessageModel *timeMsg = [[EDTimeMessageModel alloc] initWithTime:[NSString moli_timeGetMessageTimeWithTimestamp:t]];
        [self.dataSourceArray insertObject:timeMsg atIndex:top];
    }
    
    [self.chatTableView reloadData];
    [self chatTableViewScrolledToBottom:YES];
}

// 判断是否插入时间
- (void)insertMessageTimeSource:(id)messageBody
{
    // 该条的时间
    EDBaseMessageModel *msg = (EDBaseMessageModel *)messageBody;

    // 获取最后一条消息的时间
    EDBaseMessageModel *lastM = self.dataSourceArray.lastObject;

    if (!lastM || (msg.createTime.integerValue - lastM.createTime.integerValue > MOL_TIME_MARGIN * 1000)) {
        // 插入时间
        NSString *t = msg.createTime;
        EDTimeMessageModel *timeMsg = [[EDTimeMessageModel alloc] initWithTime:[NSString moli_timeGetMessageTimeWithTimestamp:t]];
        [self.dataSourceArray addObject:timeMsg];
    }
}

#pragma mark - EDChatTableViewDelegate
- (void)didTapChatTableView:(UITableView *)tableView {
    [self.view endEditing:true];
}

// 开始下拉刷新
- (void)startLoadingTopMessagesInTableView:(UITableView *)tableView {
    self.refreshData = YES;
    [self request_getMessageList:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 获取数据

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取model
    EDBaseMessageModel *model = self.dataSourceArray[indexPath.row];
    NSString *cellModelName = NSStringFromClass([model class]);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModelName];
    
    if (!cell) {
        cell = [model getCellWithReuseIdentifier:cellModelName];
    }
    
    // 刷新数据
    [(EDBaseChatCell *)cell updateCellWithCellModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDBaseMessageModel *model = self.dataSourceArray[indexPath.row];
    return [model getCellHeight];
}


#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.chatTableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition
{
    CGRect kbFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption animations:^{
        ///用此方法获取键盘的rect
        if (kbFrame.origin.y < self.view.height) {   // 键盘上
            
            self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, self.chatTableView.contentInset.left, self.inputView.height + kbFrame.size.height, self.chatTableView.contentInset.right);
        }else{   // 键盘下
            self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, self.chatTableView.contentInset.left, 0, self.chatTableView.contentInset.right);
        }
        
    } completion:^(BOOL finished) {
        [self chatTableViewScrolledToBottom:YES];
    }];
}

#pragma mark - 导航条
- (void)setNavigation
{
    [self basevc_setCenterTitle:self.userModel.userName titleColor:HEX_COLOR(0xffffff)];
    UIBarButtonItem *rightB = [UIBarButtonItem mol_barButtonItemWithImageName:@"mine_other_point" highlightImageName:@"mine_other_point" targat:self action:@selector(button_rightButton)];
    if ([self.userModel.userId isEqualToString:@"0"] ||
        [self.userModel.userId isEqualToString:@"00"]) {
        return;
    }
    self.navigationItem.rightBarButtonItem = rightB;
}

#pragma mark - UI
- (void)setupChatViewControllerUI
{
  

    
    EDChatTableView *tableView = [[EDChatTableView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _chatTableView = tableView;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.chatTableViewDelegate = self;
    [self.view addSubview:tableView];
    
    EDInputView *inputView = [[EDInputView alloc] init];
    _inputView = inputView;
    inputView.backgroundColor = [UIColor clearColor];
    self.inputView.width = MOL_SCREEN_WIDTH;
    self.inputView.height = 44 + MOL_TabbarSafeBottomMargin;
    self.inputView.y = self.view.height - self.inputView.height;
    self.inputView.delegate = self;
//    self.inputView.placeholder =[MOLUserManagerInstance user_getUserLastName];
    self.inputView.placeholder = @"发送消息…";
    [self.view addSubview:inputView];
    
    if ([self.userModel.userId isEqualToString:@"0"] ||
        [self.userModel.userId isEqualToString:@"00"]) {
        self.inputView.hidden = YES;
    }else{
        if (self.userModel.authInfoVO.audioAuth != 2) {
            [self addWaringView];
        }
        self.inputView.hidden = NO;
    }
 
}

- (void)calculatorChatViewControllerFrame
{
    self.chatTableView.frame = CGRectMake(0, MOL_StatusBarAndNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - self.inputView.height - MOL_StatusBarAndNavigationBarHeight);
    
    [self.chatTableView updateFrame:self.chatTableView.frame];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorChatViewControllerFrame];
}


-(NSString *)dictionaryToJSONString:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

#pragma mark EDImageCell
-(void)eDImageCellEvent:(NSNotification *)notif{
    if (notif) {
        
        [self.inputView inputRegist];
        
        NSString *urlStr =(NSString *)notif.object;
        HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
        browser.isNeedLandscape = NO;
       
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject: urlStr?urlStr:@""];
        browser.imageArray = arr;
        [browser show];
    }
}

//用户未通过视频认证 提示
-(void)addWaringView{
    CGFloat H = 40;
    self.waringView = [[UIView  alloc] initWithFrame:CGRectMake(0, MOL_StatusBarAndNavigationBarHeight, MOL_SCREEN_WIDTH, H)];
    self.waringView.backgroundColor= HEX_COLOR_ALPHA(0xFFFFFF, 0.1);
    
    UIButton *waringBtn =  [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH-H, H)];
    [waringBtn setImage:[UIImage imageNamed:@"au_tishi"] forState:UIControlStateNormal];
    [waringBtn setTitle:@" 该用户未通过视频认证，请谨慎联系，以防受骗！" forState:UIControlStateNormal];
    waringBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    waringBtn.titleLabel.font = MOL_REGULAR_FONT(12);
    [self.waringView addSubview:waringBtn];
    
    UIButton *closeBtn =  [[UIButton  alloc] initWithFrame:CGRectMake(MOL_SCREEN_WIDTH - H,0, H, H)];
    [closeBtn setImage:[UIImage imageNamed:@"au_shut_down"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.waringView addSubview:closeBtn];

    [self.view addSubview:self.waringView];
    
}
-(void)closeBtnAction:(UIButton *)sender{
        self.waringView.hidden = YES;
}

@end
