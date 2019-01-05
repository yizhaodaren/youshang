//
//  MOLReleaseRequest.m
//  reward
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLReleaseRequest.h"


typedef NS_ENUM(NSUInteger, MOLReleaseRequestType) {
    MOLReleaseRequestType_releaseWork,//发布作品
    MOLReleaseRequestType_releaseReward,//发布悬赏
    MOLReleaseRequestType_giftList,//礼物列表
     MOLReleaseRequestType_musicList,//音乐列表
     MOLReleaseRequestType_videoParser,//视频解析
};

@interface MOLReleaseRequest ()
@property (nonatomic, assign) MOLReleaseRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end
@implementation MOLReleaseRequest
//发布作品
- (instancetype)initRequest_releaseWorkWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLReleaseRequestType_releaseWork;
        _parameter = parameter;
    }
    return self;
}
//发布悬赏
- (instancetype)initRequest_releaseRewardWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLReleaseRequestType_releaseReward;
        _parameter = parameter;
    }
    return self;
}
//礼物列表
- (instancetype)initRequest_giftListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLReleaseRequestType_giftList;
        _parameter = parameter;
    }
    return self;
}
//音乐列表
- (instancetype)initRequest_MusicListWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLReleaseRequestType_musicList;
        _parameter = parameter;
    }
    return self;
}
//解析视频
- (instancetype)initRequest_videoParserWithParameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _type = MOLReleaseRequestType_videoParser;
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
        case MOLReleaseRequestType_releaseWork:
        {
           return [MOLBaseModel class];
        }
            break;
        case MOLReleaseRequestType_releaseReward:
        {
             return [MOLBaseModel class];
        }
            break;
        case MOLReleaseRequestType_giftList:
        {
           return [MOLGiftGroupModel class];
        }
            break;
        case MOLReleaseRequestType_musicList:
        {
            return [MOLMusicGroupModel class];
        }
            break;
        case MOLReleaseRequestType_videoParser:
        {
            return [MOLParserVideoModel class];
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
        case MOLReleaseRequestType_releaseWork:
        {
            NSString *url = @"/story/publish";
            return url;
        }
            break;
        case MOLReleaseRequestType_releaseReward:
        {
            NSString *url = @"/reward/publish";
            return url;
        }
            break;
        case MOLReleaseRequestType_giftList:
        {
            NSString *url = @"/gift/gifts";
            return url;
        }
            break;
        case MOLReleaseRequestType_musicList:
        {
            NSString *url = @"/music/musics";
            return url;
        }
            break;
        case MOLReleaseRequestType_videoParser:
        {
            NSString *url = @"/reward/videoParser";
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
