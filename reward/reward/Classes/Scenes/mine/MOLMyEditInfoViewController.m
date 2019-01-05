//
//  MOLMyEditInfoViewController.m
//  reward
//
//  Created by moli-2017 on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLMyEditInfoViewController.h"
#import "MOLMyEditInfoCell.h"
#import "MOLMyEditImageCell.h"
#import "MOLMyEditModel.h"
#import "JAGrowingTextView.h"

#import "MOLAccountViewModel.h"

@interface MOLMyEditInfoViewController ()<UITableViewDelegate, UITableViewDataSource,YYTextKeyboardObserver>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) NSDictionary *oriFormDict;  // 原始表单数据

@property (nonatomic,strong) NSMutableDictionary *formDict;  // 表单数据
@property (nonatomic, assign) BOOL edit;

@property (nonatomic, assign) CGRect textViewFrame;

@property (nonatomic, strong) MOLAccountViewModel *accountViewModel;
@end

@implementation MOLMyEditInfoViewController

- (BOOL)showNavigationLine
{
    return YES;
}

- (void)dealloc
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)leftBackAction
{
    
    @weakify(self);
    [self needSave:^(BOOL needUpdate, NSMutableDictionary *dic) {
        @strongify(self);
        if (needUpdate == YES) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否保存修改" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.accountViewModel.changeInfoCommand execute:dic];
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancleAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountViewModel = [[MOLAccountViewModel alloc] init];
    self.formDict = [NSMutableDictionary dictionary];
    self.dataSourceArray = [NSMutableArray array];
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    
    [self setupNavigation];
    
    self.formDict[@"image"] = self.userModel.avatar;
    self.formDict[@"name"] = self.userModel.userName;
    self.formDict[@"rewardId"] = self.userModel.userUuid;
    self.formDict[@"sex"] = self.userModel.gender > 0 ? (self.userModel.gender == 1 ? @"男" : @"女") : nil;
    self.formDict[@"birthday"] = self.userModel.birthDay;
    self.formDict[@"introduction"] = self.userModel.signInfo;
    
    self.oriFormDict = self.formDict;
    
    [self request_getEditData];
    
    [self setupMyEditInfoViewControllerUI];
    
    [self bindingViewModel];
}

#pragma mark - bindingViewModel
- (void)bindingViewModel
{
    [self.accountViewModel.changeInfoCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        MOLUserModel *user = (MOLUserModel *)x;
        if (user.code == MOL_SUCCESS_REQUEST) {
            // 保存用户信息
            [MBProgressHUD showMessageAMoment:@"保存成功"];
            [MOLUserManagerInstance user_saveUserInfoWithModel:user isLogin:NO];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showMessageAMoment:user.message];
        }
    }];
}

#pragma mark - 网络请求
- (void)request_getEditData
{
    MOLMyEditModel *model1 = [MOLMyEditModel new];
    model1.cellType = MOLMyEditModelType_image;
    model1.image = self.userModel.avatar;
    model1.key = @"image";
    model1.cellHeight = 150;
    [self.dataSourceArray addObject:model1];
    
    MOLMyEditModel *model2 = [MOLMyEditModel new];
    model2.cellType = MOLMyEditModelType_text;
    model2.title = @"昵称";
    model2.placeholder = @"请输入名字";
    model2.key = @"name";
    model2.keyboardType = MOLMyEditKeyboardType_normal;
    model2.cellHeight = 50;
    [self.dataSourceArray addObject:model2];
    
    MOLMyEditModel *model3 = [MOLMyEditModel new];
    model3.cellType = MOLMyEditModelType_text;
    model3.title = @"ID";
    model3.placeholder = @"有封信ID";
    model3.key = @"rewardId";
    model3.keyboardType = MOLMyEditKeyboardType_id;
    model3.cellHeight = 50;
    [self.dataSourceArray addObject:model3];
    
    MOLMyEditModel *model4 = [MOLMyEditModel new];
    model4.cellType = MOLMyEditModelType_text;
    model4.title = @"性别";
    model4.placeholder = @"点击选择性别";
    model4.key = @"sex";
    model4.keyboardType = MOLMyEditKeyboardType_sex;
    model4.cellHeight = 50;
    [self.dataSourceArray addObject:model4];
    
    MOLMyEditModel *model5 = [MOLMyEditModel new];
    model5.cellType = MOLMyEditModelType_text;
    model5.title = @"生日";
    model5.placeholder = @"点击选择出生日期";
    model5.key = @"birthday";
    model5.keyboardType = MOLMyEditKeyboardType_birthday;
    model5.cellHeight = 50;
    [self.dataSourceArray addObject:model5];
    
    MOLMyEditModel *model6 = [MOLMyEditModel new];
    model6.cellType = MOLMyEditModelType_text;
    model6.title = @"签名";
    model6.placeholder = @"这家伙很懒，什么都没有留下";
    model6.key = @"introduction";
    model6.keyboardType = MOLMyEditKeyboardType_introduction;
    model6.cellHeight = 100;
    [self.dataSourceArray addObject:model6];
}

#pragma mark - 按钮的点击
- (void)needSave:(void(^)(BOOL needUpdate,NSMutableDictionary *dic))saveBlock
{
    BOOL needUpdate = NO;
    [self.view endEditing:YES];
    
    NSString *image = self.formDict[@"image"];
    NSString *name = self.formDict[@"name"];
    NSString *sex = self.formDict[@"sex"];
    NSInteger sexNum = 0;
    if ([sex isEqualToString:@"男"]) {
        sexNum = 1;
    }else if ([sex isEqualToString:@"女"]) {
        sexNum = 2;
    }
    
    NSString *birthday = self.formDict[@"birthday"];
    NSString *introduce = self.formDict[@"introduction"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (![image isEqualToString:self.userModel.avatar]) {
        dic[@"avatar"] = image;
        needUpdate = YES;
    }
    
    if (![name isEqualToString:self.userModel.userName]) {
        dic[@"userName"] = name;
        needUpdate = YES;
    }
    
    if (sexNum != self.userModel.gender) {
        dic[@"gender"] = @(sexNum);
        needUpdate = YES;
    }
    
    if (![birthday isEqualToString:self.userModel.birthDay]) {
        dic[@"birthDay"] = birthday;
        needUpdate = YES;
    }
    
    if (![introduce isEqualToString:self.userModel.signInfo]) {
        dic[@"signInfo"] = introduce;
        needUpdate = YES;
    }
    
    if (saveBlock) {
        saveBlock(needUpdate,dic);
    }
}
- (void)button_clickSaveInfo
{
    @weakify(self);
    [self needSave:^(BOOL needUpdate, NSMutableDictionary *dic) {
        @strongify(self);
        if (needUpdate == YES) {
            [self.accountViewModel.changeInfoCommand execute:dic];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition
{
    CGRect kbFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    
    CGFloat offset = self.textViewFrame.origin.y + self.textViewFrame.size.height + MOL_StatusBarAndNavigationBarHeight - kbFrame.origin.y;
    if (offset > 0) {
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
    }else{
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    MOLMyEditModel *model = self.dataSourceArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLMyEditModel *model = self.dataSourceArray[indexPath.row];
    if (model.cellType == MOLMyEditModelType_image) {
        MOLMyEditImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLMyEditImageCell_id"];
        cell.model = model;
        cell.formDic = self.formDict;
        return cell;
    }else{
        MOLMyEditInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOLMyEditInfoCell_id"];
        cell.model = model;
        cell.formDic = self.formDict;
        __weak typeof(cell)weakCell = cell;
        [cell setClickTextfieldBlock:^(CGRect frame) {
            __strong typeof(weakCell)strongCell = weakCell;
            
            self.textViewFrame = [strongCell convertRect:frame toView: tableView];
        }];
        return cell;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 导航条
- (void)setupNavigation
{
    [self basevc_setCenterTitle:@"个人资料" titleColor:HEX_COLOR(0xffffff)];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"保存" color:HEX_COLOR(0xFFEC00) disableColor:HEX_COLOR_ALPHA(0xFFEC00, 0.5) font:MOL_MEDIUM_FONT(17) targat:self action:@selector(button_clickSaveInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UI
- (void)setupMyEditInfoViewControllerUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MOLMyEditInfoCell class] forCellReuseIdentifier:@"MOLMyEditInfoCell_id"];
    [tableView registerClass:[MOLMyEditImageCell class] forCellReuseIdentifier:@"MOLMyEditImageCell_id"];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, MOL_TabbarHeight, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:tableView];
}

- (void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

- (void)calculatorMyEditInfoViewControllerFrame
{
    self.tableView.frame = self.view.bounds;
    self.tableView.height = self.view.height - MOL_StatusBarAndNavigationBarHeight;
    self.tableView.y = MOL_StatusBarAndNavigationBarHeight;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self calculatorMyEditInfoViewControllerFrame];
}
@end
