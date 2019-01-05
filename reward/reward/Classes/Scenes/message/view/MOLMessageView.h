//
//  MOLMessageView.h
//  reward
//
//  Created by 刘宏亮 on 2018/9/16.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAPaddingLabel.h"

@interface MOLMessageView : UIView
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, weak) UIButton *fansButton;    // 粉丝
@property (nonatomic, weak) JAPaddingLabel *fansNotiCountLabel;
@property (nonatomic, weak) UIButton *likeButton;    // 点赞
@property (nonatomic, weak) JAPaddingLabel *likeNotiCountLabel;
@property (nonatomic, weak) UIButton *commentButton; // 评论
@property (nonatomic, weak) JAPaddingLabel *commentNotiCountLabel;
//@property (nonatomic, weak) UIButton *examineButton; // 评选
//@property (nonatomic, weak) JAPaddingLabel *examineNotiCountLabel;

@property (nonatomic, weak) UILabel *examineContentLabel;

@property (nonatomic, weak) UIButton *atButton; // @我
@property (nonatomic, weak) JAPaddingLabel *atNotiCountLabel;

- (void)NotificationSettings;
@end
