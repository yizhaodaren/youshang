//
//  MOLExamineView.m
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExamineView.h"
#import "MOLExamineListCell.h"
#import "MOLVideoOutsideGroupModel.h"
#import "MOLExaminePacketModeViewController.h"

@interface MOLExamineView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MOLExamineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSourceArray = [NSMutableArray array];
        [self setupExamineViewUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    
    MOLExaminePacketModeViewController *vc = [[MOLExaminePacketModeViewController alloc] init];
    vc.rewardId = model.rewardVO.rewardId;
    vc.titleString = model.rewardVO.content;
    [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
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
    return model.rewardVO.cardHeight_check + 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    MOLExamineListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLExamineListCell_id"];
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
    
}

#pragma mark - UI
- (void)setupExamineViewUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
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
    [tableView registerClass:[MOLExamineListCell class] forCellReuseIdentifier:@"MOLExamineListCell_id"];
    [self addSubview:tableView];
}

- (void)calculatorExamineViewFrame
{
    self.tableView.width = self.width;
    self.tableView.height = self.height;
    self.tableView.y = 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorExamineViewFrame];
}
@end
