//
//  MOLYXManager.m
//  reward
//
//  Created by moli-2017 on 2018/9/26.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLYXManager.h"

@implementation MOLYXManager
+ (instancetype)shareYXManager
{
    static MOLYXManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[MOLYXManager alloc] init];
        }
    });
    return instance;
}


/// 自动登录云信
- (void)yx_autoLoginYXWithCurrentViewControl:(id)vc
{
    if (![MOLUserManagerInstance user_isLogin]) {
        return;
    }
    
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    
    NSString *account = [NSString stringWithFormat:@"reward%@",user.userId];
    NSString *token = account;
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        loginData.account = account;
        loginData.token = token;
        loginData.forcedMode = YES;
        
        [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
        
        [[NIMSDK sharedSDK].loginManager addDelegate:vc];
    }
}

/// 退出云信
- (void)yx_exitYX
{
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error){}];
}

/// 创建单个会话
- (NIMSession *)yx_creatChatSessionWithUserId:(NSString *)userId
{
    NSString *sessionId = [NSString stringWithFormat:@"reward%@",userId];
    NIMSession *session = [NIMSession session:sessionId type:NIMSessionTypeP2P];
    return session;
}

/// 获取所有的会话列表
- (NSArray<NIMRecentSession *> *)yx_getAllChatSession
{
    NSArray *sessionArr = [NIMSDK sharedSDK].conversationManager.allRecentSessions;
    
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:sessionArr];
    
    return arrM;
}

/// 获取会话的未读数量
- (NSInteger)yx_getChatSessionUnreadCount
{
    return [[NIMSDK sharedSDK].conversationManager allUnreadCount];
}

/// 删除单个会话
- (void)yx_deleteChatSession:(NIMRecentSession *)session
{
    [[NIMSDK sharedSDK].conversationManager deleteRecentSession:session];
}

/// 获取聊天历史记录 --- 根据传入的消息获取更早的消息
- (void)yx_getUserHistoryMessageWithSession:(NIMSession *)session message:(NIMMessage *)message complete:(void(^)(NSError *error, NSArray *messages))complete
{
    NIMHistoryMessageSearchOption *searchOpt = [[NIMHistoryMessageSearchOption alloc] init];
    searchOpt.startTime  = 0;
    searchOpt.currentMessage = message;
    searchOpt.endTime = message ? message.timestamp : 0;
    searchOpt.limit      = 20;
    searchOpt.sync       = NO;
    [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:session option:searchOpt result:^(NSError *error, NSArray *messages) {
        if (complete) {
            if (message) {
                complete(error,messages);
            }else{
                
                complete(error,messages.reverseObjectEnumerator.allObjects);
            }
        };
    }];
}

/// 发送文本消息
- (void)yx_sendMessage:(NSString *)message withSession:(NIMSession *)session
{
    
}

/// 发送图片消息
- (void)yx_sendPictureMessage:(NSString *)message withSession:(NIMSession *)session
{
    
}

/// 获取用户资料
- (void)yx_getUserInfo:(NSArray *)userArr complete:(void(^_Nullable)(NSArray<NIMUser *> * _Nullable users))complete
{
    [[NIMSDK sharedSDK].userManager fetchUserInfos:userArr completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
        if (error == nil) {
            complete(users);
        }
    }];
}

/// 将用户聊天信息设置为已读
- (void)yx_MessageRead:(NIMSession *_Nullable)session
{
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:session];
}

@end
