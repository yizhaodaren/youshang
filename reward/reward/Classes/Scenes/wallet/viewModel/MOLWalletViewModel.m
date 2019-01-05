//
//  MOLWalletViewModel.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLWalletViewModel.h"

#import "MOLGoodsRequest.h"

@implementation MOLWalletViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupWalletViewModel];
    }
    return self;
}

- (void)setupWalletViewModel
{
    @weakify(self);
    self.rechargeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            MOLGoodsRequest *r = [[MOLGoodsRequest alloc] initRequest_goodsListWithParameter:nil];
            [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                [subscriber sendNext:responseModel];
                [subscriber sendCompleted];
            } failure:^(__kindof MOLBaseNetRequest *request) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }];
            
            
            return nil;
        }];
        
        return signal;
    }];
}

@end
