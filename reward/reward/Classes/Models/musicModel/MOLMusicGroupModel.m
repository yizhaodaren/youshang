//
//  MOLMusicGroupModel.m
//  reward
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMusicGroupModel.h"
#import "MOLMusicModel.h"
@implementation MOLMusicGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[MOLMusicModel class]
             };
}

@end
