//
//  NSDictionary+MOLDictionaryExtention.h
//  aletter
//
//  Created by moli-2017 on 2018/7/31.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MOLDictionaryExtention)

- (NSString *)mol_jsonString:(NSString *)key;

- (NSDictionary *)mol_jsonDict:(NSString *)key;
- (NSArray *)mol_jsonArray:(NSString *)key;
- (NSArray *)mol_jsonStringArray:(NSString *)key;

- (BOOL)mol_jsonBool:(NSString *)key;
- (NSInteger)mol_jsonInteger:(NSString *)key;
- (long long)mol_jsonLongLong:(NSString *)key;
- (unsigned long long)mol_jsonUnsignedLongLong:(NSString *)key;

- (double)mol_jsonDouble:(NSString *)key;
@end
