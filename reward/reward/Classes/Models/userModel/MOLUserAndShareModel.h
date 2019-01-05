//
//  MOLUserAndShareModel.h
//  reward
//
//  Created by apple on 2018/11/22.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLBaseModel.h"
#import "MOLShareModel.h"
#import "MOLAuthInfoModel.h"
@interface MOLUserAndShareModel : MOLBaseModel
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *birthDay;
@property (nonatomic, strong) NSString *constellation;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, strong) NSString *signInfo;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userUuid; // 用户id

@property (nonatomic, assign) NSInteger isFriend;  // 0未关注  1 已关注 2 相互关注

@property (nonatomic, assign) NSInteger attentionCount;  // 关注数量
@property (nonatomic, assign) NSInteger fansCount;  // 粉丝数量
@property (nonatomic, assign) NSInteger beFavorCount;  // 获赞数量

@property (nonatomic, assign) NSInteger favorCount;  // 喜欢数量
@property (nonatomic, assign) NSInteger storyCount;  // 作品数量
@property (nonatomic, assign) NSInteger rewardCount;  // 悬赏数量

@property (nonatomic, strong) NSString *accessToken; // token

@property (nonatomic, strong) MOLShareModel *shareMsgVO; //分享
@property (nonatomic,strong)  MOLAuthInfoModel  *authInfoVO;//认证信息
@end
