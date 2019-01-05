//
//  MOLRechargeViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLRechargeViewController.h"
#import "MOLRechargeCell.h"
#import "MOLWalletViewModel.h"
#import "MOLChooseRechargeView.h"

#import "MOLWalletGroupModel.h"
#import "MOLApplePayManager.h"

#import "MOLUserPageRequest.h"

@interface MOLRechargeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, weak) UIButton *diamondButton;  // 钻石
@property (nonatomic, weak) UILabel *rechargeLabel;  //   充值
@property (nonatomic, weak) UILabel *introduceLabel;  //  CC不提倡未成年人进行充值

@property (nonatomic, strong) MOLWalletViewModel *walletViewModel;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) NSMutableArray *productSourceArray;

@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation MOLRechargeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.walletViewModel = [[MOLWalletViewModel alloc] init];
    self.dataSourceArray = [NSMutableArray array];
    self.productSourceArray = [NSMutableArray array];
    [self setupRechargeViewControllerUI];
    [self bindingwalletViewModel];
 
    // 获取个人
    [self request_getRechargeList];
    
    // 获取个人财富
    [self request_getMyTreasure];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request_getMyTreasure) name:@"MOL_PING_PAY" object:nil];
}

#pragma mark - 网络请求
- (void)request_getMyTreasure
{
    MOLUserPageRequest *r = [[MOLUserPageRequest alloc] initRequest_getTreasureWithParameter:nil];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
       
        MOLTreasureModel *model = (MOLTreasureModel *)responseModel;
        
        [self.diamondButton setTitle:[NSString stringWithFormat:@"%.0f",model.diamondAmount] forState:UIControlStateNormal];
        [self.diamondButton layoutIfNeeded];
        [self.diamondButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}

- (void)request_getRechargeList
{
    [self.dataSourceArray removeAllObjects];
    
    // 非内购
//    [self.walletViewModel.rechargeCommand execute:nil];
    
    // 内购
    [MBProgressHUD showMessage:nil toView:self.view];
    [[MOLApplePayManager shareApplePayManager] requestProductDataWithcompleteHandle:^(NSArray *product) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.productSourceArray removeAllObjects];
        [self.dataSourceArray removeAllObjects];
        [self.productSourceArray addObjectsFromArray:product];

        for (NSInteger i = 0; i < product.count; i++) {
            SKProduct *pro = product[i];
            MOLWalletModel *model = [[MOLWalletModel alloc] init];
            model.goodsId = pro.productIdentifier;
            model.diamondAmount = pro.localizedTitle;
            model.cnyAmount = [NSString stringWithFormat:@"%@",pro.price];
            [self.dataSourceArray addObject:model];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - ViewModel
- (void)bindingwalletViewModel
{
    @weakify(self);
    [self.walletViewModel.rechargeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        MOLWalletGroupModel *model = (MOLWalletGroupModel *)x;
        if (model.code != MOL_SUCCESS_REQUEST) {
            
            [MBProgressHUD showMessageAMoment:model.message];
            
            return;
        }
        
        [self.dataSourceArray addObjectsFromArray:model.resBody];
        [self.tableView reloadData];
    }];
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 非内购
//    MOLWalletModel *model = self.dataSourceArray[indexPath.row];
//    [MOLChooseRechargeView chooseRechargeView_showWith:model.goodsId];
    
    // 内购
    // 获取凭证
    NSString *productId = [[NSUserDefaults standardUserDefaults] objectForKey:@"MOL_IAP_PRO"];
    if (productId.length) {
        [MBProgressHUD showMessageAMoment:@"您有未完成订单,请关闭程序重试"];
    }else{
        SKProduct *product = self.productSourceArray[indexPath.row];
        [[MOLApplePayManager shareApplePayManager] startPurchWithID:product.productIdentifier];
    }
    
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
    MOLWalletModel *model = self.dataSourceArray[indexPath.row];
    MOLRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLRechargeCell_id"];
    cell.walletModel = model;
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
        
        UIButton *diamondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _diamondButton = diamondButton;
        [diamondButton setImage:[UIImage imageNamed:@"withdraw_diamond"] forState:UIControlStateNormal];
        [diamondButton setTitle:@"0" forState:UIControlStateNormal];
        [diamondButton setTitleColor:HEX_COLOR_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
        diamondButton.titleLabel.font = MOL_MEDIUM_FONT(30);
        diamondButton.width = MOL_SCREEN_WIDTH;
        diamondButton.height = 130;
        [diamondButton mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];
        [_headView addSubview:diamondButton];
        
        UILabel *rechargeLabel = [[UILabel alloc] init];
        _rechargeLabel = rechargeLabel;
        rechargeLabel.text = @"充值";
        rechargeLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.3);
        rechargeLabel.font = MOL_MEDIUM_FONT(13);
        [rechargeLabel sizeToFit];
        rechargeLabel.x = 15;
        rechargeLabel.bottom = _headView.height - 10;
        [_headView addSubview:rechargeLabel];
        
        UILabel *introduceLabel = [[UILabel alloc] init];
        _introduceLabel = introduceLabel;
        introduceLabel.text = @"CC不提倡未成年人进行充值";
        introduceLabel.textColor = HEX_COLOR_ALPHA(0xffffff, 0.3);
        introduceLabel.font = MOL_MEDIUM_FONT(13);
        [introduceLabel sizeToFit];
        introduceLabel.right = _headView.width - 15;
        introduceLabel.bottom = _headView.height - 10;
        [_headView addSubview:introduceLabel];
    }
    
    return _headView;
}

#pragma mark - UI
- (void)setupRechargeViewControllerUI
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
    [tableView registerClass:[MOLRechargeCell class] forCellReuseIdentifier:@"MOLRechargeCell_id"];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarHeight, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.tableHeaderView = self.headView;
}

- (void)calculatorRechargeViewControllerFrame
{
    self.tableView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorRechargeViewControllerFrame];
}
@end
