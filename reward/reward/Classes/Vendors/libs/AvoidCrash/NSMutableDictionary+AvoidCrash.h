//
//  NSMutableDictionary+AvoidCrash.h
//  PorklingTV
//
//  Created by xujin 16/9/22.
//  Copyright © 2016 xujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (AvoidCrash)

+ (void)avoidCrashExchangeMethod;

@end


/**
 *  Can avoid crash method
 *
 *  1. - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
 *  2. - (void)removeObjectForKey:(id)aKey
 *
 */
