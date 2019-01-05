//
//  EDChatTableView.m
//  aletter
//
//  Created by moli-2017 on 2018/8/24.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDChatTableView.h"

/**
 *  下拉多少距离开启刷新
 */
static CGFloat const kMQChatPullRefreshDistance = 44.0;
static CGFloat const kMQChatScrollBottomDistanceThreshold = 128.0;

@interface EDChatTableView()

@end

@implementation EDChatTableView
{
    //表明是否正在获取顶部的消息
    BOOL isLoadingTopMessages;
    
    //在加载历史消息时的offset
    CGFloat scrollOffsetAfterLoading;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChatTableView:)];
        tapViewGesture.cancelsTouchesInView = false;
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:tapViewGesture];
        scrollOffsetAfterLoading = 0.0;
        //初始化上拉、下拉刷新
        isLoadingTopMessages = false;

        [self initTopPullRefreshView];
    }
    return self;
}

- (void)hiddenMsgRecordInput
{
    
}

- (void)updateTableViewAtIndexPath:(NSIndexPath *)indexPath {
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

/** 点击tableView的事件 */
- (void)tapChatTableView:(id)sender {
    if (self.chatTableViewDelegate) {
        if ([self.chatTableViewDelegate respondsToSelector:@selector(didTapChatTableView:)]) {
            [self.chatTableViewDelegate didTapChatTableView:self];
        }
    }
}

// 开始下拉刷新
- (void)startLoadingTopRefreshView {
    if (!isLoadingTopMessages) {
        isLoadingTopMessages = true;
        [self.topRefreshView startLoading];
        if (self.chatTableViewDelegate) {
            if ([self.chatTableViewDelegate respondsToSelector:@selector(startLoadingTopMessagesInTableView:)]) {
                [self.chatTableViewDelegate startLoadingTopMessagesInTableView:self];
            }
        }
    }
}

// 结束下拉刷新
- (void)finishLoadingTopRefreshView
{
    if (isLoadingTopMessages) {
        isLoadingTopMessages = false;
        [self.topRefreshView finishLoading];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    BOOL didPullTopRefreshView = (scrollView.contentOffset.y + scrollView.contentInset.top <= -kMQChatPullRefreshDistance);
    if (didPullTopRefreshView) {
        //开启下拉刷新(顶部刷新)的条件
        [self startLoadingTopRefreshView];
    }
}

- (void)updateFrame:(CGRect)frame {
    self.frame = frame;
    
    [self.topRefreshView updateFrame];
}

- (void)initTopPullRefreshView {
    self.topRefreshView = [[EDPullRefreshView alloc] initWithSuperScrollView:self];
    [self addSubview:self.topRefreshView];
}

- (BOOL)isTableViewScrolledToBottom {
    if(self.contentOffset.y + self.frame.size.height + kMQChatScrollBottomDistanceThreshold > self.contentSize.height){
        return true;
    } else {
        return false;
    }
}

// 滚动到最底部
- (void)chatTableViewScrolledToBottom
{
//    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastCellIndex-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    
}
@end
