//
//  MOLPostRewardView.h
//  reward
//
//  Created by apple on 2018/10/24.
//  Copyright © 2018年 reward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOLShowGiftBigView;
@class MOLSeleGoldView;

@interface MOLPostRewardView : UIView
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIView *headView;

//悬赏金币
@property (nonatomic, strong) UIView *RewardGoldView;
@property (nonatomic, strong) UIButton *selGoldButton;//go
@property (nonatomic, strong) MOLShowGiftBigView *showGiftView;

//悬赏时间
@property (nonatomic, strong) UIView *RewardTimeView;
@property (nonatomic, strong) UILabel *timeLable;//悬赏的时间
@property (nonatomic, strong) UILabel *dueToTimeLable;//结束时间
@property (nonatomic, strong) UIButton *goButton;//到期时间
//红包个数
@property (nonatomic, strong) UIView *RewardMoneyView;
@property (nonatomic, strong) UITextField *moneyTF;
//textView
@property (nonatomic, strong) UITextView *upTextView;
@property (nonatomic, strong) UIButton *addUserButton;//@用户
@property (nonatomic, strong) UILabel *textNumLab;
//合拍按钮
@property (nonatomic, strong) UIButton  *mixBtn;

//底部
@property (nonatomic, strong)UIView   *bottomView;
@property (nonatomic, strong)UIButton *jumpBtn;//跳过录制
@property (nonatomic, strong)UIButton *recordBtn;//录制悬赏视频

// @的匹配信息
@property (nonatomic, strong) NSMutableDictionary *atInfo;
//合拍动画
-(void)mixRecordBtnAnimate;
@end
