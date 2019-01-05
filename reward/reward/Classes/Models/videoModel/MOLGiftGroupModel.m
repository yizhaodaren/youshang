//
//  MOLGiftGroupModel.m
//  reward
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLGiftGroupModel.h"
#import "MOLGiftModel.h"
@implementation MOLGiftGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[MOLGiftModel class]
             };
}
@end
