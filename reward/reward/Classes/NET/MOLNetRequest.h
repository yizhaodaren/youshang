//
//  MOLNetRequest.h
//  aletter
//
//  Created by moli-2017 on 2018/7/31.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLBaseNetRequest.h"
#import "MOLBaseModel.h"

typedef void(^JARequestSuccessBlock)(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message);
typedef void(^JARequestFaileBlock)(__kindof MOLBaseNetRequest *request);

@interface MOLNetRequest : MOLBaseNetRequest

- (void)baseNetwork_startRequestWithcompletion:(JARequestSuccessBlock)completion failure:(JARequestFaileBlock)failure;

@end
