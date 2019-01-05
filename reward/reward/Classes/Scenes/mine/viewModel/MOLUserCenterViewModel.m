//
//  MOLUserCenterViewModel.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLUserCenterViewModel.h"

@implementation MOLUserCenterViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUserCenterViewModel];
    }
    return self;
}

- (void)setupUserCenterViewModel
{
    // 用户的个人信息
    @weakify(self);
    self.userInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            //获取数据
            
            
            return nil;
        }];
        
        return signal;
    }];
    
    // 用户的作品
    self.userProductionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            //获取数据
            
            
            return nil;
        }];
        
        return signal;
    }];
    
    // 用户的悬赏
    self.userRewardCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            //获取数据
            
            
            return nil;
        }];
        
        return signal;
    }];
    
    // 用户的喜欢
    self.userLikeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            //获取数据
            
            
            return nil;
        }];
        
        return signal;
    }];
    
}
@end
