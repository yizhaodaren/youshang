//
//  RewardSetModel.m
//  reward
//
//  Created by xujin on 2018/10/19.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "RewardSetModel.h"
#import "RewardModel.h"
@implementation RewardSetModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[RewardModel class]
             };
}
@end
