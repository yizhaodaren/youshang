//
//  MOLAccountViewModel.h
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLAccountViewModel : NSObject
/// 获取验证码
@property (nonatomic, strong) RACCommand *codeCommand;
/// 登录(快捷登录、三方登录、密码登录、找回密码登录)
@property (nonatomic, strong) RACCommand *loginCommand;
/// 修改密码
@property (nonatomic, strong) RACCommand *changePswCommand;
/// 修改用户信息
@property (nonatomic, strong) RACCommand *changeInfoCommand;
/// 绑定（手机+三方）
@property (nonatomic, strong) RACCommand *bindingCommand;
/// 解除绑定三方
@property (nonatomic, strong) RACCommand *removeBindingCommand;
/// 获取用户信息
@property (nonatomic, strong) RACCommand *userInfoCommand;
/// 用户账户信息
@property (nonatomic, strong) RACCommand *userAccountCommand;

@property (nonatomic, strong) NSString *phoneNumber;  // 手机号码

@property (nonatomic, strong) NSString *codeString; // 验证码
@property (nonatomic, strong) NSString *pwdString; // 密码
@property (nonatomic, strong) RACSignal *bindingNextSignal; // 绑定-->下一步
@property (nonatomic, strong) RACSignal *bindingFinishSignal; // 绑定-->完成

@property (nonatomic, strong) NSString *oldPswString; // 老密码
@property (nonatomic, strong) NSString *nowPwdString; // 新密码
@property (nonatomic, strong) NSString *againPwdString; // 确认密码
@property (nonatomic, strong) RACSignal *changePswFinishSignal; // 修改密码-->完成

@property (nonatomic, strong) RACSignal *setPswFinishSignal; // 设置密码-->完成
@end
