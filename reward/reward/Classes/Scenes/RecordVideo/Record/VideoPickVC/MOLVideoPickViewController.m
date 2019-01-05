//
//  MOLVideoPickViewController.m
//  reward
//
//  Created by apple on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLVideoPickViewController.h"

#import <PLShortVideoKit/PLShortVideoKit.h>
#import "MOLEditViewController.h"
#import "MOLReleaseViewController.h"
#pragma mark -- PHAsset (PLSImagePickerHelpers)

@implementation PHAsset (PLSImagePickerHelpers)

- (NSURL *)movieURL {
    __block NSURL *url = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    if (self.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:self options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            url = urlAsset.URL;
            
            dispatch_semaphore_signal(semaphore);
        }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return url;
}

- (UIImage *)imageURL:(PHAsset *)phAsset targetSize:(CGSize)targetSize {
    __block UIImage *image = nil;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestImageForAsset:phAsset targetSize:targetSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
    }];
    
    return image;
}

@end


#pragma mark -- PLSAssetCell

@implementation PLSAssetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageRequestID = PHInvalidImageRequestID;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        
        
        CGFloat w = 50;
        CGFloat h = 20;
        self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - w, frame.size.height - h, w, h)];
        self.timeLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.timeLable];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.imageView.bounds = self.bounds;
}

- (void)prepareForReuse {
    [self cancelImageRequest];
    self.imageView.image = nil;
}

- (void)cancelImageRequest {
    if (self.imageRequestID != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        self.imageRequestID = PHInvalidImageRequestID;
    }
}

- (void)setAsset:(PHAsset *)asset {
    if (_asset != asset) {
        _asset = asset;
        _timeLable.text =[CommUtls convertToMSStringWithS:asset.duration];
        [self cancelImageRequest];
        
        if (_asset) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
            self.imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:_asset
                                                                             targetSize:size
                                                                            contentMode:PHImageContentModeAspectFill
                                                                                options:options
                                                                          resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                              if (_asset == asset) {
                                                                                  self.imageView.image = result;
                                                                              }
                                                                          }];
        }
        
    }
}

@end



@interface MOLVideoPickViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView * videoCollectionView;
@property (strong, nonatomic) NSArray *assets;//资源

@end

@implementation MOLVideoPickViewController{
    NSTimer *_timer; //定时检查权限
    //没有开启权限时候的提示
    UIView * _warnView;
    UILabel * _tipLabel;
    UIButton * _settingBtn;
}

//static NSString * const reuseIdentifier = @"Cell";
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //     self.isHidenTaBar = YES;
    //    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.hidden = YES;//隐藏导航栏
    
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //     self.isHidenTaBar = NO;
    //    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.hidden = NO;//隐藏导航栏
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, MOL_StatusBarHeight + 10, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT - MOL_StatusBarHeight - 10)];
    bgView.backgroundColor = [UIColor whiteColor];
    //设置切哪个直角
    //    UIRectCornerTopLeft     = 1 << 0,  左上角
    //    UIRectCornerTopRight    = 1 << 1,  右上角
    //    UIRectCornerBottomLeft  = 1 << 2,  左下角
    //    UIRectCornerBottomRight = 1 << 3,  右下角
    //    UIRectCornerAllCorners  = ~0UL     全部角
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15,15)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bgView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    bgView.layer.mask = maskLayer;
    [self.view addSubview:bgView];
    
    //取消
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 50, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    
    //视频选择
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLable.text = @"选取视频";
    titleLable.center = CGPointMake(MOL_SCREEN_WIDTH/2, cancelBtn.center.y);
    [titleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLable];
 
    
    //collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = ([UIScreen mainScreen].bounds.size.width / 4) - 1;
    layout.itemSize = CGSizeMake(w, w);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;

    self.videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, MOL_SCREEN_WIDTH, bgView.bounds.size.height - 50) collectionViewLayout:layout];
    [self.videoCollectionView registerClass:[PLSAssetCell class] forCellWithReuseIdentifier:@"Cell"];
    _videoCollectionView.delegate = self;
    _videoCollectionView.dataSource = self;
    _videoCollectionView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:self.videoCollectionView];
  
    
    //没有权限时候的提示
    _warnView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, MOL_SCREEN_WIDTH, bgView.bounds.size.height - 50)];
    _warnView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_warnView];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.frame = CGRectMake(8, 120, MOL_SCREEN_WIDTH - 16, 60);
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.numberOfLines = 0;
    _tipLabel.font = [UIFont systemFontOfSize:16];
    _tipLabel.textColor = [UIColor blackColor];
    
    //设置权限
    NSDictionary *infoDict = [CommUtls getInfoDictionary];
    NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
    NSString *tipText = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册",appName];
    _tipLabel.text = tipText;
    [_warnView addSubview:_tipLabel];
    if (iOS8) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_settingBtn setTitle:@"设置" forState:UIControlStateNormal];
        _settingBtn.frame = CGRectMake(0, 180, MOL_SCREEN_WIDTH, 44);
        _settingBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_warnView addSubview:_settingBtn];
    }
    
    
    
    //获取视频
    _warnView.hidden = YES;
    [self fetchAssetsWithMediaType:PHAssetMediaTypeVideo];
    
    if (PHPhotoLibrary.authorizationStatus != PHAuthorizationStatusAuthorized) {
        _warnView.hidden = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:NO];
    }
    
}

//设置状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)fetchAssetsWithMediaType:(PHAssetMediaType)mediaType {
    __weak __typeof(self) weak = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.includeHiddenAssets = NO;
        fetchOptions.includeAllBurstAssets = NO;
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:mediaType options:fetchOptions];
        
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        [fetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [assets addObject:obj];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weak.assets = assets;
            [weak.videoCollectionView reloadData];
        });
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLSAssetCell *cell = (PLSAssetCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell
    PHAsset *asset = self.assets[indexPath.item];
    cell.asset = asset;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        PHAsset *asset = self.assets[indexPath.item];
      NSURL *url = [asset movieURL];
    
    if (asset.duration < MOL_RecordMinTime) {
        [MBProgressHUD showMessageAMoment:@"视频太短了,选择一个长点的!"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(picktedVoideWith:)]) {
        
         [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:NO];
        

          [self.delegate picktedVoideWith:url];
      
       
    }
    
}



- (void)settingBtnClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (void)observeAuthrizationStatusChange {
    [_timer invalidate];
    _timer = nil;
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized) {
        _warnView.hidden = YES;
        [self fetchAssetsWithMediaType:PHAssetMediaTypeVideo];
    }else{
         _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:NO];
    }
}


-(void)cancelAction{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
