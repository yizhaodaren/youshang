//
//  MOLWithdrawViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLWithdrawViewController.h"
#import "MOLWithdrawCell.h"
#import "MOLWebViewController.h"
#import "MOLUserPageRequest.h"
#import "MOLHostHead.h"

@interface MOLWithdrawViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, weak) UILabel *validGlodLabel;
@property (nonatomic, weak) UIButton *validGlodButton;  // 已审核金币
@property (nonatomic, weak) UILabel *invalidGlodLabel;
@property (nonatomic, weak) UIButton *invalidGlodButton;  // 待审核金币
@property (nonatomic, weak) UIView *lineView;  //   竖线

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation MOLWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArray = [NSMutableArray array];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"title"] = @"红包收益";
    dic[@"image"] = @"withdrawal";
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"title"] = @"兑换钻石";
    dic1[@"image"] = @"withdraw_exchange";
    [self.dataSourceArray addObject:dic];
    [self.dataSourceArray addObject:dic1];
    
    [self setupWithdrawViewControllerUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取个人财富
    [self request_getMyTreasure];
}

#pragma mark - 网络请求
- (void)request_getMyTreasure
{
    MOLUserPageRequest *r = [[MOLUserPageRequest alloc] initRequest_getTreasureWithParameter:nil];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        MOLTreasureModel *model = (MOLTreasureModel *)responseModel;
        
        [self.validGlodButton setTitle:[NSString stringWithFormat:@"%.0f",model.coinAmount] forState:UIControlStateNormal];
        
        [self.invalidGlodButton setTitle:[NSString stringWithFormat:@"%.0f",model.txCoinAmount ] forState:UIControlStateNormal];
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MOLWebViewController *vc = [[MOLWebViewController alloc] init];
    
    if (indexPath.row == 0) {
        NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
        offic = MOL_TEST_SERVICE;  // 测试
#endif
        vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/bank/widthdraw.html",offic];
        vc.titleString = @"红包收益";
    }else{
        NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
        offic = MOL_TEST_SERVICE;  // 测试
#endif
        vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/bank/exchange.html",offic];
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSourceArray[indexPath.row];
    MOLWithdrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLWithdrawCell_id"];
    cell.dictionary = dic;
    return cell;
}

#pragma mark - 懒加载
- (UIView *)headView
{
    if (_headView == nil) {
        
        _headView = [[UIView alloc] init];
        _headView.width = MOL_SCREEN_WIDTH;
        _headView.height = 160;
        _headView.backgroundColor = HEX_COLOR(0x161824);
        
        UILabel *validGlodLabel = [[UILabel alloc] init];
        _validGlodLabel = validGlodLabel;
        validGlodLabel.text = @"金币(可提现)";
        validGlodLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.8);
        validGlodLabel.font = MOL_MEDIUM_FONT(12);
        [validGlodLabel sizeToFit];
        validGlodLabel.centerX = _headView.width * 0.25;
        validGlodLabel.y = 40;
        [_headView addSubview:validGlodLabel];
        
        UIButton *validGlodButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _validGlodButton = validGlodButton;
        [validGlodButton setImage:[UIImage imageNamed:@"withdraw_gold_coins"] forState:UIControlStateNormal];
        [validGlodButton setTitle:@"0" forState:UIControlStateNormal];
        [validGlodButton setTitleColor:HEX_COLOR_ALPHA(0xFFEC00, 1) forState:UIControlStateNormal];
        validGlodButton.titleLabel.font = MOL_REGULAR_FONT(18);
        validGlodButton.width = _headView.width * 0.5;
        validGlodButton.height = 25;
        validGlodButton.y = validGlodLabel.bottom + 18;
        [validGlodButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:5];
        [_headView addSubview:validGlodButton];
        
        UILabel *invalidGlodLabel = [[UILabel alloc] init];
        _invalidGlodLabel = invalidGlodLabel;
        invalidGlodLabel.text = @"金币(待审核)";
        invalidGlodLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.8);
        invalidGlodLabel.font = MOL_MEDIUM_FONT(12);
        [invalidGlodLabel sizeToFit];
        invalidGlodLabel.centerX = _headView.width * 0.75;
        invalidGlodLabel.y = 40;
        [_headView addSubview:invalidGlodLabel];
        
        UIButton *invalidGlodButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _invalidGlodButton = invalidGlodButton;
        [invalidGlodButton setImage:[UIImage imageNamed:@"withdraw_gold_coins"] forState:UIControlStateNormal];
        [invalidGlodButton setTitle:@"0" forState:UIControlStateNormal];
        [invalidGlodButton setTitleColor:HEX_COLOR_ALPHA(0xFFEC00, 1) forState:UIControlStateNormal];
        invalidGlodButton.titleLabel.font = MOL_REGULAR_FONT(18);
        invalidGlodButton.width = _headView.width * 0.5;
        invalidGlodButton.height = 25;
        invalidGlodButton.x = _headView.width * 0.5;
        invalidGlodButton.y = invalidGlodLabel.bottom + 18;
        [invalidGlodButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleDefault padding:5];
        [_headView addSubview:invalidGlodButton];
        
        UIView *lineView = [[UIView alloc] init];
        _lineView = lineView;
        lineView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
        lineView.height = 80;
        lineView.width = 1;
        lineView.centerX = _headView.width * 0.5;
        lineView.centerY = _headView.height * 0.5;
        [_headView addSubview:lineView];
    }
    
    return _headView;
}

#pragma mark - UI
- (void)setupWithdrawViewControllerUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.05);
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MOLWithdrawCell class] forCellReuseIdentifier:@"MOLWithdrawCell_id"];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarHeight, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.tableHeaderView = self.headView;
}

- (void)calculatorWithdrawViewControllerFrame
{
    self.tableView.frame = self.view.bounds;
    //    self.tableView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    //    self.tableView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorWithdrawViewControllerFrame];
}
@end
