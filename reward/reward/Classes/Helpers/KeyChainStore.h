//
//  KeyChainStore.h
//  Jasmine
//
//  Created by xujin on 30/06/2017.
//  Copyright © 2017 xujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
