//
//  HoursSetModel.m
//  reward
//
//  Created by xujin on 2018/10/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HoursSetModel.h"
#import "HoursModel.h"
@implementation HoursSetModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[HoursModel class]
             };
}
@end
