//
//  MOLMsgCommentGroupModel.m
//  reward
//
//  Created by moli-2017 on 2018/10/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMsgCommentGroupModel.h"

@implementation MOLMsgCommentGroupModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[MOLMsgCommentModel class]
             };
}
@end
