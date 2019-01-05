//
//  MOLAccountViewModel.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAccountViewModel.h"
#import "MOLRegular.h"
#import "MOLLoginRequest.h"

@implementation MOLAccountViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupAccountViewModel];
    }
    return self;
}

- (void)setupAccountViewModel
{
    @weakify(self);
    RACSignal *phoneSignal = [RACObserve(self, phoneNumber) map:^id(id value) {
        @strongify(self);
        return @([self isPhoneNum:value]);
    }];
    
    // 绑定-->下一步
    self.bindingNextSignal = [RACSignal combineLatest:@[phoneSignal] reduce:^id(NSNumber *phone){
        return @(phone.integerValue);
    }];
    
    // 绑定-->完成
    RACSignal *pwdSignal = [RACObserve(self, pwdString) map:^id(id value) {
        
        return @([value length] > 0);
    }];
    
    RACSignal *codeSignal = [RACObserve(self, codeString) map:^id(id value) {
        
        return @([value length] >= 4);
    }];
    
    self.bindingFinishSignal = [RACSignal combineLatest:@[codeSignal, pwdSignal] reduce:^id(NSNumber *code, NSNumber *pwd){
        return @(code.integerValue && pwd.integerValue);
    }];
    
    
    // 修改密码 --> 完成
    RACSignal *oldpwdSignal = [RACObserve(self, oldPswString) map:^id(id value) {
        
        return @([value length] > 0);
    }];
    
    RACSignal *nowpwdSignal = [RACObserve(self, nowPwdString) map:^id(id value) {
        
        return @([value length] > 0);
    }];
    
    RACSignal *againpwdSignal = [RACObserve(self, againPwdString) map:^id(id value) {
        
        return @([value length] > 0);
    }];
    
    self.changePswFinishSignal = [RACSignal combineLatest:@[oldpwdSignal, nowpwdSignal, againpwdSignal] reduce:^id(NSNumber *old, NSNumber *now, NSNumber *again){
        return @(old.integerValue && now.integerValue && again.integerValue);
    }];
    
    // 设置密码
    self.setPswFinishSignal = [RACSignal combineLatest:@[nowpwdSignal, againpwdSignal] reduce:^id(NSNumber *now, NSNumber *again){
        return @(now.integerValue && again.integerValue);
    }];
    
    // 发送验证码
    self.codeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSDictionary *dic = (NSDictionary *)input;
        UIButton *btn = dic[@"button"];
        NSString *paraId = [dic mol_jsonString:@"paraId"];
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // 获取数据
            [MBProgressHUD showMessage:nil];
            MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_getCodeWithParameter:nil parameterId:paraId];
            
            [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                
                if (code == MOL_SUCCESS_REQUEST) {
                    // 开启定时器
                    if (btn) {
                        [[MOLCodeTimerManager shareCodeTimerManager] codeTimer_beginTimerWithButton:btn timeDownBlock:nil];
                    }else{
                        [[MOLCodeTimerManager shareCodeTimerManager] codeTimer_beginTimerWithButton:nil timeDownBlock:nil];
                    }
                    if (message.integerValue != 0) {
                        [MBProgressHUD showMessageAMoment:message];
                    }else{
                        [MBProgressHUD showMessageAMoment:@"验证码发送成功"];
                    }
                }else{
                    btn.enabled = YES;
                    [MBProgressHUD showMessageAMoment:message];
                }
                
                [subscriber sendNext:@(code)];
                [subscriber sendCompleted];
                [MBProgressHUD hideHUD];
            } failure:^(__kindof MOLBaseNetRequest *request) {
                btn.enabled = YES;
                [subscriber sendCompleted];
                [MBProgressHUD hideHUD];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
    
    // 登录
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSDictionary *dict = (NSDictionary *)input;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        NSString *inviteUuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"reward_invite"];
        if (inviteUuid.length) {
            dic[@"inviteUuid"] = inviteUuid;
        }
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // 获取数据
            MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_loginWithParameter:dic];
            
            [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                
                MOLUserModel *user = (MOLUserModel *)responseModel;
                [subscriber sendNext:user];
                [subscriber sendCompleted];
                
                if (code == MOL_SUCCESS_REQUEST) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"reward_invite"];
             
                    NSInteger loginType = (NSInteger)[dict objectForKey:@"loginType"];
                    [[NSUserDefaults standardUserDefaults] setInteger:loginType forKey:@"lastLoginType"];
                    
                }
                
            } failure:^(__kindof MOLBaseNetRequest *request) {
                
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        
        return signal;
    }];
    
    // 获取用户信息
    self.userInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSString *paraId = (NSString *)input;
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // 获取数据
            MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_getUserInfoWithParameter:nil parameterId:paraId];
            
            [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                
                MOLUserModel *user = (MOLUserModel *)responseModel;
                [subscriber sendNext:user];
                [subscriber sendCompleted];
                
            } failure:^(__kindof MOLBaseNetRequest *request) {
                
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        
        return signal;
    }];
    
    // 修改用户信息
    self.changeInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSDictionary *dic = (NSDictionary *)input;
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // 获取数据
            MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_changeInfoWithParameter:dic];
            
            [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                
                MOLUserModel *user = (MOLUserModel *)responseModel;
                [subscriber sendNext:user];
                [subscriber sendCompleted];
                
            } failure:^(__kindof MOLBaseNetRequest *request) {
                
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
    
    // 修改密码
    self.changePswCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSDictionary *dic = (NSDictionary *)input;
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // 获取数据
            MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_changePasswordWithParameter:dic];
            
            [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                
                if (code == MOL_SUCCESS_REQUEST) {
                    [MBProgressHUD showMessageAMoment:@"密码修改成功"];
                }else if (code == 11000){
                    [MBProgressHUD showMessageAMoment:@"原密码输入错误"];
                }else{
                    [MBProgressHUD showMessageAMoment:message];
                }
                [subscriber sendNext:@(code)];
                [subscriber sendCompleted];
                
            } failure:^(__kindof MOLBaseNetRequest *request) {
                
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
    
    // 绑定(三方+手机)
    self.bindingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [MBProgressHUD showMessage:nil];
        NSDictionary *dic = (NSDictionary *)input;
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // 获取数据
            MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_bindingWithParameter:dic];
            
            [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                [MBProgressHUD hideHUD];
                if (code == MOL_SUCCESS_REQUEST) {
                    [MBProgressHUD showMessageAMoment:@"绑定成功"];
                }else{
                    [MBProgressHUD showMessageAMoment:message];
                }
                [subscriber sendNext:@(code)];
                [subscriber sendCompleted];
                
            } failure:^(__kindof MOLBaseNetRequest *request) {
                [MBProgressHUD hideHUD];
                [subscriber sendNext:@(-1)];
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
    
    // 解除绑定
    self.removeBindingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [MBProgressHUD showMessage:nil];
        NSString *type = (NSString *)input;
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // 获取数据
            MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_removeBindingWithParameter:nil parameterId:type];
            
            [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                [MBProgressHUD hideHUD];
                if (code == MOL_SUCCESS_REQUEST) {
                    [MBProgressHUD showMessageAMoment:@"解除绑定成功"];
                }else{
                    [MBProgressHUD showMessageAMoment:message];
                }
                [subscriber sendNext:@(code)];
                [subscriber sendCompleted];
                
            } failure:^(__kindof MOLBaseNetRequest *request) {
                [MBProgressHUD hideHUD];
                [subscriber sendNext:@(-1)];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        
        return signal;
    }];
    
    // 获取用户账户信息
    self.userAccountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // 获取数据
            MOLLoginRequest *r = [[MOLLoginRequest alloc] initRequest_userAccountWithParameter:nil];
            
            [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                
                [subscriber sendNext:responseModel];
                [subscriber sendCompleted];
                
            } failure:^(__kindof MOLBaseNetRequest *request) {
                
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        
        return signal;
    }];
}

- (BOOL)isPhoneNum:(NSString *)number
{
    if ([MOLRegular mol_RegularMobileNumber:[number stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        return number.length == 13;
    }
    return NO;
}
@end
