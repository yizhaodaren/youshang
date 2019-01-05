//
//  prizeListCell.m
//  reward
//
//  Created by xujin on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "prizeListCell.h"
#import "RewardModel.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
@interface prizeListCell()
@property (nonatomic,strong)RewardModel *rewardModel;
@property (nonatomic,strong)NSIndexPath *cIndexPath;
@end

@implementation prizeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rewardModel =[RewardModel new];
        [self setBackgroundColor: [UIColor clearColor]];
    }
    return self;
}

- (void)prizeListCell:(RewardModel *)model indexPath:(NSIndexPath *)indexPath{
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
    
    
    UIButton *avatarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [avatarButton sd_setImageWithURL:[NSURL URLWithString:model.userAvatar?model.userAvatar:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headerD"]];
    [avatarButton addTarget:self action:@selector(avatarButtonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:avatarButton];
    
    UILabel *userName =[UILabel new];
    [userName setTextColor: HEX_COLOR_ALPHA(0xffffff,0.6)];
    [userName setFont:MOL_MEDIUM_FONT(15)];
    [userName setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpUser:)];
    [userName addGestureRecognizer:tap];
    [userName setText: [NSString stringWithFormat:@"%@%@",model.userId?@"@":@"",model.userName?model.userName:@""]];
    [self.contentView addSubview:userName];
    
    
    
    UILabel *moneyL =[UILabel new];
    [moneyL setFont: MOL_REGULAR_FONT(14)];
    [moneyL setTextColor:HEX_COLOR(0xFFEC00)];
    [moneyL setText:[NSString stringWithFormat:@"%ld",model.coin]];
    [self.contentView addSubview:moneyL];
    
    UIImageView *moneyImg =[UIImageView new];
    if (model.rewardType ==1 && !model.userId) {//表示虚位以待
        [moneyImg setImage: [UIImage imageNamed:@"hongbao"]];
        [moneyL setAlpha:0];
    }else{
        [moneyImg setImage: [UIImage imageNamed:@"mine_money"]];
    }
    
    [self.contentView addSubview: moneyImg];
    
    
    
    __weak typeof(self) wself = self;
    if (model.rewardType ==1) { //红包悬赏
        // 1. 用户头像 2. 用户昵称 *3.时间 *4.手气最佳 5. 悬赏金币
        UILabel *timeLable =[UILabel new];
        [timeLable setTextColor: HEX_COLOR_ALPHA(0xffffff,0.6)];
        [timeLable setFont:MOL_REGULAR_FONT(13)];
        [timeLable setText:[NSString getCommentMessageTimeWithTimestamp:[NSString stringWithFormat:@"%ld",model.createTime]]];
        [self.contentView addSubview:timeLable];
        
        if (!model.userId) {//表示虚位以待
            [timeLable setAlpha:0];
        }
        
        UIImageView *optimumImg =[UIImageView new];
        if (model.best) {
            [optimumImg setImage:[UIImage imageNamed:@"shouqizuijia"]];
            [self.contentView addSubview:optimumImg];
        }
        
        [avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(wself.contentView);
            make.width.height.mas_equalTo(40);
        }];
        
        CGSize userNameLSize = [[NSString stringWithFormat:@"%@%@",model.userId?@"@":@"",model.userName?model.userName:@""] boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :MOL_MEDIUM_FONT(15)} context:nil].size;
        
        if (userNameLSize.width>120) {
            userNameLSize.width =120;
        }
        
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatarButton.mas_right).offset(10);
            
            if (!model.userId) {//表示虚伪以待
                make.centerY.mas_equalTo(avatarButton.mas_centerY);
            }else{
                make.top.mas_equalTo(wself.contentView);
            }
            make.height.mas_equalTo(21);
            //处理 如果是手气最佳
            make.width.mas_equalTo(userNameLSize.width);
        }];
        
        if (model.userId) {//表示非虚位以待
            [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(userName.mas_left);
                make.top.mas_equalTo(userName.mas_bottom);
                make.height.mas_equalTo(18);
                //处理 如果是手气最佳
                if (model.best) {
                    make.right.mas_lessThanOrEqualTo(optimumImg.mas_left);
                }
                else{
                    make.right.mas_lessThanOrEqualTo(moneyImg.mas_left);
                }
                
            }];
        }
        
        if (model.best) {
            [optimumImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_greaterThanOrEqualTo(userName.mas_right);
                
                make.centerY.mas_equalTo(avatarButton.mas_centerY);
                make.height.mas_equalTo(26/2.0);
                make.width.mas_equalTo(92/2.0);
                make.right.mas_equalTo(moneyImg.mas_left).offset(-10);
            }];
        }
        
        
        [moneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
            //手气最佳
            if (model.best) {
                make.left.mas_equalTo(optimumImg.mas_right).offset(10);
            }else{
                //非手气最佳
                make.left.mas_greaterThanOrEqualTo(userName.mas_right);
            }
            
            make.centerY.mas_equalTo(avatarButton.mas_centerY);
            
            if (model.userId) {
                make.right.mas_equalTo(moneyL.mas_left).offset(-4);
                make.height.mas_equalTo(32/2.0);
                make.width.mas_equalTo(34/2.0);
            }else{
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(32/2.0);
                make.width.mas_equalTo(28/2.0);
            }
            
        }];
        
        if (model.userId) {
            CGSize moneyLSize = [moneyL.text?moneyL.text:@"" boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :MOL_REGULAR_FONT(14)} context:nil].size;
            [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(avatarButton.mas_centerY);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(moneyLSize.width+5);
                make.right.mas_equalTo(-15);
            }];
        }
        
        
    }else{ //排名悬赏
        // *1.标签  2. 用户头像 3. 用户昵称  4.悬赏金币
        UIImageView *labelImageView =[UIImageView new];
        if (model.pIndex<3 && model.pIndex>=0) { //显示前3个
            [labelImageView setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%ld",model.pIndex]]];
        }else if(model.pIndex<10 && model.pIndex>=0){
            [labelImageView setImage: [UIImage imageNamed:@"3"]];
        }else{
            [labelImageView setImage: [UIImage imageNamed:@"4"]];
        }
        
        [self.contentView addSubview:labelImageView];
        
        UILabel *label =[UILabel new];
        [label setFont: MOL_REGULAR_FONT(12)];
        [label setTextColor: HEX_COLOR(0x322200)];
        if(model.pIndex>=0){
            [label setText:[NSString stringWithFormat:@"No%ld",model.pIndex+1]];
        }
        
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:label];
        // [label setBackgroundColor:[UIColor blueColor]];
        [label sizeToFit];
        
        CGSize labelSize = [label.text?label.text:@"" boundingRectWithSize:CGSizeMake(MAXFLOAT, 19) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : MOL_REGULAR_FONT(12)} context:nil].size;
        if (labelSize.width<23) {
            labelSize.width=23;
        }
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(11);
            make.height.mas_equalTo(19);
            make.width.mas_equalTo(labelSize.width+6);
        }];
        
        [labelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_left);
            make.top.mas_equalTo(label.mas_top);
            make.height.mas_equalTo(label.mas_height);
            make.width.mas_equalTo(label.width+6+6+3);
        }];
        
        [avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(labelImageView.mas_right).offset(12);
            make.top.mas_equalTo(wself.contentView);
            make.width.height.mas_equalTo(40);
        }];
        
        CGSize userNameLSize = [[NSString stringWithFormat:@"%@%@",model.userId?@"@":@"",model.userName?model.userName:@""] boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :MOL_MEDIUM_FONT(15)} context:nil].size;
        
        if (userNameLSize.width>120) {
            userNameLSize.width =120;
        }
        
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatarButton.mas_right).offset(10);
            make.centerY.mas_equalTo(avatarButton.mas_centerY);
            make.height.mas_equalTo(21);
            make.width.mas_equalTo(userNameLSize.width);
        }];
        
        
        [moneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(userName.mas_right);
            make.centerY.mas_equalTo(avatarButton.mas_centerY);
            make.height.mas_equalTo(32/2.0);
            make.width.mas_equalTo(34/2.0);
            make.right.mas_equalTo(moneyL.mas_left).offset(-4);
        }];
        
        [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(moneyImg.mas_right).offset(4);
            make.centerY.mas_equalTo(avatarButton.mas_centerY);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-15);
        }];
    }
    
    
    [avatarButton.layer setMasksToBounds:YES];
    [avatarButton.layer setCornerRadius:40/2.0];
    
}

- (void)avatarButtonEvent:(UIButton *)sender{
    [self avatarEvent];
}

- (void)jumpUser:(UITapGestureRecognizer *)sender{
    [self avatarEvent];
}

- (void)avatarEvent{
    NSLog(@"跳转到用户事件响应");
    
    if (!self.rewardModel.userId) {
        return;
    }
    if (self.rewardModel.isUserOneself) {
        MOLMineViewController *vc = [[MOLMineViewController alloc] init];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
        vc.userId = [NSString stringWithFormat:@"%ld",self.rewardModel.userId];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
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
