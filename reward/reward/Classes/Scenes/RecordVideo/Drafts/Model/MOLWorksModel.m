//
//  MOLWorksModel.m
//  reward
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLWorksModel.h"


@implementation MOLWorksModel

+(LKDBHelper *)getUsingLKDBHelper{
static LKDBHelper *helper;
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
     NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/DB/sqlite.db"];
     helper = [[LKDBHelper alloc] initWithDBPath:path];
        
    });
    return helper;
    
}


+(NSString *)getTableName{
    
    return NSStringFromClass([self class]);
    
}



+(BOOL)dbWillInsert:(NSObject *)entity{
    
    NSLog(@"will insert");
    
    return YES;
    
}
+(void)dbDidCreateTable:(LKDBHelper*)helper tableName:(NSString*)tableName{
    
}


//+(void)dbDidAlterTable:(LKDBHelper*)helper tableName:(NSString*)tableName addColumns:(NSArray*)columns;
//
//+(BOOL)dbWillInsert:(NSObject*)entity;
+(void)dbDidInserted:(NSObject*)entity result:(BOOL)result{
    
}
//
//+(BOOL)dbWillUpdate:(NSObject*)entity;
//+(void)dbDidUpdated:(NSObject*)entity result:(BOOL)result;
//
//+(BOOL)dbWillDelete:(NSObject*)entity;
//+(void)dbDidDeleted:(NSObject*)entity result:(BOOL)result;
//
/////data read finish
//+(void)dbDidSeleted:(NSObject*)entity;


@end
