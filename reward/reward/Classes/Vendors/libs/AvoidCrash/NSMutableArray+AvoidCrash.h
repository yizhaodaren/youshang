//
//  NSMutableArray+AvoidCrash.h
//  PorklingTV
//
//  Created by xujin 16/9/21.
//  Copyright © 2016 xujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (AvoidCrash)

+ (void)avoidCrashExchangeMethod;

@end


/**
 *  Can avoid crash method
 *
 *  1. - (id)objectAtIndex:(NSUInteger)index
 *  2. - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
 *  3. - (void)removeObjectAtIndex:(NSUInteger)index
 *  4. - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
 *
 */
