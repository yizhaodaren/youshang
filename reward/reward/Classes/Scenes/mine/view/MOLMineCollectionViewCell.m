//
//  MOLMineCollectionViewCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMineCollectionViewCell.h"
#import "JAPaddingLabel.h"

@interface MOLMineCollectionViewCell ()
@property (nonatomic, weak) UIImageView *backImageView;
@property (nonatomic, weak) UIImageView *topBackShadow;

@property (nonatomic, weak) JAPaddingLabel *modelTypeLabel;  // 模式（我的悬赏）
@property (nonatomic, weak) UIButton *modelTypeButton;  // 模式（我的悬赏）
@property (nonatomic, weak) JAPaddingLabel *typeLabel;  // 模式（我的喜欢）
@property (nonatomic, weak) UIButton *goldButton;  // 金币按钮（悬赏详情）
@property (nonatomic, weak) UIButton *goodButton;  // 精选按钮（我的作品）
@end

@implementation MOLMineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMineCollectionViewCellUI];
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)setType:(MOLMineCollectionViewCellType)type
{
    _type = type;
    if (type == MOLMineCollectionViewCellType_userReward) {
//        self.modelTypeLabel.hidden = NO;
        self.modelTypeButton.hidden = NO;
        self.goldButton.hidden = YES;
        self.goodButton.hidden = YES;
        self.typeLabel.hidden = YES;
    }else if (type == MOLMineCollectionViewCellType_userLike){
//        self.modelTypeLabel.hidden = YES;
        self.modelTypeButton.hidden = YES;
        self.goldButton.hidden = YES;
        self.typeLabel.hidden = NO;
        self.goodButton.hidden = NO;
    }else if(type == MOLMineCollectionViewCellType_normal){
//        self.modelTypeLabel.hidden = YES;
        self.modelTypeButton.hidden = YES;
        self.goldButton.hidden = NO;
        self.goodButton.hidden = YES;
        self.typeLabel.hidden = YES;
    }else{
//        self.modelTypeLabel.hidden = YES;
        self.modelTypeButton.hidden = YES;
        self.goldButton.hidden = YES;
        self.typeLabel.hidden = YES;
        self.goodButton.hidden = NO;
    }
}

// 我的悬赏卡片下 用
- (void)setLightVideoModel:(MOLLightVideoModel *)lightVideoModel
{
    _lightVideoModel = lightVideoModel;
    self.type = self.type;
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:lightVideoModel.coverImage]];
    if (lightVideoModel.playCount >= 0) {
        self.playCountButton.hidden = NO;
        [self.playCountButton setTitle:[NSString stringWithFormat:@"%ld",lightVideoModel.playCount] forState:UIControlStateNormal];
    }else{
        self.playCountButton.hidden = YES;
        
    }
    
    if (lightVideoModel.playCount < 0) {
//        self.modelTypeLabel.hidden = NO;
        self.modelTypeButton.hidden = NO;
        if (lightVideoModel.rewardType == 1) {
//            self.modelTypeLabel.backgroundColor = HEX_COLOR(0xFE6257);
//            self.modelTypeLabel.text = @"红包悬赏";
            self.modelTypeButton.selected = NO;
        }else{
//            self.modelTypeLabel.backgroundColor = HEX_COLOR(0x74BDF5);
//            self.modelTypeLabel.text = @"排名悬赏";
            self.modelTypeButton.selected = YES;
        }
//        [self.modelTypeLabel sizeToFit];
//        self.modelTypeLabel.height = 16;
    }else{
//        self.modelTypeLabel.hidden = YES;
        self.modelTypeButton.hidden = YES;
    }
    
    
    [self layout];
}

- (void)setVideoOutsideModel:(MOLVideoOutsideModel *)videoOutsideModel
{
    _videoOutsideModel = videoOutsideModel;

    self.type = self.type;
    
    if (videoOutsideModel.contentType == 1) {

        
        [self.playCountButton setTitle:[NSString stringWithFormat:@"%ld",videoOutsideModel.rewardVO.playCount] forState:UIControlStateNormal];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:videoOutsideModel.rewardVO.coverImage]];
        
        self.typeLabel.hidden = NO;
    }else{
        
        [self.playCountButton setTitle:[NSString stringWithFormat:@"%ld",videoOutsideModel.storyVO.playCount] forState:UIControlStateNormal];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:videoOutsideModel.storyVO.coverImage]];
        
        self.typeLabel.hidden = YES;
    }
    
    if (videoOutsideModel.storyVO.isEssence && (self.type == MOLMineCollectionViewCellType_userLike || self.type == MOLMineCollectionViewCellType_userProduction)) {
        self.goodButton.hidden = NO;
    }else{
        self.goodButton.hidden = YES;
    }
    
    NSString *t = [NSString stringWithFormat:@"%ld",videoOutsideModel.storyVO.rewardAmount];
    if (videoOutsideModel.storyVO.rewardAmount > 0 && self.type == MOLMineCollectionViewCellType_normal) {
        [self.goldButton setTitle:t forState:UIControlStateNormal];
        self.goldButton.hidden = NO;
    }else{
        self.goldButton.hidden = YES;
    }
    
    [self layout];
}

- (void)layout
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - UI
- (void)setupMineCollectionViewCellUI
{
    UIImageView *backImageView = [[UIImageView alloc] init];
    _backImageView = backImageView;
    backImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.clipsToBounds = YES;
    [self.contentView addSubview:backImageView];
    
    UIImageView *topBackShadow=[UIImageView new];
    _topBackShadow = topBackShadow;
    [topBackShadow setImage: [UIImage imageNamed:@"mine_projection"]];
    [self.contentView addSubview:topBackShadow];
    
    UIButton *playCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playCountButton = playCountButton;
    [playCountButton setTitle:@"0" forState:UIControlStateNormal];
    [playCountButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    playCountButton.titleLabel.font = MOL_MEDIUM_FONT(12);
    [playCountButton setImage:[UIImage imageNamed:@"mine_play1"] forState:UIControlStateNormal];
    [self.contentView addSubview:playCountButton];
    
//    JAPaddingLabel *modelTypeLabel = [[JAPaddingLabel alloc] init];
//    _modelTypeLabel = modelTypeLabel;
//    modelTypeLabel.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//    self.modelTypeLabel.textColor = HEX_COLOR(0xffffff);
//    self.modelTypeLabel.font = MOL_MEDIUM_FONT(10);
//    self.modelTypeLabel.layer.cornerRadius = 3;
//    self.modelTypeLabel.clipsToBounds = YES;
//    [self.contentView addSubview:modelTypeLabel];
    
    UIButton *modelTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _modelTypeButton = modelTypeButton;
    modelTypeButton.hidden = YES;
    [modelTypeButton setImage:[UIImage imageNamed:@"packet_type"] forState:UIControlStateNormal];
    [modelTypeButton setImage:[UIImage imageNamed:@"ranking_type"] forState:UIControlStateSelected];
    [self.contentView addSubview:modelTypeButton];
    
    JAPaddingLabel *typeLabel = [[JAPaddingLabel alloc] init];
    _typeLabel = typeLabel;
    typeLabel.textColor = HEX_COLOR(0x000000);
    typeLabel.font = MOL_REGULAR_FONT(10);
    typeLabel.text = @"悬赏";
    typeLabel.backgroundColor = HEX_COLOR(0xFFEC00);
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:typeLabel];
    
    UIButton *goldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goldButton = goldButton;
    goldButton.hidden = YES;
    [goldButton setImage:[UIImage imageNamed:@"video_money"] forState:UIControlStateNormal];
    [goldButton setTitle:@"0" forState:UIControlStateNormal];
    goldButton.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.7);
    [goldButton setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateNormal];
    goldButton.titleLabel.font = MOL_REGULAR_FONT(10);
    [self.contentView addSubview:goldButton];
    
    UIButton *goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goodButton = goodButton;
    goodButton.hidden = YES;
    [goodButton setImage:[UIImage imageNamed:@"mine_producte_good"] forState:UIControlStateNormal];
    [self.contentView addSubview:goodButton];
}

- (void)calculatorMineCollectionViewCellFrame
{
    self.backImageView.width = self.contentView.width;
    self.backImageView.height = self.contentView.height;
    
    [self.playCountButton sizeToFit];
    self.playCountButton.right = self.contentView.width - 5;
    self.playCountButton.bottom = self.contentView.height - 5;
    [self.playCountButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:5];
    
    [self.topBackShadow setFrame:CGRectMake(0,self.contentView.height - 50, self.contentView.width, 50)];
    
//    [self.modelTypeLabel sizeToFit];
//    self.modelTypeLabel.height = 16;
//    self.modelTypeLabel.x = 5;
//    self.modelTypeLabel.y = 5;
    
    [self.modelTypeButton sizeToFit];
    self.modelTypeButton.x = 5;
    self.modelTypeButton.y = 5;
    
    [self.typeLabel sizeToFit];
    self.typeLabel.width = 30;
    self.typeLabel.height = 16;
    self.typeLabel.right = self.contentView.width - 5;
    self.typeLabel.y = 5;
    
    [self.goldButton sizeToFit];
    self.goldButton.width += 15;
    self.goldButton.height = 14;
    self.goldButton.layer.cornerRadius = self.goldButton.height * 0.5;
    self.goldButton.clipsToBounds = YES;
    self.goldButton.x = -self.goldButton.height * 0.5;
    self.goldButton.y = 5;
    
    [self.goodButton sizeToFit];
    self.goodButton.y = 5;
    self.goodButton.x = 5;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorMineCollectionViewCellFrame];
}
@end
