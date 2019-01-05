//
//  EDStoryMessageModel.h
//  aletter
//
//  Created by moli-2017 on 2018/8/28.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDBaseMessageModel.h"

@interface EDStoryMessageModel : EDBaseMessageModel<NIMCustomAttachment>

@property (nonatomic, strong) NSString *rewardUserName;
@property (nonatomic, strong) NSString *rewardUserId;
@property (nonatomic, strong) NSString *rewardUserAvatar;

@property (nonatomic, strong) NSString *storyContent;  // 内容
@property (nonatomic, strong) NSString *beginTime; // 创建时间
@property (nonatomic, strong) NSString *finishTime; // 完成时间

@property (nonatomic, assign) NSInteger type;  // 0 红包悬赏 1 排位悬赏
@property (nonatomic, assign) NSInteger goldCount; // 金币数
@property (nonatomic, strong) NSString *giftImage;  // 礼物图片
@property (nonatomic, assign) NSInteger giftCount; // 礼物数

@property (nonatomic, assign) CGRect labelFrame;
@property (nonatomic, assign) CGRect attendButtonFrame;
@property (nonatomic, assign) CGRect cardViewFrame;

@property (nonatomic, assign) CGFloat cellHeight;

/**
 * 用文字初始化message
 */
- (instancetype)initWithStory:(EDStoryMessageModel *)story;

- (CGFloat)getCellHeight;
@end
