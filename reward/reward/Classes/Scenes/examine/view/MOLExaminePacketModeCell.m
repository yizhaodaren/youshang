//
//  MOLExaminePacketModeCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExaminePacketModeCell.h"
#import <Photos/Photos.h>
#import "CBAutoScrollLabel.h"
#import "MOLActionRequest.h"
#import "STSystemHelper.h"
#import "HomePageRequest.h"
#import "HomeCommentView.h"
#import "HomeShareView.h"
#import <AFHTTPSessionManager.h>
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
#import "RewardDetailViewController.h"
#import "MOLStatistics.h"
#import "OMGAttributedLabel.h"

@interface MOLExaminePacketModeCell ()<PLPlayerDelegate,HomeShareViewDelegate,TYAttributedLabelDelegate>
@property (nonatomic, assign) MOLExaminePacketModeCellType cellType;  // 有无满意按钮

@property (nonatomic, weak) UIView *iconBackView;
@property (nonatomic, weak) UIImageView *iconImageView;  // 头像
@property (nonatomic, weak) UILabel *nameLabel;  // 名字
@property (nonatomic, weak) OMGAttributedLabel *contentLabel;  // 内容
@property (nonatomic, weak) UIView *videoView;  // 视频
@property (nonatomic, weak) UIImageView *thumbImageView;  // 视频
@property (nonatomic, weak) UIButton *playButton;  // 播放按钮

@property (nonatomic, weak) UILabel *timeLabel;  // 时间
@property (nonatomic, weak) UIButton *likeButton;  // 点赞
@property (nonatomic, weak) UIButton *commentButton;  // 评论
@property (nonatomic, weak) UIButton *shareButton;  // 分享
@property (nonatomic, weak) UIButton *myActionButton;  // 我的帖子的时候展示
@property (nonatomic, weak) UIButton *qualifiedButton;  // 满意(合格)
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, assign) CGRect oriRect;
@property (nonatomic, weak) UIView *videoView_big;  // 视频
@property (nonatomic, weak) UIImageView *bottomImgView;

@property (nonatomic, weak) UIImageView *rewardUserImageView;  // 悬赏下作品 用户头像
@property (nonatomic, weak) UIImageView *harmonyImageView;  // 是否是合拍
@property (nonatomic, weak) CBAutoScrollLabel *rewardContentLabel; // 悬赏下作品 悬赏内容

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *oriUrlString;
@property (nonatomic, assign) NSInteger favorC; //点赞数 用于+ -

@property (nonatomic, assign) NSInteger currentType; // 统计用 - 类型
@property (nonatomic, strong) NSString *currentId; // 统计用 - id
@end

@implementation MOLExaminePacketModeCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(MOLExaminePacketModeCellType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellType = type;
        self.favorC =0;
        [self setupExaminePacketModeCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self notification];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.favorC =0;
        [self setupExaminePacketModeCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self notification];
    }
    return self;
}

- (void)notification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachableViaWWAN) name:MOL_ReachableViaWWAN object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentEvent:) name:MOL_SEND_COMMENT object:nil];
    
}

- (void)commentEvent:(NSNotification *)notif{
    if (notif.object) {
        
        MOLVideoOutsideModel *model = notif.object;
        
        if(self.videoModel){
            if (model.storyVO.storyId == self.videoModel.storyId) {
//                self.videoModel.commentCount += 1;
                NSString *count = [STSystemHelper getNum:self.videoModel.commentCount];
                [self.commentButton setTitle:count forState:UIControlStateNormal];
            }
        }else{
            if (model.contentType == 1) {
                if ([model.rewardVO.rewardId isEqualToString:self.videoOutsideModel.rewardVO.rewardId]) {
//                    self.videoOutsideModel.rewardVO.commentCount += 1;
                    NSString *count = [STSystemHelper getNum:self.videoOutsideModel.rewardVO.commentCount];
                    [self.commentButton setTitle:count forState:UIControlStateNormal];
                }
            }else{
                if (model.storyVO.storyId == self.videoOutsideModel.storyVO.storyId) {
//                    self.videoOutsideModel.storyVO.commentCount += 1;
                    NSString *count = [STSystemHelper getNum:self.videoOutsideModel.storyVO.commentCount];
                    [self.commentButton setTitle:count forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)reachableViaWWAN
{
    if (self.player.playing) {
        [self.player pause];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前为非WIFI环境\n已为你暂停播放" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"继续播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.player resume];
            
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"暂停播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancleAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] presentViewController:alertController animated:YES completion:nil];
        });
    }
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

#pragma mark - 数据
- (void)setVideoModel:(MOLVideoModel *)videoModel
{
    _videoModel = videoModel;
    
    if (_videoOutsideModel == nil) {

        _videoOutsideModel = [[MOLVideoOutsideModel alloc] init];
    }
    _videoOutsideModel.storyVO = videoModel;
    _videoOutsideModel.contentType = 2;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.userVO.avatar]];
    self.nameLabel.text = [NSString stringWithFormat:@"@%@",videoModel.userVO.userName?videoModel.userVO.userName:@""];
//    self.contentLabel.attributedText = [self examinePacketList_getTextWitnContent:videoModel.content];
    [self.contentLabel setTextContainer: [self.contentLabel textContainerContents:_videoOutsideModel imageType:OMGAttributedLabelImageType_Undefined]];
    
    self.timeLabel.text = [NSString getCommentMessageTimeWithTimestamp:videoModel.createTime];
    
    if (videoModel.commentCount > 0) {
        NSString *count = [STSystemHelper getNum:videoModel.commentCount];
        [self.commentButton setTitle:count forState:UIControlStateNormal];
    }else{
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    }
    
    if (videoModel.favorCount > 0) {
        [self.likeButton setTitle:[STSystemHelper getNum:videoModel.favorCount] forState:UIControlStateNormal];
    }else{
        [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    
    self.likeButton.selected = videoModel.isFavor;

    if (videoModel.shareCount > 0) {
        NSString *count = [STSystemHelper getNum:videoModel.shareCount];
        [self.shareButton setTitle:count forState:UIControlStateNormal];
    }else{
        [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
    }
    
    BOOL needsetupPlay = ![self.oriUrlString isEqualToString:videoModel.audioUrl];
    
    self.oriUrlString = videoModel.audioUrl;
    self.url = [NSURL URLWithString:videoModel.audioUrl];
    self.currentId = [NSString stringWithFormat:@"%ld",videoModel.storyId];
    self.currentType = 2;
    
    self.thumbImageView.contentMode =[BMSHelpers getPlayerContentMode:self.videoOutsideModel];
    
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.coverImage]];
    
    if (needsetupPlay) {
        [self setupPlayer];
    }
    
    self.videoView.width = self.videoModel.scaleVideoW;
    self.videoView.height = self.videoModel.scaleVideoH;
    
    self.contentLabel.width = self.contentView.width - 15 * 2;
    NSMutableAttributedString *str = [self examinePacketList_getTextWitnContent:self.videoModel.content];
    self.contentLabel.height = [str mol_getAttributedTextHeightWithMaxWith:self.contentLabel.width font:MOL_REGULAR_FONT(15)];
    
    if (videoModel.isReward) {
        self.qualifiedButton.selected = YES;
        self.qualifiedButton.backgroundColor = HEX_COLOR(0x9b9b9b);
    }else{
        self.qualifiedButton.selected = NO;
        self.qualifiedButton.backgroundColor = HEX_COLOR(0xFE6257);
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setVideoOutsideModel:(MOLVideoOutsideModel *)videoOutsideModel
{
    _videoOutsideModel = videoOutsideModel;
    
     self.thumbImageView.contentMode =[BMSHelpers getPlayerContentMode:self.videoOutsideModel];
    
    if (videoOutsideModel.contentType == 1) {  // 悬赏
        self.bottomImgView.hidden = YES;
        self.rewardContentLabel.hidden = YES;
        self.rewardUserImageView.hidden = YES;
        self.harmonyImageView.hidden = YES;
        MOLExamineCardModel *model = videoOutsideModel.rewardVO;
        self.favorC =videoOutsideModel.rewardVO.favorCount;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userVO.avatar]];
        self.nameLabel.text = model.userVO.userName;
        self.nameLabel.text = [NSString stringWithFormat:@"@%@",model.userVO.userName?model.userVO.userName:@""];
//        self.contentLabel.attributedText = [self home_getTextWitnContent:model.content type:model.rewardType == 1 ? @"红包悬赏":@"排名悬赏"];
        
        [self.contentLabel setTextContainer: [self.contentLabel textContainerContents:_videoOutsideModel imageType:OMGAttributedLabelImageType_Reward]];
        
        UITapGestureRecognizer *rewardCTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rewardContentEvent:)];
        [self.contentLabel addGestureRecognizer:rewardCTap];
        
        self.timeLabel.text = [NSString getCommentMessageTimeWithTimestamp:model.createTime];
        
        if (model.commentCount > 0) {
            NSString *count = [STSystemHelper getNum:model.commentCount];
            [self.commentButton setTitle:count forState:UIControlStateNormal];
        }else{
            [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
        }
        if (model.favorCount > 0) {
            [self.likeButton setTitle:[STSystemHelper getNum:model.favorCount] forState:UIControlStateNormal];
        }else{
            [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
        }
        
        self.likeButton.selected = model.isFavor;
        
        if (model.shareCount > 0) {
            NSString *count = [STSystemHelper getNum:model.shareCount];
            [self.shareButton setTitle:count forState:UIControlStateNormal];
        }else{
            [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
        }
        
        
        BOOL needsetupPlay = ![self.oriUrlString isEqualToString:model.audioUrl];
        
        self.oriUrlString = model.audioUrl;
        self.url = [NSURL URLWithString:model.audioUrl];
        self.currentId = [NSString stringWithFormat:@"%@",model.rewardId];
        self.currentType = 1;
        
        [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImage]];
        
        if (needsetupPlay) {
            [self setupPlayer];
        }
        
        self.videoView.width = model.scaleVideoW;
        self.videoView.height = model.scaleVideoH;
        
        self.contentLabel.width = self.contentView.width - 15 * 2;
        NSMutableAttributedString *str = [self home_getTextWitnContent:model.content type:model.rewardType == 1 ? @"红包悬赏":@"排名悬赏"];
        self.contentLabel.height = [str mol_getAttributedTextHeightWithMaxWith:self.contentLabel.width font:MOL_REGULAR_FONT(15)];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
    }else{  // 作品
        
        MOLVideoModel *videoModel = videoOutsideModel.storyVO;
        self.favorC =videoOutsideModel.storyVO.favorCount;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.userVO.avatar]];
        
        self.nameLabel.text = [NSString stringWithFormat:@"@%@",videoModel.userVO.userName?videoModel.userVO.userName:@""];
       // self.contentLabel.attributedText = [self home_getTextWitnContent:videoModel.content type:nil];
        [self.contentLabel setTextContainer: [self.contentLabel textContainerContents:_videoOutsideModel imageType:OMGAttributedLabelImageType_Reward]];
        
        self.timeLabel.text = [NSString getCommentMessageTimeWithTimestamp:videoModel.createTime];
        
        if (videoModel.commentCount > 0) {
            NSString *count = [STSystemHelper getNum:videoModel.commentCount];
            [self.commentButton setTitle:count forState:UIControlStateNormal];
        }else{
            [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
        }
        
        if (videoModel.favorCount > 0) {
            [self.likeButton setTitle:[STSystemHelper getNum:videoModel.favorCount] forState:UIControlStateNormal];
        }else{
            [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
        }
        
        self.likeButton.selected = videoModel.isFavor;

        if (videoModel.shareCount > 0) {
            NSString *count = [STSystemHelper getNum:videoModel.shareCount];
            [self.shareButton setTitle:count forState:UIControlStateNormal];
        }else{
            [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
        }
        
        BOOL needsetupPlay = ![self.oriUrlString isEqualToString:videoModel.audioUrl];
        
        self.oriUrlString = videoModel.audioUrl;
        self.url = [NSURL URLWithString:videoModel.audioUrl];
        self.currentId = [NSString stringWithFormat:@"%ld",videoModel.storyId];
        self.currentType = 2;
        
        [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.coverImage]];
        
        if (videoModel.rewardVO) {
            self.bottomImgView.hidden = NO;
            self.rewardContentLabel.hidden = NO;
            self.rewardUserImageView.hidden = NO;
            
            self.rewardContentLabel.text = videoModel.rewardVO.content;
            [self.rewardUserImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.rewardVO.avatar]];
            
            [self.rewardContentLabel observeApplicationNotifications];
            if (videoModel.rewardVO.isJoiner) {
                self.harmonyImageView.hidden = NO;
            }else{
                self.harmonyImageView.hidden = YES;
            }
        }else{
            self.bottomImgView.hidden = YES;
            self.rewardContentLabel.hidden = YES;
            self.rewardUserImageView.hidden = YES;
            self.harmonyImageView.hidden = YES;
        }
        
        if (needsetupPlay) {
            [self setupPlayer];
        }
        
        
        self.videoView.width = videoModel.scaleVideoW;
        self.videoView.height = videoModel.scaleVideoH;
        
        self.contentLabel.width = self.contentView.width - 15 * 2;
        NSMutableAttributedString *str = [self home_getTextWitnContent:videoModel.content type:nil];
        self.contentLabel.height = [str mol_getAttributedTextHeightWithMaxWith:self.contentLabel.width font:MOL_REGULAR_FONT(15)];
        
        if (videoModel.isReward) {
            self.qualifiedButton.selected = YES;
            self.qualifiedButton.backgroundColor = HEX_COLOR(0x9b9b9b);
        }else{
            self.qualifiedButton.selected = NO;
            self.qualifiedButton.backgroundColor = HEX_COLOR(0xFE6257);
        }
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    
}

#pragma mark - 播放控制器
- (void) setupPlayer
{
    [self.player stop];
    [self.player.playerView removeFromSuperview];
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    NSString *urlString = _url.absoluteString.lowercaseString;
    if ([urlString hasSuffix:@"mp4"]) {
        format = kPLPLAY_FORMAT_MP4;
    } else if ([urlString hasPrefix:@"rtmp:"]) {
        format = kPLPLAY_FORMAT_FLV;
    } else if ([urlString hasSuffix:@".mp3"]) {
        format = kPLPLAY_FORMAT_MP3;
    } else if ([urlString hasSuffix:@".m3u8"]) {
        format = kPLPLAY_FORMAT_M3U8;
    }
    [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:_url option:option];
    [self.videoView insertSubview:self.player.playerView atIndex:0];
    self.player.delegateQueue = dispatch_get_main_queue();
    
    self.player.playerView.contentMode = [BMSHelpers getPlayerContentMode:self.videoOutsideModel];
    self.player.delegate = self;
    self.player.loopPlay = YES;
}

#pragma mark - PLPlayerDelegate
- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state
{
    if (state == PLPlayerStatusStopped || state == PLPlayerStatusError) {
        self.thumbImageView.hidden = NO;
    }else{
//        self.thumbImageView.hidden = YES;
    }
    
    if (player.playing) {
        self.playButton.selected = YES;
    }else{
        self.playButton.selected = NO;
    }
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error
{
    self.thumbImageView.hidden = NO;
    self.playButton.selected = NO;
}

- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType
{
    self.thumbImageView.hidden = YES;
    self.playButton.selected = YES;
    
    // 统计-播放
    if (firstRenderType == PLPlayerFirstRenderTypeVideo) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"operateType"] = @"1";
        dic[@"recordType"] = @(self.currentType);
        dic[@"typeId"] = self.currentId;
        [MOLStatistics statistics_play:dic];
    }
}

#pragma mark - 按钮的点击
- (void)button_clickLikeButton   // 点赞
{
    if (![MOLUserManagerInstance user_isLogin]) {
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    self.likeButton.userInteractionEnabled = NO;
    self.likeButton.selected =!self.likeButton.selected;
    
    if (self.likeButton.selected) {
        self.favorC ++;
    }else{
        if (self.favorC>0) {
            self.favorC--;
        }
    }
    
    if (self.favorC > 0) {
        [self.likeButton setTitle:[STSystemHelper getNum:self.favorC] forState:UIControlStateNormal];
    }else{
        [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    
    [self.likeButton sizeToFit];
    
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"1" forKey:@"operateType"];
    
    
    if (_videoOutsideModel.contentType ==1) {//悬赏
        [dic setObject:@"1" forKey:@"recordType"];
        [dic setObject:[NSString stringWithFormat:@"%@",_videoOutsideModel.rewardVO.rewardId?_videoOutsideModel.rewardVO.rewardId:@""] forKey:@"typeId"];
    }else{ //作品
        [dic setObject:@"2" forKey:@"recordType"];
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)_videoOutsideModel.storyVO.storyId] forKey:@"typeId"];
    }
    
    
    __weak typeof(self) wself = self;
    [[[HomePageRequest alloc] initRequest_PraiseParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        NSInteger type = [request.responseObject[@"resBody"] integerValue];
        if (code  != MOL_SUCCESS_REQUEST) {
            wself.likeButton.selected =!wself.likeButton.selected;
            if (self->_videoOutsideModel.contentType ==1) {//悬赏
                wself.favorC =self->_videoOutsideModel.rewardVO.favorCount;
            }else{ //作品
                wself.favorC =self->_videoOutsideModel.storyVO.favorCount;
            }
            
            if (wself.favorC > 0) {
                [wself.likeButton setTitle:[STSystemHelper getNum:wself.favorC] forState:UIControlStateNormal];
            }else{
                [wself.likeButton setTitle:@"赞" forState:UIControlStateNormal];
            }
            [self.likeButton sizeToFit];
            
        }else{
            if (type == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_LIKE object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_LIKE_cancle object:nil];
            }
            
            if (self.videoModel) {
                self.videoModel.isFavor = type;
                self.videoModel.favorCount = type == 0 ? self.videoModel.favorCount-1:self.videoModel.favorCount+1;
            }else{
                if (self.videoOutsideModel.contentType == 1) {
                    self.videoOutsideModel.rewardVO.isFavor = type;
                    self.videoOutsideModel.rewardVO.favorCount = type == 0 ? self.videoOutsideModel.rewardVO.favorCount-1:self.videoOutsideModel.rewardVO.favorCount+1;
                }else{
                    self.videoOutsideModel.storyVO.isFavor = type;
                    self.videoOutsideModel.storyVO.favorCount = type == 0 ? self.videoOutsideModel.storyVO.favorCount-1:self.videoOutsideModel.storyVO.favorCount+1;
                }
            }
        }
        
        wself.likeButton.selected = type;
       
        wself.likeButton.userInteractionEnabled = YES;
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        wself.likeButton.userInteractionEnabled = YES;
    }];

}

- (void)button_clickCommentButton  // 评论
{
    HomeCommentView *commentView =[HomeCommentView new];
    [commentView cottent:_videoOutsideModel];
    [self addSubview:commentView];
}

- (void)button_clickShareButton    // 分享
{
    HomeShareView *shareView =[HomeShareView new];
    shareView.dto =_videoOutsideModel;
    [shareView setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
    
    MOLUserModel *userDto =[MOLUserModel new];
    if (_videoOutsideModel.contentType ==1) { //悬赏
        userDto =_videoOutsideModel.rewardVO.userVO;
    }else{//作品
        userDto =_videoOutsideModel.storyVO.userVO;
    }
    
    
    if ([[MOLGlobalManager shareGlobalManager] isUserself:userDto]) {//自己
        if (_videoOutsideModel.contentType ==1) { //悬赏
            shareView.currentBusinessType = HomeShareViewBusinessOneselfRecommendRewardType;
            [shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo",@"fuzhi",@"baocunbendi",@"hepai"] ];
        }else{//作品
            if (!_videoOutsideModel.storyVO.rewardVO) {//自由作品
                shareView.currentBusinessType = HomeShareViewBusinessOneselfRecommendOtherType;
                [shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo",@"delete",@"fuzhi",@"baocunbendi",@"hepai"] ];
            }else{//悬赏作品
                shareView.currentBusinessType = HomeShareViewBusinessOneselfRecommendRewardType;
                [shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo",@"fuzhi",@"baocunbendi",@"hepai"]];
            }
            
        }
    }else{//非自己
        shareView.currentBusinessType = HomeShareViewBusinessAttentionType;
        [shareView contentIcon:@[@"pengyouquan",@"weixin",@"qqkongjian",@"qq",@"weibo",@"jubao",@"fuzhi",@"baocunbendi",@"hepai"]];
    }
    
    
    shareView.delegate =self;
    [self addSubview:shareView];
}

#pragma mark -
#pragma mark HomeShareViewDelegate
- (void)homeShareView:(MOLVideoOutsideModel *)model businessType:(HomeShareViewBusinessType)businessType type:(HomeShareViewType)shareType;{
    
    switch (shareType) {
        case HomeShareViewWechat: //朋友圈
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
        case HomeShareViewWeixin: //微信好友
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        }
            break;
        case HomeShareViewMqMzone: //QQ空间
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
        }
            break;
        case HomeShareViewQQ: //QQ
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
        }
            break;
        case HomeShareViewSinaweibo: //微博
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
        }
            break;
        case HomeShareViewReport: //举报
        {
            
            if (![MOLUserManagerInstance user_isLogin]) {
                [[MOLGlobalManager shareGlobalManager] global_modalLogin];
                return ;
            }
            
            NSArray *titleButtons = @[@"色情低俗",@"垃圾广告",@"政治敏感",@"抄袭复制",@"违规内容"];
            @weakify(self);
            LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:5 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
                @strongify(self);
                if (buttonIndex >= titleButtons.count) {
                    return;
                }
                NSString *title = titleButtons[buttonIndex];
                NSMutableDictionary *dic =[NSMutableDictionary new];
                [dic setObject:[NSString stringWithFormat:@"%@",title?title:@""] forKey:@"cause"];
                
                
                    [dic setObject:@"3" forKey:@"reportType"];
                    [dic setObject:[NSString stringWithFormat:@"%@",model.rewardVO.rewardId?model.rewardVO.rewardId:@""] forKey:@"typeId"];

                [[[HomePageRequest alloc] initRequest_ReportParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                    if (code  != MOL_SUCCESS_REQUEST) {
                        [OMGToast showWithText:message];
                    }
                    
                } failure:^(__kindof MOLBaseNetRequest *request) {
                    
                }];
                
            }];
            [actionS show];
        }
            break;
        case HomeShareViewCopyUrl: //复制链接
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            if (model.contentType == 1) {//悬赏
                pasteboard.string =model.rewardVO.audioUrl?model.rewardVO.audioUrl:@"";
            }else{//作品
                pasteboard.string =model.storyVO.audioUrl?model.storyVO.audioUrl:@"";
            }
            
            [OMGToast showWithText:@"复制链接成功"];
        }
            break;
        case HomeShareViewSave: //保存本地
        {
            [self playerDownload:model];
            
        }
            break;
        case HomeShareViewUnLike: //不感兴趣
        {
            if (_delegate && [_delegate respondsToSelector:@selector(MOLExaminePacketModeCellEvent:)]) {
                [_delegate MOLExaminePacketModeCellEvent:model];
            }
            
        }
            break;
        case HomeShareViewCancel: //取消
        {
            
        }
            break;
        case HomeShareViewDelete: //删除
        {
            if (![MOLUserManagerInstance user_isLogin]) {
                [[MOLGlobalManager shareGlobalManager] global_modalLogin];
                return;
            }
            
            if (model.contentType ==2) { //作品
                if (model.storyVO.isReward==1) { //已经获得奖金不能删除
                    [OMGToast showWithText:@"已获得奖励的视频无法删除"];
                }else{
                    //删除视频
                    
                    [[[HomePageRequest alloc] initRequest_DeleteStoryParameter:@{} parameterId:[NSString stringWithFormat:@"%ld",model.storyVO.storyId]] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                        if (code  != MOL_SUCCESS_REQUEST) {
                            [OMGToast showWithText:message];
                        }else{
                            if (self->_delegate && [self->_delegate respondsToSelector:@selector(MOLExaminePacketModeCellEvent:)]) {
                                [self->_delegate MOLExaminePacketModeCellEvent:model];
                            }
                        }
                        
                        
                    } failure:^(__kindof MOLBaseNetRequest *request) {
                        
                    }];
                
                }
            }
            
        }
            break;
        case HomeShareViewInTune: //合拍
        {
            if (![MOLUserManagerInstance user_isLogin]) {
                [[MOLGlobalManager shareGlobalManager] global_modalLogin];
                return;
            }
            NSURL *audioUrl;
            if (model.contentType ==1) {//悬赏
                audioUrl =[NSURL URLWithString:model.rewardVO.audioUrl?model.rewardVO.audioUrl:@""];
                 [[MOLRecordManager manager] loadMaterialResourcesWith:audioUrl WithRewardID:model.rewardVO.rewardId.integerValue];
            }else{//作品
                audioUrl =[NSURL URLWithString:model.storyVO.audioUrl?model.storyVO.audioUrl:@""];
                [[MOLRecordManager manager] loadMaterialResourcesWith:audioUrl WithRewardID:0];
            }
            
            
        }
            break;
    }
    
}

//-----下载视频--
- (void)playerDownload:(MOLVideoOutsideModel *)playDto{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.bezelView.style=MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor =[UIColor blackColor];
    hud.contentColor =[UIColor whiteColor];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    [hud showAnimated:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *audioUrl =@"";
    NSString *audioId =@"";
    if (playDto.contentType == 1) {//悬赏
        audioUrl =playDto.rewardVO.audioUrl?playDto.rewardVO.audioUrl:@"";
        audioId =playDto.rewardVO.rewardId?playDto.rewardVO.rewardId:@"";
    }else{//作品
        audioUrl =playDto.storyVO.audioUrl?playDto.storyVO.audioUrl:@"";
        audioId =[NSString stringWithFormat:@"%ld",playDto.storyVO.storyId];
    }
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory,audioId];
    NSURL *urlNew = [NSURL URLWithString:audioUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        hud.progressObject = downloadProgress;
        NSString *string =@" completed";
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.label.text =[downloadProgress.localizedDescription substringWithRange:NSMakeRange(0,downloadProgress.localizedDescription.length-string.length)];
        });
        
        NSLog(@"%@",downloadProgress.localizedDescription);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        [self saveVideo:fullPath];
    }];
    
    [task resume];
    
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

#pragma mark-
#pragma mark 保存视频完成之后的回调

- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
        [OMGToast showWithText:@"视频保存失败"];
    }
    else {
        NSLog(@"保存视频成功");
        [OMGToast showWithText:@"保存成功,请到系统相册查看"];
        
        // 统计-下载
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"operateType"] = @"3";
        dic[@"recordType"] = @(self.currentType);
        dic[@"typeId"] = self.currentId;
        [MOLStatistics statistics_downLoad:dic];
    }
}


#pragma mark-
#pragma mark 分享实现
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  @"";
    NSString* title =@"";
    NSString* content =@"";
    NSString* webpageStr =@"";
    if (_videoOutsideModel.contentType ==1) {//悬赏
        thumbURL =_videoOutsideModel.rewardVO.shareMsgVO.shareImg?_videoOutsideModel.rewardVO.shareMsgVO.shareImg:@"";
        title =_videoOutsideModel.rewardVO.shareMsgVO.shareTitle?_videoOutsideModel.rewardVO.shareMsgVO.shareTitle:@"";
        content =_videoOutsideModel.rewardVO.shareMsgVO.shareContent?_videoOutsideModel.rewardVO.shareMsgVO.shareContent:@"";
        webpageStr =_videoOutsideModel.rewardVO.shareMsgVO.shareUrl?_videoOutsideModel.rewardVO.shareMsgVO.shareUrl:@"";
    }else{ //作品
        thumbURL =_videoOutsideModel.storyVO.shareMsgVO.shareImg?_videoOutsideModel.storyVO.shareMsgVO.shareImg:@"";
        title =_videoOutsideModel.storyVO.shareMsgVO.shareTitle?_videoOutsideModel.storyVO.shareMsgVO.shareTitle:@"";
        content =_videoOutsideModel.storyVO.shareMsgVO.shareContent?_videoOutsideModel.storyVO.shareMsgVO.shareContent:@"";
        webpageStr =_videoOutsideModel.storyVO.shareMsgVO.shareUrl?_videoOutsideModel.storyVO.shareMsgVO.shareUrl:@"";
    }
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = webpageStr;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[[MOLGlobalManager shareGlobalManager] global_currentViewControl] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            // 统计-分享
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"operateType"] = @"2";
            dic[@"recordType"] = @(self.currentType);
            dic[@"typeId"] = self.currentId;
            [MOLStatistics statistics_share:dic];
            
            if (self.videoModel) {
                self.videoModel.shareCount += 1;
                NSString *count = [STSystemHelper getNum:self.videoModel.shareCount];
                [self.shareButton setTitle:count forState:UIControlStateNormal];
            }else{
                if (self.videoOutsideModel.contentType == 1) {
                    self.videoOutsideModel.rewardVO.shareCount += 1;
                    NSString *count = [STSystemHelper getNum:self.videoOutsideModel.rewardVO.shareCount];
                    [self.shareButton setTitle:count forState:UIControlStateNormal];
                }else{
                    self.videoOutsideModel.storyVO.shareCount += 1;
                    NSString *count = [STSystemHelper getNum:self.videoOutsideModel.storyVO.shareCount];
                    [self.shareButton setTitle:count forState:UIControlStateNormal];
                }
            }
        }
    }];
}

- (void)button_clickMyActionButton   // 我的帖子
{
    
}

- (void)button_clickqualifiedButton   // 是否合格
{
    self.qualifiedButton.userInteractionEnabled = NO;
    if (self.qualifiedButton.selected) {
        return;
    }
    
    NSInteger count = 0;
    if (self.videoModel) {
        count = self.videoModel.rewardVO.remainSize;
    }else{
        count = self.videoOutsideModel.storyVO.rewardVO.remainSize;
    }
    
    if (count == 0) {
        [MBProgressHUD showMessageAMoment:@"红包已发完"];
        return;
    }
    
    if (self.videoModel.rewardVO.isFinish || count == 0) {
        [MBProgressHUD showMessageAMoment:@"活动已结束"];
        return;
    }
    
    // 友盟统计
    [MobClick event:ST_c_satisfaction_button];
    
    NSString *t = [NSString stringWithFormat:@"你确定把红包发给Ta吗？(红包还剩%ld个)",count];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:t message:@"红包发出后，不可撤销" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 友盟统计
        [MobClick event:ST_c_confirm_button];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (self.videoModel) {
            dic[@"rewardId"] = [NSString stringWithFormat:@"%ld",self.videoModel.rewardVO.rewardId];
            dic[@"storyId"] = [NSString stringWithFormat:@"%ld",self.videoModel.storyId];
        }else{
            dic[@"rewardId"] = [NSString stringWithFormat:@"%ld",self.videoOutsideModel.storyVO.rewardVO.rewardId];
            dic[@"rewardId"] = [NSString stringWithFormat:@"%ld",self.videoOutsideModel.storyVO.storyId];
        }
        
        MOLActionRequest *r = [[MOLActionRequest alloc] initRequest_payoutActionWithParameter:dic];
        [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
           
            if (code == MOL_SUCCESS_REQUEST) {
                if (self.videoModel) {
                    self.videoModel.isReward = 1;
                    self.videoModel.rewardVO.remainSize -= 1;
                }else{
                    self.videoOutsideModel.storyVO.isReward = 1;
                    self.videoOutsideModel.storyVO.rewardVO.remainSize -= 1;
                }
                
                self.qualifiedButton.selected = YES;
                self.qualifiedButton.backgroundColor = HEX_COLOR(0x9b9b9b);
            }else{
                [MBProgressHUD showMessageAMoment:message];
            }
        } failure:^(__kindof MOLBaseNetRequest *request) {
            self.qualifiedButton.userInteractionEnabled = YES;
        }];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.qualifiedButton.userInteractionEnabled = YES;
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancleAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)button_ClickPlay  // 点击播放按钮
{
    if (self.player.playing) {
        [self.player pause];
        self.playButton.selected = NO;
        self.clickPause = YES;
    }else if (self.player.status == PLPlayerStatusPaused) {
        [self.player resume];
        self.playButton.selected = YES;
        self.clickPause = NO;
    }else if (self.player.status == PLPlayerStatusUnknow){
        [self.player playWithURL:_url];
        self.clickPause = NO;
    }
}

- (void)button_clickVideoView  // 点击了视频view
{
//     获取当前的view在window的位置
    self.oriRect = [self.videoView convertRect:self.videoView.bounds toView:MOLAppDelegateWindow];

    UIView *videoView_big = [[UIView alloc] init];
    _videoView_big = videoView_big;
    videoView_big.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [MOLAppDelegateWindow addSubview:videoView_big];

    [videoView_big addSubview:self.player.playerView];
    videoView_big.frame = self.oriRect;
    self.player.playerView.frame = videoView_big.bounds;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button_clickvideoView_big)];
    [videoView_big addGestureRecognizer:tap];

    // 视频
    [UIView animateWithDuration:0.5 animations:^{
        videoView_big.width = MOL_SCREEN_WIDTH;
        videoView_big.height = MOL_SCREEN_HEIGHT;
        videoView_big.x = 0;
        videoView_big.y = 0;
        self.player.playerView.frame = videoView_big.bounds;
        
    } completion:^(BOOL finished) {
        [videoView_big addSubview:self.playButton];
        self.playButton.right = videoView_big.width - 15;
        self.playButton.bottom = videoView_big.height - 15;
    }];
}
#pragma mark  点击放大视频
- (void)button_clickvideoView_big
{
    [UIView animateWithDuration:0.5 animations:^{
        self.videoView_big.frame = self.oriRect;
        self.player.playerView.frame = self.videoView_big.bounds;
        self.playButton.hidden = YES;
    } completion:^(BOOL finished) {
        self.oriRect = CGRectZero;
        [self.videoView_big removeFromSuperview];
        [self.videoView insertSubview:self.player.playerView atIndex:0];
        [self.videoView addSubview:self.playButton];
        self.playButton.hidden = NO;
        self.playButton.right = self.videoView.width - 15;
        self.playButton.bottom = self.videoView.height - 15;
    }];
}

///用户事件触发
- (void)userEvent{
    
    MOLUserModel *userVO =[MOLUserModel new];
    if (_videoOutsideModel.contentType ==1) { //悬赏
        userVO =_videoOutsideModel.rewardVO.userVO;
    }else{
        userVO =_videoOutsideModel.storyVO.userVO;
    }
    
    if ([[MOLGlobalManager shareGlobalManager] isUserself:userVO]) {
        MOLMineViewController *vc = [[MOLMineViewController alloc] init];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
        vc.userId = [NSString stringWithFormat:@"%@",userVO.userId?userVO.userId:@""];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
}

/// 跳转到悬赏详情页
- (void)rewardContentEvent:(UITapGestureRecognizer *)tap{
    [self jumpToRewardDetailViewController];
}

- (void)jumpToRewardDetailViewController{
    if (!self.videoOutsideModel) {
        return;
    }
    
    if (self.videoOutsideModel.contentType ==1) { //悬赏
        RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
        rewardDetail.rewardId =self.videoOutsideModel.rewardVO.rewardId?self.videoOutsideModel.rewardVO.rewardId:@"";
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
        
    }else if (self.videoOutsideModel.contentType ==2){//作品
        if (self.videoOutsideModel.storyVO.rewardVO) {//悬赏作品
            RewardDetailViewController *rewardDetail =[RewardDetailViewController new];
            rewardDetail.rewardId =[NSString stringWithFormat:@"%ld",self.videoOutsideModel.storyVO.rewardVO.rewardId];
            [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:rewardDetail animated:YES];
        }
        
    }
    
}

#pragma mark - UI
- (void)setupExaminePacketModeCellUI
{
    UIView *iconBackView = [[UIView alloc] init];
    _iconBackView = iconBackView;
    iconBackView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:iconBackView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    [iconImageView setUserInteractionEnabled:YES];
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITapGestureRecognizer *avartTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userEvent)];
    [iconImageView addGestureRecognizer:avartTap];
    [iconBackView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @"加载中...";
    nameLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 1);
    nameLabel.font = MOL_MEDIUM_FONT(15);
    [nameLabel setUserInteractionEnabled: YES];
    UITapGestureRecognizer *nameTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userEvent)];
    [nameLabel addGestureRecognizer:nameTap];
    [self.contentView addSubview:nameLabel];
    
    OMGAttributedLabel *contentLabel = [[OMGAttributedLabel alloc] init];
    _contentLabel = contentLabel;
    [contentLabel setBackgroundColor: [UIColor clearColor]];
    [contentLabel setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.8)];
    [contentLabel setFont: MOL_REGULAR_FONT(15)];
    contentLabel.numberOfLines = 0;
    contentLabel.delegate =self;
    [self.contentView addSubview:contentLabel];
    
    UIView *videoView = [[UIView alloc] init];
    _videoView = videoView;
    videoView.layer.cornerRadius = 5;
    videoView.clipsToBounds = YES;
    videoView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(button_clickVideoView)];
    [videoView addGestureRecognizer:tap];
    [self.contentView addSubview:videoView];
    
    UIImageView *thumbImageView = [[UIImageView alloc] init];
    _thumbImageView = thumbImageView;
    [videoView addSubview:thumbImageView];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton = playButton;
    [playButton setImage:[UIImage imageNamed:@"mine_reward_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"mine_reward_suspended"] forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(button_ClickPlay) forControlEvents:UIControlEventTouchUpInside];
    [videoView addSubview:playButton];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.text = @"刚刚";
    timeLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
    timeLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:timeLabel];
    
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton = likeButton;
    [likeButton setTitle:@"赞" forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"focus on_praise"] forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"focus on_praise1"] forState:UIControlStateSelected];
    [likeButton setImage:[UIImage imageNamed:@"focus on_praise1"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [likeButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
    likeButton.titleLabel.font = MOL_REGULAR_FONT(13);
    likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [likeButton addTarget:self action:@selector(button_clickLikeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:likeButton];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton = commentButton;
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton setImage:[UIImage imageNamed:@"focus on_comment"] forState:UIControlStateNormal];
    [commentButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
    commentButton.titleLabel.font = MOL_REGULAR_FONT(13);
    commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [commentButton addTarget:self action:@selector(button_clickCommentButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton = shareButton;
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"focus on_share"] forState:UIControlStateNormal];
    [shareButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
    shareButton.titleLabel.font = MOL_REGULAR_FONT(13);
    shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [shareButton addTarget:self action:@selector(button_clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shareButton];
    
    UIButton *myActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _myActionButton = myActionButton;
    myActionButton.hidden = YES;
    [myActionButton setImage:[UIImage imageNamed:@"mine_other_point"] forState:UIControlStateNormal];
    [myActionButton addTarget:self action:@selector(button_clickMyActionButton) forControlEvents:UIControlEventTouchUpInside];
    myActionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:myActionButton];
    
    if (self.cellType != MOLExaminePacketModeCellType_normal) {
        UIButton *qualifiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _qualifiedButton = qualifiedButton;
        qualifiedButton.backgroundColor = HEX_COLOR(0xFE6257);
//        qualifiedButton.backgroundColor = HEX_COLOR(0x9b9b9b);
        [qualifiedButton setTitle:@"满意" forState:UIControlStateNormal];
        [qualifiedButton setTitle:@"红包已发" forState:UIControlStateSelected];
        [qualifiedButton setTitle:@"红包已发" forState:UIControlStateSelected | UIControlStateHighlighted];
        [qualifiedButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
        qualifiedButton.titleLabel.font = MOL_REGULAR_FONT(13);
        [qualifiedButton addTarget:self action:@selector(button_clickqualifiedButton) forControlEvents:UIControlEventTouchUpInside];
        qualifiedButton.layer.cornerRadius = 3;
        qualifiedButton.clipsToBounds = YES;
        [self.contentView addSubview:qualifiedButton];
    }else{
        
        // 背景显示 为白色内容背景
        UIImageView *bottomImgView =[UIImageView new];
        [bottomImgView setImage: [UIImage imageNamed:@"Group 8"]];
        _bottomImgView = bottomImgView;
        [bottomImgView setUserInteractionEnabled:YES];
        //[bottomImgView setBackgroundColor:[UIColor redColor]];
        [videoView addSubview:bottomImgView];
        
        // rewardUser
        UIImageView *rewardUserImageView = [[UIImageView alloc] init];
        _rewardUserImageView = rewardUserImageView;
        rewardUserImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [videoView addSubview:rewardUserImageView];
        
        UIImageView *harmonyImageView = [[UIImageView alloc] init];
        _harmonyImageView = harmonyImageView;
        harmonyImageView.hidden = YES;
        harmonyImageView.image = [UIImage imageNamed:@"mine_harmony1"];
        [videoView addSubview:harmonyImageView];
        
        // rewardContent
        CBAutoScrollLabel *rewardContentLabel = [[CBAutoScrollLabel alloc] init];
        _rewardContentLabel = rewardContentLabel;
        _rewardContentLabel.textColor = HEX_COLOR(0xffffff);
        _rewardContentLabel.font = MOL_REGULAR_FONT(13);
        [videoView addSubview:rewardContentLabel];
        
        UITapGestureRecognizer *rewardUserTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rewardContentEvent:)];
        [rewardUserImageView setUserInteractionEnabled:YES];
        [rewardUserImageView addGestureRecognizer:rewardUserTap];
        
        UITapGestureRecognizer *rewardContentTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rewardContentEvent:)];
        [rewardContentLabel setUserInteractionEnabled:YES];
        [rewardContentLabel addGestureRecognizer:rewardContentTap];
    }
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self.contentView addSubview:lineView];
}

- (void)calculatorExaminePacketModeCellFrame
{
    self.iconBackView.width = 40;
    self.iconBackView.height = 40;
    self.iconBackView.x = 15;
    self.iconBackView.y = 25;
    self.iconBackView.layer.cornerRadius = self.iconBackView.height * 0.5;
    self.iconBackView.clipsToBounds = YES;
    
    self.iconImageView.width = 39;
    self.iconImageView.height = 39;
    self.iconImageView.center = CGPointMake(self.iconBackView.width * 0.5, self.iconBackView.height * 0.5);
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
    
    [self.nameLabel sizeToFit];
    self.nameLabel.x = self.iconBackView.right + 5;
    self.nameLabel.centerY = self.iconBackView.centerY;
    
    self.contentLabel.width = self.contentView.width - 15 * 2;
    self.contentLabel.x = 15;
    self.contentLabel.y = self.iconBackView.bottom + 10;
    
    self.videoView.x = 15;
    self.videoView.y = self.contentLabel.bottom + 10;
    self.thumbImageView.frame = self.videoView.bounds;
    
    [self.playButton sizeToFit];
    self.playButton.right = self.videoView.width - 15;
    self.playButton.bottom = self.videoView.height - 15;
    
    self.player.playerView.frame = self.videoView.bounds;
    
    self.bottomImgView.width = self.videoView.width;
    self.bottomImgView.height = 60;
    self.bottomImgView.x = 0;
    self.bottomImgView.bottom = self.videoView.height;
    
    
    self.rewardUserImageView.width = 25;
    self.rewardUserImageView.height = 25;
    self.rewardUserImageView.x = 10;
    self.rewardUserImageView.bottom = self.videoView.height - 10;
    self.rewardUserImageView.layer.cornerRadius = 12.5;
    self.rewardUserImageView.clipsToBounds = YES;
    
    self.harmonyImageView.width = 19;
    self.harmonyImageView.height = 18;
    self.harmonyImageView.x = self.rewardUserImageView.right + 5;
    self.harmonyImageView.centerY = self.rewardUserImageView.centerY;
//    self.harmonyImageView.layer.cornerRadius = 12.5;
//    self.harmonyImageView.clipsToBounds = YES;
    
    self.rewardContentLabel.width = MOL_SCREEN_ADAPTER(140);
    self.rewardContentLabel.height = 18;
    
    if (self.harmonyImageView.hidden) {
        self.rewardContentLabel.x = self.rewardUserImageView.right + 10;
    }else{
        self.rewardContentLabel.x = self.harmonyImageView.right + 5;
    }
    
    self.rewardContentLabel.centerY = self.rewardUserImageView.centerY;
    
    [self.timeLabel sizeToFit];
    self.timeLabel.x = 15;
    self.timeLabel.y = self.videoView.bottom + 10;
    
    [self.likeButton sizeToFit];
    self.likeButton.x = 15;
    self.likeButton.y = self.timeLabel.bottom + 20;
    [self.likeButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:3];
    
    [self.commentButton sizeToFit];
    self.commentButton.x = self.likeButton.right + 30;
    self.commentButton.centerY = self.likeButton.centerY;
    [self.commentButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:3];
    
    [self.shareButton sizeToFit];
    self.shareButton.x = self.commentButton.right + 30;
    self.shareButton.centerY = self.likeButton.centerY;
    [self.shareButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:3];
    
    self.qualifiedButton.width = 60;
    self.qualifiedButton.height = 30;
    self.qualifiedButton.right = self.contentView.width - 15;
    self.qualifiedButton.centerY = self.likeButton.centerY;
    
    self.lineView.height = 1;
    self.lineView.width = self.contentView.width - 30;
    self.lineView.x = 15;
    self.lineView.y = self.contentView.height - self.lineView.height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorExaminePacketModeCellFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSMutableAttributedString *)examinePacketList_getTextWitnContent:(NSString *)content   // 计算高度的地方也要改
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    text.yy_color = HEX_COLOR_ALPHA(0xffffff, 0.6);
    text.yy_font = MOL_REGULAR_FONT(15);
    return text;
}

- (NSMutableAttributedString *)home_getTextWitnContent:(NSString *)content type:(NSString *)type   // type  红包悬赏 排位悬赏
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
