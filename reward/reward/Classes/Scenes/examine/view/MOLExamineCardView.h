//
//  MOLExamineCardView.h
//  reward
//
//  Created by moli-2017 on 2018/9/15.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOLExamineCardModel.h"

typedef NS_ENUM(NSUInteger, MOLExamineCardViewType) {
    MOLExamineCardViewType_normal,  // 普通
    MOLExamineCardViewType_noProduction, // 不需要展示底部作品
};

@interface MOLExamineCardView : UIView
@property (nonatomic, strong) MOLExamineCardModel *cardModel;

@property (nonatomic, assign) MOLExamineCardViewType cardViewType;
@end
