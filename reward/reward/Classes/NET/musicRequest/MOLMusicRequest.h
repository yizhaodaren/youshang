//
//  MOLMusicRequest.h
//  reward
//
//  Created by apple on 2018/11/16.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLNetRequest.h"
#import "MOLMusicGroupModel.h"
#import "MOLMusicModel.h"
#import "MOLCollectResultModel.h"
#import "MOLHotMusicModel.h"
#import "MOLVideoOutsideGroupModel.h"

@interface MOLMusicRequest : MOLNetRequest
//音乐列表
- (instancetype)initRequest_MusicListWithParameter:(NSDictionary *)parameter;
//音乐收藏
- (instancetype)initRequest_MusicCollectWithParameter:(NSDictionary *)parameter;
//音乐收藏列表
- (instancetype)initRequest_MusicCollectListWithParameter:(NSDictionary *)parameter;
//音乐详情
- (instancetype)initRequest_MusicInfoWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId;
//音乐搜索
- (instancetype)initRequest_MusicSearchWithParameter:(NSDictionary *)parameter;
//用过的音乐
- (instancetype)initRequest_MusiclogWithParameter:(NSDictionary *)parameter;
//发现页面hotMusic
- (instancetype)initRequest_MusicHotWithParameter:(NSDictionary *)parameter;
//发现页面hotMusic 和悬赏
- (instancetype)initRequest_MusicAndRewardWithParameter:(NSDictionary *)parameter;
@end
