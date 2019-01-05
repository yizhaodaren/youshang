//
//  NSMutableAttributedString+AvoidCrash.h
//  PorklingTV
//
//  Created by xujin 16/10/15.
//  Copyright © 2016 xujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (AvoidCrash)

+ (void)avoidCrashExchangeMethod;

@end


/**
 *  Can avoid crash method
 *
 *  1.- (instancetype)initWithString:(NSString *)str
 *  2.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 */
