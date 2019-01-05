//
//  MOLMsgAgreeModel.h
//  reward
//
//  Created by moli-2017 on 2018/10/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLMsgAgreeModel : MOLBaseModel
@property (nonatomic, strong) MOLUserModel *baseUserVO;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *type;   // REWARD  STORY  COMMENT
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *avatar;
@end
