//
//  MOLYSHelpMessageModel.h
//  reward
//
//  Created by moli-2017 on 2018/10/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "EDBaseMessageModel.h"

@interface MOLYSHelpMessageModel : EDBaseMessageModel<NIMCustomAttachment>
//@property (nonatomic, strong) NSString *customContent;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *typeId;

@property (nonatomic, assign) CGRect attendButtonFrame;
@property (nonatomic, assign) CGRect contentLabelFrame;

@property (nonatomic, assign) CGFloat cellHeight;

- (CGFloat)getCellHeight;
@end
