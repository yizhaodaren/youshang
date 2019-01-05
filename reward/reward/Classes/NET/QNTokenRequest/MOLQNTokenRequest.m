//
//  MOLQNTokenRequest.m
//  reward
//
//  Created by moli-2017 on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLQNTokenRequest.h"

@interface MOLQNTokenRequest ()
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation MOLQNTokenRequest
/// token
- (instancetype)initRequest_qiNiuTokenWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
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
    return [MOLBaseModel class];
}

- (NSString *)requestUrl
{
    NSString *url = @"/upload/getToken";
    return url;
}

- (NSString *)parameterId {
    if (!_parameterId.length) {
        return @"";
    }
    return _parameterId;
}
@end
