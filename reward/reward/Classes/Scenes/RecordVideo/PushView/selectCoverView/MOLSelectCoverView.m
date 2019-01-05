//
//  MOLSelectCoverView.m
//  reward
//
//  Created by apple on 2018/11/16.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLSelectCoverView.h"


#import <objc/runtime.h>
#import <Masonry.h>
#import "UIImage+PLSClip.h"


#define TEMP_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]




static NSString * const MOLselectCoverViewCellId = @"MOLselectCoverViewCellId";
@interface MOLSelectCoverView() <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) AVAsset *asset; // 视频对象
@property (nonatomic, assign) Float64 frameRate; // 帧率
@property (assign, nonatomic) Float64 minDuration; // 截取视频的最短时间
@property (assign, nonatomic) Float64 maxDuration; // 截取视频的最长时间
@property (nonatomic, assign) Float64 totalSeconds; // 总秒数
@property (nonatomic, assign) Float64 screenSeconds; // 当前屏幕显示的秒数

@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionImages;

@property (nonatomic, strong) UILabel *clipSecondLabel; // 一共截多少秒

@property (nonatomic, strong) UIView *leftDragView; // 左边时间拖拽view
@property (nonatomic, strong) UIView *rightDragView; // 右边时间拖拽view

@property (nonatomic,assign)CGFloat lastCellScallRatio;//最后一个cell的宽度比其他的小的倍率


@property(nonatomic, assign)NSInteger  currentCoverIndex;//当前选择的封面下标

@end

@implementation MOLSelectCoverView


- (instancetype)initWithMovieAsset:(AVAsset *)asset minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration withCustomH:(CGFloat)height showBottom:(BOOL) isShowBottom {
    self = [super initWithCustomH:height showBottom:isShowBottom];
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
    self.contentView.backgroundColor = [UIColor blackColor];
    [self.customView  addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.customView.mas_bottom).offset(-18);
        make.height.mas_equalTo(1.2*TEMP_ImagesViewH);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIView *bg = [[UIView alloc] init];
    [self.customView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MOL_SCREEN_WIDTH * 3.0 /5.0);
        make.centerX.mas_equalTo(self.customView);
        make.top.mas_equalTo(self.customView);
        make.bottom.mas_equalTo(self.collectionView.mas_top);
    }];
    
    //封面图
    [bg addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bg.mas_width);
        make.height.mas_equalTo(bg.mas_width).multipliedBy(16.0/9.0);
        make.center.mas_equalTo(bg);
    }];
    
//     [self setUpDragView];
    
}
/** 初始化拖拽view */
- (void)setUpDragView {
    // 添加左右拖拽view
    UIView *leftDragView = [UIView new];
    leftDragView.layer.contents = (id) [UIImage imageNamed:@"cut_bar_left"].CGImage;
    [self.customView addSubview:leftDragView];
    self.leftDragView = leftDragView;
    [leftDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TEMP_DragViewW,TEMP_DragViewH));
        make.left.mas_equalTo(TEMP_LRDistance);
        make.centerY.mas_equalTo(self.collectionView);
    }];
    
    
    UIView *rightDragView = [UIView new];
    rightDragView.layer.contents = (id) [UIImage imageNamed:@"cut_bar_right"].CGImage;
    [self.customView addSubview:rightDragView];
    self.rightDragView = rightDragView;
    [rightDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TEMP_DragViewW, TEMP_DragViewH));
        make.right.mas_equalTo(-TEMP_LRDistance);
        make.centerY.mas_equalTo(self.collectionView).offset(10);
    }];
    
    // 添加一个底层黄色背景的view
    UIView *topLinView = [UIView new];
    topLinView.backgroundColor = TEMP_RGBCOLOR(252, 221, 0);
    [self.customView insertSubview:topLinView belowSubview:self.collectionView];
    [topLinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftDragView.mas_right);
        make.right.mas_equalTo(rightDragView.mas_left);
        
        make.top.mas_equalTo(self.collectionView.mas_top).offset(-TEMP_LineW);
        make.height.mas_offset(TEMP_LineW);
    }];
    
    UIView *bottomLinView = [UIView new];
    bottomLinView.backgroundColor = TEMP_RGBCOLOR(252, 221, 0);
    [self.customView insertSubview:bottomLinView belowSubview:self.collectionView];
    [bottomLinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftDragView.mas_right);
        make.right.mas_equalTo(rightDragView.mas_left);
        make.bottom.mas_equalTo(self.collectionView.mas_bottom).offset(TEMP_LineW);
        make.height.mas_offset(TEMP_LineW);
    }];
    
    
}

- (void)initDataFromAsset:(AVAsset *)asset {
    
    
    CMTime cmtime = asset.duration;
    self.totalSeconds = CMTimeGetSeconds(cmtime);
    
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        self.frameRate = [[asset tracksWithMediaType:AVMediaTypeVideo][0] nominalFrameRate];
    }
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    NSUInteger imageCount = 0;
    if (self.totalSeconds <= self.maxDuration) {
        imageCount = TEMP_MinImageCount;
        self.screenSeconds = self.totalSeconds;
        self.lastCellScallRatio = 1;
    } else {
        imageCount = ceil(self.totalSeconds * TEMP_MinImageCount / self.maxDuration);
        
        
        
        CGFloat ratio =  imageCount - (self.totalSeconds *TEMP_MinImageCount /self.maxDuration);
        self.lastCellScallRatio = (ratio == 0) ? 1 : ratio;
        
        
        self.screenSeconds = self.maxDuration;
    }
    

    __weak typeof(self) weakSelf = self;
    
    
    [self getImagesCount:imageCount imageBackBlock:^(UIImage *image) {
        if (image) {
            
            UIImage *scaledImg = [UIImage scaleImage:image maxDataSize:1024 * 20]; // 将图片压缩到最大20k进行显示
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakSelf.collectionImages.count < imageCount) {
                    
                    [weakSelf.collectionImages addObject:image];
                }
                if (weakSelf.collectionImages.count == imageCount) {
                    weakSelf.coverImageView.image = weakSelf.collectionImages.firstObject;
                    [weakSelf.collectionView reloadData];
                }
            });
            
        }
    }];
    
    
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
    self.imageGenerator.maximumSize = self.asset.pls_videoSize;
//    CGSizeMake(100, 100);
    
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




#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MOLClipMovieViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:MOLselectCoverViewCellId forIndexPath:indexPath];
    [cell layoutImageView];
    cell.imageData = self.collectionImages[indexPath.item];
    cell.backgroundColor = [UIColor blackColor];
    if (self.currentCoverIndex == indexPath.row) {
        [cell setBorder];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.coverImageView.image = self.collectionImages[indexPath.row];
    self.currentCoverIndex = indexPath.row;
    [self.collectionView reloadData];
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.currentCoverIndex) {
      return CGSizeMake(1.2*TEMP_ImagesVIewW, 1.2*TEMP_ImagesViewH);
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




- (NSMutableArray *)collectionImages {
    if (!_collectionImages) {
        _collectionImages = [NSMutableArray array];
    }
    
    return _collectionImages;
}
-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = [UIColor clearColor];
        _coverImageView.contentMode =  UIViewContentModeScaleAspectFit;
//        _coverImageView.width = MOL_SCREEN_WIDTH *3 /5;
//        _coverImageView.height = _coverImageView.width * 16.0 / 9.0;
//        _coverImageView.centerX = self.customView.centerX;
//        _coverImageView.bottom = _collectionView.top - 20;
    }
    return _coverImageView;
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
        
        [_collectionView registerClass:[MOLClipMovieViewCell class] forCellWithReuseIdentifier:MOLselectCoverViewCellId];
//        _collectionView.contentInset = UIEdgeInsetsMake(0, TEMP_LRAddDragWDis, 0, TEMP_LRAddDragWDis);
             _collectionView.contentInset = UIEdgeInsetsMake(0, TEMP_LRDistance, 0, TEMP_LRDistance);
        
        
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    return _collectionView;
}

@end
