//
//  MOLApplePayManager.m
//  reward
//
//  Created by moli-2017 on 2018/10/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLApplePayManager.h"

#import "MOLGoodsRequest.h"
#import <XYIAPKit.h>
#import <XYStoreUserDefaultsPersistence.h>

@interface MOLApplePayManager ()<SKPaymentTransactionObserver,SKProductsRequestDelegate,XYStoreReceiptVerifier>
{
    NSString           *_purchID;
    IAPCompletionHandle _handle;
    ProductCompletionHandle _ProductHandle;
}
@property (nonatomic, strong) NSArray *productIdentifiers;
@end

@implementation MOLApplePayManager

+ (instancetype)shareApplePayManager
{
    static MOLApplePayManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[MOLApplePayManager alloc] init];
        }
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
//        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        self.productIdentifiers = @[@"1E42E6",
                                    @"2E84E12",
                                    @"3E210E30",
                                    @"4E420E60",
                                    @"5E756E108",
                                    @"6E3626E518"
                                    ];
        
        [[XYStore defaultStore] registerReceiptVerifier:self];
    }
    return self;
}

- (void)dealloc{
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

// 获取商品信息列表
- (void)requestProductDataWithcompleteHandle:(ProductCompletionHandle)handle
{
    _ProductHandle = handle;
    NSSet * set = [NSSet setWithArray:self.productIdentifiers];
//    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
//    request.delegate = self;
//    [request start];
    
    
    [[XYStore defaultStore] requestProducts:set success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
        NSArray *sortedArray = [products sortedArrayUsingDescriptors:sortDescriptors];
        
        if (handle) {
            handle(sortedArray);
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessageAMoment:@"获取商品列表失败"];
    }];
}

- (void)startPurchWithID:(NSString *)purchId
{
    if (purchId) {
        _purchID = purchId;
        if ([SKPaymentQueue canMakePayments]) {
            // 开始购买服务
            [MBProgressHUD showMessage:nil];
            [[XYStore defaultStore] addPayment:purchId success:^(SKPaymentTransaction *transaction) {
                
            } failure:^(SKPaymentTransaction *transaction, NSError *error) {
                [MBProgressHUD hideHUD];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MOL_IAP_PRO"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }];
        }else{
            [MBProgressHUD showMessageAMoment:@"您的设备不允许程序内购买商品"];
        }
    }
}


- (void)verifyTransaction:(SKPaymentTransaction*)transaction
                  success:(void (^)(void))successBlock
                  failure:(void (^)(NSError *error))failureBlock
{
    
    [MBProgressHUD hideHUD];
    // 服务器验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    //
    NSString *str = [receipt base64EncodedStringWithOptions:0];
    
    [self startServiceRecei:str];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// 重新验证
- (void)startServiceRecei:(NSString *)rec
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"receipt"] = rec;
    dic[@"payEnv"] = @"1";
#ifdef MOL_TEST_HOST
    dic[@"payEnv"] = @"0";
#endif
    [[NSUserDefaults standardUserDefaults] setObject:rec forKey:@"MOL_IAP_PRO"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD showMessage:@"验证订单"];
    MOLGoodsRequest *r = [[MOLGoodsRequest alloc] initRequest_creatIPAWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        [MBProgressHUD hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (code == MOL_SUCCESS_REQUEST) {
                
                [MBProgressHUD showMessageAMoment:@"订单验证成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MOL_PING_PAY" object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"MOL_IAP_PRO"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else{
                [MBProgressHUD showMessageAMoment:@"订单验证失败,请关闭app重试"];
            }
        });
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessageAMoment:@"订单验证失败,请关闭app重试"];
    }];
}









- (void)handleActionWithType:(SIAPPurchType)type data:(NSData *)data{
#if DEBUG
    switch (type) {
        case SIAPPurchSuccess:
            NSLog(@"购买成功");
            break;
        case SIAPPurchFailed:
            NSLog(@"购买失败");
            break;
        case SIAPPurchCancle:
            NSLog(@"用户取消购买");
            break;
        case SIAPPurchVerFailed:
            NSLog(@"订单校验失败");
            break;
        case SIAPPurchVerSuccess:
            NSLog(@"订单校验成功");
            break;
        case SIAPPurchNotArrow:
            NSLog(@"不允许程序内付费");
            break;
        default:
            break;
    }
#endif
    if(_handle){
        _handle(type,data);
    }
}

// 交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;
    
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
//
        NSString *str = [receipt base64EncodedStringWithOptions:0];
//
//        NSLog(@"%@",str);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"receipt"] = str;
        dic[@"payEnv"] = @"1";
#ifdef MOL_TEST_HOST
        dic[@"payEnv"] = @"0";
#endif
        MOLGoodsRequest *r = [[MOLGoodsRequest alloc] initRequest_creatIPAWithParameter:dic];
        [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
           
            if (code == MOL_SUCCESS_REQUEST) {
                [self handleActionWithType:SIAPPurchVerSuccess data:nil];
            }else{
                [self handleActionWithType:SIAPPurchVerFailed data:nil];
            }
        } failure:^(__kindof MOLBaseNetRequest *request) {
            [self handleActionWithType:SIAPPurchVerFailed data:nil];
        }];
        
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

//    [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO];
}

// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:SIAPPurchFailed data:nil];
    }else{
        [self handleActionWithType:SIAPPurchCancle data:nil];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag{
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];

    if(!receipt){
        // 交易凭证为空验证失败
        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
    // 购买成功将交易凭证发送给服务端进行再次校验
    [self handleActionWithType:SIAPPurchSuccess data:receipt];

    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];

    if (!requestData) { // 交易凭证为空验证失败
        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }

    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt

    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
    if (flag) {
        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   // 无法连接服务器,购买校验失败
                                   [self handleActionWithType:SIAPPurchVerFailed data:nil];
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) {
                                       // 苹果服务器校验数据返回为空校验失败
                                       [self handleActionWithType:SIAPPurchVerFailed data:nil];
                                   }

                                   // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
                                   NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
                                   if (status && [status isEqualToString:@"21007"]) {
                                       [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
                                   }else if(status && [status isEqualToString:@"0"]){
                                       [self handleActionWithType:SIAPPurchVerSuccess data:nil];
                                   }
#if DEBUG
                                   NSLog(@"----验证结果 %@",jsonResponse);
#endif
                               }
                           }];


    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortedArray = [response.products sortedArrayUsingDescriptors:sortDescriptors];
    
    if (_ProductHandle) {
        _ProductHandle(sortedArray);
    }
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
#if DEBUG
    NSLog(@"------------------错误-----------------:%@", error);
#endif
}

- (void)requestDidFinish:(SKRequest *)request{
#if DEBUG
    NSLog(@"------------反馈信息结束-----------------");
#endif
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
#if DEBUG
                NSLog(@"商品添加进列表");
#endif
                break;
            case SKPaymentTransactionStateRestored:
#if DEBUG
                NSLog(@"已经购买过商品");
#endif
                // 消耗型不支持恢复购买
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }
}
@end
