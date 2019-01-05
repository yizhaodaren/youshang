//
//  MOLClipMovieView.m
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLClipMovieView.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <Masonry.h>
#import "UIImage+PLSClip.h"

#define TEMP_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define TEMP_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define TEMP_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#define TEMP_MinImageCount 9   // 显示的图片最少个数
#define TEMP_ImagesViewH 50.0  // 预览图高度


#define TEMP_LineW 4         // 线宽
#define TEMP_LRDistance 20.f //左右边距

#define TEMP_DragViewW 15.f //拖动View的宽度

#define TEMP_DragViewH (TEMP_ImagesViewH + TEMP_LineW*2) //拖动View的高度
#define TEMP_LRAddDragWDis (TEMP_LRDistance + TEMP_DragViewW) //距离➕拖动View的宽度

//浮标
#define TEMP_BuoyW 5.f
#define TEMP_BuoyH (TEMP_DragViewH + 10.0)

#define TEMP_EffectiveScreenW (TEMP_SCREEN_WIDTH - TEMP_LRAddDragWDis * 2)//有效屏幕的宽度
#define TEMP_ImagesVIewW (TEMP_EffectiveScreenW / TEMP_MinImageCount) // 图片宽度




@interface MOLClipMovieViewCell ()

@property (strong, nonatomic) UIImageView *scaledIamgeView;

@end

@implementation MOLClipMovieViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scaledIamgeView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.scaledIamgeView.clipsToBounds = YES;
        self.scaledIamgeView.contentMode =
        UIViewContentModeScaleAspectFill;
//        UIViewContentModeScaleAspectFit;
        [self addSubview:self.scaledIamgeView];
    }
    return self;
}
-(void)layoutImageView{
    self.scaledIamgeView.x = 0;
    self.scaledIamgeView.y = 0;
    self.scaledIamgeView.width = self.width;
    self.scaledIamgeView.height = self.height;
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    self.clipsToBounds = YES;
    self.layer.borderColor = HEX_COLOR(0xFFEC00).CGColor;
}
-(void)setBorder{
        self.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = HEX_COLOR(0xFFEC00).CGColor;
}
- (void)setImageData:(UIImage *)imageData {
    _imageData = imageData;
    self.scaledIamgeView.image = imageData;
}

@end


static NSString * const MOLClipMovieViewCellId = @"MOLClipMovieViewCellId";

@interface MOLClipMovieView () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) AVAsset *asset; // 视频对象
@property (nonatomic, assign) Float64 frameRate; // 帧率
@property (assign, nonatomic) Float64 minDuration; // 截取视频的最短时间
@property (assign, nonatomic) Float64 maxDuration; // 截取视频的最长时间
@property (nonatomic, assign) Float64 totalSeconds; // 总秒数
@property (nonatomic, assign) Float64 screenSeconds; // 当前屏幕显示的秒数

@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;

@property (nonatomic, assign) Float64 leftSecond; // 左侧滑块代表的时间
@property (nonatomic, assign) Float64 rightSecond; // 右侧滑块代表的时间
@property (nonatomic, assign) Float64 offsetSecond; // 偏移量时间

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionImages;

@property (nonatomic, strong) UILabel *startTimeLabel; // 开始秒数
@property (nonatomic, strong) UILabel *endTimeLabel; // 结束秒数
@property (nonatomic, strong) UILabel *clipSecondLabel; // 一共截多少秒

@property (nonatomic, strong) UIView *leftDragView; // 左边时间拖拽view
@property (nonatomic, strong) UIView *rightDragView; // 右边时间拖拽view
@property (nonatomic, strong) UIView *progressBarView; // 进度播放view

//bottom
@property (nonatomic, strong) UILabel *bottomTitleLable; // 底部标题
@property (nonatomic, strong) UIButton *closeButton; // 关闭按钮
@property (nonatomic, strong) UIButton *endButton; // 选择结束

@property (nonatomic,assign)CGFloat lastCellScallRatio;//最后一个cell的宽度比其他的小的倍率

@property (nonatomic,strong)UIImageView *ImageView;

@property(nonatomic,assign)NSUInteger imageCount;


@end

@implementation MOLClipMovieView

- (instancetype)initWithMovieURL:(NSURL *)url minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration {
    AVAsset *asset = [AVAsset assetWithURL:url];
    return [self initWithMovieAsset:asset minDuration:minDuration maxDuration:maxDuration];
}

- (instancetype)initWithMovieAsset:(AVAsset *)asset minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration {
    self = [super init];
    if (self) {
        self.asset = asset;
        self.minDuration = minDuration;
        self.maxDuration = maxDuration;
        [self initView];
        [self initDataFromAsset:asset];
    }
    return self;
}

#pragma mark - 初始化
- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//    //开始时间
//    [self addSubview:self.startTimeLabel];
//    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.top.mas_equalTo(23);
//    }];
//
//    //结束时间
//    [self addSubview:self.endTimeLabel];
//    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.top.mas_equalTo(self.startTimeLabel);
//    }];
    
    //已经选取的时间
    [self addSubview:self.clipSecondLabel];
    [self.clipSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
         make.top.mas_equalTo(23);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.clipSecondLabel.mas_bottom).offset(18);
        make.height.mas_equalTo(TEMP_ImagesViewH);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self setUpDragView];
    
    //裁剪
    [self addSubview:self.bottomTitleLable];
    [self.bottomTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.collectionView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
    }];
    //X号
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TEMP_LRDistance);
        make.centerY.mas_equalTo(self.bottomTitleLable);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    //对号
    [self addSubview:self.endButton];
    [self.endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-TEMP_LRDistance);
        make.centerY.mas_equalTo(self.bottomTitleLable);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

/** 初始化拖拽view */
- (void)setUpDragView {
    // 添加左右拖拽view
    UIView *leftDragView = [UIView new];
//    [leftDragView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftDragGesture:)]];
    leftDragView.layer.contents = (id) [UIImage imageNamed:@"cut_bar_left"].CGImage;
    [self addSubview:leftDragView];
    self.leftDragView = leftDragView;
    [leftDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TEMP_DragViewW,TEMP_DragViewH));
        make.left.mas_equalTo(TEMP_LRDistance);
        make.centerY.mas_equalTo(self.collectionView);
    }];

    
    UIView *rightDragView = [UIView new];
//    [rightDragView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightDragGesture:)]];
    rightDragView.layer.contents = (id) [UIImage imageNamed:@"cut_bar_right"].CGImage;
    [self addSubview:rightDragView];
    self.rightDragView = rightDragView;
    [rightDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TEMP_DragViewW, TEMP_DragViewH));
        make.right.mas_equalTo(-TEMP_LRDistance);
        make.centerY.mas_equalTo(self.collectionView);
    }];
    
    
    //******************************************手动画的条纹****************************************//
//    //添加条纹
//    UIView *viewL = [[UIView alloc] init];
//    viewL.backgroundColor =  TEMP_RGBCOLOR(252, 221, 0);
//    [self.leftDragView addSubview:viewL];
//    [viewL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(TEMP_DragViewW/2, TEMP_DragViewH/2));
//        make.center.mas_equalTo(leftDragView);
//    }];
//    //添加条纹
//    UIView *viewR = [[UIView alloc] init];
//    viewR.backgroundColor =  TEMP_RGBCOLOR(252, 221, 0);
//    [self.rightDragView addSubview:viewR];
//    [viewR mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(TEMP_DragViewW/2, TEMP_DragViewH/2));
//        make.center.mas_equalTo(rightDragView);
//    }];
//
//    CGFloat w = TEMP_DragViewW/2 / 5.0;
//    CGFloat h = TEMP_DragViewH/2;
//    for (int i = 0; i<3; i++) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(2*i*w, 0, 0.8, h)];
//        view.backgroundColor = [UIColor darkGrayColor];
//        view.layer.cornerRadius = 1;
//
//        UIView *viewT = [[UIView alloc] initWithFrame:CGRectMake(2*i*w, 0, 0.8, h)];
//        viewT.backgroundColor = [UIColor darkGrayColor];
//        viewT.layer.cornerRadius = 1;
//
//        [viewL addSubview:viewT];
//        [viewR addSubview:view];
//    }
//******************************************手动画的条纹****************************************//
    
    // 添加一个底层黄色背景的view
    UIView *topLinView = [UIView new];
    topLinView.backgroundColor = TEMP_RGBCOLOR(252, 221, 0);
    [self insertSubview:topLinView belowSubview:self.collectionView];
    [topLinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftDragView.mas_right);
        make.right.mas_equalTo(rightDragView.mas_left);
       
        make.top.mas_equalTo(self.collectionView.mas_top).offset(-TEMP_LineW);
        make.height.mas_offset(TEMP_LineW);
    }];
    
    UIView *bottomLinView = [UIView new];
    bottomLinView.backgroundColor = TEMP_RGBCOLOR(252, 221, 0);
    [self insertSubview:bottomLinView belowSubview:self.collectionView];
    [bottomLinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftDragView.mas_right);
        make.right.mas_equalTo(rightDragView.mas_left);
        make.bottom.mas_equalTo(self.collectionView.mas_bottom).offset(TEMP_LineW);
        make.height.mas_offset(TEMP_LineW);
    }];
//
//    // 添加左右侧阴影view
//    UIView *leftShadowView = [UIView new];
//    leftShadowView.userInteractionEnabled = NO;
//    leftShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    [self addSubview:leftShadowView];
//    [leftShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(leftDragView.mas_left);
//        make.top.bottom.mas_equalTo(imagesBackView);
//    }];
//
//    UIView *rightShadowView = [UIView new];
//    rightShadowView.userInteractionEnabled = NO;
//    rightShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    [self addSubview:rightShadowView];
//    [rightShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.left.mas_equalTo(rightDragView.mas_right);
//        make.top.bottom.mas_equalTo(imagesBackView);
//    }];
    
    UIView *progressBarView = [UIView new];
//    progressBarView.hidden = YES;
//    progressBarView.layer.contents = (id) [UIImage imageNamed:@"cut_bar_progress"].CGImage;
    progressBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:progressBarView];
    self.progressBarView = progressBarView;
    [progressBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TEMP_BuoyW);
        make.height.mas_equalTo(TEMP_BuoyH);
        make.left.mas_equalTo(self.leftDragView.mas_right);
        make.centerY.mas_equalTo(self.collectionView);
    }];
    progressBarView.layer.cornerRadius = 2;
    
}

- (void)initDataFromAsset:(AVAsset *)asset {
    
    //设置初始值
    self.offsetSecond = 0.0f;//默认偏移量
    CMTime cmtime = asset.duration;
    self.totalSeconds = CMTimeGetSeconds(cmtime);
    self.leftSecond = 0.f;
    self.rightSecond = self.totalSeconds > self.maxDuration ? self.maxDuration :self.totalSeconds;
    
    
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        self.frameRate = [[asset tracksWithMediaType:AVMediaTypeVideo][0] nominalFrameRate];
    }
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];

   
    if (self.totalSeconds <= self.maxDuration) {
        self.imageCount = TEMP_MinImageCount;
        self.screenSeconds = self.totalSeconds;
        self.lastCellScallRatio = 1;
    } else {
        self.imageCount = ceil(self.totalSeconds * TEMP_MinImageCount / self.maxDuration);
        
        
        CGFloat ratio = 1 -(self.imageCount - (self.totalSeconds *TEMP_MinImageCount /self.maxDuration));
        self.lastCellScallRatio = (ratio == 0) ? 1 : ratio;
        self.screenSeconds = self.maxDuration;
    }
    
    self.clipSecondLabel.text = [NSString stringWithFormat:@"已选择取%.1fs", self.screenSeconds];
    self.endTimeLabel.text = [self secondsToStr:self.screenSeconds];
    
    __weak typeof(self) weakSelf = self;
    
    [self getImagesCount:self.imageCount imageBackBlock:^(UIImage *image) {
        if (image) {
            UIImage *scaledImg = [UIImage scaleImage:image maxDataSize:1024 * 20]; // 将图片压缩到最大20k进行显示
            dispatch_async(dispatch_get_main_queue(), ^{  
                if (weakSelf.collectionImages.count < self.imageCount) {
                    [weakSelf.collectionImages addObject:scaledImg];
                      [weakSelf.collectionView reloadData];
                }
                if (weakSelf.collectionImages.count == self.imageCount) {
                    [weakSelf.collectionView reloadData];
                    [weakSelf addAction];
                }
            });
            
        }
    }];
    
}
-(void)addAction{
    [self.leftDragView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftDragGesture:)]];
     [self.rightDragView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightDragGesture:)]];
    [self.endButton addTarget:self action:@selector(endButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)getImagesCount:(NSUInteger)imageCount imageBackBlock:(void (^)(UIImage *))imageBackBlock {
    Float64 durationSeconds = self.totalSeconds;
    float fps = self.frameRate;
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    
    Float64 perFrames = totalFrames / imageCount; // 一共切imageCount张图
    
    Float64 frame = 1;//从第一帧开始取图片
    
    CMTime timeFrame;
    while (frame < totalFrames) {
        timeFrame = CMTimeMake(frame, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
        
        frame += perFrames;
    }
    
    // 防止时间出现偏差
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    self.imageGenerator.appliesPreferredTrackTransform = YES;  // 截图的时候调整到正确的方向
    self.imageGenerator.maximumSize = CGSizeMake(100, 100);

    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                break;
            case AVAssetImageGeneratorFailed:
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *displayImage = [UIImage imageWithCGImage:image];
                !imageBackBlock ? : imageBackBlock(displayImage);
            }
                break;
        }
    }];
}

/** 将秒转为字符串 */
- (NSString *)secondsToStr:(Float64)seconds {
    NSInteger secondI = (NSInteger) seconds;
    if (!secondI) {
        return @"00:00";
    } else {
        NSInteger second = floor(secondI % 60);
        NSInteger minute = floor((secondI / 60) % secondI);
        return [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    }
}

#pragma mark - 拖拽事件
- (void)leftDragGesture:(UIPanGestureRecognizer *)ges {
    
    CGPoint translation = [ges translationInView:self];
    //gem 的最大X值
    CGFloat maxX = CGRectGetMinX(self.rightDragView.frame) - self.minDuration / self.screenSeconds * TEMP_EffectiveScreenW;
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            if ([self.delegate respondsToSelector:@selector(didStartDragView)]) {
                [self.delegate didStartDragView];
            }
            
            [self resetProgressBarMode];
            break;
        case UIGestureRecognizerStateChanged: {
            
            // 1.控制最小间距
            if ((CGRectGetMaxX(ges.view.frame) > maxX && translation.x > 0) || (ges.view.x < TEMP_LRDistance && translation.x < 0)) {
                return;
            }
            
            if (CGRectGetMaxX(ges.view.frame) + translation.x <= maxX && ges.view.x + translation.x >= TEMP_LRDistance) {
                [ges.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(ges.view.x + translation.x);
                }];
                
                [ges setTranslation:CGPointZero inView:self];
                
                [self layoutIfNeeded];
            }
            
            // 2.计算leftDragView对应的时间
            Float64 leftTotalSecond = [self getSecondsUsingView:ges.view];
            
            // 3.显示左边时间和截取时间
            self.leftSecond = leftTotalSecond;
            self.startTimeLabel.text = [NSString stringWithFormat:@"%.5f",leftTotalSecond];
//            [self secondsToStr:leftTotalSecond];
            
            Float64 clipSeconds = self.rightSecond - self.leftSecond;
//            (self.rightDragView.x - CGRectGetMaxX(ges.view.frame)) / TEMP_EffectiveScreenW * self.screenSeconds;
           
            self.clipSecondLabel.text = [NSString stringWithFormat:@"已选择取%.1fs", clipSeconds];
        } break;
        case UIGestureRecognizerStateEnded:
            
            
//            //******************************************当被快速滑动过界返回****************************************//
//            if (ges.view.x > maxX && translation.x > 0) {
//                ges.view.x = maxX;
//                [self layoutIfNeeded];
//            }
//            if ((ges.view.x < TEMP_LRDistance && translation.x < 0)) {
//                ges.view.x = TEMP_LRDistance;
//                [self layoutIfNeeded];
//            }
//            // 2.计算leftDragView对应的时间
//            Float64 leftTotalSecond = [self getSecondsUsingView:ges.view];
//
//            // 3.显示左边时间和截取时间
//            self.leftSecond = leftTotalSecond;
//            self.startTimeLabel.text = [self secondsToStr:leftTotalSecond];
//
//            Float64 clipSeconds = (CGRectGetMaxX(self.rightDragView.frame) - ges.view.x) / self.width * self.screenSeconds;
//            self.clipSecondLabel.text = [NSString stringWithFormat:@"%.1f", clipSeconds];
//            //******************************************注释****************************************//
            
            if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
                [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
            }
            break;
        default:
            break;
    }
}

- (void)rightDragGesture:(UIPanGestureRecognizer *)ges {
    CGPoint translation = [ges translationInView:self];
    CGFloat minX = CGRectGetMaxX(self.leftDragView.frame) + self.minDuration / self.screenSeconds * TEMP_EffectiveScreenW;
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            if ([self.delegate respondsToSelector:@selector(didStartDragView)]) {
                [self.delegate didStartDragView];
            }
            
            [self resetProgressBarMode];
            break;
        case UIGestureRecognizerStateChanged: {
    
               // 1.控制最小间距
            if ((ges.view.x < minX && translation.x < 0) || (ges.view.x > (self.width-TEMP_LRAddDragWDis) && translation.x > 0)) {
                return;
            }
            
            if (CGRectGetMinX(ges.view.frame) + translation.x >=minX && CGRectGetMaxX(ges.view.frame) + translation.x <= self.width-TEMP_LRDistance) {
                CGFloat distance = self.width - (CGRectGetMaxX(ges.view.frame) + translation.x);
                [ges.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_offset(-distance);
                }];
                
                [ges setTranslation:CGPointZero inView:self];
            }
            
            // 2.计算leftDragView对应的时间
            Float64 rightTotalSecond = [self getSecondsUsingView:ges.view];
            
            // 3.显示左边时间和截取时间
            self.rightSecond = rightTotalSecond;
            self.endTimeLabel.text = [NSString stringWithFormat:@"%.5f",rightTotalSecond];
//            [self secondsToStr:rightTotalSecond];
            
            Float64 clipSeconds =  self.rightSecond - self.leftSecond;
//            (ges.view.x - CGRectGetMaxX(self.leftDragView.frame)) / TEMP_EffectiveScreenW * self.screenSeconds;
            self.clipSecondLabel.text = [NSString stringWithFormat:@"已选择取%.1fs", clipSeconds];
        } break;
        case UIGestureRecognizerStateEnded: {
            
//            //******************************************当被快速滑动过界返回****************************************//
//            if  (ges.view.x < minX && translation.x < 0) {
//                 ges.view.x = minX;
//                [self layoutIfNeeded];
//            }
//            if (ges.view.x > (self.width-TEMP_LRAddDragWDis) && translation.x > 0) {
//                ges.view.x = (self.width-TEMP_LRAddDragWDis);
//                [self layoutIfNeeded];
//            }
//
//            // 2.计算leftDragView对应的时间
//            Float64 rightTotalSecond = [self getSecondsUsingView:ges.view];
//
//            // 3.显示左边时间和截取时间
//            self.rightSecond = rightTotalSecond;
//            Float64 clipSeconds = (CGRectGetMaxX(ges.view.frame) - CGRectGetMinX(self.leftDragView.frame)) / self.width * self.screenSeconds;
//            self.clipSecondLabel.text = [NSString stringWithFormat:@"%.1f", clipSeconds];
//            //******************************************注释****************************************//
           
            
            if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
                [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
            }
            
        } break;
        default:
            break;
    }
}

#pragma mark - 事件处理
- (void)resetProgressBarMode {
    self.progressBarView.hidden = YES;
}

- (Float64)getSecondsUsingView:(UIView *)view {
 
    
    Float64 offsetSecond = [self getCurrentOffSetX] / self.collectionView.contentSize.width * self.totalSeconds;
    
    
    
    Float64 second = 0;
    if (view == self.leftDragView) {
        second = (view.x-TEMP_LRDistance) / TEMP_EffectiveScreenW * self.screenSeconds;
    } else {
        second = (CGRectGetMinX(view.frame) - TEMP_LRAddDragWDis) / TEMP_EffectiveScreenW * self.screenSeconds;
    }
    
    Float64 totalSecond = second + offsetSecond;
    
    return totalSecond;
}
-(CGFloat)getCurrentOffSetX{
    
    CGFloat offsetX = 0;
    if (self.collectionView.contentOffset.x + TEMP_LRAddDragWDis < 0) {
        offsetX = 0;
    } else {
        offsetX = self.collectionView.contentOffset.x + TEMP_LRAddDragWDis;
    }
    return offsetX;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // leftDragView和rightDragView 1.5倍高度矩形区域成为拖拽区域
    
    // 计算leftDragView矩形拖拽区域
    CGFloat leftDragWH = self.leftDragView.height * 1.5;
    CGFloat leftDragX = self.leftDragView.center.x - leftDragWH * 0.5;
    CGFloat leftDragY = self.leftDragView.center.y - leftDragWH * 0.5;
    
    CGRect leftDragVRect = CGRectMake(leftDragX, leftDragY, leftDragWH, leftDragWH);
    
    // 计算rightDragView矩形拖拽区域
    CGFloat rightDragWH = self.rightDragView.height * 1.5;
    CGFloat rightDragX = self.rightDragView.center.x - rightDragWH * 0.5;
    CGFloat rightDragY = self.rightDragView.center.y - rightDragWH * 0.5;
    
    CGRect rightDragVRect = CGRectMake(rightDragX, rightDragY, rightDragWH, rightDragWH);
    
    if (CGRectContainsPoint(leftDragVRect, point)) {
        return self.leftDragView;
    } else if (CGRectContainsPoint(rightDragVRect, point)) {
        return self.rightDragView;
    } else {
        return [super hitTest:point withEvent:event];
    }
    
}

#pragma mark - 进度条移动动画
- (void)setProgressBarPoisionWithSecond:(Float64)second {
    CGFloat position = TEMP_EffectiveScreenW / self.screenSeconds * (second  + self.leftSecond - self.offsetSecond) + TEMP_LRAddDragWDis;
    self.progressBarView.x = position;
    self.progressBarView.hidden = NO;
    
//    NSLog(@"正在移动位置");
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MOLClipMovieViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MOLClipMovieViewCellId forIndexPath:indexPath];
    
    cell.imageData = self.collectionImages[indexPath.item];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.imageCount == (indexPath.row + 1)) {
        return  CGSizeMake(self.lastCellScallRatio * TEMP_ImagesVIewW , TEMP_ImagesViewH);
        
    }
    return  CGSizeMake(TEMP_ImagesVIewW, TEMP_ImagesViewH);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0,0);
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(didStartDragView)]) {
        [self.delegate didStartDragView];
    }
    [self resetProgressBarMode];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    CGFloat leftSecond= [self getSecondsUsingView:self.leftDragView];
    CGFloat rightSecond = [self getSecondsUsingView:self.rightDragView];
    
    self.startTimeLabel.text = [self secondsToStr:leftSecond];
    self.endTimeLabel.text = [self secondsToStr:rightSecond];
    
//    if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
//        [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
//    }
    
    if ([self.delegate respondsToSelector:@selector(clipFrameView:isScrolling:)]) {
        [self.delegate clipFrameView:self isScrolling:YES];
    }
    
    self.offsetSecond = [self getCurrentOffSetX] / self.collectionView.contentSize.width * self.totalSeconds;
    
//    NSLog(@"偏移量====%f",scrollView.contentOffset.x);
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.leftSecond = [self getSecondsUsingView:self.leftDragView];
    self.rightSecond = [self getSecondsUsingView:self.rightDragView];
    
    if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
        [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.leftSecond = [self getSecondsUsingView:self.leftDragView];
    self.rightSecond = [self getSecondsUsingView:self.rightDragView];
    
    if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
        [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
    }
    
    if ([self.delegate respondsToSelector:@selector(clipFrameView:isScrolling:)]) {
        [self.delegate clipFrameView:self isScrolling:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.leftSecond = [self getSecondsUsingView:self.leftDragView];
        self.rightSecond = [self getSecondsUsingView:self.rightDragView];
        
        if ([self.delegate respondsToSelector:@selector(clipFrameView:didEndDragLeftView:rightView:)]) {
            [self.delegate clipFrameView:self didEndDragLeftView:CMTimeMakeWithSeconds(self.leftSecond, self.frameRate) rightView:CMTimeMakeWithSeconds(self.rightSecond, self.frameRate)];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(clipFrameView:isScrolling:)]) {
        [self.delegate clipFrameView:self isScrolling:decelerate];
    }
}

#pragma mark - 懒加载
- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        UILabel *startTimeLabel = [UILabel new];
        startTimeLabel.textColor = [UIColor whiteColor];
        startTimeLabel.font = [UIFont systemFontOfSize:14];
        startTimeLabel.text = @"00:00";
        
        _startTimeLabel = startTimeLabel;
    }
    
    return _startTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        UILabel *endTimeLabel = [UILabel new];
        endTimeLabel.textColor = [UIColor whiteColor];
        endTimeLabel.font = [UIFont systemFontOfSize:14];
        
        _endTimeLabel = endTimeLabel;
    }
    
    return _endTimeLabel;
}

- (UILabel *)clipSecondLabel {
    if (!_clipSecondLabel) {
        UILabel *clipSecondLabel = [UILabel new];
        clipSecondLabel.textColor = [UIColor whiteColor];
        clipSecondLabel.font = [UIFont systemFontOfSize:17];
        
        _clipSecondLabel = clipSecondLabel;
    }
    
    return _clipSecondLabel;
}

- (NSMutableArray *)collectionImages {
    if (!_collectionImages) {
        _collectionImages = [NSMutableArray array];
    }
    
    return _collectionImages;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        layout.itemSize = CGSizeMake(TEMP_ImagesVIewW, TEMP_ImagesViewH);
//        layout.minimumLineSpacing = 0;
        
        CGRect collectionRect = CGRectMake(0, 0, TEMP_SCREEN_WIDTH, TEMP_ImagesViewH);
        
      _collectionView =  [[UICollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[MOLClipMovieViewCell class] forCellWithReuseIdentifier:MOLClipMovieViewCellId];
        _collectionView.contentInset = UIEdgeInsetsMake(0, TEMP_LRAddDragWDis, 0, TEMP_LRAddDragWDis);

        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    return _collectionView;
}
-(UILabel *)bottomTitleLable{
    if (!_bottomTitleLable) {
        _bottomTitleLable = [[UILabel alloc] init];
        _bottomTitleLable.text = @"裁剪";
        _bottomTitleLable.font = [UIFont systemFontOfSize:17];
        _bottomTitleLable.textColor = [UIColor whiteColor];
        _bottomTitleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomTitleLable;
}
-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton  = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"rc_return"] forState:UIControlStateNormal];
        
      
    }
    return _closeButton;
}
-(UIButton *)endButton{
    if (!_endButton) {
        _endButton = [[UIButton alloc] init];
         [_endButton setImage:[UIImage imageNamed:@"rc_confirm"] forState:UIControlStateNormal];
    
    }
    return _endButton;
}

-(void)closeButtonAction{
    if ([self.delegate respondsToSelector:@selector(closeButtonAction)]) {
        [self.delegate closeButtonAction];
    }
}
-(void)endButtonAction{
    if ([self.delegate respondsToSelector:@selector(endButtonAction)]) {
        [self.delegate endButtonAction];
    }
}
@end

