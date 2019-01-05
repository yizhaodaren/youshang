//
//  MOLGoodsRequest.h
//  reward
//
//  Created by moli-2017 on 2018/10/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLNetRequest.h"
#import "MOLWalletGroupModel.h"

@interface MOLGoodsRequest : MOLNetRequest


/// 获取支付凭证
- (instancetype)initRequest_creatChargeWithParameter:(NSDictionary *)parameter;

/// 获取支付订单
- (instancetype)initRequest_creatOrderWithParameter:(NSDictionary *)parameter;

/// 内购
- (instancetype)initRequest_creatIPAWithParameter:(NSDictionary *)parameter;

/// 商品列表
- (instancetype)initRequest_goodsListWithParameter:(NSDictionary *)parameter;


/// 支付宝异步回调
- (instancetype)initRequest_alipayNotifyWithParameter:(NSDictionary *)parameter;
/// 支付宝同步回调
- (instancetype)initRequest_alipayReturnWithParameter:(NSDictionary *)parameter;

/// 微信异步回调
- (instancetype)initRequest_wxpayNotifyWithParameter:(NSDictionary *)parameter;

/// 支付凭证
- (instancetype)initRequest_paySignWithParameter:(NSDictionary *)parameter;
@end
