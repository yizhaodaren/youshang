//
//  MOLChooseRechargeView.m
//  reward
//
//  Created by moli-2017 on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLChooseRechargeView.h"
#import "MOLGoodsRequest.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface MOLChooseRechargeView ()
@property (nonatomic, weak) UIView *alphaView;  // 顶部view
@property (nonatomic, weak) UIView *bottomView;  // 底部白色view
@property (nonatomic, weak) UILabel *label1; // 选择支付方式
@property (nonatomic, weak) UIButton *closeButton;
@property (nonatomic, weak) UIView *lineView1;
@property (nonatomic, weak) UIButton *wxButton;
@property (nonatomic, weak) UIView *lineView2;
@property (nonatomic, weak) UIButton *zfbButton;

@property (nonatomic, strong) NSString *goodId;
@end

@implementation MOLChooseRechargeView

+ (void)chooseRechargeView_showWith:(NSString *)goodId
{
    MOLChooseRechargeView *v = [[MOLChooseRechargeView alloc] init];
    v.width = MOL_SCREEN_WIDTH;
    v.height = MOL_SCREEN_HEIGHT;
    v.y = MOL_SCREEN_HEIGHT;
    v.goodId = goodId;
    [MOLAppDelegateWindow addSubview:v];
    
    [UIView animateWithDuration:0.5 animations:^{
        v.y = 0;
    } completion:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChooseRechargeViewUI];
    }
    return self;
}

#pragma mark - dismiss
- (void)dimiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.y = MOL_SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 按钮点击
- (void)button_clickAlphaView
{
    [self dimiss];
}
- (void)button_clickClose
{
    [self dimiss];
}
- (void)button_clickWX
{
    [self dimiss];
    
    // 获取订单信息
    [self creatChargeWithGoodId:self.goodId channel:@"1" payment:^(NSString *json) {
        
        NSDictionary *dict = [self convertjsonStringToDict:json];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.package             = [dict objectForKey:@"package"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }];
}

- (NSDictionary *)convertjsonStringToDict:(NSString *)jsonString{
    
    NSDictionary *retDict = nil;
    if ([jsonString isKindOfClass:[NSString class]]) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        return  retDict;
    }else{
        return retDict;
    }
}

- (void)button_clickZFB
{
    [self dimiss];
    [self creatChargeWithGoodId:self.goodId channel:@"2" payment:^(NSString *json) {
        NSString *appScheme = @"alisdk34ad04b90532e44c";
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:json fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }];
}

#pragma mark - 获取支付凭证
- (void)creatChargeWithGoodId:(NSString *)goodId channel:(NSString *)channel payment:(void(^)(NSString *json))paymentBlock
{
    
    [MBProgressHUD showMessage:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"channelId"] = channel;
    dic[@"goodsId"] = goodId;
    
    MOLGoodsRequest *r = [[MOLGoodsRequest alloc] initRequest_creatOrderWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
       
        if (code == MOL_SUCCESS_REQUEST) {
            NSString *order = request.responseObject[@"resBody"][@"orderId"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"orderId"] = order;
            dict[@"channelId"] = channel;
            
//            MOLGoodsRequest *r1 = [[MOLGoodsRequest alloc] initRequest_creatChargeWithParameter:dict];
            MOLGoodsRequest *r1 = [[MOLGoodsRequest alloc] initRequest_paySignWithParameter:dict];
            
            [r1 baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                [MBProgressHUD hideHUD];
                if (code == MOL_SUCCESS_REQUEST) {
                    
                    if (paymentBlock) {
                        paymentBlock(request.responseObject[@"resBody"]);
                    }
                    
                }else{
                    [MBProgressHUD showMessageAMoment:message];
                }
                
            } failure:^(__kindof MOLBaseNetRequest *request) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showMessageAMoment:@"支付失败"];
            }];
            
        }else{
            [MBProgressHUD showMessageAMoment:message];
        }
    } failure:^(__kindof MOLBaseNetRequest *request) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessageAMoment:@"支付失败"];
    }];
}

#pragma mark - UI
- (void)setupChooseRechargeViewUI
{
    UIView *alphaView = [[UIView alloc] init];
    _alphaView = alphaView;
    alphaView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button_clickAlphaView)];
    [alphaView addGestureRecognizer:tap];
    [self addSubview:alphaView];
    
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UILabel *label1 = [[UILabel alloc] init];
    _label1 = label1;
    label1.text = @"选择支付方式";
    label1.textColor = HEX_COLOR_ALPHA(0x000000, 1);
    label1.font = MOL_MEDIUM_FONT(14);
    [bottomView addSubview:label1];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton = closeButton;
    [closeButton setImage:[UIImage imageNamed:@"withdraw_shut_down"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(button_clickClose) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:closeButton];
    
    UIView *lineView1 = [[UIView alloc] init];
    _lineView1 = lineView1;
    lineView1.backgroundColor = HEX_COLOR_ALPHA(0xEDEDED, 1);
    [bottomView addSubview:lineView1];
    
    UIButton *wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wxButton = wxButton;
    [wxButton setImage:[UIImage imageNamed:@"withdraw_weixin"] forState:UIControlStateNormal];
    [wxButton setTitle:@"微信支付" forState:UIControlStateNormal];
    [wxButton setTitleColor:HEX_COLOR_ALPHA(0x000000, 0.6) forState:UIControlStateNormal];
    wxButton.titleLabel.font = MOL_MEDIUM_FONT(14);
    wxButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    wxButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [wxButton addTarget:self action:@selector(button_clickWX) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:wxButton];
    
    UIView *lineView2 = [[UIView alloc] init];
    _lineView2 = lineView2;
    lineView2.backgroundColor = HEX_COLOR_ALPHA(0xEDEDED, 1);
    [bottomView addSubview:lineView2];
    
    UIButton *zfbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _zfbButton = zfbButton;
    [zfbButton setImage:[UIImage imageNamed:@"withdraw_zhifubao"] forState:UIControlStateNormal];
    [zfbButton setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [zfbButton setTitleColor:HEX_COLOR_ALPHA(0x000000, 0.6) forState:UIControlStateNormal];
    zfbButton.titleLabel.font = MOL_MEDIUM_FONT(14);
    zfbButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    zfbButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [zfbButton addTarget:self action:@selector(button_clickZFB) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:zfbButton];
}

- (void)calculatorChooseRechargeViewFrame
{
    self.alphaView.width = MOL_SCREEN_WIDTH;
    self.alphaView.height = MOL_SCREEN_HEIGHT - 180;
    
    self.bottomView.width = MOL_SCREEN_WIDTH;
    self.bottomView.height = 180;
    self.bottomView.y = self.alphaView.bottom;
    
    [self.label1 sizeToFit];
    self.label1.centerX = self.bottomView.width * 0.5;
    self.label1.y = 10;
    
    [self.closeButton sizeToFit];
    self.closeButton.right = self.bottomView.width - 20;
    self.closeButton.centerY = self.label1.centerY;
    self.closeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    
    self.lineView1.width = self.bottomView.width;
    self.lineView1.height = 1;
    self.lineView1.y = 40;
    
    self.wxButton.width = self.bottomView.width - 20;
    self.wxButton.height = 70;
    self.wxButton.x = 20;
    self.wxButton.y = self.lineView1.bottom;
    
    self.lineView2.width = self.bottomView.width;
    self.lineView2.height = 1;
    self.lineView2.y = self.wxButton.bottom;
    
    self.zfbButton.width = self.bottomView.width - 20;
    self.zfbButton.height = 70;
    self.zfbButton.x = 20;
    self.zfbButton.y = self.lineView2.bottom;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorChooseRechargeViewFrame];
}
@end
