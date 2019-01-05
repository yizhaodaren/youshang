//
//  MOLAltHelper.m
//  reward
//
//  Created by apple on 2018/11/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLAltHelper.h"

#define kATRegular @"\b.*?\b"//匹配用户的正则
#define MOL_textColor  HEX_COLOR(0xFFD479) //@用户的字体颜色

@implementation MOLAltHelper
+ (instancetype)shared
{
    static MOLAltHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil)
        {
            instance = [[MOLAltHelper alloc] init];
        }
    });
    return instance;
}

-(void)changeAltColorWith:(UITextView *)textView WithOriginalFont:(UIFont *)font AndFontColor:(UIColor *)color{
    
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变,就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.string.length)];
   
    if (!font) {
        string.yy_color = [UIColor whiteColor];
        string.yy_font = MOL_FONT(14);
    }else{
        string.yy_color = color;
        string.yy_font = font;
    }
  
    
    NSArray *matches = [self findAllAtWith:textView];
    
    for (NSTextCheckingResult *match in matches)
    {
        [string addAttribute:NSForegroundColorAttributeName value:MOL_textColor range:NSMakeRange(match.range.location, match.range.length - 1)];
    }
    
    textView.attributedText = string;
}
- (NSArray<NSTextCheckingResult *> *)findAllAtWith:(UITextView *)textView
{
    // 找到文本中所有的@
    NSString *string = textView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}
@end
