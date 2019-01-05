//
//  MOLPostRewardVC.m
//  reward
//
//  Created by apple on 2018/10/24.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLPostRewardVC.h"
#import "MOLReleaseViewController.h"
#import "MOLRecordViewController.h"
#import <UITextView+ZWPlaceHolder.h>
#import <TYAttributedLabel/TYAttributedLabel.h>
#import "MOLSeleGoldView.h"
#import "MOLShowGiftBigView.h"
#import "MOLRewardModel.h"
#import "MOLWalletViewController.h"
#import "MOLCallFriendsViewController.h"
#import "UIView+Alert.h"

#import "MOLPostRewardView.h"

#define edgeW 15.0f//边界
#define MAX_LIMIT_NUMS 140//行数限制

#define  redEvenGoldMinNum  5000//红包悬赏每人最小金币数目
#define  rankGoldMinNum 30000//排名悬赏最小金币数

@interface MOLPostRewardVC ()<MOLSeleGoldViewDelegate,SPPageMenuDelegate>

@property(nonatomic,strong)MOLPostRewardView  *postRewardView;//
@property(nonatomic, strong)MOLSeleGoldView *seleGoldView;
//发布数据
@property(nonatomic,assign)NSInteger currentRewardType;//当前悬赏类型 1红包 2排名
@property(nonatomic,assign)MOLGiftModel *currentGift;//礼物ID
@property(nonatomic,assign)NSInteger currentGiftNum;//礼物数量
@property(nonatomic,assign)NSInteger isMixJoiner;//是否合拍  0非合拍,1合拍
@property(nonatomic,copy)NSString *currentContent;//当前内容
@property(nonatomic,assign)NSInteger currentRedEnvelopeNum;//当前红包个数
@property(nonatomic,copy)NSString *currentFinishTime;//结束时间
@property(nonatomic,copy)NSString *currentfinishDate;//结束时间天数
@property(nonatomic,copy)NSString *currentfinishDateStr;//结束时间日期

@end

@implementation MOLPostRewardVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setOption];
}

#pragma mark - UI
- (void)initUI
{
    self.postRewardView = [[MOLPostRewardView alloc] initWithFrame:self.view.bounds];
    self.postRewardView.backgroundColor = self.view.backgroundColor;
    self.view = self.postRewardView;
    //设置标题
    [self basevc_setCenterTitle:@"发布悬赏" titleColor:[UIColor whiteColor]];
    // 帮助
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"帮助" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [nextButton sizeToFit];
    nextButton.titleLabel.textAlignment = NSTextAlignmentRight;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = item;
    //金币选择
    CGFloat H  =  MOL_SCREEN_WIDTH/4/93.7*111 *2 + MOL_SCALEHeight(36) + MOL_SCALEHeight(50)+ 0.1;
    self.seleGoldView =  [[MOLSeleGoldView alloc] initWithCustomH:H showBottom:NO];
    self.seleGoldView.delegate = self;
}
-(void)setOption{
    //设置pageMenu
    [self.postRewardView.pageMenu setItems:@[@"红包悬赏",@"排名悬赏"] selectedItemIndex:0];
    self.postRewardView.pageMenu.delegate = self;
    //添加Action
    [self.postRewardView.selGoldButton addTarget:self action:@selector(selGoldBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.postRewardView.goButton addTarget:self action:@selector(timeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.postRewardView.recordBtn addTarget:self action:@selector(recordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.postRewardView.jumpBtn addTarget:self action:@selector(jumpButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.postRewardView.mixBtn addTarget:self action:@selector(mixBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selGoldBtnAction)];
    [self.postRewardView.showGiftView addGestureRecognizer:tap];

    UITapGestureRecognizer *timeBtnTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeBtnAction)];
    [self.postRewardView.dueToTimeLable addGestureRecognizer:timeBtnTap];
    
    

    //设置默认初始数据
    self.currentRedEnvelopeNum = 0;//红包个数
    self.isMixJoiner = 0;//默认非合拍
    
//    self.currentFinishTime = [CommUtls theIntervalDateAfterDays:7];
//    self.currentfinishDate = @"7天";
//    self.currentfinishDateStr = [[CommUtls theDateAfterDays:7] stringByAppendingString:@"结束"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor =HEX_COLOR(0x0F101C);//  [UIColor blackColor];//HEX_COLOR(0x0F101C);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (toIndex == 0) {
        self.postRewardView.RewardTimeView.hidden = YES;
        self.postRewardView.RewardMoneyView.hidden = NO;
        self.currentRewardType = 1;
    }else{
        self.postRewardView.RewardTimeView.hidden = NO;
        self.postRewardView.RewardMoneyView.hidden = YES;
        self.currentRewardType = 2;
    }
}
#pragma mark 跳过录制
-(void)jumpButtonClick{
    if (![self cheakMenu]) {
        return;
    }
    
    MOLRewardModel *model = [[MOLRewardModel alloc] init];
    model.rewardType = self.currentRewardType;
    model.contentStr =  [BMSHelpers getContent:self.postRewardView.upTextView.text userSet:self.postRewardView.atInfo];
    model.content = self.postRewardView.upTextView.text;
    model.finishTime = self.currentFinishTime;
    model.finishDate = self.currentfinishDate;
    model.finishDateStr = self.currentfinishDateStr;
    model.gift = self.currentGift;
    model.gitfNum = self.currentGiftNum;
    model.isJoiner = self.isMixJoiner;
    model.redEnvelopeNum = self.currentRedEnvelopeNum;

    [MOLReleaseManager manager].currentRewardModel = model;
    MOLReleaseViewController *vc = [[MOLReleaseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 合拍按钮
-(void)mixBtnClick:(UIButton *)sender{
 
    [self.postRewardView mixRecordBtnAnimate];
    if (sender.selected) {
        self.isMixJoiner = 1;
    }else{
        self.isMixJoiner = 0;
    }
}
#pragma mark 录制视频
-(void)recordButtonClick{
    if (![self cheakMenu]) {
        return;
    }
    MOLRewardModel *model = [[MOLRewardModel alloc] init];
    model.rewardType = self.currentRewardType;
    model.contentStr = [BMSHelpers getContent:self.postRewardView.upTextView.text userSet:self.postRewardView.atInfo];
    model.content = self.postRewardView.upTextView.text;
    model.finishTime = self.currentFinishTime;
    model.finishDate = self.currentfinishDate;
    model.finishDateStr = self.currentfinishDateStr;
    model.gift = self.currentGift;
    model.gitfNum = self.currentGiftNum;
    model.redEnvelopeNum = self.currentRedEnvelopeNum;
    model.isJoiner = self.isMixJoiner;
    [MOLReleaseManager manager].currentRewardModel = model;
    
    MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)cheakMenu{
    
    NSInteger gold = self.currentGift.gold * self.currentGiftNum;
    
    if (self.currentRewardType == 1) {
        //红包悬赏
        self.currentRedEnvelopeNum = self.postRewardView.moneyTF.text.integerValue;
        if (gold < redEvenGoldMinNum) {
            NSString *title = [NSString stringWithFormat:@"悬赏金币必须大于%d才能进行红包悬赏哦!",redEvenGoldMinNum];
            [self showAlertWithTitle:title Message:nil];
            return NO;
        }else if(self.currentRedEnvelopeNum < 1 ){
            [MBProgressHUD showMessageAMoment:@"请填写红包个数!"];
            return NO;
        }else{
            NSInteger svGold = gold / self.currentRedEnvelopeNum;
            if(svGold < redEvenGoldMinNum){
                    //判断
                    NSInteger mod = gold % redEvenGoldMinNum;
                    NSInteger Num =  ceil(gold / redEvenGoldMinNum);
                    if (mod == 0) {
                        Num = Num + 1;
                    }
                    NSString *title = [NSString stringWithFormat:@"该悬赏金币下,红包个数必须小于%ld个,才能进行红包悬赏哦!",Num];
                    [self showAlertWithTitle:title Message:@"也可以提高悬赏金币，从而增加红包个数"];
                    return NO;
            }
        }
    }else{
        //排位悬赏
        if (gold < rankGoldMinNum) {
            NSString *title = [NSString stringWithFormat:@"悬赏金币必须大于%d才能进行排名悬赏哦!",rankGoldMinNum];
            [self showAlertWithTitle:title Message:nil];
            return NO;
        }
        if (self.currentFinishTime.length < 1) {
            [MBProgressHUD showMessageAMoment:@"请选择悬赏时间！"];
            return NO;
        }
    }
    if (self.postRewardView.upTextView.text.length < 5) {
        [MBProgressHUD showMessageAMoment:@"内容不能少于5个字!"];
        return NO;
    }
    return YES;
}

-(void)showAlertWithTitle:(NSString *)title Message:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancenAc = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    MJWeakSelf
    UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"追加悬赏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.seleGoldView showInView:weakSelf.view];
    }];
    
    [cancenAc setValue:HEX_COLOR_ALPHA(0x221E1E, 0.6) forKey:@"titleTextColor"];
    [sureAc setValue:HEX_COLOR(0xFE6257) forKey:@"titleTextColor"];
    [alert addAction:cancenAc];
    [alert addAction:sureAc];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark 选取金币
-(void)selGoldBtnAction{
    //友盟统计选择天数
    if (self.currentRewardType == 1) {
        //红包悬赏
           [MobClick event:ST_input_coin_success];
    }else{
        // 排位悬赏
           [MobClick event:ST_input_rank_coin_success];
    }
 
    [self.view endEditing:YES];
    [self.seleGoldView showInView:self.view];
}
#pragma mark 选择时间
-(void)timeBtnAction{
    
    //友盟统计选择天数
    [MobClick event:ST_input_time_success];
    
    [self.view endEditing:YES];
    NSArray *titleButtons = @[@"7天",@"10天",@"15天",@"30天"];
    @weakify(self);
    LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:5 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
        @strongify(self);
        if (buttonIndex >= titleButtons.count) {
            return;
        }
        if (buttonIndex == 0) {
            self.postRewardView.timeLable.text = @"7天";
            NSString *TimeStr = [[CommUtls theDateAfterDays:7] stringByAppendingString:@"结束"];
            self.postRewardView.dueToTimeLable.text = TimeStr;
            self.currentFinishTime = [CommUtls theIntervalDateAfterDays:7];
            self.currentfinishDate = @"7天";
            self.currentfinishDateStr =TimeStr;
        }else if (buttonIndex == 1) {
            self.postRewardView.timeLable.text = @"10天";
            NSString *TimeStr = [[CommUtls theDateAfterDays:10] stringByAppendingString:@"结束"];
            self.postRewardView.dueToTimeLable.text = TimeStr;
            self.currentFinishTime = [CommUtls theIntervalDateAfterDays:10];
            self.currentfinishDate = @"10天";
            self.currentfinishDateStr =TimeStr;
        }else if (buttonIndex == 2) {
            self.postRewardView.timeLable.text = @"15天";
            NSString *TimeStr = [[CommUtls theDateAfterDays:15] stringByAppendingString:@"结束"];
            self.postRewardView.dueToTimeLable.text = TimeStr;
            self.currentFinishTime = [CommUtls theIntervalDateAfterDays:15];
            self.currentfinishDate = @"15天";
            self.currentfinishDateStr =TimeStr;
        }else if (buttonIndex == 3) {
            self.postRewardView.timeLable.text = @"30天";
            NSString *TimeStr = [[CommUtls theDateAfterDays:30] stringByAppendingString:@"结束"];
            self.postRewardView.dueToTimeLable.text = TimeStr;
            self.currentFinishTime = [CommUtls theIntervalDateAfterDays:30];
            self.currentfinishDate = @"30天";
            self.currentfinishDateStr =TimeStr;
        }
        
    }];
    [actionS show];
}
-(void)didSelectAddGold{
    MOLWalletViewController *vc = [[MOLWalletViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 帮助
-(void)nextButtonClick{
    // 根据返回得到展示信息
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"帮助" message:@"在红包悬赏中，悬赏者发布的悬赏奖励将会被随机分配到多个红包中（红包数量可选择），完成悬赏的用户可瓜分悬赏奖励。\n在排名悬赏中，通过官方审核的视频将会在悬赏时间到期后根据点赞排行来发放悬赏奖励。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
//    //下面的代码就是找出标题和消息内容的承载标签控件
//    UIView *subView1 = alert.view.subviews[0];
//    UIView *subView2 = subView1.subviews[0];
//    UIView *subView3 = subView2.subviews[0];
//    UIView *subView4 = subView3.subviews[0];
//    UIView *subView5 = subView4.subviews[0];
//    // UILabel *title = subView5.subviews[0];//第一个是标题,
//    //第二个是message
//    UILabel *message = subView5.subviews[1];
//    //改变message的对齐方式
//    message.textAlignment = NSTextAlignmentLeft;
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark 礼物选择代理 MOLSeleGoldViewDelegate
- (void)didSelectAt:(MOLGiftModel *)gift{
    self.postRewardView.showGiftView.giftModel = gift;
    self.currentGift = gift;
}
-(void)didSelectGiftNumber:(NSInteger)num{
    self.postRewardView.showGiftView.giftNum = num;
    self.currentGiftNum = num;
}
- (void)didSetGift:(MOLGiftModel *)gift WithGiftNum:(NSInteger)num{
    self.postRewardView.showGiftView.giftModel = gift;
    self.postRewardView.showGiftView.giftNum = num;
    
    self.currentGift = gift;
    self.currentGiftNum = num;
}

@end
