//
//  MOLApplePayManager.h
//  reward
//
//  Created by moli-2017 on 2018/10/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
typedef enum {
    SIAPPurchSuccess = 0,       // 购买成功
    SIAPPurchFailed = 1,        // 购买失败
    SIAPPurchCancle = 2,        // 取消购买
    SIAPPurchVerFailed = 3,     // 订单校验失败
    SIAPPurchVerSuccess = 4,    // 订单校验成功
    SIAPPurchNotArrow = 5,      // 不允许内购
}SIAPPurchType;

typedef void (^IAPCompletionHandle)(SIAPPurchType type,NSData *data);
typedef void (^ProductCompletionHandle)(NSArray *product);

@interface MOLApplePayManager : NSObject
+ (instancetype)shareApplePayManager;

// 获取商品信息列表
- (void)requestProductDataWithcompleteHandle:(ProductCompletionHandle)handle;

// 发起内购请求
- (void)startPurchWithID:(NSString *)purchId;

// 重新验证
- (void)startServiceRecei:(NSString *)rec;

@end
