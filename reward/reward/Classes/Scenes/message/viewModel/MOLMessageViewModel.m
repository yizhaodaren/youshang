//
//  MOLMessageViewModel.m
//  reward
//
//  Created by 刘宏亮 on 2018/9/16.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMessageViewModel.h"
#import "MOLMessageListModel.h"

@implementation MOLMessageViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupMessageViewModel];
    }
    return self;
}

- (void)setupMessageViewModel
{
    @weakify(self);
    self.messageListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            //获取数据
            NSArray *arr = [[MOLYXManager shareYXManager] yx_getAllChatSession];
            
            [subscriber sendNext:arr];
            [subscriber sendCompleted];
            
            return nil;
        }];
        
        return signal;
    }];
}
@end
