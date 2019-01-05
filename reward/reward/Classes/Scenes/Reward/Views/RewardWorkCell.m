//
//  RewardWorkCell.m
//  reward
//
//  Created by xujin on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "RewardWorkCell.h"
#import "MOLVideoOutsideModel.h"
#import "MOLExamineCardModel.h"

@interface RewardWorkCell()
    @property (nonatomic, strong)NSIndexPath *curentIndexPath;
    @end

@implementation RewardWorkCell
    
- (instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
        }
        return self;
    }
    
#pragma mark - UI
- (void)content:(MOLVideoOutsideModel *)model indexPath:(NSIndexPath *)indexPath;
    {
        if (!model) {
            return;
        }
        
        if (indexPath) {
            self.curentIndexPath =indexPath;
        }
        
        for (id views in self.contentView.subviews) {
            [views removeFromSuperview];
        }
        
        // 2
        if (indexPath.row >=(model.rewardVO.storyList.count>0?model.rewardVO.storyList.count+1:1)) {
            return;
        }
        
        
        MOLLightVideoModel *videoModel =[MOLLightVideoModel new];
        if (indexPath.row==0) { //表示是悬赏作品:红包 排名
            videoModel.isExistMark =YES;
            videoModel.coverImage =model.rewardVO.coverImage;
            videoModel.rewardType =model.rewardVO.rewardType;
            
        }else{
            videoModel.isExistMark =NO;
            videoModel =model.rewardVO.storyList[indexPath.row-1];
        }
        
        
        
        UIImageView *backImageView = [[UIImageView alloc] init];
        backImageView.contentMode = UIViewContentModeScaleAspectFill;
        backImageView.clipsToBounds = YES;
        [backImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.coverImage?videoModel.coverImage:@""] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
        backImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:backImageView];
        __weak typeof(self) wself = self;
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(wself.contentView);
        }];
        
        if (videoModel.isExistMark) {
            UIImageView *markImage =[UIImageView new];
            
            if (videoModel.rewardType==1) { //红包悬赏
                [markImage setImage: [UIImage imageNamed:@"packet_type"]];
            }else{
                [markImage setImage: [UIImage imageNamed:@"ranking_type"]];
            }
            
            [self.contentView addSubview:markImage];
            [markImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(5);
                make.left.mas_equalTo(5);
                make.height.mas_equalTo(18);
                make.width.mas_equalTo(50);
                
            }];
            
        }
    }
    
    
#pragma mark - UI
- (void)contentMusic:(MOLVideoOutsideModel *)model indexPath:(NSIndexPath *)indexPath;
    {
        if (!model) {
            return;
        }
        
        if (indexPath) {
            self.curentIndexPath =indexPath;
        }
        
        for (id views in self.contentView.subviews) {
            [views removeFromSuperview];
        }
        
        // 2
        //        if (indexPath.row >=(model.rewardVO.storyList.count>0?model.rewardVO.storyList.count+1:1)) {
        //            return;
        //        }
        
        
        
        MOLLightVideoModel *videoModel =[[MOLLightVideoModel alloc] init];
        videoModel.isExistMark =NO;
        videoModel = model.musicStoryVO.storyList[indexPath.row];
        
        
        UIImageView *backImageView = [[UIImageView alloc] init];
        backImageView.contentMode = UIViewContentModeScaleAspectFill;
        backImageView.clipsToBounds = YES;
        NSString * str = videoModel.coverImage;
        NSURL *imageUrl= [NSURL URLWithString:str];
        [backImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
        backImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:backImageView];
        __weak typeof(self) wself = self;
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(wself.contentView);
        }];
    }
    
    @end
