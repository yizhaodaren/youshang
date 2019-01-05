//
//  MOLVideoOutsideModel.h
//  reward
//
//  Created by ACTION on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "MOLVideoModel.h"
#import "MOLExamineCardModel.h"
#import "MOLMusicModel.h"

@interface MOLVideoOutsideModel : MOLBaseModel
//1悬赏 2作品 3热门音乐 :1>悬赏作品 2>自由作品 (根据rewardVO值判断，有值为悬赏作品、无值为自由作品)
@property (nonatomic, assign) NSInteger contentType;
@property (nonatomic, strong) MOLVideoModel *storyVO;  //作品模型
@property (nonatomic, strong) MOLExamineCardModel *rewardVO; //悬赏模型
@property (nonatomic, strong) MOLMusicModel *musicStoryVO; //悬赏模型

@property (nonatomic, assign) CGFloat startRecordCardHeight;//录制作品开拍卡片高度wsc
@end
