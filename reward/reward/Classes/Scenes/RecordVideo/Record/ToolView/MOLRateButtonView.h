//
//  PLSRateScrollView.h
//  reward
//
//  Created by apple on 2018/9/8.
//  Copyright © 2018年 reward. All rights reserved.
///Users/apple/Documents/Moli/CC/reward/reward/Classes/Scenes/loginAndRegist

#import <UIKit/UIKit.h>
@class MOLRateButtonView;
@protocol MOLRateButtonViewDelegate <NSObject>

- (void)rateButtonView:(MOLRateButtonView *)rateButtonView didSelectedTitleIndex:(NSInteger)titleIndex;

@end

@interface MOLRateButtonView : UIView

@property (nonatomic, strong) NSArray *staticTitleArray;
@property (nonatomic, strong) NSArray *scrollTitleArr;

@property (nonatomic, strong) NSMutableArray *totalLabelArray;

@property (nonatomic, assign) id<MOLRateButtonViewDelegate> rateDelegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat space;


- (instancetype)initWithFrame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex;
@end
