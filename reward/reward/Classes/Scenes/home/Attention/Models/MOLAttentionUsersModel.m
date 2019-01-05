//
//  MOLAttentionUsersModel.m
//  reward
//
//  Created by ACTION on 2018/10/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAttentionUsersModel.h"
#import "MOLUserModel.h"

@implementation MOLAttentionUsersModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[MOLUserModel class]
             };
}
@end
