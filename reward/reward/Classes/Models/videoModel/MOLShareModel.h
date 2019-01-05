//
//  MOLShareModel.h
//  reward
//
//  Created by xujin on 2018/10/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MOLShareModel : MOLBaseModel
@property (nonatomic, strong) NSString *shareContent; //分享内容
@property (nonatomic, strong) NSString *shareImg;  // 分享图片
@property (nonatomic, strong) NSString *shareTitle;   // 分享标题
@property (nonatomic, strong) NSString *shareUrl;   // 分享网页

@property (nonatomic, strong) NSString *imageBase64; // 分享图片

@property (nonatomic, copy) NSString *type;  // 分享平台 0，朋友圈,  1，微信   2,qq空间  3,qq  4,微博
/// 分享的类型
@property (nonatomic, copy) NSString *dataType;  // 分享类型 1，一般的url内容   2，base64图片。
@end

NS_ASSUME_NONNULL_END
