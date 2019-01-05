//
//  AnimateView.m
//  ani
//
//  Created by moli-2017 on 2018/11/1.
//  Copyright © 2018 aletter-2018. All rights reserved.
//

#import "AnimateView.h"


@interface AnimateView ()<CAAnimationDelegate>

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIImageView *imageView1;
@property (nonatomic, weak) UIImageView *imageView2;
@property (nonatomic, weak) UIImageView *imageView3;

@property (nonatomic, assign) BOOL isStop;
@end

@implementation AnimateView

- (instancetype)initWithFrame:(CGRect)frame withTpye:(MOLAnimateViewTYPE)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animateType = type;
        [self setupUI];
        self.isStop = YES;
        
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    _imageView = imageView;
//    imageView.image = [UIImage imageNamed:@"Group 17"];
//    imageView.frame = CGRectMake(self.frame.size.width * 0.5 - 25, self.frame.size.height-50, 50, 50);
//    [self addSubview:imageView];
    
    
    
    UIImage * image1 = [UIImage imageNamed:@"music2_float"];
    UIImage * image2 = [UIImage imageNamed:@"music3_float"];
    UIImage * image3 = [UIImage imageNamed:@"music1_float"];
    
    if (self.animateType == MOLAnimateViewTYPEe_flower) {
        image1 = [UIImage imageNamed:@"music2_float"];
        image2 = [UIImage imageNamed:@"music3_float"];
        image3 = [UIImage imageNamed:@"music1_float"];
    }else{
        image1 = [UIImage imageNamed:@"god1_float"];
        image2 = [UIImage imageNamed:@"god4_float"];
        image3 = [UIImage imageNamed:@"god3_float"];
    }
    
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    _imageView1 = imageView1;
    imageView1.image = image1;
    imageView1.alpha = 0;
    imageView1.frame = CGRectMake(self.frame.size.width * 0.5 - 8, self.frame.size.height-8, 16, 16);
    [self addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    _imageView2 = imageView2;
    imageView2.image = image2;
    imageView2.alpha = 0;
    imageView2.frame = CGRectMake(self.frame.size.width * 0.5 - 8, self.frame.size.height-8, 16, 16);
    [self addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] init];
    _imageView3 = imageView3;
    imageView3.image = image3;
    imageView3.alpha = 0;
    imageView3.frame = CGRectMake(self.frame.size.width * 0.5 - 6.5, self.frame.size.height-6.5, 13, 13);
    [self addSubview:imageView3];
    
}




- (void)calculatorFrame{}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorFrame];
}

- (void)beginAnimate
{
    [self stopAnimate];
    self.isStop = NO;
    [self pathAnimate];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 4];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = 5;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [rotationAnimation setValue:@"image_animate" forKey:@"AnimationKey"];
    [self.imageView.layer addAnimation:rotationAnimation forKey:@"image_animate"];
}

- (void)pathAnimate
{
    if (self.imageView1.layer.animationKeys.count) {
        return;
    }
    CAAnimationGroup *group1 = [self getGroupAni:0];
    [group1 setValue:@"image_animate1" forKey:@"AnimationKey"];
    group1.delegate = self;
    [self.imageView1.layer addAnimation:group1 forKey:@"image_animate1"];
    
    CAAnimationGroup *group2 = [self getGroupAni:1];
    [group2 setValue:@"image_animate2" forKey:@"AnimationKey"];
    group2.delegate = self;
    [self.imageView2.layer addAnimation:group2 forKey:@"image_animate2"];
    
    CAAnimationGroup *group3 = [self getGroupAni:2];
    [group3 setValue:@"image_animate3" forKey:@"AnimationKey"];
    group3.delegate = self;
    [self.imageView3.layer addAnimation:group3 forKey:@"image_animate3"];
    
}

- (CAAnimationGroup *)getGroupAni:(CGFloat)delayed
{
    CGFloat t = 3;
    CGFloat totalT = t + delayed;
    
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.5;
    opacityAnimation.beginTime = delayed;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1);
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *apath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5) radius:self.frame.size.width * 0.5 startAngle:M_PI / 2 endAngle:M_PI clockwise:YES];
    animation.path = apath.CGPath;
    animation.duration = t;
    animation.beginTime = delayed;
 
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI * 0.2];
    rotationAnimation.cumulative = YES;
    rotationAnimation.duration = t;
    rotationAnimation.beginTime = delayed;
    
    CABasicAnimation *opacityAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation1.duration = 1;
    opacityAnimation1.beginTime = totalT - 1;
    opacityAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation1.fromValue = @(1.0);
    opacityAnimation1.toValue = @(0.0);
    
    group1.animations = @[opacityAnimation,animation,rotationAnimation,opacityAnimation1];
    group1.repeatCount = 1;
    group1.duration = totalT;
    
    return group1;
}

- (void)pauseAnimate
{
    if (self.imageView1.layer.speed == 0) {
        return;
    }
    
    CFTimeInterval pauseTime = [self.imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    CFTimeInterval pauseTime1 = [self.imageView1.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    CFTimeInterval pauseTime2 = [self.imageView2.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    CFTimeInterval pauseTime3 = [self.imageView3.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    self.imageView.layer.timeOffset = pauseTime;
    self.imageView1.layer.timeOffset = pauseTime1;
    self.imageView2.layer.timeOffset = pauseTime2;
    self.imageView3.layer.timeOffset = pauseTime3;
    
    self.imageView.layer.speed = 0;
    self.imageView1.layer.speed = 0;
    self.imageView2.layer.speed = 0;
    self.imageView3.layer.speed = 0;
}

- (void)resumeAnimate
{
    
    if (self.isStop) {
        [self beginAnimate];
        return;
    }
    
    if (self.imageView1.layer.speed != 0) {
        return;
    }
    CFTimeInterval pauseTime = self.imageView.layer.timeOffset;
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    [self.imageView.layer setTimeOffset:0];
    [self.imageView.layer setBeginTime:begin];
    self.imageView.layer.speed = 1;
    
    CFTimeInterval pauseTime1 = self.imageView1.layer.timeOffset;
    CFTimeInterval begin1 = CACurrentMediaTime() - pauseTime1;
    [self.imageView1.layer setTimeOffset:0];
    [self.imageView1.layer setBeginTime:begin1];
    self.imageView1.layer.speed = 1;
    
    CFTimeInterval pauseTime2 = self.imageView2.layer.timeOffset;
    CFTimeInterval begin2 = CACurrentMediaTime() - pauseTime2;
    [self.imageView2.layer setTimeOffset:0];
    [self.imageView2.layer setBeginTime:begin2];
    self.imageView2.layer.speed = 1;
    
    CFTimeInterval pauseTime3 = self.imageView3.layer.timeOffset;
    CFTimeInterval begin3 = CACurrentMediaTime() - pauseTime3;
    [self.imageView3.layer setTimeOffset:0];
    [self.imageView3.layer setBeginTime:begin3];
    self.imageView3.layer.speed = 1;
}

- (void)stopAnimate
{
    self.isStop = YES;
    [self.imageView.layer removeAllAnimations];
    [self.imageView1.layer removeAllAnimations];
    [self.imageView2.layer removeAllAnimations];
    [self.imageView3.layer removeAllAnimations];
    
    self.imageView.layer.speed = 1;
    self.imageView1.layer.speed = 1;
    self.imageView2.layer.speed = 1;
    self.imageView3.layer.speed = 1;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        CABasicAnimation * animation = (CABasicAnimation *)anim;
        if ([[animation valueForKey:@"AnimationKey"] isEqualToString:@"image_animate1"]) {
            [self.imageView1.layer removeAllAnimations];
            CAAnimationGroup *group1 = [self getGroupAni:0];
            [group1 setValue:@"image_animate1" forKey:@"AnimationKey"];
            group1.delegate = self;
            [self.imageView1.layer addAnimation:group1 forKey:@"image_animate1"];
            
        }else if ([[animation valueForKey:@"AnimationKey"] isEqualToString:@"image_animate2"]){
            [self.imageView2.layer removeAllAnimations];
            CAAnimationGroup *group2 = [self getGroupAni:0];
            [group2 setValue:@"image_animate2" forKey:@"AnimationKey"];
            group2.delegate = self;
            [self.imageView2.layer addAnimation:group2 forKey:@"image_animate2"];
        }else if ([[animation valueForKey:@"AnimationKey"] isEqualToString:@"image_animate3"]){
            [self.imageView3.layer removeAllAnimations];
            CAAnimationGroup *group3 = [self getGroupAni:0];
            [group3 setValue:@"image_animate3" forKey:@"AnimationKey"];
            group3.delegate = self;
            [self.imageView3.layer addAnimation:group3 forKey:@"image_animate3"];
        }
    }
}

- (void)dealloc
{
    [self stopAnimate];
}
- (void)setFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, 100, 100);
    [super setFrame:frame];
}
@end
