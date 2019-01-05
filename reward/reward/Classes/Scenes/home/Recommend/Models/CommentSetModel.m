//
//  CommentSetModel.m
//  reward
//
//  Created by xujin on 2018/10/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "CommentSetModel.h"
#import "HomeCommentModel.h"

@implementation CommentSetModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resBody":[HomeCommentModel class]
             };
}
@end
