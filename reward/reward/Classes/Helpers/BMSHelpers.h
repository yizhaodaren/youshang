//
//  BMSHelpers.h
//  reward
//
//  Created by xujin on 2018/11/6.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MOLVideoOutsideModel,MOLMsgUserModel;
@interface BMSHelpers : NSObject
+ (NSInteger)getPlayerContentMode:(MOLVideoOutsideModel *)model;
+ (NSString *)getContent:(NSString *)text userSet:(NSMutableDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
