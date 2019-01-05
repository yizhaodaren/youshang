//
//  MOLProgressBar.m
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLProgressBar.h"

#define DEVICE_BOUNDS [[UIScreen mainScreen] bounds]
#define DEVICE_SIZE [[UIScreen mainScreen] bounds].size
#define RGB_COLOR_ALPHA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


#define MOL_HEX_COLOR_ALPHA(_HEX_,a) [UIColor colorWithRed:((float)((_HEX_ & 0xFF0000) >> 16))/255.0 green:((float)((_HEX_ & 0xFF00) >> 8))/255.0 blue:((float)(_HEX_ & 0xFF))/255.0 alpha:a]

#define TIMER_INTERVAL 1.0f

@interface MOLProgressBar ()
{
    CGFloat _barHeight;
}

@property (strong, nonatomic) NSMutableArray *progressViewArray;
@property (strong, nonatomic) UIView *barView;
@property (strong, nonatomic) UIImageView *progressIndicator;
@property (strong, nonatomic) NSTimer *shiningTimer;

@end

@implementation MOLProgressBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _barHeight = frame.size.height;
        [self initalize];
    }
    return self;
}

- (void)initalize {
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [UIColor clearColor];
    self.progressViewArray = [[NSMutableArray alloc] init];
    
    //barView
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _barHeight)];
    _barView.backgroundColor = MOL_HEX_COLOR_ALPHA(0x909189, 0.5);
//    /[UIColor redColor];
//    RGB_COLOR_ALPHA(43, 42, 55, 1);
    [self addSubview:_barView];
    
    //最短分割线
//    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(self.width * (MOL_RecordMinTime/MOL_RecordMaxTime), 0, 1, _barHeight)];
//    intervalView.backgroundColor = [UIColor blackColor];
//    [_barView addSubview:intervalView];
 
    
    //indicator
    self.progressIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, _barHeight)];
    _progressIndicator.backgroundColor = [UIColor clearColor];
    _progressIndicator.image = [UIImage imageNamed:@"progressbar_front.png"];
    [self addSubview:_progressIndicator];
}

- (UIView *)getProgressView {
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, _barHeight)];
    progressView.backgroundColor = MOL_HEX_COLOR_ALPHA(0xFFEC00, 1);
//    RGB_COLOR_ALPHA(229, 61, 146, 1);
    progressView.autoresizesSubviews = YES;
    
    return progressView;
}

- (void)refreshIndicatorPosition {
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        _progressIndicator.center = CGPointMake(0, self.frame.size.height / 2);
        return;
    }
    
    _progressIndicator.center = CGPointMake(MIN(lastProgressView.frame.origin.x + lastProgressView.frame.size.width, self.frame.size.width - _progressIndicator.frame.size.width / 2 + 2), self.frame.size.height / 2);
}

- (void)onTimer:(NSTimer *)timer
{
    [UIView animateWithDuration:TIMER_INTERVAL / 2 animations:^{
        _progressIndicator.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:TIMER_INTERVAL / 2 animations:^{
            _progressIndicator.alpha = 1;
        }];
    }];
}

#pragma mark -- method
- (void)startShining {
    self.shiningTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)stopShining {
    [_shiningTimer invalidate];
    self.shiningTimer = nil;
    _progressIndicator.alpha = 1;
}

- (void)addProgressView {
    UIView *lastProgressView = [_progressViewArray lastObject];
    CGFloat newProgressX = 0.0f;
    
    if (lastProgressView) {
        CGRect frame = lastProgressView.frame;
        frame.size.width -= 1;
        lastProgressView.frame = frame;
        
        newProgressX = frame.origin.x + frame.size.width + 1;
    }
    
    UIView *newProgressView = [self getProgressView];
    [self setView:newProgressView toOriginX:newProgressX];
    
    [_barView addSubview:newProgressView];
    
    [_progressViewArray addObject:newProgressView];
}

- (void)setLastProgressToWidth:(CGFloat)width {
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
          [self setView:lastProgressView toSizeWidth:width];
    }];
    [self refreshIndicatorPosition];
}

- (void)setLastProgressToStyle:(MOLProgressBarProgressStyle)style {
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    switch (style) {
        case MOLProgressBarProgressStyleDelete:
        {
            lastProgressView.backgroundColor = [UIColor redColor];
            _progressIndicator.hidden = YES;
        }
            break;
        case MOLProgressBarProgressStyleNormal:
        {
            lastProgressView.backgroundColor = RGB_COLOR_ALPHA(43, 42, 55, 1);
            _progressIndicator.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)deleteLastProgress {
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [lastProgressView removeFromSuperview];
    [_progressViewArray removeLastObject];
    
    _progressIndicator.hidden = NO;
    
    [self refreshIndicatorPosition];
}

- (void)deleteAllProgress {

    while (_progressViewArray.count) {
        UIView *progressView = _progressViewArray.lastObject;
        [progressView removeFromSuperview];
        [_progressViewArray removeLastObject];
    }
    _progressIndicator.hidden = NO;
    [self refreshIndicatorPosition];

}

- (void)setView:(UIView *)view toSizeWidth:(CGFloat)width {
    
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

- (void)setView:(UIView *)view toOriginX:(CGFloat)x {
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

- (void)setView:(UIView *)view toOriginY:(CGFloat)y {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

- (void)setView:(UIView *)view toOrigin:(CGPoint)origin {
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
}

- (void)dealloc {
    _progressViewArray = nil;
    _barView = nil;
    _progressIndicator = nil;
    [_shiningTimer invalidate];
    _shiningTimer = nil;
}
- (void)setMinTime:(CGFloat)minTime AndMaxTime:(CGFloat)maxTime{
    //最短分割线
    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(self.width * (minTime/maxTime), 0, 1, _barHeight)];
    intervalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [_barView addSubview:intervalView];
}
@end

