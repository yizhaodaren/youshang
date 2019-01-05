//
//  MOLHotMusicCell.m
//  reward
//
//  Created by apple on 2018/11/24.
//  Copyright © 2018 reward. All rights reserved.
//
#import "MOLHotMusicCell.h"
#import "MOLVideoOutsideModel.h"
#import "MOLGiftCountView.h"
#import "RewardWorkCell.h"
#import "MOLGlobalManager.h"
#import "RecommendViewController.h"
#import "RewardDetailViewController.h"
#import <TYAttributedLabel/TYAttributedLabel.h>
#import "RegexKitLite.h"
#import "OMGAttributedLabel.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
#import "MOLMusicDetailViewController.h"

@interface MOLHotMusicCell()<UICollectionViewDelegate,UICollectionViewDataSource,TYAttributedLabelDelegate>
@property (nonatomic,strong)MOLVideoOutsideModel *outsideModel;
@property (nonatomic,weak)UIView *verticalV;
@property (nonatomic,strong)NSIndexPath *cIndexPath;
@property (nonatomic, weak) UIButton *moreButton; // 更多按钮
@property (nonatomic, weak) UICollectionView *collectionView;  // 悬赏拍摄视频
@end

@implementation MOLHotMusicCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.outsideModel =[MOLVideoOutsideModel new];
        [self setBackgroundColor: [UIColor clearColor]];
    }
    return self;
}

- (void)rewardCell:(MOLVideoOutsideModel *)model indexPath:(NSIndexPath *)indexPath{
    if (!model) {
        return;
    }
    
    if (indexPath) {
        self.cIndexPath =indexPath;
    }
    
    self.outsideModel =model;
    
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    __weak typeof(self) wself = self;
    
    UIImageView *avatars =UIImageView.new;
    avatars.image = [UIImage imageNamed:@"yinle-3"];
    //    [avatars sd_setImageWithURL:[NSURL URLWithString:@"yinle-3"] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    //
    //    }];
    [avatars setBackgroundColor:[UIColor grayColor]];
    //    UITapGestureRecognizer *avatarsTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarsTapEvent:)];
    //    [avatars addGestureRecognizer:avatarsTap];
    [avatars.layer setMasksToBounds:YES];
    [avatars setUserInteractionEnabled:YES];
    [self.contentView addSubview:avatars];
    
    [avatars mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(40);
    }];
    [avatars.layer setCornerRadius:40/2.0];
    
    UIButton *userName =[UIButton buttonWithType:UIButtonTypeCustom];
    [userName setTitle:[NSString stringWithFormat:@"%@",model.musicStoryVO.name?model.musicStoryVO.name:@""] forState:UIControlStateNormal];
    [userName.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [userName setTitleColor:HEX_COLOR_ALPHA(0xffffff,1.0) forState:UIControlStateNormal];
    [userName.titleLabel setFont:MOL_MEDIUM_FONT(15)];
    //    [userName addTarget:self action:@selector(userNameEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:userName];
    
    CGSize userNameSize = [userName.titleLabel.text?userName.titleLabel.text:@"" boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_MEDIUM_FONT(15)} context:nil].size;
    
    CGFloat userNameW = userNameSize.width;
    
    if (userNameSize.width >120) {
        userNameW = 120;
    }
    
    [userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatars.mas_top);
        make.left.mas_equalTo(avatars.mas_right).offset(10);
        make.width.mas_equalTo(userNameW);
        make.height.mas_equalTo(21);
    }];
    
    //热门音乐
    UILabel *detailLab = [[UILabel  alloc] init];
    //    detailLab.text = model.musicStoryVO.name?model.musicStoryVO.name:@"";
    detailLab.text = @"热门音乐";
    detailLab.textColor = HEX_COLOR_ALPHA(0x8F919D, 1);
    detailLab.font = MOL_REGULAR_FONT(13);
    detailLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:detailLab];
    [detailLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(avatars.mas_bottom);
        make.left.mas_equalTo(userName.mas_left);
        make.height.mas_equalTo(21);
    }];
    
    //播放次数
    UIButton *playNumLable =[UIButton buttonWithType:UIButtonTypeCustom];
    [playNumLable setTitle:[NSString stringWithFormat:@"%ld",model.musicStoryVO.storyCount] forState:UIControlStateNormal];
    [playNumLable setImage:[UIImage imageNamed:@"Group 10"] forState:UIControlStateNormal];
    [playNumLable setTitleColor:HEX_COLOR_ALPHA(0xEAEDF4, 1) forState:UIControlStateNormal];
    [playNumLable.titleLabel setFont:MOL_MEDIUM_FONT(13)];
    [playNumLable setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    playNumLable.tag =indexPath.row;
    //[playNumLable setBackgroundColor:[UIColor redColor]];
    //        [playNumLable addTarget:self action:@selector(jumpToRewardDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    playNumLable.userInteractionEnabled = NO;
    [self.contentView addSubview:playNumLable];
    CGSize playNumSize = [[NSString stringWithFormat:@"%@",playNumLable.titleLabel.text] boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_REGULAR_FONT(11)} context:nil].size;
    [playNumLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(avatars.mas_centerY);
        make.left.greaterThanOrEqualTo(userName.mas_right);
        make.right.mas_equalTo(wself.contentView).offset(-16);
        //            make.width.mas_equalTo(playNumSize.width+8);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(20);
    }];
    [playNumLable mol_setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:3];
    playNumLable.backgroundColor = HEX_COLOR(0x393B48);
    playNumLable.layer.cornerRadius = 3;
    
    
    
    
    
    
    
    UICollectionViewFlowLayout *flowLayout =[UICollectionViewFlowLayout new];
    
    CGFloat itemW = 114;
    CGFloat itemH = 154;
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    
    UICollectionView *collectionViewS = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    
    
    collectionViewS.contentInset = UIEdgeInsetsMake(0, 15, 0, 35);
    collectionViewS.delegate = self;
    collectionViewS.dataSource = self;
    collectionViewS.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        collectionViewS.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    collectionViewS.showsVerticalScrollIndicator = NO;
    collectionViewS.showsHorizontalScrollIndicator = NO;
    [collectionViewS registerClass:[RewardWorkCell class] forCellWithReuseIdentifier:@"RewardWorkCellID"];
    
    self.collectionView =collectionViewS;
    [self addSubview:collectionViewS];
    
    
    [collectionViewS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatars.mas_bottom).offset(10);
        make.left.right.mas_equalTo(wself.contentView);
        make.bottom.mas_equalTo(wself.contentView).offset(-15);
    }];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton = moreButton;
    [moreButton setImage:[UIImage imageNamed:@"reward_more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(button_clickMoreButton) forControlEvents:UIControlEventTouchUpInside];
    [moreButton sizeToFit];
    
    
    [collectionViewS addSubview:moreButton];
    
    
    UIView *lineView =[UIView new];
    [lineView setBackgroundColor:HEX_COLOR_ALPHA(0xffffff, 0.1)];
    [self.contentView addSubview:lineView];
    
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatars.mas_left);
        make.right.mas_equalTo(wself.contentView).offset(-15);
        make.bottom.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(@1);
    }];
    
}
#pragma mark - collectionviewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    WSC
    //    if (self.outsideModel.musicStoryVO.musicId > 0) {
    //        MOLMusicDetailViewController * rewardDetail = [MOLMusicDetailViewController new];
    //        rewardDetail.musicId = self.outsideModel.musicStoryVO.musicId;
    //        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
    //    }
    
    
    //跳转到首页播放器
    RecommendViewController *vc = [[RecommendViewController alloc] init];
    PLMediaInfo *info = [[PLMediaInfo alloc] init];
    
    
    info.index = indexPath.row;
    info.musicID = self.outsideModel.musicStoryVO.musicId;
    info.sortType = 3;
    info.businessType = HomePageBusinessType_sameMusicUserProduction;
    info.pageNum =1;
    info.pageSize =MOL_REQUEST_COUNT_VEDIO;
    vc.mediaDto = info;
    
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    
    
    
}
//分区，组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //  NSLog(@"%ld",self.outsideModel.rewardVO?self.outsideModel.rewardVO.storyList.count+1:0);
    NSInteger num = self.outsideModel.musicStoryVO?self.outsideModel.musicStoryVO.storyList.count:0;
    return num;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RewardWorkCell *rewardWorkCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RewardWorkCellID" forIndexPath:indexPath];
    
    if (self.outsideModel.musicStoryVO) {
        [rewardWorkCell contentMusic:self.outsideModel indexPath:indexPath];
    }
    
    NSLog(@"%f",collectionView.contentSize.width);
    NSLog(@"%ld",(long)indexPath.row);
    
    
    if(self.outsideModel.musicStoryVO.storyList.count >= 6){
        
        self.moreButton.hidden = NO;
        self.moreButton.centerY = self.collectionView.height * 0.5;
        self.moreButton.right = self.collectionView.contentSize.width + 40;
    }else{
        NSLog(@"YESYESYESYES%ld",self.outsideModel.musicStoryVO.storyList.count);
        
        self.moreButton.hidden = YES;
    }
    
    
    //    if (collectionView.contentSize.width > MOL_SCREEN_WIDTH) {
    //            NSLog(@"NO");
    //        self.moreButton.hidden = NO;
    //        self.moreButton.centerY = self.collectionView.height * 0.5;
    //        self.moreButton.right = self.collectionView.contentSize.width + 40;
    //    }else{
    //         NSLog(@"YES");
    ////        self.moreButton.hidden = YES;
    //    }
    
    
    return rewardWorkCell;
}

- (void)button_clickMoreButton  // 点击更多
{
    //WSC
    if (self.outsideModel.musicStoryVO.musicId > 0) {
        MOLMusicDetailViewController * rewardDetail = [MOLMusicDetailViewController new];
        rewardDetail.musicId = self.outsideModel.musicStoryVO.musicId;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
    }
    
    
}
#pragma mark
#pragma mark action event
- (void)jumpToRewardDetail:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(playCountEvent: indexPath:)]) {
        [_delegate playCountEvent:sender indexPath:self.cIndexPath];
    }
}
- (void)userNameEvent:(UIButton *)sender{
    //  NSLog(@"用户名称事件响应");
    // self.currentType =CommentCellEventComment;
    [self personalCenterEventResponse];
}

- (void)reviewerEvent:(UIButton *)sender{
    //  NSLog(@"被评论名称事件响应");
    // self.currentType =CommentCellEventReviewers;
    [self personalCenterEventResponse];
}

- (void)avatarsTapEvent:(UITapGestureRecognizer *)sender{
    //  NSLog(@"用户头像被点击");
    //   self.currentType =CommentCellEventAvatars;
    [self personalCenterEventResponse];
}

- (void)personalCenterEventResponse{
    
    if (_delegate && [_delegate respondsToSelector: @selector(rewardCellAvatarEvent:)]) {
        [_delegate rewardCellAvatarEvent:self.cIndexPath];
    }
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]])
    {
        ContentsItemModel *model = ((TYLinkTextStorage*)textStorage).linkData;
        if (model && [model isKindOfClass: [ContentsItemModel class]] && model.type == 2) {
            
            MOLUserModel *userVO =[MOLUserModel new];
            userVO.userId = [NSString stringWithFormat:@"%ld",model.typeId];
            
            if ([[MOLGlobalManager shareGlobalManager] isUserself:userVO]) {
                MOLMineViewController *vc = [[MOLMineViewController alloc] init];
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }else{
                MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
                vc.userId = userVO.userId;
                [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
            }
            
        }
    }
}

- (NSMutableAttributedString *)examinePacketList_getTextWitnContent:(NSString *)content
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    text.yy_color = HEX_COLOR_ALPHA(0xFFEC00, 1);
    text.yy_font = MOL_MEDIUM_FONT(18);
    return text;
}

@end
