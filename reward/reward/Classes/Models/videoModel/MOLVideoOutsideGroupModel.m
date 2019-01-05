//
//  MOLVideoOutsideGroupModel.m
//  reward
//
//  Created by moli-2017 on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLVideoOutsideGroupModel.h"

@implementation MOLVideoOutsideGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[MOLVideoOutsideModel class]
             };
}
@end
