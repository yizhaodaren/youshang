//
//  EDBaseMessageModel.h
//  aletter
//
//  Created by moli-2017 on 2018/8/24.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDBaseChatCell;


//定义cell中的布局
/**
 * 头像和气泡的距离
 */
static CGFloat const kEDIconAndBubbleEdgeSpacing = 5.0;
/**
 * cell的content字体大小
 */
static CGFloat const kEDCellContentTitleFont = 14.0;
/**
 * cell的左右间距
 */
static CGFloat const kEDCellHorizontalEdgeSpacing = 20.0;
/**
 * cell的上下间距
 */
static CGFloat const kEDCellVerticalEdgeSpacing = 10.0;
/**
 * 气泡的左右间距
 */
static CGFloat const kEDBubbleHorizontalEdgeSpacing = 15.0;
/**
 * 气泡的上下间距
 */
static CGFloat const kEDBubbleVerticalEdgeSpacing = 10.0;

/**
 *  message的来源枚举定义
 *  MQChatMessageIncoming - 收到的消息
 *  MQChatMessageOutgoing - 发送的消息
 */
typedef NS_ENUM(NSUInteger, MessageFromType) {
    MessageFromType_me,
    MessageFromType_other
};

typedef NS_ENUM(NSUInteger, MessageSendStatusType) {
    MessageSendStatusType_success,
    MessageSendStatusType_sending,
    MessageSendStatusType_failure,
};

@interface EDBaseMessageModel : NSObject

/** 消息id */
@property (nonatomic, copy) NSString *logId;

/** 用户id */
@property (nonatomic, copy) NSString *userId;  

/** 用户名字 */
@property (nonatomic, copy) NSString *userName;

/** 用户头像 */
@property (nonatomic, copy) NSString *userImage;

/** 消息的来源类型 */
@property (nonatomic, assign) MessageFromType fromType;

/** 消息内容 */
@property (nonatomic, copy) NSString *content;

/** 消息类型 */
@property (nonatomic, assign) NSInteger chatType; // 消息类型 0 文字 1图片 2语音 3 帖子 10 时间 

/** 消息已读 */
@property (nonatomic, assign) BOOL isRead;

/** 消息时间 */
@property (nonatomic, copy) NSString *createTime;


@property (nonatomic, assign) CGRect bubbleImageFrame; // 别人的气泡
@property (nonatomic, assign) CGRect iconImageViewFrame;  // 头像（暂时没用）
@property (nonatomic, assign) CGRect sendingIndicatorFrame;  // 发送状态（暂时没用）
@property (nonatomic, assign) CGRect failureIndicatorFrame;  // 发送失败状态（暂时没用）


/** 消息发送的状态 */
@property (nonatomic, assign) MessageSendStatusType sendStatus;

- (EDBaseChatCell *)getCellWithReuseIdentifier:(NSString *)identifier;

- (CGFloat)getCellHeight;

- (void)setupModelWithNIM:(NIMMessage *)message ownUser:(MOLUserModel *)user otherUser:(MOLUserModel *)otherUser;

@end
