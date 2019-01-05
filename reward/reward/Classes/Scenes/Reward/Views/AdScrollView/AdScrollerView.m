//
//  DemoScrollerView.m
//  GunDongDemo
//
//  Created by Lemon on 15/4/21.
//  Copyright (c) 2015年 Lemon. All rights reserved.
//

#import "AdScrollerView.h"
#import "UIImageView+WebCache.h"
#import "BannerModel.h"
#import <AVFoundation/AVFoundation.h>
#import "MOLPageControl.h"
static const NSTimeInterval imgTime=3;
static const NSTimeInterval videoTime=8;





@implementation AdScrollerView
{
    
    NSMutableArray *_imgArr;
    CGRect viewSize;
    UIScrollView *scrollView;
    NSArray *imageArray;
    NSArray *titleArray;
    MOLPageControl *pageControl;
    NSInteger    currentPage;
    UILabel *noteTitle;
    NSTimer *_moveTime;
    BOOL _isTimeUp;
    NSInteger _pageCount;
    
}

@synthesize currentPageIndex=currentPageIndex;
@synthesize currentPageIdx =currentPageIdx;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewSize = frame;
        [self setBackgroundColor:HEX_COLOR(0xf1f1f1)];
        
    }
    return self;
}







-(void) setContent:(NSArray *)arr{
    
    _imgArr =[NSMutableArray new];
    
    NSString *imgURL = nil;
    NSURL *imageUrl = nil;
    UIImageView *imgView = nil;
    
    for (id view in scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    
    for (id views in self.subviews) {
        [views removeFromSuperview];
    }
    
    //scrollView =nil;
    
    
            if ([arr count] <= 0) {// 没有需要下载的广告情况
                return;
            }else if([arr count] ==1){ //只有1张图片
    
               _imgArr =[arr mutableCopy];
    
            }else if([arr count] >1){ //大于1张图片
    
                _imgArr =[arr mutableCopy];
    
                [_imgArr insertObject:arr[arr.count-1] atIndex:0];
                [_imgArr addObject:arr[0]];
    
            }
    
    NSLog(@"0--->%@",scrollView);
    for (id vivi in scrollView.subviews) {
        NSLog(@"2--->%@",vivi);
    }
    
    NSLog(@"1--->%@",self);
    for (id vivi in self.subviews) {
        NSLog(@"3--->%@",vivi);
    }
    
    
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
    scrollView.pagingEnabled = YES;
    scrollView.tag=8000;
    scrollView.contentSize = CGSizeMake(viewSize.size.width *_imgArr.count, viewSize.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    
    for (int i=0; i<_imgArr.count; i++) {
        
        BannerModel *bannerDto =[BannerModel new];
        bannerDto =_imgArr[i];
        
        if (bannerDto.bannerType.integerValue==1) {//作品
            
            imgURL=bannerDto.image;
            
        }else{//表示web
            
            imgURL=bannerDto.image;
        }
        
        imageUrl = [NSURL URLWithString:imgURL];
        
        
        imgView=[[UIImageView alloc] init];
        
        [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        
        if (_imgArr.count==1) { //只有一个数据
            imgView.tag =1001;
        }
        else{
            imgView.tag =1000+i;
        }
        
        

                [imgView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"bannerDefine"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (error) {
                        NSLog(@"下载失败%@",error);
                        
                    }
                }];
        
        
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
        [Tap setNumberOfTapsRequired:1];
        [Tap setNumberOfTouchesRequired:1];
        imgView.userInteractionEnabled=YES;
        [imgView addGestureRecognizer:Tap];
        [scrollView addSubview:imgView];
    }

    [self addSubview:scrollView];
    
    
    if ([_imgArr count]==1) {
        currentPageIdx=0;
    }
    
    
    
    if ([_imgArr count] > 1) {
        
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
        UIImageView *bottomImgView =[UIImageView new];
        [bottomImgView setImage: [UIImage imageNamed:@"Group 8"]];
        [bottomImgView setFrame:CGRectMake(0, viewSize.size.height-100,viewSize.size.width, 100)];
        [self addSubview:bottomImgView];
        
        //说明文字层
        float pageControlWidth = (_imgArr.count-2)*10.0f+40.f;
        float pageControlHeight=20.0f;
        
        pageControl=[[MOLPageControl alloc]initWithFrame:CGRectMake(10,(scrollView.frame.size.height-pageControlHeight-10), pageControlWidth, pageControlHeight)];
    

        pageControl.tag=999;
        pageControl.currentPage=0;
        pageControl.numberOfPages=_imgArr.count-2;
        [scrollView.superview addSubview:pageControl];
        currentPageIdx=1;
//        pageControl.currentPageIndicatorTintColor = HEX_COLOR(0xFACE15);
//        pageControl.pageIndicatorTintColor = HEX_COLOR_ALPHA(0xffffff,0.8);

       
        [self timeRunLoopEvent:imgTime];
            

        
    }
}

-(void)timeRunLoopEvent:(NSTimeInterval)time{
    
    [self lDeallocTimer];
    
    _moveTime = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    //消息循环  线程
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:_moveTime forMode:NSRunLoopCommonModes];
    
}


// Get the video's center frame as video poster image
- (UIImage *)frameImageFromVideoURL:(NSURL *)videoURL {
    // result
    UIImage *image = nil;
    
    // AVAssetImageGenerator
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    // calculate the midpoint time of video
    // Float64 duration = CMTimeGetSeconds([asset duration]);
    // 取某个帧的时间，参数一表示哪个时间（秒），参数二表示每秒多少帧
    // 通常来说，600是一个常用的公共参数，苹果有说明:
    // 24 frames per second (fps) for film, 30 fps for NTSC (used for TV in North America and
    // Japan), and 25 fps for PAL (used for TV in Europe).
    // Using a timescale of 600, you can exactly represent any number of frames in these systems
    CMTime midpoint = CMTimeMakeWithSeconds(1, 1);
    
    // get the image from
    NSError *error = nil;
    CMTime actualTime;
    // Returns a CFRetained CGImageRef for an asset at or near the specified time.
    // So we should mannully release it
    CGImageRef centerFrameImage = [imageGenerator copyCGImageAtTime:midpoint
                                                         actualTime:&actualTime
                                                              error:&error];
    
    if (centerFrameImage != NULL) {
        image = [[UIImage alloc] initWithCGImage:centerFrameImage];
        // Release the CFRetained image
        CGImageRelease(centerFrameImage);
    }
    
    return image;
}


#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    if (currentPageIndex == 1) {
        currentPageIndex ++;
        
    }
    
    if (currentPageIndex <= ([_imgArr count])) {
        [UIView animateWithDuration:0.5f animations:^{
            scrollView.contentOffset = CGPointMake(currentPageIndex * scrollView.frame.size.width, 0);
        }];
        currentPageIndex ++;
        
    }
    
    if (currentPageIndex==0) {
        
        [scrollView setContentOffset:CGPointMake(([_imgArr count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([_imgArr count])) {
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }
    
    if (videoTime) {
        
        if (scrollView.contentOffset.x==viewSize.size.width) {//表示在第一个可视视图
            
            [self timeRunLoopEvent: videoTime];
            
        }else{
            
            [self timeRunLoopEvent: imgTime];
            
        }
        
    }
    
}
#pragma mark scrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    currentPageIdx =page;
    pageControl.currentPage=(page-1);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    _scrollView = scrollView;
    if (currentPageIndex==0) {
        
        [_scrollView setContentOffset:CGPointMake(([_imgArr count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([_imgArr count] - 1)) {
        
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }
    
    if (videoTime) {
        
        if (_scrollView.contentOffset.x==viewSize.size.width) {//表示在第一个可视视图
            
            [self timeRunLoopEvent: videoTime];
            
        }else{
            
             [self timeRunLoopEvent: imgTime];
            
        }
        
    }
    
}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    
    if ([_delegate respondsToSelector:@selector(DemoScrollerViewDidClicked:)]) {
        [_delegate DemoScrollerViewDidClicked:sender.view.tag];
    }
    
}

- (void)imgBtnClick{
    
    NSLog(@"跳转到固定页面");
    
}

- (void)startTimerEvent{
    
    if (scrollView.contentOffset.x==viewSize.size.width) {//表示在第一个可视视图
        
        [self timeRunLoopEvent: videoTime];
        
    }else{
        
        [self timeRunLoopEvent: imgTime];
        
    }
    
}

/**
 销毁定时器
 */
-(void) lDeallocTimer{
    
    
    if ([_moveTime isValid]) {
        [_moveTime invalidate];
        _moveTime=nil;
    }
}

- (void)dealloc
{
    
    [self lDeallocTimer];
}


@end
