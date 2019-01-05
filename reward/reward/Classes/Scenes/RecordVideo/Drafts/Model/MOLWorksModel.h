//
//  MOLWorksModel.h
//  reward
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 reward. All rights reserved.
//

//作品和悬赏
#import <Foundation/Foundation.h>
#import <NSObject+LKDBHelper.h>
@interface MOLWorksModel : NSObject

//悬赏信息

@property(copy,nonatomic)NSString* contextText;
@property(copy,nonatomic)NSData *audioData;
@property(copy,nonatomic)NSString* audioUrl;
@property(strong,nonatomic)UIImage* coverImage;
@property(strong,nonatomic)NSDate* createTime;




//@property NSUInteger  age;
//@property BOOL isGirl;
//@property(strong,nonatomic)LKTestForeign* address;
//@property(strong,nonatomic)NSArray* blah;
//@property(strong,nonatomic)NSDictionary* hoho;
//
//@property char like;
@end
