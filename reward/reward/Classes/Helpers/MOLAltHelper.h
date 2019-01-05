//
//  MOLAltHelper.h
//  reward
//
//  Created by apple on 2018/11/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOLAltHelper : NSObject
+ (instancetype)shared;
-(void)changeAltColorWith:(UITextView *)textView WithOriginalFont:(UIFont *)font AndFontColor:(UIColor *)color;
@end
