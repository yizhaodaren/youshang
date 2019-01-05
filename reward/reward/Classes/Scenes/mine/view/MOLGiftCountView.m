//
//  MOLGiftCountView.m
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLGiftCountView.h"

#define kAniNumWidth 10
#define kAniNumHeight 12

@interface MOLGiftCountView ()

@property (nonatomic, strong) NSString *drawNumber;

@end
@implementation MOLGiftCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _beginNumber = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 从传入的数值获得字符串和翻转图形上下文
    NSString *numString = self.drawNumber;
    
    if (numString.integerValue <= 0) {
        return;
    }
    // 获取当前图形上下文
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(imageContext, 0, rect.size.height);
    CGContextScaleCTM(imageContext, 1.0, -1.0);
    
    
    //3 绘制数值 - 先绘制X
    UIImage *crossImage = [UIImage imageNamed:@"x_icon"];
    CGRect crossRect = CGRectMake(0, (self.height-kAniNumHeight) * 0.5, kAniNumWidth, kAniNumHeight);
    CGContextDrawImage(imageContext, crossRect, crossImage.CGImage);
    
    // 绘制数字
    for (NSUInteger index = 0; index<numString.length; index++)
    {
        NSString *digit = [numString substringWithRange:NSMakeRange(index, 1)];
        
        UIImage *digitImage = [UIImage imageNamed: [NSString stringWithFormat:@"num_%@", digit]];
        
        // 绘制到合适位置
        CGRect drawRect = CGRectMake(kAniNumWidth + kAniNumWidth * (index),(self.height - kAniNumHeight) * 0.5, kAniNumWidth, kAniNumHeight);
        CGContextDrawImage(imageContext, drawRect, digitImage.CGImage);
    }
    
}

- (void)setBeginNumber:(NSInteger)beginNumber
{
    _beginNumber = beginNumber;
    
    [self drawAgain];
}


- (void)drawAgain
{
    _drawNumber = [NSString stringWithFormat:@"%ld",(long)_beginNumber];
    [self setNeedsDisplay];
    
}
@end
