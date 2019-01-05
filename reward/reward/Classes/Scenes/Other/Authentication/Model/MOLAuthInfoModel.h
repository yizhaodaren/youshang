//
//  MOLAuthInfoModel.h
//  reward
//
//  Created by apple on 2018/11/28.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLAuthInfoModel : MOLBaseModel
@property (nonatomic, assign) NSInteger realAuth;//实名认证状态 1认证中。2认证成功 3失败
@property (nonatomic, assign) NSInteger audioAuth; //视频认证状态 1认证中。 2认证成功 3失败

@property (nonatomic, strong) NSString *audioUrl;  //视频认证URL
@property (nonatomic, strong) NSString *name;  //作者
@property (nonatomic, strong) NSString *card;  //身份证信号
@property (nonatomic, strong) NSString *imgUrl;  //认证图片
@end
