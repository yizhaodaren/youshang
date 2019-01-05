//
//  MOLAccountModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLAccountModel : MOLBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *subName;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *wbUid;
@property (nonatomic, strong) NSString *wbName;
@property (nonatomic, strong) NSString *wbAvatar;

@property (nonatomic, strong) NSString *qqUid;
@property (nonatomic, strong) NSString *qqName;
@property (nonatomic, strong) NSString *qqAvatar;

@property (nonatomic, strong) NSString *wxUid;
@property (nonatomic, strong) NSString *wxName;
@property (nonatomic, strong) NSString *wxAvatar;
@end
