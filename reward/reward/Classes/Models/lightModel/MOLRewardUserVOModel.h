//
//  MOLRewardUserVOModel.h
//  reward
//
//  Created by moli-2017 on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLRewardUserVOModel : MOLBaseModel

@property (nonatomic, strong) NSString *userAvatars;
@property (nonatomic, assign) NSInteger storyNum;   // 总数
@property (nonatomic, assign) NSInteger userNum;   // 新发布数
@end
