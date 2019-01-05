//
//  PLMediaInfoList.m
//  reward
//
//  Created by xujin on 2018/10/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "PLMediaInfoList.h"
#import "PLMediaInfo.h"
@implementation PLMediaInfoList
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[PLMediaInfo class]
             };
}

@end
