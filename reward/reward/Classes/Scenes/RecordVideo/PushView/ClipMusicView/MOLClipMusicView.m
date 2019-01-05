//
//  MOLClipMusicView.m
//  reward
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLClipMusicView.h"
#define MOLTimeLabelH 50.f

@interface MOLClipMusicView()<UIScrollViewDelegate>

@property(nonatomic,strong)UILabel *currentTimeLabel;
@property(nonatomic,strong)UIScrollView  *musicScrollView;
@property(nonatomic,strong)UIImageView  *waveImageView;
@property(nonatomic,strong)UIImageView  *progressImageView;



@property(nonatomic,assign)CGFloat waveH;
@property(nonatomic,strong)UIColor  *waveColor;
@property(nonatomic,strong)UIColor  *progressColor;

@property(nonatomic,strong)NSURL  *currentMusicUrl;
@property(nonatomic,assign)CGFloat  currentMusicDuration;
@property(nonatomic,assign)CGFloat  currentVoideDuration;
@end


@implementation MOLClipMusicView

-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show{
    self = [super initWithCustomH:height showBottom:show];
    if (self) {
        [self configData];
        [self customUI];
    }
    return self;
}
-(void)customUI{
     [self.customView addSubview:self.currentTimeLabel];
     [self.customView addSubview:self.musicScrollView];
    
     [self.musicScrollView addSubview:self.waveImageView];
     [self.musicScrollView addSubview:self.progressImageView];
}
-(void)configData{
    _waveColor = [UIColor whiteColor];
    _progressColor = [UIColor yellowColor];
    
}
-(void)updateWithMsic:(NSURL *)musicUrl WithVoideDuration:(CGFloat)duration{
    self.currentMusicUrl = musicUrl;
    self.currentVoideDuration = duration;
    self.currentMusicDuration = [CommUtls getFileDuration:musicUrl];

    CGFloat width = (self.musicScrollView.width * self.currentMusicDuration / duration);
    self.musicScrollView.contentSize = CGSizeMake(width,self.musicScrollView.height);
    self.waveImageView.width = width;
    self.progressImageView.width = 30.f;
    //绘制图片
     UIImage *renderedImage = [self drawImageFromCreaterWithMinValue:5 MaxValue:90];
    _waveImageView.image = renderedImage;
    _progressImageView.image =[CommUtls Chanage:renderedImage WithColor:_progressColor];
}

//根据时间更新
-(void)setProgressWithSecond:(Float64)second{
    if (self.currentVoideDuration > 0) {
        CGFloat progressWidth =  self.musicScrollView.width * second / self.currentVoideDuration;
        self.progressImageView.width = self.musicScrollView.contentOffset.x + progressWidth;
    }

}
#pragma mark 懒加载
-(UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.customView.width, MOLTimeLabelH)];
        _currentTimeLabel.text =  @"当前从00:00开始";
        _currentTimeLabel.textColor = HEX_COLOR(0xFFEC00);
        _currentTimeLabel.font = [UIFont systemFontOfSize:14];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}
-(UIScrollView *)musicScrollView{
    if (!_musicScrollView) {
        _musicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MOLTimeLabelH, self.customView.width, self.customView.height - 50)];
        _musicScrollView.contentSize = CGSizeMake(1000, self.customView.height - MOLTimeLabelH);
        _musicScrollView.bounces = NO;
        _musicScrollView.delegate = self;
    }
    return _musicScrollView;
}
-(UIImageView *)waveImageView{
    if (!_waveImageView) {
        _waveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.musicScrollView.contentSize.width, self.musicScrollView.height)];
 
        _waveImageView.contentMode = UIViewContentModeLeft;
    }
    return _waveImageView;
}
-(UIImageView *)progressImageView{
    if (!_progressImageView) {
        _progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, self.musicScrollView.height)];
        _progressImageView.contentMode = UIViewContentModeLeft;
        _progressImageView.clipsToBounds = YES;
    }
    return _progressImageView;
}

//音波图是随机数生成的假图，可根据自己需要生成图片
- (UIImage*)drawImageFromCreaterWithMinValue:(int)minValue
                                     MaxValue:(int)maxValue {
    CGSize imageSize =self.musicScrollView.contentSize;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetAlpha(context, 1.0);
    
    CGRect rect;
    rect.size = imageSize;
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    CGColorRef waveColor = _waveColor.CGColor;
    
    CGContextFillRect(context, rect);
    
    
    float lineWidth = 3.0;
    float lineSpace = 3.0;
    int lineCount = imageSize.width/(lineSpace+lineWidth)+1;
    
    CGContextSetLineWidth(context, lineWidth);
    
    float channelCenterY = imageSize.height / 2;
    
    
    for (NSInteger i = 0; i < lineCount; i++)
    {
        int value  = [self getRandomNumber:minValue to:maxValue];
        
        CGRect lineRect = CGRectMake(i*(lineSpace +lineWidth), channelCenterY - value / 2.0, lineWidth/2, value);
        CGContextSetLineWidth(context,lineWidth/2);
        CGContextSetStrokeColorWithColor(context, waveColor);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:lineRect cornerRadius:10];
        CGContextAddPath(context, bezierPath.CGPath);
        CGContextStrokePath(context);
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (int)getRandomNumber:(int)from to:(int)to {
    return (from + (arc4random()%(to-from+1)));
}


-(void)updateSTWith:(CGFloat)offset{
    CGFloat startTime =  self.currentMusicDuration * offset / self.musicScrollView.contentSize.width;
    
    
    NSInteger time = round(startTime);
    NSInteger sec = time % 60;
    NSInteger fen = time / 60;
    self.currentTimeLabel.text = [NSString stringWithFormat:@"当前从%02ld:%02ld开始",fen,sec];
    
    if (self.updateSTBlock) {
        self.updateSTBlock(startTime);
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"活动中%f",scrollView.contentOffset.x);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"结束滑动滑动");
    
    [self updateSTWith:scrollView.contentOffset.x];

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  
//当decelerate为YES的时候 还会调用 DidendDecelear 如果为NO则不会再调用了
    if (!decelerate) {
          [self updateSTWith:scrollView.contentOffset.x];
          NSLog(@"结束拖动YES");
    
    }
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
     NSLog(@"scrollViewDidZoom");
}
@end
