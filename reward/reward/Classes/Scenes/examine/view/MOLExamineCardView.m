//
//  MOLExamineCardView.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExamineCardView.h"
#import "MOLGiftCountView.h"
#import "MOLExamineCardCell.h"

@interface MOLExamineCardView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UIImageView *videoImageView;
@property (nonatomic, weak) UIImageView *playImageView;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *rewardNameLabel;  // 发布的悬赏

@property (nonatomic, weak) UILabel *goldLabel;  // 悬赏金币:
@property (nonatomic, weak) UIButton *goldButton;
@property (nonatomic, weak) UIImageView *giftImageView;
@property (nonatomic, weak) MOLGiftCountView *giftCountView;
@property (nonatomic, weak) UIButton *timeDownButton;  // 倒计时
@property (nonatomic, weak) UIImageView *overImageView; // 已经结束

@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) YYLabel *contentLabel;

@property (nonatomic, weak) UIView *bottomView;  // 底部view
@property (nonatomic, weak) UIView *bottomLineView;
@property (nonatomic, weak) UILabel *introduceLabel;  // @xxx 7人新发布了你悬赏作品(共44个)
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout; // 布局
@property (nonatomic, weak) UICollectionView *collectionView; // 所有拍摄人的头像
@property (nonatomic, weak) UIImageView *arrowImageView;  // 箭头
@end

@implementation MOLExamineCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupExamineCardViewUI];
    }
    return self;
}

#pragma mark - collectionviewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//分区，组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cardModel.userArray.count;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.cardModel.userArray[indexPath.row];
    MOLExamineCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MOLExamineCardCell_id" forIndexPath:indexPath];
    cell.image = str;
    return cell;
}

#pragma mark - 布局
- (void)setCardViewType:(MOLExamineCardViewType)cardViewType
{
    _cardViewType = cardViewType;
    
    if (cardViewType == MOLExamineCardViewType_normal) {
        self.bottomView.hidden = NO;
    }else{
        self.bottomView.hidden = YES;
    }
}

#pragma mark - 数据
- (void)setCardModel:(MOLExamineCardModel *)cardModel
{
    _cardModel = cardModel;
    
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.coverImage]];
    self.nameLabel.text = [NSString stringWithFormat:@"@%@",cardModel.userVO.userName];
    
    [self.goldButton setTitle:[NSString stringWithFormat:@"%ld",cardModel.rewardAmount] forState:UIControlStateNormal];
    NSMutableAttributedString *str = [self getTextWitnContent:self.cardModel.content type:self.cardModel.rewardType == 1 ? @"红包悬赏" : @"排名悬赏"];
    self.contentLabel.attributedText = str;
    
    [self.timeDownButton setTitle:cardModel.timeDownTime forState:UIControlStateNormal];
    [self.timeDownButton sizeToFit];
    
    self.introduceLabel.text = cardModel.videodescribe;
    if (cardModel.userArray.count) {
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }else{
        self.collectionView.hidden = YES;
        [self.collectionView reloadData];
    }
    
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.giftVO.giftThumb]];
    self.giftCountView.beginNumber = cardModel.giftVO.giftNum;
    
    self.overImageView.hidden = !cardModel.isFinish;
}

#pragma mark - UI
- (void)setupExamineCardViewUI
{
    UIImageView *videoImageView = [[UIImageView alloc] init];
    _videoImageView = videoImageView;
    videoImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:videoImageView];
    
    UIImageView *playImageView = [[UIImageView alloc] init];
    _playImageView = playImageView;
    playImageView.image = [UIImage imageNamed:@"mine_reward_play"];
    [videoImageView addSubview:playImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @" ";
    nameLabel.textColor = HEX_COLOR(0xffffff);
    nameLabel.font = MOL_MEDIUM_FONT(14);
    [self addSubview:nameLabel];
    
    UILabel *rewardNameLabel = [[UILabel alloc] init];
    _rewardNameLabel = rewardNameLabel;
    rewardNameLabel.text = @"发布的悬赏";
    rewardNameLabel.textColor = HEX_COLOR(0xffffff);
    rewardNameLabel.font = MOL_MEDIUM_FONT(14);
    [self addSubview:rewardNameLabel];
    
    UILabel *goldLabel = [[UILabel alloc] init];
    _goldLabel = goldLabel;
    goldLabel.text = @"悬赏金币：";
    goldLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    goldLabel.font = MOL_REGULAR_FONT(12);
    [self addSubview:goldLabel];
    
    UIButton *goldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goldButton = goldButton;
    goldButton.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [goldButton setImage:[UIImage imageNamed:@"mine_money"] forState:UIControlStateNormal];
    [goldButton setTitle:@"0" forState:UIControlStateNormal];
    [goldButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    goldButton.titleLabel.font = MOL_REGULAR_FONT(14);
    goldButton.layer.cornerRadius = 3;
    goldButton.clipsToBounds = YES;
    [self addSubview:goldButton];
    
    UIImageView *giftImageView = [[UIImageView alloc] init];
    _giftImageView = giftImageView;
    giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    giftImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:giftImageView];
    
    MOLGiftCountView *giftCountView = [[MOLGiftCountView alloc] init];
    _giftCountView = giftCountView;
    [self addSubview:giftCountView];
    
    UIButton *timeDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeDownButton = timeDownButton;
    [timeDownButton setImage:[UIImage imageNamed:@"mine_hourglass"] forState:UIControlStateNormal];
    [timeDownButton setTitle:@"还剩 0天0小时0分" forState:UIControlStateNormal];
    [timeDownButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    timeDownButton.titleLabel.font = MOL_REGULAR_FONT(13);
    [self addSubview:timeDownButton];
    
    UIImageView *overImageView = [[UIImageView alloc] init];
    _overImageView = overImageView;
    overImageView.image = [UIImage imageNamed:@"mine_reward_over"];
    [self addSubview:overImageView];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self addSubview:lineView];
    
    YYLabel *contentLabel = [[YYLabel alloc] init];
    _contentLabel = contentLabel;
    contentLabel.numberOfLines = 2;
    [self addSubview:contentLabel];
    
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomView];
    
    UIView *bottomLineView = [[UIView alloc] init];
    _bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [bottomView addSubview:bottomLineView];
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    _introduceLabel = introduceLabel;
    introduceLabel.text = @" ";
    introduceLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    introduceLabel.font = MOL_REGULAR_FONT(13);
    [bottomView addSubview:introduceLabel];
    
    CGFloat itemW = MOL_SCREEN_ADAPTER(25);
    CGFloat itemH = MOL_SCREEN_ADAPTER(25);
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = MOL_SCREEN_ADAPTER(10);
    self.flowLayout.minimumInteritemSpacing = MOL_SCREEN_ADAPTER(10);
    self.flowLayout.itemSize = CGSizeMake(itemW, itemH);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, MOL_SCREEN_ADAPTER(25)) collectionViewLayout:self.flowLayout];
    _collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MOLExamineCardCell class] forCellWithReuseIdentifier:@"MOLExamineCardCell_id"];
    [bottomView addSubview:_collectionView];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    _arrowImageView = arrowImageView;
    arrowImageView.image = [UIImage imageNamed:@"mine_shape"];
    [bottomView addSubview:arrowImageView];
}

- (void)calculatorExamineCardViewFrame
{
    self.videoImageView.width = 84;
    self.videoImageView.height = 112;
    self.videoImageView.y = 20;
    self.videoImageView.x = 10;
    
    self.playImageView.width = 15;
    self.playImageView.height = 18;
    self.playImageView.centerX = self.videoImageView.width * 0.5;
    self.playImageView.centerY = self.videoImageView.height * 0.5;
    
    [self.rewardNameLabel sizeToFit];
    self.rewardNameLabel.height = 23;
    self.rewardNameLabel.right = self.width - 10;
    self.rewardNameLabel.y = self.videoImageView.y;
    
    self.nameLabel.x = self.videoImageView.right + 10;
    self.nameLabel.y = self.videoImageView.y;
    [self.nameLabel sizeToFit];
    if (self.nameLabel.width > self.rewardNameLabel.x - self.nameLabel.x) {
        self.nameLabel.width = self.rewardNameLabel.x - self.nameLabel.x;
    }
    self.nameLabel.height = self.rewardNameLabel.height;
    
    if (self.nameLabel.right <= self.rewardNameLabel.x) {
        self.rewardNameLabel.x = self.nameLabel.right;
    }
    
    [self.goldLabel sizeToFit];
    self.goldLabel.height = 17;
    self.goldLabel.x = self.nameLabel.x;
    self.goldLabel.y = self.nameLabel.bottom + 17;
    
    [self.goldButton sizeToFit];
    self.goldButton.width += 30;
    self.goldButton.height = 30;
    self.goldButton.x = self.goldLabel.right;
    self.goldButton.centerY = self.goldLabel.centerY;
    [self.goldButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:5];
    
    self.giftImageView.width = 60;
    self.giftImageView.height = 40;
    self.giftImageView.x = self.nameLabel.x;
    self.giftImageView.bottom = self.videoImageView.bottom;
    
    self.giftCountView.x = self.giftImageView.right;
    self.giftCountView.y = self.giftImageView.y;
    self.giftCountView.height = self.giftImageView.height;
    self.giftCountView.width = self.width - self.giftCountView.x;
    
    [self.timeDownButton sizeToFit];
    self.timeDownButton.x = self.videoImageView.x;
    self.timeDownButton.y = self.videoImageView.bottom + 10;
    [self.timeDownButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:5];
    
    self.overImageView.width = 87;
    self.overImageView.height = 55;
    self.overImageView.bottom = self.timeDownButton.bottom + 5;
    self.overImageView.right = self.width - 10;
    
    self.lineView.width = self.width;
    self.lineView.height = 1;
    self.lineView.y = self.timeDownButton.bottom + 10;
    
    
    self.contentLabel.width = self.width - 20;
    self.contentLabel.x = self.videoImageView.x-1;
    self.contentLabel.y = self.lineView.bottom + 10;
    NSMutableAttributedString *str = [self getTextWitnContent:self.cardModel.content type:self.cardModel.rewardType == 1 ? @"红包悬赏" : @"排名悬赏"];
    CGFloat h = [str mol_getAttributedTextHeightWithMaxWith:self.width - 20 font:MOL_REGULAR_FONT(15)];
    self.contentLabel.height = h > 44 ? 44 : h;
    
    self.bottomView.width = self.width;
    self.bottomView.y = self.contentLabel.bottom + 10;
    
    self.bottomLineView.width = self.bottomView.width;
    self.bottomLineView.height = 1;
    
    self.introduceLabel.width = self.bottomView.width - 20;
    [self.introduceLabel sizeToFit];
    self.introduceLabel.width = self.bottomView.width - 20;
    self.introduceLabel.x = 10;
    self.introduceLabel.y = self.bottomLineView.bottom + 10;
    
    self.collectionView.width = self.bottomView.width - 30;
    self.collectionView.height = MOL_SCREEN_ADAPTER(25);
    self.collectionView.y = self.introduceLabel.bottom + 10;
    self.collectionView.x = 10;
    
    self.bottomView.height = self.collectionView.bottom + 10;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorExamineCardViewFrame];
}

- (NSMutableAttributedString *)getTextWitnContent:(NSString *)content type:(NSString *)type   // type  红包悬赏 排位悬赏
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.6);
    text.yy_font = MOL_REGULAR_FONT(15);
    
    if (!type.length) {
        return text;
    }
    
    UIImage *image = [UIImage imageNamed:@"mine_ harmony"];
    
    if ([type isEqualToString:@"红包悬赏"]) {
        image = [UIImage imageNamed:@"packet_type"];
    }else if ([type isEqualToString:@"排名悬赏"]){
        image = [UIImage imageNamed:@"ranking_type"];
    }
    
    image = [UIImage imageWithCGImage:image.CGImage scale:MOL_SCREEN_SCALE orientation:UIImageOrientationUp];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:MOL_REGULAR_FONT(15) alignment:YYTextVerticalAlignmentCenter];
    
//    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ",type]];
//    one.yy_font = [UIFont boldSystemFontOfSize:10];
//    one.yy_color = [UIColor whiteColor];
//
//    YYTextBorder *border = [YYTextBorder new];
//    border.cornerRadius = 2;
//    border.insets = UIEdgeInsetsMake(-3, -3, -3, -3);
//    if ([type isEqualToString:@"红包悬赏"]) {
//        border.fillColor = HEX_COLOR(0xFE6257);
//    }else{
//        border.fillColor = HEX_COLOR(0x74BDF5);
//    }
//    border.lineStyle = YYTextLineStyleSingle;
//    [one yy_setTextBackgroundBorder:border range:[one.string rangeOfString:type]];
    
    [text insertAttributedString:attachText atIndex:0];
    
    return text;
}
@end
