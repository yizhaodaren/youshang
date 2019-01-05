//
//  MOLMsgUserModel.h
//  reward
//
//  Created by moli-2017 on 2018/10/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLMsgUserModel : MOLBaseModel
@property (nonatomic, strong) MOLUserModel *userVO;
@property (nonatomic, strong) NSString *createTime;
@end
