//
//  NSMutableAttributedString+AttExtention.h
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (AttExtention)

- (CGFloat)mol_getAttributedTextHeightWithMaxWith:(CGFloat)width font:(UIFont *)font;
-(CGFloat)mol_getThreeAttributedTextHeightWithMaxWith:(CGFloat)height font:(UIFont *)font;
@end
