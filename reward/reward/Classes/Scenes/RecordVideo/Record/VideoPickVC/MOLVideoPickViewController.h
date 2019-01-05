//
//  MOLVideoPickViewController.h
//  reward
//
//  Created by apple on 2018/9/11.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>



@interface PHAsset (PLSImagePickerHelpers)

- (NSURL *)movieURL;

@end

@interface PLSAssetCell : UICollectionViewCell

@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) PHImageRequestID imageRequestID;
@property (nonatomic,strong) UILabel *timeLable;

@end




@protocol PicktedVoidDelegate <NSObject>

- (void)picktedVoideWith:(NSURL *)url;

@end
@interface MOLVideoPickViewController : MOLBaseViewController

@property (nonatomic, assign) id<PicktedVoidDelegate> delegate;

@end
