//
//  MOLYXManager.h
//  reward
//
//  Created by moli-2017 on 2018/9/26.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLYXManager : NSObject

+ (instancetype)shareYXManager;

/// 自动登录云信
- (void)yx_autoLoginYXWithCurrentViewControl:(id)vc;

/// 退出云信
- (void)yx_exitYX;

/// 创建单个会话
- (NIMSession *)yx_creatChatSessionWithUserId:(NSString *)userId;

/// 获取所有的会话列表
- (NSArray<NIMRecentSession *> *)yx_getAllChatSession;

/// 获取会话的未读数量
- (NSInteger)yx_getChatSessionUnreadCount;

/// 删除单个会话
- (void)yx_deleteChatSession:(NIMRecentSession *)session;

/// 获取聊天历史记录 --- 根据传入的消息获取更早的消息
- (void)yx_getUserHistoryMessageWithSession:(NIMSession *)session message:(NIMMessage *)message complete:(void(^)(NSError *error, NSArray *messages))complete;

/// 发送文本消息
- (void)yx_sendMessage:(NSString *)message withSession:(NIMSession *)session;

/// 发送图片消息
- (void)yx_sendPictureMessage:(NSString *)message withSession:(NIMSession *)session;

/// 获取用户资料
- (void)yx_getUserInfo:(NSArray *)userArr complete:(void(^_Nullable)(NSArray<NIMUser *> * _Nullable users))complete;

/// 将用户聊天信息设置为已读
- (void)yx_MessageRead:(NIMSession *_Nullable)session;
@end
