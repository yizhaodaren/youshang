//
//  MOLMusicModel.m
//  reward
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMusicModel.h"

@implementation MOLMusicModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"storyList":[MOLLightVideoModel class],
             };
}
    

- (NSMutableArray *)storyList
    {
        if (_storyList == nil) {
            _storyList = [NSMutableArray array];
        }
        
        return _storyList;
    }
@end
