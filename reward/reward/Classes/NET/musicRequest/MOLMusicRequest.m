//
//  MOLMusicRequest.m
//  reward
//
//  Created by apple on 2018/11/16.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLMusicRequest.h"

typedef NS_ENUM(NSUInteger, MOLMusicRequestType) {
    MOLMusicRequestType_musicList,//音乐列表
    MOLMusicRequestType_musicInfo,//音乐详情
    MOLMusicRequestType_musicCollect,//收藏音乐
    MOLMusicRequestType_musicCollectList,//收藏音乐列表
    MOLMusicRequestType_searchMusic,//搜索音乐
    MOLMusicRequestType_musicLogList,//用过的音乐
    MOLMusicRequestType_hotMusics,//发现页面的展示的hotMusic
     MOLMusicRequestType_hotMusicsAndReward,//发现页面的展示的hotMusic和悬赏
};

@interface MOLMusicRequest ()
@property (nonatomic, assign) MOLMusicRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end
@implementation MOLMusicRequest

//音乐列表
- (instancetype)initRequest_MusicListWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLMusicRequestType_musicList;
        _parameter = parameter;
    }
    return self;
}
//音乐收藏
- (instancetype)initRequest_MusicCollectWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLMusicRequestType_musicCollect;
        _parameter = parameter;
    }
    return self;
}
//音乐收藏列表
- (instancetype)initRequest_MusicCollectListWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLMusicRequestType_musicCollectList;
        _parameter = parameter;
    }
    return self;
}
//用过的音乐
- (instancetype)initRequest_MusiclogWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLMusicRequestType_musicLogList;
        _parameter = parameter;
    }
    return self;
}
//发现页面hotMusic
- (instancetype)initRequest_MusicHotWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLMusicRequestType_hotMusics;
        _parameter = parameter;
    }
    return self;
}
//音乐搜索
- (instancetype)initRequest_MusicSearchWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLMusicRequestType_searchMusic;
        _parameter = parameter;
    }
    return self;
}
//音乐详情
- (instancetype)initRequest_MusicInfoWithParameter:(NSDictionary *)parameter parameterId:(NSString *)parameterId{
    self = [super init];
    if (self) {
        _type = MOLMusicRequestType_musicInfo;
        _parameter = parameter;
        _parameterId = parameterId;
    }
    return self;
}
//发现页面hotMusic 和悬赏
- (instancetype)initRequest_MusicAndRewardWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLMusicRequestType_hotMusicsAndReward;
        _parameter = parameter;
    }
    return self;
}
- (id)requestArgument
{
    return _parameter;
}

- (Class)modelClass
{
    
    switch (_type) {
            
        case MOLMusicRequestType_musicInfo:
        {
            return [MOLMusicModel class];
        }
            break;
        case MOLMusicRequestType_musicList:
        {
            return [MOLMusicGroupModel class];
        }
            break;
        case MOLMusicRequestType_musicCollect:
        {
            return [MOLCollectResultModel class];
        }
            break;
        case MOLMusicRequestType_musicCollectList:
        {
            return [MOLMusicGroupModel class];
        }
            break;
        case MOLMusicRequestType_musicLogList:
        {
            return [MOLMusicGroupModel class];
        }
            break;
            
        case MOLMusicRequestType_hotMusics:
        {
            return [MOLVideoOutsideGroupModel class];
        }
            break;
        case MOLMusicRequestType_hotMusicsAndReward:
        {
            return [MOLVideoOutsideGroupModel class];
        }
            break;
            
        case MOLMusicRequestType_searchMusic:
        {
            return [MOLMusicGroupModel class];
        }
            break;
           
        default:
            return [MOLBaseModel class];
            break;
    }
    
}

- (NSString *)requestUrl
{
    
    switch (_type) {

        case MOLMusicRequestType_musicInfo:
        {
            NSString *url = @"/music/info/{musicId}";
            url = [url stringByReplacingOccurrencesOfString:@"{musicId}" withString:self.parameterId];
            return url;
        }
            break;
        case MOLMusicRequestType_musicList:
        {
            NSString *url = @"/music/musics";
            return url;
        }
            break;
        case MOLMusicRequestType_musicCollect:
        {
            NSString *url = @"/collection/collect";
            return url;
        }
            break;
        case MOLMusicRequestType_musicCollectList:
        {
            NSString *url = @"/collection/music";
            return url;
        }
            break;
        case MOLMusicRequestType_musicLogList:
        {
            NSString *url = @"/music/musicLog";
            return url;
        }
        case MOLMusicRequestType_hotMusics:
        {
            NSString *url = @"/music/hotMusics";
            return url;
        }
            
            break;
        case MOLMusicRequestType_searchMusic:
        {
            NSString *url = @"/search/info";
            return url;
        }
            break;
        case MOLMusicRequestType_hotMusicsAndReward:
        {
            NSString *url = @"/discovery/discoveries";
            return url;
        }
            break;
            
        default:
            return @"";
            break;
    }
    
}

- (NSString *)parameterId {
    if (!_parameterId.length) {
        return @"";
    }
    return _parameterId;
}
@end
