//
//  MOLInviteAttendRewardView.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLInviteAttendRewardView.h"
#import "MOLInviteAttendExamineCell.h"
#import "EDStoryMessageModel.h"
#import "MOLVideoOutsideGroupModel.h"

@interface MOLInviteAttendRewardView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UIButton *cancleButton;
@property (nonatomic, weak) UIButton *sendButton;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation MOLInviteAttendRewardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSourceArray = [NSMutableArray array];
        self.selectArray = [NSMutableArray array];
        
        [self setupInviteAttendRewardViewUI];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MOLVideoOutsideModel *OutsideModel = self.dataSourceArray[indexPath.row];
    MOLExamineCardModel *model = OutsideModel.rewardVO;
    model.selectSend = !model.selectSend;
    if (model.selectSend) {
        if (![self.selectArray containsObject:model]) {
            [self.selectArray addObject:model];
        }
        
    }else{
        if ([self.selectArray containsObject:model]) {
            [self.selectArray removeObject:model];
        }
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    return model.rewardVO.cardHeight_noBottom + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    MOLInviteAttendExamineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLInviteAttendExamineCell_id"];
    cell.cardModel = model.rewardVO;
    return cell;
}

#pragma mark - 按钮的点击
- (void)button_clickCancle
{
    [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] dismissViewControllerAnimated:YES completion:nil];
}

- (void)button_clickSend
{
    NIMSession *session = [[MOLYXManager shareYXManager] yx_creatChatSessionWithUserId:self.userId];
    
    for (NSInteger i = 0; i < self.selectArray.count; i++) {
        
        MOLExamineCardModel *cardModel = self.selectArray[i];
        
        // 发送自定义消息
        EDStoryMessageModel *model = [[EDStoryMessageModel alloc] init];
        model.rewardUserId = cardModel.userVO.userId;
        model.rewardUserName = cardModel.userVO.userName;
        model.rewardUserAvatar = cardModel.userVO.avatar;
        model.storyContent = cardModel.content;
        model.beginTime = cardModel.createTime;
        model.finishTime = cardModel.finishTime;
        model.type = cardModel.rewardType;
        model.goldCount = cardModel.rewardAmount;
        model.giftImage = cardModel.giftVO.giftThumb;
        model.giftCount = cardModel.giftVO.giftNum;
        
        //构造自定义MessageObject
        NIMCustomObject *object = [[NIMCustomObject alloc] init];
        object.attachment = model;
        
        //构造自定义消息
        NIMMessage *message = [[NIMMessage alloc] init];
        message.messageObject = object;
        
        //发送消息
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    }
    
    
}

#pragma mark - UI
- (void)setupInviteAttendRewardViewUI
{
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleButton = cancleButton;
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:HEX_COLOR(0x4A4A4A) forState:UIControlStateNormal];
    cancleButton.titleLabel.font = MOL_MEDIUM_FONT(16);
    [cancleButton addTarget:self action:@selector(button_clickCancle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleButton];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton = sendButton;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:HEX_COLOR(0x4A4A4A) forState:UIControlStateNormal];
    sendButton.titleLabel.font = MOL_MEDIUM_FONT(16);
    [sendButton addTarget:self action:@selector(button_clickSend) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.text = @"选择悬赏";
    titleLabel.textColor = HEX_COLOR(0x221E1E);
    titleLabel.font = MOL_MEDIUM_FONT(17);
    [self addSubview:titleLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 55) style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MOLInviteAttendExamineCell class] forCellReuseIdentifier:@"MOLInviteAttendExamineCell_id"];
    [self addSubview:tableView];
}

- (void)calculatorInviteAttendRewardViewFrame
{
    [self.cancleButton sizeToFit];
    self.cancleButton.y = 12;
    self.cancleButton.x = 15;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerY = self.cancleButton.centerY;
    self.titleLabel.centerX = self.width * 0.5;
    
    [self.sendButton sizeToFit];
    self.sendButton.right = self.width - 15;
    self.sendButton.centerY = self.cancleButton.centerY;
    
    self.tableView.width = self.width;
    self.tableView.height = self.height - 55;
    self.tableView.y = 55;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorInviteAttendRewardViewFrame];
}
@end
