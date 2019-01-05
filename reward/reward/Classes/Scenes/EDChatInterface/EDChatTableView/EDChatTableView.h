//
//  EDChatTableView.h
//  aletter
//
//  Created by moli-2017 on 2018/8/24.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDPullRefreshView.h"

@protocol EDChatTableViewDelegate <NSObject>

/** 点击 */
- (void)didTapChatTableView:(UITableView *)tableView;

/**
 *  开始下拉刷新（顶部刷新）
 */
- (void)startLoadingTopMessagesInTableView:(UITableView *)tableView;

@end
@interface EDChatTableView : UITableView

@property (nonatomic, weak) id<EDChatTableViewDelegate> chatTableViewDelegate;

@property (nonatomic, strong) EDPullRefreshView *topRefreshView;

/** 更新indexPath的cell */
- (void)updateTableViewAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  结束下拉刷新
 */
- (void)finishLoadingTopRefreshView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)updateFrame:(CGRect)frame;

/**
 *  判断tableView当前是否已经滑动到最低端
 */
- (BOOL)isTableViewScrolledToBottom;

@end
