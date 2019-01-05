//
//  DMHeartFlyView.m
//  DMHeartFlyAnimation
//
//  Created by Rick on 16/3/9.
//  Copyright © 2016年 Rick. All rights reserved.
//

#define DMRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define DMRGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define DMRandColor DMRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#import "DMHeartFlyView.h"

@interface DMHeartFlyView ()
@property(nonatomic,strong) UIColor *strokeColor;
@property(nonatomic,strong) UIColor *fillColor;
@property (nonatomic, weak) UIImageView *heartImageView;
@end

@implementation DMHeartFlyView

-(instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        _strokeColor = [UIColor whiteColor];
        _fillColor = DMRandColor;
        self.backgroundColor = [UIColor clearColor];

        UIImageView *heartImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heilongjiangtubiao12"]];
        _heartImageView = heartImageView;
        [self addSubview:heartImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.heartImageView.frame = self.bounds;
}

static CGFloat PI = M_PI;
-(void)animateInView:(UIView *)view{
    
    //Pre-Animation setup
    self.transform = CGAffineTransformMakeScale(0, 0);
    self.alpha = 0;
    
    //Bloom
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        NSInteger i = arc4random_uniform(3);
        NSInteger rotationDirection = 1- (2*i*0.5);// -1 0 1
        CGFloat rotationFraction = (arc4random_uniform(10) + 1) * 0.1;
        self.transform = CGAffineTransformMakeRotation(rotationDirection * rotationFraction);
        self.alpha = 0.9;
    } completion:^(BOOL finished) {
        CABasicAnimation *keyFrameAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        keyFrameAnimation.toValue = @(self.centerY - 140);
        keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        keyFrameAnimation.duration = 0.5;
        [self.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    }];
    
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformScale(self.transform, 2.0f, 2.0f);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


//-(void)drawRect:(CGRect)rect{
//    [self drawHeartInRect:rect];
//}

-(void)drawHeartInRect:(CGRect)rect{
    [_strokeColor setStroke];
    [_fillColor setFill];
    
    CGFloat drawingPadding = 4.0;
    CGFloat curveRadius = floor((CGRectGetWidth(rect) - 2*drawingPadding) / 4.0);
    
    //Creat path
    UIBezierPath *heartPath = [UIBezierPath bezierPath];
    
    //Start at bottom heart tip
    CGPoint tipLocation = CGPointMake(floor(CGRectGetWidth(rect) / 2.0), CGRectGetHeight(rect) - drawingPadding);
    [heartPath moveToPoint:tipLocation];
    
    //Move to top left start of curve
    CGPoint topLeftCurveStart = CGPointMake(drawingPadding, floor(CGRectGetHeight(rect) / 2.4));
    
    [heartPath addQuadCurveToPoint:topLeftCurveStart controlPoint:CGPointMake(topLeftCurveStart.x, topLeftCurveStart.y + curveRadius)];
    
    //Create top left curve
    [heartPath addArcWithCenter:CGPointMake(topLeftCurveStart.x + curveRadius + 2, topLeftCurveStart.y) radius:curveRadius + 2 startAngle:PI endAngle: - M_PI * 0.2 clockwise:YES];
    
    //Create top right curve
    CGPoint topRightCurveStart = CGPointMake(topLeftCurveStart.x + 2*curveRadius - 2, topLeftCurveStart.y);
    [heartPath addArcWithCenter:CGPointMake(topRightCurveStart.x + curveRadius, topRightCurveStart.y) radius:curveRadius + 2 startAngle:PI + M_PI * 0.2 endAngle:0 clockwise:YES];
    
    //Final curve to bottom heart tip
    CGPoint topRightCurveEnd = CGPointMake(topLeftCurveStart.x + 4*curveRadius, topRightCurveStart.y);
    [heartPath addQuadCurveToPoint:tipLocation controlPoint:CGPointMake(topRightCurveEnd.x, topRightCurveEnd.y + curveRadius)];
    
    [heartPath fill];
    
    heartPath.lineWidth = 1;
    heartPath.lineCapStyle = kCGLineCapRound;
    heartPath.lineJoinStyle = kCGLineCapRound;
    [heartPath stroke];
}


@end
