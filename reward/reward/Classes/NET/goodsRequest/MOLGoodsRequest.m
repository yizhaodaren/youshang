//
//  MOLGoodsRequest.m
//  reward
//
//  Created by moli-2017 on 2018/10/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLGoodsRequest.h"

typedef NS_ENUM(NSUInteger, MOLGoodsRequestType) {
    MOLGoodsRequestType_goodsList,
    MOLGoodsRequestType_creatCharge,
    MOLGoodsRequestType_creatOrder,
    MOLGoodsRequestType_ipa,
    MOLGoodsRequestType_alipayNotify,
    MOLGoodsRequestType_alipayReturn,
    MOLGoodsRequestType_wxpayNotify,
    MOLGoodsRequestType_paySign,
    
};
@interface MOLGoodsRequest ()
@property (nonatomic, assign) MOLGoodsRequestType type;
@property (nonatomic, strong) NSDictionary *parameter;
@property (nonatomic, strong) NSString *parameterId;
@end

@implementation MOLGoodsRequest


/// 商品列表
- (instancetype)initRequest_goodsListWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLGoodsRequestType_goodsList;
        _parameter = parameter;
    }
    
    return self;
}

/// 获取支付凭证
- (instancetype)initRequest_creatChargeWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLGoodsRequestType_creatCharge;
        _parameter = parameter;
    }
    
    return self;
}


/// 获取支付订单
- (instancetype)initRequest_creatOrderWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLGoodsRequestType_creatOrder;
        _parameter = parameter;
    }
    
    return self;
}


/// 内购
- (instancetype)initRequest_creatIPAWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLGoodsRequestType_ipa;
        _parameter = parameter;
    }
    
    return self;
}



/// 支付宝异步回调
- (instancetype)initRequest_alipayNotifyWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLGoodsRequestType_alipayNotify;
        _parameter = parameter;
    }
    
    return self;
}
/// 支付宝同步回调
- (instancetype)initRequest_alipayReturnWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLGoodsRequestType_alipayReturn;
        _parameter = parameter;
    }
    
    return self;
}

/// 微信异步回调
- (instancetype)initRequest_wxpayNotifyWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = MOLGoodsRequestType_wxpayNotify;
        _parameter = parameter;
    }
    
    return self;
}

/// 支付凭证
- (instancetype)initRequest_paySignWithParameter:(NSDictionary *)parameter;
{
    self = [super init];
    if (self) {
        _type = MOLGoodsRequestType_paySign;
        _parameter = parameter;
    }
    
    return self;
}

- (id)requestArgument
{
    return _parameter;
}

- (Class)modelClass
{
    if (_type == MOLGoodsRequestType_goodsList) {
        return [MOLWalletGroupModel class];
    }
    return [MOLBaseModel class];
}

- (NSString *)requestUrl
{
    switch (_type) {
        case MOLGoodsRequestType_goodsList:
        {
            NSString *url = @"/diamond/goodsList";
            return url;
        }
            break;
        case MOLGoodsRequestType_creatCharge:
        {
            NSString *url = @"/payment/createCharge";
            return url;
        }
            break;
        case MOLGoodsRequestType_creatOrder:
        {
            NSString *url = @"/order/createOrder";
            return url;
        }
            break;
        case MOLGoodsRequestType_ipa:
        {
            NSString *url = @"/payment/iap";
            return url;
        }
            break;
        case MOLGoodsRequestType_alipayNotify:
        {
            NSString *url = @"/oripay/alipayNotifyUrl";
            return url;
        }
            break;
        case MOLGoodsRequestType_alipayReturn:
        {
            NSString *url = @"/oripay/alipayReturnUrl";
            return url;
        }
            break;
        case MOLGoodsRequestType_wxpayNotify:
        {
            NSString *url = @"/oripay/wxNotifyUrl";
            return url;
        }
            break;
        case MOLGoodsRequestType_paySign:
        {
            NSString *url = @"/oripay/paySign";
            return url;
        }
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)parameterId {
    if (!_parameterId.length) {
        return @"";
    }
    return _parameterId;
}
@end
