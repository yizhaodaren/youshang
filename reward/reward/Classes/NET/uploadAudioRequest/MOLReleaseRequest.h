//
//  MOLReleaseRequest.h
//  reward
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"
#import "MOLGiftModel.h"
#import "MOLGiftGroupModel.h"
#import "MOLMusicGroupModel.h"
#import "MOLParserVideoModel.h"

@interface MOLReleaseRequest : MOLNetRequest
//发布作品
- (instancetype)initRequest_releaseWorkWithParameter:(NSDictionary *)parameter;
//发布悬赏
- (instancetype)initRequest_releaseRewardWithParameter:(NSDictionary *)parameter;
//礼物列表
- (instancetype)initRequest_giftListWithParameter:(NSDictionary *)parameter;
//音乐列表
- (instancetype)initRequest_MusicListWithParameter:(NSDictionary *)parameter;
//解析视频
- (instancetype)initRequest_videoParserWithParameter:(NSDictionary *)parameter;
@end
