//
//  MOLBannerSetModel.m
//  reward
//
//  Created by xujin on 2018/10/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBannerSetModel.h"
#import "BannerModel.h"
@implementation MOLBannerSetModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[BannerModel class]
             };
}
@end
