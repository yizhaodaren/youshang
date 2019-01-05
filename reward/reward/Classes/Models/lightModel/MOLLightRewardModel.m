//
//  MOLLightRewardModel.m
//  reward
//
//  Created by xujin on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLLightRewardModel.h"

@implementation MOLLightRewardModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents":[ContentsItemModel class]
             };
}

@end
