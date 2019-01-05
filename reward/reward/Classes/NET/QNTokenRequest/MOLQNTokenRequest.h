//
//  MOLQNTokenRequest.h
//  reward
//
//  Created by moli-2017 on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"

@interface MOLQNTokenRequest : MOLNetRequest

/// token
- (instancetype)initRequest_qiNiuTokenWithParameter:(NSDictionary *)parameter;
@end
