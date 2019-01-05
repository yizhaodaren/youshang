//
//  MOLAtUserModel.h
//  reward
//
//  Created by moli-2017 on 2018/11/7.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOLAtUserModel : MOLBaseModel
@property (nonatomic, strong) MOLUserModel *baseUserVO;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *commentContent;
@property (nonatomic, strong) NSString *commentId;  // 评论的id
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *avatar;
@end

NS_ASSUME_NONNULL_END
