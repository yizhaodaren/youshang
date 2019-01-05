//
//  MOLRegular.m
//  aletter
//
//  Created by moli-2017 on 2018/8/2.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "MOLRegular.h"

@implementation MOLRegular
+ (BOOL)mol_RegularMobileNumber:(NSString *)mobileNum
{
    NSString *userNameRegex = @"^1\\d{10}$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    
    return [userNamePredicate evaluateWithObject:mobileNum];
}
@end
