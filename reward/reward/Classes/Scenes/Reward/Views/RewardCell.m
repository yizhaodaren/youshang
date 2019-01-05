//
//  RewardCell.m
//  reward
//
//  Created by xujin on 2018/9/23.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "RewardCell.h"
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


@interface RewardCell()<UICollectionViewDelegate,UICollectionViewDataSource,TYAttributedLabelDelegate>
@property (nonatomic,strong)MOLVideoOutsideModel *rewardModel;
@property (nonatomic,weak)UIView *verticalV;
@property (nonatomic,strong)NSIndexPath *cIndexPath;
@property (nonatomic, weak) UIButton *moreButton; // 更多按钮
@property (nonatomic, weak) UICollectionView *collectionView;  // 悬赏拍摄视频
@end

@implementation RewardCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rewardModel =[MOLVideoOutsideModel new];
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
    
    self.rewardModel =model;
    
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
     __weak typeof(self) wself = self;
    
    UIImageView *avatars =UIImageView.new;
    [avatars sd_setImageWithURL:[NSURL URLWithString:model.rewardVO.userVO.avatar?model.rewardVO.userVO.avatar:@""] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

    }];
    [avatars setBackgroundColor:[UIColor grayColor]];
    UITapGestureRecognizer *avatarsTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarsTapEvent:)];
    [avatars addGestureRecognizer:avatarsTap];
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
    [userName setTitle:[NSString stringWithFormat:@"@%@",model.rewardVO.userVO.userName?model.rewardVO.userVO.userName:@""] forState:UIControlStateNormal];
    //userName.titleLabel.textAlignment=NSTextAlignmentLeft;
    [userName.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [userName setTitleColor:HEX_COLOR_ALPHA(0xffffff,1.0) forState:UIControlStateNormal];
    [userName.titleLabel setFont:MOL_MEDIUM_FONT(15)];
    [userName addTarget:self action:@selector(userNameEvent:) forControlEvents:UIControlEventTouchUpInside];
    //  [userName setBackgroundColor:[UIColor blueColor]];
    [self.contentView addSubview:userName];
    
   
    
    CGSize userNameSize = [userName.titleLabel.text?userName.titleLabel.text:@"" boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_MEDIUM_FONT(15)} context:nil].size;
    
    CGFloat userNameW = userNameSize.width;
    
    if (userNameSize.width >120) {
        userNameW = 120;
    }
    
    [userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(avatars.mas_centerY);
        make.left.mas_equalTo(avatars.mas_right).offset(10);
        make.width.mas_equalTo(userNameW);
        make.height.mas_equalTo(21);
    }];
    

//    UIButton *playNumLable =[UIButton buttonWithType:UIButtonTypeCustom];
//    [playNumLable setTitle:[NSString stringWithFormat:@"播放%ld次",model.rewardVO.playCount] forState:UIControlStateNormal];
//    [playNumLable setImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
//    [playNumLable setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.6) forState:UIControlStateNormal];
//    [playNumLable.titleLabel setFont:MOL_REGULAR_FONT(11)];
//    [playNumLable setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//
//    playNumLable.tag =indexPath.row;
//    //[playNumLable setBackgroundColor:[UIColor redColor]];
//    [playNumLable addTarget:self action:@selector(jumpToRewardDetail:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:playNumLable];
//    CGSize playNumSize = [[NSString stringWithFormat:@"%@",playNumLable.titleLabel.text] boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_REGULAR_FONT(11)} context:nil].size;
//    [playNumLable mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(userName.mas_centerY);
//        make.left.greaterThanOrEqualTo(userName.mas_right);
//        make.right.mas_equalTo(wself.contentView).offset(-16);
//        make.width.mas_equalTo(playNumSize.width+8);
//        make.height.mas_equalTo(16);
//    }];
//
//    // 还可增设间距
//    CGFloat spacing = 5;
//    // 图片右移
//    CGSize imageSize = playNumLable.imageView.frame.size;
//    // 文字左移
//    CGSize titleSize = playNumLable.titleLabel.frame.size;
//
//    //self.titleButotn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width-titleSize.width + spacing, 0.0, 0.0);
//
//    // 文字左移
//    // CGSize titleSize = self.titleButotn.titleLabel.frame.size;
//    playNumLable.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0,-(titleSize.width + imageSize.width)*2.0 - spacing);
//    /* 小结: imageEdgeInsets 为'上左下右', 正值远离中心, 负值向中心聚拢. 具体以单词'inset'来记忆 */
//
//
//    //[playNumLable setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//   // [playNumLable sizeToFit];
    
    
    
///////////
    
    OMGAttributedLabel *mainCommet =[OMGAttributedLabel new];
    [mainCommet setBackgroundColor: [UIColor clearColor]];
    [mainCommet setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.8)];
    [mainCommet setFont: MOL_REGULAR_FONT(15)];
    
    [mainCommet setPreferredMaxLayoutWidth:MOL_SCREEN_WIDTH - 45 - 15];
    mainCommet.delegate =self;
    [self.contentView addSubview:mainCommet];

    NSMutableAttributedString *desStr = [OMGAttributedLabel getJoinerAttributedStr:model.rewardVO];
   
    OMGAttributedLabelImageType imageType =OMGAttributedLabelImageType_Undefined;

        if (model.rewardVO.isJoiner) {//是合拍
            imageType = OMGAttributedLabelImageType_InTune;
        }
    
    
    [mainCommet setTextContainer:[mainCommet textContainerContents:model imageType:imageType]];
    // mainCommet.attributedText =desStr;
    
    [mainCommet.textContainer setLineBreakMode:kCTLineBreakByTruncatingTail];
    
    CGFloat textH = [desStr mol_getAttributedTextHeightWithMaxWith:MOL_SCREEN_WIDTH - 15 - 15 font:MOL_REGULAR_FONT(15)];
   
    
    
    
    if (textH > 22*3) {//限制3行
        textH =66;
    }
    [mainCommet mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatars.mas_left);
        make.right.mas_equalTo(wself.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(avatars.mas_bottom).offset(10);
        make.height.mas_equalTo(textH);
    }];
    
    mainCommet.numberOfLines = 3;
    
   // [mainCommet setBackgroundColor:[UIColor redColor]];
    
///////////
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    //label.highlightedLinkColor = [UIColor redColor];
    [label setTextAlignment:kCTTextAlignmentRight];
    label.delegate =self;
    [label setBackgroundColor: [UIColor clearColor]];
    [self.contentView addSubview:label];
    
    
    NSString *text =@"赏金";
    
    text =[text stringByAppendingString:[NSString stringWithFormat:@"[mine_money,14,14]"]];
    text =[text stringByAppendingString:[STSystemHelper countNumAndChangeformat:[NSString stringWithFormat:@"%ld",model.rewardVO.rewardAmount]]];
    text =[text stringByAppendingString:@" [Group,13,8]"];
    
    
    
    // 属性文本生成器
    
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    textContainer.textAlignment = NSTextAlignmentRight;
    [textContainer setStrokeColor: [UIColor clearColor]];
    [textContainer setTextColor:HEX_COLOR(0xFFEC00)];
    [textContainer setFont: MOL_MEDIUM_FONT(13)];
//    label.backgroundColor =[UIColor redColor];
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // 正则匹配图片信息
    [text enumerateStringsMatchedByRegex:@"\\[(\\w+?),(\\d+?),(\\d+?)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 3) {
            // 图片信息储存
            TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
            imageStorage.cacheImageOnMemory = YES;
            imageStorage.imageAlignment =TYImageAlignmentFill;
            imageStorage.imageName = capturedStrings[1];
            imageStorage.range = capturedRanges[0];
            imageStorage.size = CGSizeMake([capturedStrings[2]intValue], [capturedStrings[3]intValue]);
            
            [tmpArray addObject:imageStorage];
        }
    }];
    
    // 添加图片信息数组到label
    [textContainer addTextStorageArray:tmpArray];
    
    //   textContainer = [textContainer createTextContainerWithTextWidth:CGRectGetWidth(self.view.frame)];
    
    label.textContainer =textContainer;
    
    // 计算文字宽度
    CGSize lableSize = [[NSString stringWithFormat:@"赏金%@",[STSystemHelper countNumAndChangeformat:[NSString stringWithFormat:@"%ld ",model.rewardVO.rewardAmount]]] boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_MEDIUM_FONT(15)} context:nil].size;
                        
    
   
    CGFloat textW = lableSize.width;
    textW =textW+(14+13)+5;
    if (textW>(MOL_SCREEN_WIDTH-15-15-40-userName.width)) {
        textW =MOL_SCREEN_WIDTH-15-15-40-userName.width;
    }
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(userName.mas_centerY);
        make.right.mas_equalTo(wself.contentView).offset(-15);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(textW);
        
    }];
//    UIButton *goldButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    goldButton.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
//    [goldButton setImage:[UIImage imageNamed:@"mine_money"] forState:UIControlStateNormal];
//    [goldButton setTitle:[NSString stringWithFormat:@"%ld",model.rewardVO.rewardAmount] forState:UIControlStateNormal];
//    [goldButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
//    goldButton.titleLabel.font = MOL_REGULAR_FONT(14);
//    [self.contentView addSubview:goldButton];
//
//    [goldButton sizeToFit];
//    goldButton.layer.cornerRadius = 3;
//    goldButton.clipsToBounds = YES;
//    [goldButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(avatars.mas_right).offset(12);
//        make.top.mas_equalTo(mainCommet.mas_bottom).offset(10);
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(goldButton.width+28);
//    }];
//
//    UIImageView *giftImageView = [[UIImageView alloc] init];
//
//   // giftImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [giftImageView sd_setImageWithURL:[NSURL URLWithString:model.rewardVO.giftVO.giftThumb?model.rewardVO.giftVO.giftThumb:@""] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
//
//    [giftImageView setContentMode:UIViewContentModeScaleAspectFill];
//    [self.contentView addSubview:giftImageView];
//    MOLGiftCountView *giftCountView = [[MOLGiftCountView alloc] init];
//    giftCountView.beginNumber = model.rewardVO.giftVO.giftNum;
//    CGSize giftSize = [[NSString stringWithFormat:@"X%ld",giftCountView.beginNumber] boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_MEDIUM_FONT(18)} context:nil].size;
//    [self.contentView addSubview:giftCountView];
//   // [giftCountView setBackgroundColor: [UIColor redColor]];
//
//    [giftCountView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(wself.contentView.mas_right).offset(-15);
//        make.height.mas_equalTo(giftImageView.mas_height);
//        make.width.mas_equalTo(giftSize.width);
//        make.centerY.mas_equalTo(goldButton.mas_centerY);
//    }];
//
//    [giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(giftCountView.mas_left);
//        make.height.mas_equalTo(53);
//        make.width.mas_equalTo(57);
//        make.centerY.mas_equalTo(goldButton.mas_centerY);
//    }];
//
    
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
        make.top.mas_equalTo(mainCommet.mas_bottom).offset(10);
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
    if (indexPath.row==0) {//跳转到悬赏详情
        RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
        rewardDetail.rewardModel =self.rewardModel;
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
    }else{//跳转到首页播放器
        RecommendViewController *vc = [[RecommendViewController alloc] init];
        PLMediaInfo *info = [[PLMediaInfo alloc] init];
        info.index = indexPath.row - 1 > 0 ? indexPath.row - 1 : 0;
        info.rewardId = self.rewardModel.rewardVO.rewardId;
        info.userId = self.rewardModel.rewardVO.userVO.userId;
        info.businessType = HomePageBusinessType_RewardList;
        info.pageNum =1;
        info.pageSize =MOL_REQUEST_COUNT_VEDIO;
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
  //  NSLog(@"%ld",self.rewardModel.rewardVO?self.rewardModel.rewardVO.storyList.count+1:0);
    return self.rewardModel.rewardVO?self.rewardModel.rewardVO.storyList.count+1:0;
}

//单元格复用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RewardWorkCell *rewardWorkCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RewardWorkCellID" forIndexPath:indexPath];
    
    if (self.rewardModel.rewardVO) {
        [rewardWorkCell content:self.rewardModel indexPath:indexPath];
    }
    
    if (collectionView.contentSize.width > MOL_SCREEN_WIDTH) {
        self.moreButton.hidden = NO;
        self.moreButton.centerY = self.collectionView.height * 0.5;
        self.moreButton.right = self.collectionView.contentSize.width + 40;
    }else{
        self.moreButton.hidden = YES;
    }
    

    return rewardWorkCell;
}

- (void)button_clickMoreButton  // 点击更多
{
//    RecommendViewController *vc = [[RecommendViewController alloc] init];
//    PLMediaInfo *info = [[PLMediaInfo alloc] init];
//    info.index = 0;
//    info.rewardId = self.rewardModel.rewardVO.rewardId;
//    info.userId = self.rewardModel.rewardVO.userVO.userId;
//    info.businessType = HomePageBusinessType_RewardList;
//    info.pageNum =1;
//    info.pageSize =MOL_REQUEST_COUNT_VEDIO;
//    vc.mediaDto = info;
//
//    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    
    RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
    rewardDetail.rewardModel =self.rewardModel;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail
                                         animated:YES];
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
