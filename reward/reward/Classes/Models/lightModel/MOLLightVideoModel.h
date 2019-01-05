//
//  MOLLightVideoModel.h
//  reward
//
//  Created by moli-2017 on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLLightVideoModel : MOLBaseModel
@property (nonatomic, strong) NSString *coverImage;
@property (nonatomic, assign) NSInteger playCount;

@property (nonatomic, assign) NSInteger rewardType; // 悬赏模式 0 排位 1 红包
@property (nonatomic, assign) BOOL isExistMark; //表示是否显示标签
@end
