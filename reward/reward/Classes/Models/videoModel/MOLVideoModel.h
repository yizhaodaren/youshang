//
//  MOLVideoModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/19.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "MOLUserModel.h"
#import "MOLLightRewardModel.h"
#import "MOLGiftModel.h"
#import "MOLShareModel.h"
#import "ContentsItemModel.h"
@interface MOLVideoModel : MOLBaseModel
@property (nonatomic, assign) CGFloat scaleVideoW;
@property (nonatomic, assign) CGFloat scaleVideoH;  

@property (nonatomic, assign) CGFloat cellHeight_examinePackted;  // cellHeight

@property (nonatomic, copy) NSString *musicCover; //音乐
@property (nonatomic, assign) NSInteger musicId;//音乐ID

@property (nonatomic, copy) NSString *audioUrl;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSMutableArray <ContentsItemModel *>*contents;
@property (nonatomic, copy) NSString *coverImage;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger favorCount;
@property (nonatomic, assign) NSInteger isFavor;
@property (nonatomic, assign) NSInteger isEssence;

@property (nonatomic, assign) NSInteger isReward;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) NSInteger storyId;
@property (nonatomic, assign) NSInteger rewardAmount;
@property (nonatomic, strong) MOLUserModel *userVO;
@property (nonatomic, strong) MOLLightRewardModel *rewardVO;
@property (nonatomic, strong) MOLGiftModel *giftVO;  // 礼物vo
@property (nonatomic, strong) MOLShareModel *shareMsgVO; //分享

// 视频宽高
@property (nonatomic, assign) CGFloat audioWidth;
@property (nonatomic, assign) CGFloat audioHeight;

@end
