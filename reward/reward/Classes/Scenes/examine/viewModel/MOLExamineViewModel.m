//
//  MOLExamineViewModel.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExamineViewModel.h"
#import "MOLMessagePageRequest.h"
#import "MOLUserPageRequest.h"

@implementation MOLExamineViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupExamineViewModel];
    }
    return self;
}

- (void)setupExamineViewModel
{
    // 评选列表
    @weakify(self);
    self.examineListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSDictionary *dic = (NSDictionary *)input;
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            MOLMessagePageRequest *r = [[MOLMessagePageRequest alloc] initRequest_getExamineListWithParameter:dic];
            
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
    
    // 评选红包列表
    self.examinePacketCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSDictionary *dic = (NSDictionary *)input;
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            //获取数据
            MOLUserPageRequest *r = [[MOLUserPageRequest alloc] initRequest_getProductionListWithParameter:dic];
            
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

//http://demo-videos.qnsdk.com/shortvideo/%E7%8B%97.mp4

@end
