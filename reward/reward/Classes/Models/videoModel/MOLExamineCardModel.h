//
//  MOLExamineCardModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "MOLGiftModel.h"
#import "MOLLightVideoModel.h"
#import "MOLRewardUserVOModel.h"
#import "MOLShareModel.h"
#import "ContentsItemModel.h"

@interface MOLExamineCardModel : MOLBaseModel

//@property (nonatomic, strong) NSString *image;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, assign) NSInteger goldCount;
//@property (nonatomic, strong) NSString *giftName;
//@property (nonatomic, assign) NSInteger giftCount;
//@property (nonatomic, strong) NSString *timeDownTime;
//@property (nonatomic, strong) NSString *createTime;
//@property (nonatomic, strong) NSString *content;
//@property (nonatomic, assign) NSInteger type;  // 0 红包悬赏 1 排位悬赏
//@property (nonatomic, strong) NSString *videodescribe;
//@property (nonatomic, strong) NSArray *videoArray;  // 已拍个数

// 自定义
@property (nonatomic, assign) BOOL selectSend;
@property (nonatomic, assign) CGFloat cardHeight; // 个人中心 悬赏卡片
@property (nonatomic, assign) CGFloat startRecordCardHeight;//录制作品开拍卡片高度wsc
@property (nonatomic, assign) CGFloat cardHeight_check; // 评选 悬赏卡片
@property (nonatomic, assign) CGFloat cardHeight_noBottom;  // 发布邀请悬赏
@property (nonatomic, assign) CGFloat cellHeight_homeFocus;  // 首页关注
@property (nonatomic, assign) CGFloat rewardCellHeight; //悬赏-列表

@property (nonatomic, assign) CGFloat scaleVideoW;
@property (nonatomic, assign) CGFloat scaleVideoH; 

// 已定
@property (nonatomic, copy) NSString *audioUrl;
@property (nonatomic, assign) NSInteger commentCount; // 评论的个数
@property (nonatomic, assign) NSInteger favorCount; // 喜欢的个数
@property (nonatomic, assign) NSInteger shareCount; // 分享的个数
@property (nonatomic, assign) NSInteger playCount; // 播放的个数
@property (nonatomic, strong) NSString *content;  // 内容
@property (nonatomic, strong) NSMutableArray <ContentsItemModel *>*contents;
@property (nonatomic, strong) NSString *coverImage;  // 封面
@property (nonatomic, copy) NSString *createTime; // 创建时间
@property (nonatomic, copy) NSString *finishTime; // 完成时间
@property (nonatomic, copy) NSString *flushTime;
@property (nonatomic, assign) BOOL isFinish;  // 悬赏是否完成
@property (nonatomic, assign) BOOL isPublish;  // 悬赏是否已经发布
@property (nonatomic, assign) BOOL isFavor;  // 是否喜欢
@property (nonatomic, assign) BOOL isRecommend;  // 悬赏是否是推荐
@property (nonatomic, assign) NSInteger awardSize; // 获奖清单 总数

@property (nonatomic, assign) NSInteger remainSize;// 获奖清单 剩余数

@property (nonatomic, assign) NSInteger rewardAmount; // 金币总数

@property (nonatomic, assign) NSInteger rewardType; // 悬赏模式 0 排位 1 红包
@property (nonatomic, strong) NSString *rewardId;  // 悬赏ID
@property (nonatomic, strong) MOLUserModel *userVO;  // 悬赏作者的用户vo
@property (nonatomic, strong) MOLGiftModel *giftVO;  // 礼物vo
@property (nonatomic, strong) NSMutableArray <MOLLightVideoModel *>*storyList;  // 视频vo 的 list
@property (nonatomic, strong) MOLRewardUserVOModel *rewardUserVO;
@property (nonatomic, strong) MOLShareModel *shareMsgVO; //分享
// 待定
@property (nonatomic, strong) NSString *videodescribe;
@property (nonatomic, strong) NSString *timeDownTime;  // 倒计时
@property (nonatomic, strong) NSArray *userArray;  // 已拍人的头像

// 视频宽高
@property (nonatomic, assign) CGFloat audioWidth;
@property (nonatomic, assign) CGFloat audioHeight;
@property (nonatomic, assign) BOOL isJoiner;

//@property (nonatomic, assign) NSInteger type;  // 0 红包悬赏 1 排位悬赏
//@property (nonatomic, strong) NSArray *videoArray;  // 已拍个数
//@property (nonatomic, assign) NSInteger goldCount;
//@property (nonatomic, assign) NSInteger giftCount;
//@property (nonatomic, strong) NSString *giftImage; // 礼物图片

@end
