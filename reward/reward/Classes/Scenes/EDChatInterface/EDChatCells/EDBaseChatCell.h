//
//  EDBaseChatCell.h
//  aletter
//
//  Created by moli-2017 on 2018/8/24.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDBaseMessageModel.h"

@protocol EDBaseChatCellDelegate <NSObject>

@end

@interface EDBaseChatCell : UITableViewCell

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIImageView *bubbleImageView;
@property (nonatomic, weak) UIActivityIndicatorView *sendIndicatorView;
@property (nonatomic, weak) UIButton *sendFailureButton;

- (void)updateCellWithCellModel:(EDBaseMessageModel *)model;

@property (nonatomic, weak) id <EDBaseChatCellDelegate> chatCellDelegate;  // 点击cell里面的事件（如：电话、邮箱）等
@end
