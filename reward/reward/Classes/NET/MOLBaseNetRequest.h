//
//  MOLBaseNetRequest.h
//  aletter
//
//  Created by moli-2017 on 2018/7/31.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "YTKRequest.h"
#import <YTKNetwork.h>
#import "MOLBaseModel.h"

@interface MOLBaseNetRequest : YTKRequest
@property (nonatomic, assign) Class modelClass;
@property (nonatomic, assign) BOOL isToast;

@end
