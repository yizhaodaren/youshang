//
//  MOLAtUserGroupModel.m
//  reward
//
//  Created by moli-2017 on 2018/11/7.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLAtUserGroupModel.h"

@implementation MOLAtUserGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[MOLAtUserModel class]
             };
}
@end
