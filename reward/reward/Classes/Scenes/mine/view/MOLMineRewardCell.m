//
//  MOLMineRewardCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMineRewardCell.h"
#import "MOLGiftCountView.h"
#import "JAPaddingLabel.h"
#import "MOLMineCollectionViewCell.h"
#import "MOLExaminePacketModeViewController.h"
#import "RecommendViewController.h"
#import "RewardDetailViewController.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
#import "STSystemHelper.h"
#import "OMGAttributedLabel.h"
#import "MOLOtherUserViewController.h"

@interface MOLMineRewardCell ()<UICollectionViewDelegate, UICollectionViewDataSource,TYAttributedLabelDelegate>
@property (nonatomic, weak) JAPaddingLabel *timeLabel;  // 时间
@property (nonatomic, weak) UIView *iconBackView;  // 头像边框
@property (nonatomic, weak) UIImageView *iconImageView;  //  头像
@property (nonatomic, weak) UILabel *nameLabel;    // 名字
@property (nonatomic, weak) UIButton *timeDownButton;  // 倒计时
@property (nonatomic, weak) UIButton *checkButton;  // 红包悬赏才有
@property (nonatomic, weak) OMGAttributedLabel *contentLabel; // 内容
@property (nonatomic, weak) UIButton *goldButton0;  // 金币
@property (nonatomic, weak) UIButton *goldButton;  // 金币
//@property (nonatomic, weak) UIImageView *giftImageView;  // 礼物
//@property (nonatomic, weak) MOLGiftCountView *giftCountView;  // 礼物数量
@property (nonatomic, weak) UICollectionView *collectionView;  // 悬赏拍摄视频
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout; // 布局
@property (nonatomic, weak) UIButton *moreButton; // 更多按钮
@property (nonatomic, weak) UIView *lineView;
@end

@implementation MOLMineRewardCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMineRewardCellUI];
        self.backgroundColor = HEX_COLOR(0x0E0F1A);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 数据
- (void)setCellType:(MOLMineRewardCellType)cellType
{
    _cellType = cellType;
    if (cellType == MOLMineRewardCellType_mine) {
        self.checkButton.hidden = NO;
    }else{
        self.checkButton.hidden = YES;
    }
}

- (void)setCardModel:(MOLExamineCardModel *)cardModel
{
    _cardModel = cardModel;
    
    self.timeLabel.text = [NSString moli_timeGetMessageTimeWithTimestamp:cardModel.createTime];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.userVO.avatar]];
    self.nameLabel.text = [NSString stringWithFormat:@"@%@",cardModel.userVO.userName];
    NSString *amount = [STSystemHelper countNumAndChangeformat:[NSString stringWithFormat:@"%ld ",cardModel.rewardAmount]];
    [self.goldButton setTitle:amount forState:UIControlStateNormal];
    NSString *t = nil;
    OMGAttributedLabelImageType type = OMGAttributedLabelImageType_Undefined;
    if (cardModel.isJoiner) {
        t = @"合拍";
        type = OMGAttributedLabelImageType_InTune;
    }
    NSMutableAttributedString *str = [self getTextWitnContent:self.cardModel.content type:t];
//    self.contentLabel.attributedText = str;
    
    MOLVideoOutsideModel *model = [[MOLVideoOutsideModel alloc] init];
    model.contentType = 1;
    model.rewardVO = cardModel;
    
    [self.contentLabel setTextContainer: [self.contentLabel textContainerContents:model imageType:type]];
    
    self.contentLabel.height = [str mol_getThreeAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 30 font:MOL_REGULAR_FONT(15)];
    
    [self.timeDownButton setTitle:cardModel.timeDownTime forState:UIControlStateNormal];
    [self.timeDownButton sizeToFit];
    
    if (self.cellType == MOLMineRewardCellType_mine) {
        if (cardModel.rewardType == 1) {
            self.checkButton.hidden = NO;
        }else{
            self.checkButton.hidden = YES;
        }
    }else{
        self.checkButton.hidden = YES;
    }
    
    
    MOLLightVideoModel *m = cardModel.storyList.firstObject;
    if (m.playCount == -1) {
        [cardModel.storyList removeObject:m];
    }
    
    MOLLightVideoModel *firstM = [[MOLLightVideoModel alloc] init];
    firstM.coverImage = cardModel.coverImage;
    firstM.playCount = -1;
    firstM.rewardType = cardModel.rewardType;
    [cardModel.storyList insertObject:firstM atIndex:0];
    
    if (cardModel.storyList.count) {
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }else{
        self.collectionView.hidden = YES;
        [self.collectionView reloadData];
    }
    
//    self.giftCountView.beginNumber = cardModel.giftVO.giftNum;
//    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.giftVO.giftThumb]];
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]])
    {
        ContentsItemModel *model = ((TYLinkTextStorage*)textStorage).linkData;
        if (model && [model isKindOfClass: [ContentsItemModel class]] && model.type == 2) {
            
            MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
            vc.userId = [NSString stringWithFormat:@"%ld",model.typeId];
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 按钮点击
- (void)button_clickCheckButton    // 评选
{
    MOLExaminePacketModeViewController *vc = [[MOLExaminePacketModeViewController alloc] init];
    vc.rewardId = self.cardModel.rewardId;
    vc.titleString = self.cardModel.content;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

- (void)button_clickMoreButton  // 点击更多
{
    RecommendViewController *vc = [[RecommendViewController alloc] init];
    PLMediaInfo *info = [[PLMediaInfo alloc] init];
    info.index = 0;
    info.rewardId = self.cardModel.rewardId;
    info.pageNum = 1;
    info.pageSize = MOL_REQUEST_COUNT_VEDIO;
    info.businessType = HomePageBusinessType_userReward;
    info.userId = self.cardModel.userVO.userId;
    vc.mediaDto = info;
    
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
}

#pragma mark - 点击头像
- (void)clickIconImageView
{
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    if ([self.cardModel.userVO.userId isEqualToString:user.userId]) {
        MOLMineViewController *vc = [[MOLMineViewController alloc] init];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
        vc.userId = self.cardModel.userVO.userId;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
}

#pragma mark - collectionviewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        RewardDetailViewController *vc = [[RewardDetailViewController alloc] init];
        vc.rewardModel = self.videooutModel;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        RecommendViewController *vc = [[RecommendViewController alloc] init];
        PLMediaInfo *info = [[PLMediaInfo alloc] init];
        info.index = indexPath.row - 1 > 0 ? indexPath.row - 1 : 0;
        info.rewardId = self.cardModel.rewardId;
        info.pageNum = 1;
        info.pageSize = MOL_REQUEST_COUNT_VEDIO;
        info.businessType = HomePageBusinessType_userReward;
        info.userId = self.cardModel.userVO.userId;
        vc.mediaDto = info;
        
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
}
//分区，组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cardModel.storyList.count;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MOLLightVideoModel *model = self.cardModel.storyList[indexPath.row];
    
    MOLMineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MOLMineCollectionViewCell_id" forIndexPath:indexPath];
    cell.type = MOLMineCollectionViewCellType_userReward;
    cell.lightVideoModel = model;
    if (collectionView.contentSize.width > MOL_SCREEN_WIDTH) {
        self.moreButton.hidden = NO;
        self.moreButton.centerY = self.collectionView.height * 0.5;
        self.moreButton.right = self.collectionView.contentSize.width + 40;
    }else{
        self.moreButton.hidden = YES;
    }
    return cell;
}

#pragma mark - UI
- (void)setupMineRewardCellUI
{
    JAPaddingLabel *timeLabel = [[JAPaddingLabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.text = @"刚刚";
    timeLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
    timeLabel.font = MOL_REGULAR_FONT(11);
    timeLabel.edgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
    timeLabel.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    timeLabel.layer.cornerRadius = 3;
    timeLabel.clipsToBounds = YES;
    [self.contentView addSubview:timeLabel];
    
    UIView *iconBackView = [[UIView alloc] init];
    _iconBackView = iconBackView;
    iconBackView.backgroundColor = HEX_COLOR(0xffffff);
    [self.contentView addSubview:iconBackView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    iconImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconImageView)];
//    [iconImageView addGestureRecognizer:tap];
    [iconBackView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @"加载中...";
    nameLabel.textColor = HEX_COLOR(0xffffff);
    nameLabel.font = MOL_MEDIUM_FONT(15);
    [self.contentView addSubview:nameLabel];
    
    UIButton *timeDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeDownButton = timeDownButton;
    [timeDownButton setImage:[UIImage imageNamed:@"mine_hourglass"] forState:UIControlStateNormal];
    [timeDownButton setTitle:@"还剩 0天0小时0分" forState:UIControlStateNormal];
    [timeDownButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.3) forState:UIControlStateNormal];
    timeDownButton.titleLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:timeDownButton];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton = checkButton;
    checkButton.backgroundColor = HEX_COLOR(0xFFEC00);
//    [checkButton setTitle:@"我来评选" forState:UIControlStateNormal];
//    [checkButton setTitleColor:HEX_COLOR(0x322200) forState:UIControlStateNormal];
//    checkButton.titleLabel.font = MOL_MEDIUM_FONT(11);
//    checkButton.layer.cornerRadius = 3;
//    checkButton.clipsToBounds = YES;
    [checkButton setImage:[UIImage imageNamed:@"mine_examine"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(button_clickCheckButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:checkButton];
    
//    YYLabel *contentLabel = [[YYLabel alloc] init];
//    _contentLabel = contentLabel;
//    contentLabel.numberOfLines = 3;
//    [self.contentView addSubview:contentLabel];
    OMGAttributedLabel *contentLabel =[OMGAttributedLabel new];
    _contentLabel = contentLabel;
    [contentLabel setBackgroundColor: [UIColor clearColor]];
    [contentLabel setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.8)];
    [contentLabel setFont: MOL_REGULAR_FONT(15)];
    [contentLabel setNumberOfLines:3];
//    contentLabel.numberOfLines = 0;
    contentLabel.delegate =self;
    [self.contentView addSubview:contentLabel];
    
    UIButton *goldButton0 = [UIButton buttonWithType:UIButtonTypeCustom];
    _goldButton0 = goldButton0;
    goldButton0.userInteractionEnabled = NO;
    [goldButton0 setImage:[UIImage imageNamed:@"mine_money"] forState:UIControlStateNormal];
    [goldButton0 setTitle:@"赏金" forState:UIControlStateNormal];
    [goldButton0 setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateNormal];
    goldButton0.titleLabel.font = MOL_MEDIUM_FONT(13);
    [self.contentView addSubview:goldButton0];
    
    UIButton *goldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _goldButton = goldButton;
    goldButton.userInteractionEnabled = NO;
    [goldButton setImage:[UIImage imageNamed:@"mine_examine_detail"] forState:UIControlStateNormal];
    [goldButton setTitle:@"0" forState:UIControlStateNormal];
    [goldButton setTitleColor:HEX_COLOR(0xFFEC00) forState:UIControlStateNormal];
    goldButton.titleLabel.font = MOL_MEDIUM_FONT(13);
    [self.contentView addSubview:goldButton];
//
//    UIImageView *giftImageView = [[UIImageView alloc] init];
//    _giftImageView = giftImageView;
//    giftImageView.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:giftImageView];
//
//    MOLGiftCountView *giftCountView = [[MOLGiftCountView alloc] init];
//    _giftCountView = giftCountView;
//    giftCountView.beginNumber = 1024;
//    [self.contentView addSubview:giftCountView];
//
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self.contentView addSubview:lineView];
    
    CGFloat itemW = 114;
    CGFloat itemH = 154;
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = 1;
    self.flowLayout.minimumInteritemSpacing = 1;
    self.flowLayout.itemSize = CGSizeMake(itemW, itemH);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
    _collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 40);
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MOLMineCollectionViewCell class] forCellWithReuseIdentifier:@"MOLMineCollectionViewCell_id"];
    [self addSubview:_collectionView];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton = moreButton;
    [moreButton setImage:[UIImage imageNamed:@"reward_more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(button_clickMoreButton) forControlEvents:UIControlEventTouchUpInside];
    [moreButton sizeToFit];
    [collectionView addSubview:moreButton];
}

- (void)calculatorMineRewardCellFrame
{
    [self.timeLabel sizeToFit];
    self.timeLabel.y = 30;
    self.timeLabel.centerX = self.contentView.width * 0.5;
    
    self.iconBackView.width = 40;
    self.iconBackView.height = 40;
    self.iconBackView.x = 15;
    self.iconBackView.y = self.timeLabel.bottom + 10;
    self.iconBackView.layer.cornerRadius = self.iconBackView.height * 0.5;
    self.iconBackView.clipsToBounds = YES;
    
    self.iconImageView.width = 39;
    self.iconImageView.height = 39;
    self.iconImageView.centerX = self.iconBackView.width * 0.5;
    self.iconImageView.centerY = self.iconBackView.height * 0.5;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
    
    [self.nameLabel sizeToFit];
    if (self.nameLabel.width > self.contentView.width * 0.4) {
        self.nameLabel.width = self.contentView.width * 0.4;
    }
    self.nameLabel.x = self.iconBackView.right + 10;
    self.nameLabel.centerY = self.iconBackView.centerY;
    
    [self.goldButton sizeToFit];
    self.goldButton.height = 18;
    self.goldButton.right = self.contentView.width - 15;
    self.goldButton.centerY = self.nameLabel.centerY;
    [self.goldButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:3];
    
    [self.goldButton0 sizeToFit];
    self.goldButton0.height = 18;
    self.goldButton0.right = self.goldButton.x - 3;
    self.goldButton0.centerY = self.nameLabel.centerY;
    [self.goldButton0 mol_setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:3];
    
    self.contentLabel.width = MOL_SCREEN_WIDTH - 30;
    self.contentLabel.x = 15;
    self.contentLabel.y = self.nameLabel.bottom + 20;
    
    [self.timeDownButton sizeToFit];
    self.timeDownButton.x = 19;
    self.timeDownButton.y = self.contentLabel.bottom + 5;
    [self.timeDownButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:5];
    
    self.checkButton.width = 70;
    self.checkButton.height = 18;
    self.checkButton.right = self.contentView.width - 15;
    self.checkButton.centerY = self.timeDownButton.centerY;
    self.checkButton.layer.cornerRadius = self.checkButton.height * 0.5;
    
//    self.giftImageView.width = 57;
//    self.giftImageView.height = 53;
//    self.giftImageView.centerY = self.goldButton.centerY + 2;
//    self.giftImageView.right = self.contentView.width - 60;
//    
//    self.giftCountView.width = 60;
//    self.giftCountView.height = self.giftImageView.height;
//    self.giftCountView.y = self.giftImageView.y;
//    self.giftCountView.x = self.giftImageView.right;
    
    self.collectionView.width = self.contentView.width;
    self.collectionView.height = 154;
    self.collectionView.y = self.timeDownButton.bottom + 10;
    
//    self.lineView.width = self.contentView.width - 30;
//    self.lineView.height = 1;
//    self.lineView.x = 15;
//    self.lineView.y = self.contentView.height - 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorMineRewardCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (NSMutableAttributedString *)getTextWitnContent:(NSString *)content type:(NSString *)type   // type  红包悬赏 排位悬赏
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.8);
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
