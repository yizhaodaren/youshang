//
//  MOLExaminePacketModeView.m
//  reward
//
//  Created by moli-2017 on 2018/9/18.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLExaminePacketModeView.h"
#import "MOLExaminePacketModeCell.h"
#import "MOLVideoModel.h"
#import "MOLVideoOutsideGroupModel.h"

@interface MOLExaminePacketModeView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *currentCellsArray;
@end

@implementation MOLExaminePacketModeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentCellsArray = [NSMutableArray array];
        self.dataSourceArray = [NSMutableArray array];
        [self setupExaminePacketModeViewUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    return model.storyVO.cellHeight_examinePackted;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLVideoOutsideModel *model = self.dataSourceArray[indexPath.row];
    MOLExaminePacketModeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLExaminePacketModeCell_id"];
    if (cell == nil) {
        cell = [[MOLExaminePacketModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MOLExaminePacketModeCell_id" cellType:MOLExaminePacketModeCellType_examine];
    }
    
    cell.videoModel = model.storyVO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLExaminePacketModeCell *modecell = (MOLExaminePacketModeCell *)cell;
    [modecell.player stop];
    [self.currentCellsArray removeObject:modecell];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLExaminePacketModeCell *modecell = (MOLExaminePacketModeCell *)cell;
    [self.currentCellsArray addObject:modecell];
}


- (BOOL)canPlay:(CGRect)rect cell:(MOLExaminePacketModeCell *)cell
{
    // 获取屏幕的两个rect
    CGRect topRect = CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT * 0.5);
    CGRect bottomRect = CGRectMake(0, MOL_SCREEN_HEIGHT * 0.5, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT * 0.5);
    
    if (rect.origin.y > MOL_SCREEN_HEIGHT * 0.5 + 80) {  // 传入的rect的y在下半部分
        cell.clickPause = NO;
        return NO;
    }
    
    if (rect.origin.y == MOL_SCREEN_HEIGHT * 0.5 + 80) {
        return YES;
    }
    
    // 传入的rect的y在上半部分
    if (CGRectContainsRect(rect, topRect)) {  // 如果视频包含了topRect 可以播放
        return YES;
    }
    
    if (CGRectContainsRect(rect, bottomRect)) {  // 如果视频和bottomRect 有交集 可以播放
        return YES;
    }
    cell.clickPause = NO;
    return NO;
    
//    if (rect.origin.y > MOL_SCREEN_HEIGHT * 0.5 - 100) {
//
//        return NO;
//    }
//
//    if (rect.origin.y + rect.size.height < MOL_SCREEN_HEIGHT * 0.5 - 100 && rect.origin.y < MOL_StatusBarAndNavigationBarHeight) {
//        return NO;
//    }
//
//
//    if (rect.origin.y <= MOL_SCREEN_HEIGHT * 0.5 - 100) {
//        return YES;
//    }
//
//    return NO;
}

- (void)play_beginOrresume
{
    for (NSInteger i = 0; i < self.currentCellsArray.count; i++) {
        MOLExaminePacketModeCell *cell = self.currentCellsArray[i];
        
        CGRect rect = [cell convertRect:cell.bounds toView:MOLAppDelegateWindow];
        
        
        if ([self canPlay:rect cell:cell]) {
            if (cell.player.status == PLPlayerStatusPaused) {
                if (!cell.clickPause) {
                    [cell.player resume];
                }
                continue;
            }else{
                if (!cell.player.isPlaying) {
                    [cell.player playWithURL:[NSURL URLWithString:cell.videoModel.audioUrl]];
                }
            }
        }else{
            if (cell.player.playing){
                [cell.player pause];
            }
        }
    }
}

- (void)play_resume
{
    for (NSInteger i = 0; i < self.currentCellsArray.count; i++) {
        MOLExaminePacketModeCell *cell = self.currentCellsArray[i];
        if (cell.player.playing) {        
            [cell.player pause];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    [self play_beginOrresume];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self play_beginOrresume];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (!decelerate) {
        [self play_beginOrresume];
    }
}

#pragma mark - UI
- (void)setupExaminePacketModeViewUI
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
    [self addSubview:tableView];
}

- (void)calculatorExaminePacketModeViewFrame
{
    self.tableView.width = self.width;
    self.tableView.height = self.height;
    self.tableView.y = 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self calculatorExaminePacketModeViewFrame];
}
@end
