//
//  CommentCell.m
//  reward
//
//  Created by xujin on 2018/9/21.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "CommentCell.h"
#import "HomeCommentModel.h"
#import "STSystemHelper.h"
#import "HomePageRequest.h"
#import "OMGAttributedLabel.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"

@interface CommentCell()<TYAttributedLabelDelegate>
@property (nonatomic,strong)HomeCommentModel *commentDto;
@property (nonatomic,weak)UIView *verticalV;
@property (nonatomic,strong)NSIndexPath *cIndexPath;
@property (nonatomic,assign)CommentCellEventType currentType;
@property (nonatomic,weak)UILabel *favorL;
@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.commentDto =[HomeCommentModel new];
        [self setBackgroundColor: [UIColor clearColor]];
    }
    return self;
}

- (void)commentCell:(HomeCommentModel *)model indexPath:(NSIndexPath *)indexPath{
    if (!model) {
        return;
    }
    
    if (indexPath) {
        self.cIndexPath =indexPath;
    }
    
    self.commentDto =model;
    
    for (id views in self.contentView.subviews) {
        [views removeFromSuperview];
    }
    
    UIImageView *avatars =UIImageView.new;
    [avatars sd_setImageWithURL:[NSURL URLWithString:model.avatar?model.avatar:@""] placeholderImage:[UIImage imageNamed:@"headerD"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    UITapGestureRecognizer *avatarsTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarsTapEvent:)];
    [avatars addGestureRecognizer:avatarsTap];
    [avatars.layer setMasksToBounds:YES];
    [avatars setUserInteractionEnabled:YES];
    [self.contentView addSubview:avatars];
    
    [avatars mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.width.height.mas_equalTo(32);
    }];
    [avatars.layer setCornerRadius:32/2.0];
    
    UIButton *userName =[UIButton buttonWithType:UIButtonTypeCustom];
    [userName setTitle:[NSString stringWithFormat:@"@%@",model.userName?model.userName:@""] forState:UIControlStateNormal];
    [userName.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [userName setTitleColor:HEX_COLOR_ALPHA(0xffffff,0.7) forState:UIControlStateNormal];
    [userName.titleLabel setFont:MOL_MEDIUM_FONT(13)];
    [userName addTarget:self action:@selector(userNameEvent:) forControlEvents:UIControlEventTouchUpInside];
  //  [userName setBackgroundColor:[UIColor blueColor]];
    [self.contentView addSubview:userName];
    
//    NSLog(@"userName:%@",userName.titleLabel.text);
    
    CGSize userNameSize = [userName.titleLabel.text?userName.titleLabel.text:@"" boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_MEDIUM_FONT(13)} context:nil].size;
    
    CGFloat userNameW = userNameSize.width;
    if (userNameW>120) {
        userNameW =120;
    }

    [userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(avatars.mas_right).offset(12);
        make.width.mas_equalTo(5+userNameW);
        make.height.mas_equalTo(17);
    }];
    
    
    __weak typeof(self) wself = self;
    if (model.userType==1 || model.userType==2) {
        UIImageView *userTypeImage =UIImageView.new;
        
        if (model.userType ==1) {
            [userTypeImage setImage: [UIImage imageNamed:@"zuozhe"]];
        }else if(model.userType ==2){
            [userTypeImage setImage: [UIImage imageNamed:@"xuanzhangzhe"]];
        }
        [self.contentView addSubview:userTypeImage];
        
        [userTypeImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12);
            make.left.mas_equalTo(userName.mas_right).offset(6);
            CGFloat userTypeImageW =22.0;
            if (model.userType==2) {
                userTypeImageW =30.0;
            }
            make.width.mas_equalTo(userTypeImageW);
            make.centerY.mas_equalTo(userName.mas_centerY);
        }];
    }
    
    
    
    
    
    OMGAttributedLabel *mainCommet =[OMGAttributedLabel new];
    [mainCommet setBackgroundColor: [UIColor clearColor]];
    [mainCommet setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.9)];
    [mainCommet setFont: MOL_MEDIUM_FONT(14)];
    [mainCommet setNumberOfLines:0];
     mainCommet.delegate =self;
    [mainCommet setTextContainer: [mainCommet textContainerContents:model imageType:OMGAttributedLabelImageType_Undefined]];
    [self.contentView addSubview:mainCommet];
    

    CGFloat textH = model.commentHeight;
    
    [mainCommet mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatars.mas_right).offset(12);
        make.right.mas_equalTo(wself.contentView.mas_right).offset(-64);
        make.top.mas_equalTo(userName.mas_bottom);
        make.height.mas_equalTo(textH);
    }];
    
   
   
    
    
    
    
    /////////////新增点赞 赞数/////////////
    UIButton *favorButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [favorButton setImage:[UIImage imageNamed:@"Group 11"] forState:UIControlStateNormal];
    [favorButton setImage:[UIImage imageNamed:@"Group 12"] forState:UIControlStateSelected];
//    [favorButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 0.6) forState:UIControlStateNormal];
//    [favorButton setTitleColor:HEX_COLOR_ALPHA(0xFE6257, 1.0) forState:UIControlStateSelected];
    [favorButton addTarget:self action:@selector(favorButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:favorButton];
    
    if (!model.isFavor) {//未点赞
        [favorButton setSelected:NO];
    }else{//点赞
        [favorButton setSelected:YES];
    }
    
    [favorButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(wself.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(20);
        make.width.height.mas_equalTo(20);
    }];
    
    UILabel *favorLable =[UILabel new];
    [favorLable setBackgroundColor: [UIColor clearColor]];
    [favorLable setFont: MOL_REGULAR_FONT(12)];
    [favorLable setTextAlignment:NSTextAlignmentCenter];
    [favorLable setText:[STSystemHelper getNum:model.favorCount]];
    //[favorLable setBackgroundColor: [UIColor redColor]];
    self.favorL =favorLable;
    
    if (!model.isFavor) {//未点赞
        [favorLable setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.6)];
    }else{//点赞
        [favorLable setTextColor: HEX_COLOR_ALPHA(0xFE6257, 1.0)];
    }
    [self.contentView addSubview:favorLable];
    
    [favorLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(wself.contentView);
        make.top.mas_equalTo(favorButton.mas_bottom).offset(2);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(50);
    }];
    /////////////////////////
    
    if (self.commentDto.replyCommentVO) {
        //存在被评论
        UIButton *reviewer =[UIButton buttonWithType:UIButtonTypeCustom];
        [reviewer setTitle:[NSString stringWithFormat:@"@%@",model.replyCommentVO.userName?model.replyCommentVO.userName:@""] forState:UIControlStateNormal];
        [reviewer setTitleColor:HEX_COLOR_ALPHA(0xffffff,0.7) forState:UIControlStateNormal];
        [reviewer.titleLabel setFont:MOL_MEDIUM_FONT(12)];
        [reviewer addTarget:self action:@selector(reviewerEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:reviewer];
        
        CGSize reviewerSize = [reviewer.titleLabel.text?reviewer.titleLabel.text:@"" boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_MEDIUM_FONT(13)} context:nil].size;
        
        CGFloat reviewerW = reviewerSize.width;
        
        
       
        OMGAttributedLabel *reviewerCommet =[OMGAttributedLabel new];
        [reviewerCommet setBackgroundColor: [UIColor clearColor]];
        [reviewerCommet setTextColor:HEX_COLOR_ALPHA(0xffffff, 0.7)];
        [reviewerCommet setFont: MOL_MEDIUM_FONT(14)];
        [reviewerCommet setNumberOfLines:0];
        reviewerCommet.delegate =self;
        [reviewerCommet setTextContainer: [reviewerCommet textContainerContents:model imageType:OMGAttributedLabelImageType_ReplyComment]];
        [self.contentView addSubview:reviewerCommet];
       
        CGFloat reviewedH = model.replyCommentVO.replyCommentHeight;
        
        [reviewer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatars.mas_right).offset(12*2.0);
            make.height.mas_equalTo(17);
            make.width.mas_equalTo(reviewerW);
            make.top.mas_equalTo(mainCommet.mas_bottom).offset(10);
        }];
        
        [reviewerCommet mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatars.mas_right).offset(12*2.0);
            make.right.mas_equalTo(wself.contentView.mas_right).offset(-64);
            make.top.mas_equalTo(reviewer.mas_bottom).offset(3);
            make.height.mas_equalTo(reviewedH);
        }];
        
        UIView *verticalLine =[UIView new];
        [verticalLine setBackgroundColor: HEX_COLOR_ALPHA(0xffffff, 0.7)];
        self.verticalV =verticalLine;
        [self.contentView addSubview:verticalLine];
        
        [verticalLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatars.mas_right).offset(12);
            make.top.mas_equalTo(mainCommet.mas_bottom).offset(10);
            make.width.mas_equalTo(1.5);
            make.height.mas_equalTo(reviewedH+3+17);
            
        }];
        
    }
    
    //不存在被评论
//    UILabel *timeLable =[UILabel new];
//    [timeLable setBackgroundColor: [UIColor clearColor]];
//    [timeLable setTextColor: HEX_COLOR_ALPHA(0xffffff,0.3)];
//    [timeLable setFont: MOL_REGULAR_FONT(12)];
//    [timeLable setText: [NSString getCommentMessageTimeWithTimestamp:[NSString stringWithFormat:@"%ld",(long)model.createTime]]];
   // [self.contentView addSubview:timeLable];

    UIView *lineView =[UIView new];
    [lineView setBackgroundColor:HEX_COLOR_ALPHA(0xffffff, 0.1)];
    [self.contentView addSubview:lineView];
    
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatars.mas_right).offset(12);
        make.bottom.right.mas_equalTo(wself.contentView);
        make.height.mas_equalTo(@1);
    }];
    
//    [timeLable mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(avatars.mas_right).offset(12);
//        make.right.mas_equalTo(wself.contentView);
//        make.height.mas_equalTo(17);
//        if (!self.commentDto.replyCommentVO) {
//            make.top.mas_equalTo(mainCommet.mas_bottom).offset(2);
//        }else{
//            make.top.mas_equalTo(wself.verticalV.mas_bottom).offset(10);
//        }
//    }];
    
}

#pragma mark
#pragma mark action event
- (void)userNameEvent:(UIButton *)sender{
//    NSLog(@"用户名称事件响应");
    self.currentType =CommentCellEventComment;
    [self personalCenterEventResponse:self.commentDto];
}

- (void)reviewerEvent:(UIButton *)sender{
//    NSLog(@"被评论名称事件响应");
    self.currentType =CommentCellEventReviewers;
    [self personalCenterEventResponse:self.commentDto];
}

- (void)avatarsTapEvent:(UITapGestureRecognizer *)sender{
//    NSLog(@"用户头像被点击");
    self.currentType =CommentCellEventAvatars;
    [self personalCenterEventResponse:self.commentDto];
}

- (void)personalCenterEventResponse:(HomeCommentModel *)model{
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentCell" object:self.commentDto];
//   // [[NSNotificationCenter defaultCenter] pos];
//
    if (_delegate && [_delegate respondsToSelector: @selector(commentCellEvent: eventType:)]) {
        [_delegate commentCellEvent: model eventType:self.currentType];
    }
}

- (void)favorButtonEvent:(UIButton *)sender{
    if (![MOLUserManagerInstance user_isLogin]) {
        if (_delegate && [_delegate respondsToSelector: @selector(commentCellEvent: eventType:)]) {
            [_delegate commentCellEvent: self.commentDto eventType:CommentCellEventFavor];
        }
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    __weak typeof(self) wself = self;
    [[[HomePageRequest alloc] initRequest_CommentFavorParameter:@{} parameterId:[NSString stringWithFormat:@"%ld",self.commentDto.commentId]] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        if (code  == MOL_SUCCESS_REQUEST) {
            NSInteger type = [request.responseObject[@"resBody"] integerValue];
            if (!type) {//表示取消点赞
                [sender setSelected:NO];
                [wself.favorL setTextColor: HEX_COLOR_ALPHA(0xffffff, 0.6)];
            }else{//表示点赞
                [sender setSelected:YES];
                [wself.favorL setTextColor: HEX_COLOR_ALPHA(0xFE6257, 1.0)];
            }
            
            
            if (!sender.selected) {//表示取消点赞
                wself.commentDto.favorCount -=1;
                if (wself.commentDto.favorCount<0) {
                    wself.commentDto.favorCount =0;
                }
                [wself.favorL setText:[STSystemHelper getNum:wself.commentDto.favorCount]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_LIKE_cancle object:nil];


            }else{//表示点赞
                wself.commentDto.favorCount +=1;
                if (wself.commentDto.favorCount<0) {
                    wself.commentDto.favorCount =0;
                }
                [wself.favorL setText:[STSystemHelper getNum:wself.commentDto.favorCount]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_LIKE object:nil];
                
            }
            
        }
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point{
    if ([textStorage isKindOfClass:[TYLinkTextStorage class]])
    {
        ContentsItemModel *model = ((TYLinkTextStorage*)textStorage).linkData;
        if (model && [model isKindOfClass: [ContentsItemModel class]] && model.type == 2) {
            
            HomeCommentModel *dto =[HomeCommentModel new];
            MOLUserModel *userModel =[MOLUserModel new];
            userModel.userId = [NSString stringWithFormat:@"%ld",model.typeId];
            dto.userId =model.typeId;
            if ([[MOLGlobalManager shareGlobalManager] isUserself:userModel]) {
                dto.userType =3;
            }else{
                dto.userType =0;
            }
            
            self.currentType =CommentCellEventUser;
            [self personalCenterEventResponse:dto];
           
        }
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
