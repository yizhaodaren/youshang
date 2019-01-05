//
//  MOLUserRelationCell.m
//  reward
//
//  Created by moli-2017 on 2018/9/17.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLUserRelationCell.h"
#import "MOLActionRequest.h"

@interface MOLUserRelationCell ()
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *subNameLabel; // ID:000000 粉丝 102.6万
@property (nonatomic, weak) UILabel *introduceLabel;
@property (nonatomic, weak) UIButton *focusButton;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation MOLUserRelationCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUserRelationCellUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_focusUser:) name:MOL_SUCCESS_USER_FOCUS object:nil];
    }
    return self;
}

- (void)setUserModel:(MOLMsgUserModel *)userModel
{
    _userModel = userModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.userVO.avatar]];
    
    self.nameLabel.text = userModel.userVO.userName;
    NSString *subStr = [NSString stringWithFormat:@"ID:%@ 粉丝:%ld",userModel.userVO.userUuid,userModel.userVO.fansCount];
    self.subNameLabel.text = subStr;
    if (self.type) {
        self.introduceLabel.text = [NSString getCommentMessageTimeWithTimestamp:userModel.createTime];
    }else{
        
    self.introduceLabel.text = userModel.userVO.signInfo.length ? userModel.userVO.signInfo : @"本宝宝暂时没有个性签名";
    }
    
    if (userModel.userVO.isFriend == 0) {
        [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:HEX_COLOR_ALPHA(0x000000, 1) forState:UIControlStateNormal];
        self.focusButton.backgroundColor = HEX_COLOR_ALPHA(0xFFEC00, 1);
    }else if (userModel.userVO.isFriend == 1){
        
        [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
        self.focusButton.backgroundColor = HEX_COLOR_ALPHA(0x383B44, 1);
    }else{
        [self.focusButton setTitle:@"相互关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
        self.focusButton.backgroundColor = HEX_COLOR_ALPHA(0x383B44, 1);
    }
    
    if ([[MOLGlobalManager shareGlobalManager] isUserself:userModel.userVO]) {
        self.focusButton.hidden = YES;
    }else{
        self.focusButton.hidden = NO;
    }
    
    [self layoutIfNeeded];
}

#pragma mark - UI
- (void)setupUserRelationCellUI
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    _iconImageView = iconImageView;
    iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.text = @"加载中...";
    nameLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 1);
    nameLabel.font = MOL_MEDIUM_FONT(15);
    [self.contentView addSubview:nameLabel];
    
    UILabel *subNameLabel = [[UILabel alloc] init];
    _subNameLabel = subNameLabel;
    subNameLabel.text = @"ID:000000 粉丝:0";
    subNameLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
    subNameLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:subNameLabel];
    
    UILabel *introduceLabel = [[UILabel alloc] init];
    _introduceLabel = introduceLabel;
    introduceLabel.text = @"他暂时没有个性签名";
    introduceLabel.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
    introduceLabel.font = MOL_REGULAR_FONT(13);
    [self.contentView addSubview:introduceLabel];
    
    UIButton *focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _focusButton = focusButton;
    [focusButton setTitle:@"关注" forState:UIControlStateNormal];
    [focusButton setTitleColor:HEX_COLOR_ALPHA(0x000000, 1) forState:UIControlStateNormal];
    focusButton.backgroundColor = HEX_COLOR_ALPHA(0xFFEC00, 1);
    focusButton.titleLabel.font = MOL_REGULAR_FONT(13);
    [focusButton addTarget:self action:@selector(focusButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:focusButton];
    
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
    [self.contentView addSubview:lineView];
}

- (void)calculatorUserRelationCellFrame
{
    self.iconImageView.width = 40;
    self.iconImageView.height = 40;
    self.iconImageView.x = 15;
    self.iconImageView.y = 15;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height * 0.5;
    self.iconImageView.clipsToBounds = YES;
    
    self.focusButton.width = 60;
    self.focusButton.height = 28;
    self.focusButton.layer.cornerRadius = 3;
    self.focusButton.clipsToBounds = YES;
    self.focusButton.right = self.contentView.width - 15;
    self.focusButton.y = 25;
    
    self.nameLabel.x = self.iconImageView.right + 10;
    self.nameLabel.y = self.iconImageView.y;
    [self.nameLabel sizeToFit];
    if (self.nameLabel.width > self.focusButton.x - self.nameLabel.x) {
        self.nameLabel.width = self.focusButton.x - self.nameLabel.x;
    }
    self.nameLabel.height = 20;
    
    self.subNameLabel.x = self.nameLabel.x;
    self.subNameLabel.y = self.nameLabel.bottom + 1;
    self.subNameLabel.width = self.focusButton.x - self.subNameLabel.x;
    self.subNameLabel.height = 18;
    
    self.introduceLabel.x = self.nameLabel.x;
    self.introduceLabel.y = self.subNameLabel.bottom + 1;
    self.introduceLabel.width = self.subNameLabel.width;
    self.introduceLabel.height = 18;
    
    self.lineView.x = self.iconImageView.x;
    self.lineView.y = self.contentView.height - 1;
    self.lineView.width = self.contentView.width - self.lineView.x;
    self.lineView.height = 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorUserRelationCellFrame];
}

- (void)focusButtonEvent:(UIButton *)sender{
    
    if (![MOLUserManagerInstance user_isLogin]) {
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    
    self.focusButton.userInteractionEnabled = NO;
    // 关注接口
    MOLActionRequest *r = [[MOLActionRequest alloc] initRequest_focusActionWithParameter:nil parameterId:self.userModel.userVO.userId];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        NSInteger type = [request.responseObject[@"resBody"] integerValue];
        
        self.focusButton.userInteractionEnabled = YES;
        
        if (code != MOL_SUCCESS_REQUEST) {
            [MBProgressHUD showMessageAMoment:message];
        }else{
            if (self.userModel.userVO.isFriend != 0) {  // 取消关注
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:self.userModel.userVO.userId];
                [arr addObject:@(NO)];
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_FOCUS object:arr];
            }else{
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:self.userModel.userVO.userId];
                [arr addObject:@(YES)];
                [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SUCCESS_USER_FOCUS object:arr];
            }
        }
        
        if (type == 0) {
            [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
            [self.focusButton setTitleColor:HEX_COLOR_ALPHA(0x000000, 1) forState:UIControlStateNormal];
            self.focusButton.backgroundColor = HEX_COLOR_ALPHA(0xFFEC00, 1);
            
        }else if (type == 1){
            [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
            [self.focusButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
            self.focusButton.backgroundColor = HEX_COLOR_ALPHA(0x383B44, 1);
            
        }else if (type == 2){
            [self.focusButton setTitle:@"相互关注" forState:UIControlStateNormal];
            [self.focusButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
            self.focusButton.backgroundColor = HEX_COLOR_ALPHA(0x383B44, 1);
        }
        
        self.userModel.userVO.isFriend = type;
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        self.focusButton.userInteractionEnabled = YES;
    }];
}

- (void)noti_focusUser:(NSNotification *)noti
{
    NSArray *arr =noti.object;
    
    if (![arr.firstObject isEqualToString:self.userModel.userVO.userId]) {
        return;
    }
    
//    if ([arr.lastObject boolValue]) {  // 关注成功
//        self.userModel.userVO.isFriend = self.userModel.userVO.isFriend + 1;
//    }else{  // 取消成功
//        self.userModel.userVO.isFriend = 0;
//    }
//
//    if (self.userModel.userVO.isFriend == 0) {
//        [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
//        [self.focusButton setTitleColor:HEX_COLOR_ALPHA(0x000000, 1) forState:UIControlStateNormal];
//        self.focusButton.backgroundColor = HEX_COLOR_ALPHA(0xFFEC00, 1);
//    }else if (self.userModel.userVO.isFriend == 1){
//
//        [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
//        [self.focusButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
//        self.focusButton.backgroundColor = HEX_COLOR_ALPHA(0x383B44, 1);
//    }else{
//        [self.focusButton setTitle:@"相互关注" forState:UIControlStateNormal];
//        [self.focusButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
//        self.focusButton.backgroundColor = HEX_COLOR_ALPHA(0x383B44, 1);
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
