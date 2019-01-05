//
//  EDPullRefreshView.m
//  aletter
//
//  Created by moli-2017 on 2018/8/27.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "EDPullRefreshView.h"

static CGFloat const kMQPullRefreshViewHeight = 44.0;  // 刷新控件额高度
static CGFloat const kMQPullRefreshIndicatorDiameter = 20.0;  // 刷新控件的大小


@interface EDPullRefreshView()

/**
 *  拥有下拉刷新的scrollView
 */
@property (nonatomic, weak) UIScrollView *superScrollView;
@property (nonatomic, strong) UIView *loadingIndicatorView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation EDPullRefreshView
{
    BOOL isLoading;
}

- (instancetype)initWithSuperScrollView:(UIScrollView *)scrollView
{
    self = [super init];
    if (self) {
        self.kMQTableViewContentTopOffset = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 64.0 : 0.0;
        self.superScrollView = scrollView;
        isLoading = false;
        
        self.frame = CGRectMake(0, -kMQPullRefreshViewHeight, self.superScrollView.frame.size.width, kMQPullRefreshViewHeight);
        
        //初始化indicatorView
        self.loadingIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - kMQPullRefreshIndicatorDiameter/2, self.frame.size.height/2 - kMQPullRefreshIndicatorDiameter/2, kMQPullRefreshIndicatorDiameter, kMQPullRefreshIndicatorDiameter)];
        
        //初始化indicator
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.loadingIndicator.hidden = NO;
        self.loadingIndicator.hidesWhenStopped = NO;
        [self.loadingIndicatorView addSubview:self.loadingIndicator];
        [self addSubview:self.loadingIndicatorView];
        
    }
    return self;
}


- (void)startLoading {
    if (!isLoading) {
        isLoading = true;
        [self.loadingIndicator startAnimating];
        CGFloat contentInsetTop = self.superScrollView.contentInset.top + self.frame.size.height;
        self.superScrollView.contentInset = UIEdgeInsetsMake(contentInsetTop, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
    }
}

- (void)finishLoading {
    if (isLoading) {
        isLoading = false;
        [self.loadingIndicator stopAnimating];
        CGFloat contentInsetTop = self.superScrollView.contentInset.top - self.frame.size.height;
        [UIView animateWithDuration:.3 animations:^{
            self.superScrollView.contentInset = UIEdgeInsetsMake(contentInsetTop, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
        }];
    }
}


- (void)updateFrame {
    CGFloat originY = -kMQPullRefreshViewHeight;
    self.frame = CGRectMake(self.frame.origin.x, originY, self.superScrollView.frame.size.width, self.frame.size.height);
    self.loadingIndicatorView.frame = CGRectMake(self.frame.size.width/2 - kMQPullRefreshIndicatorDiameter/2, self.frame.size.height/2 - kMQPullRefreshIndicatorDiameter/2, kMQPullRefreshIndicatorDiameter, kMQPullRefreshIndicatorDiameter);
}
@end
