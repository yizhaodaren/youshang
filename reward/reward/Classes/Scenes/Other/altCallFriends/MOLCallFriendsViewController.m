 //
//  MOLCallFriendsViewController.m
//  reward
//
//  Created by apple on 2018/11/7.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLCallFriendsViewController.h"
#import "MOLCallFriendsCell.h"
#import "MOLMsgUserGroupModel.h"
 
#import "MOLMessagePageRequest.h"
#import "HomePageRequest.h"

#define MOL_Data_COUNT @10//每页拉取数据
@interface MOLCallFriendsViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *focusDataArray;//关注人数据
@property (nonatomic,strong)NSMutableArray *searchDataArray;//search的数据
@property (nonatomic,strong)NSMutableArray *currentDataArray;//当前展示的数据

@property (nonatomic, assign) NSInteger currentFocusPage;
@property (nonatomic, assign) NSInteger currentSeachedPage;
@property (nonatomic, assign) MOLFriendType currentFriendType;
@property (nonatomic,  assign)CGFloat  errorH;//没有数据或网络状态的提示view高度
@end

@implementation MOLCallFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setOption];
    
}
+(MOLCallFriendsViewController *)show{
    MOLCallFriendsViewController *vc = [[MOLCallFriendsViewController alloc] init];
    MOLBaseNavigationController *nav = [[MOLBaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:nav.view];
    
    [[[MOLGlobalManager shareGlobalManager] global_rootViewControl] presentViewController:nav animated:YES completion:nil];
    
    
    return vc;
}
-(void)setOption{
    
    self.errorH = CGRectGetMaxY(self.searchBar.frame) + 30;
    self.focusDataArray =[NSMutableArray new];
    self.searchDataArray = [NSMutableArray new];
    self.currentFriendType = MOLFriendType_focus;
    @weakify(self);
    self.tableView.mj_header = [MOLDIYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_DataWithMore:NO];
    }];
    self.tableView.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        
        [self request_DataWithMore:YES];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self request_DataWithMore:NO];
}
-(void)initUI{
    self.view.backgroundColor = [UIColor clearColor];
    [self basevc_setCenterTitle:@"召唤好友" titleColor:[UIColor whiteColor]];
    UIBarButtonItem *backItem = [UIBarButtonItem mol_barButtonItemWithImageName:@"call_Fri_close" highlightImageName:@"call_Fri_close" targat:self action:@selector(leftBackAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.view.bounds;
     [self.view addSubview:effectView];
     [self.view addSubview:self.searchBar];
     [self.view addSubview:self.tableView];
}
-(void)leftBackAction{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MOLCallFriendsViewController" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 网络请求
- (void)request_DataWithMore:(BOOL)isMore
{
    if (self.currentFriendType == MOLFriendType_seached) {
        [self getSearchNetDataWithMore:isMore];
        return;
    }

    if (!isMore) {
        self.currentFocusPage = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentFocusPage);
    dic[@"pageSize"] = MOL_Data_COUNT;
    dic[@"userId"] = [[MOLUserManager shareUserManager] user_getUserId];
    MOLMessagePageRequest *r = [[MOLMessagePageRequest alloc] initRequest_focusListWithParameter:dic];
    
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        // 解析数据
        MOLMsgUserGroupModel *groupModel = (MOLMsgUserGroupModel *)responseModel;
        
        if (!isMore) {
            [self.focusDataArray removeAllObjects];
        }
        // 添加到数据源
        [self.focusDataArray addObjectsFromArray:groupModel.resBody];
        
        [self.tableView reloadData];
        
        if (self.focusDataArray.count >= groupModel.total) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
            self.currentFocusPage += 1;
        }
        
        if (!self.focusDataArray.count) {
                [self basevc_showBlankPageWithY:self.errorH image:@"search_empty" title:nil superView:self.view];
        }else{
            [self basevc_hiddenErrorView];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self basevc_showErrorPageWithY:self.errorH select:@selector(refresh_again) superView:self.view];
    }];
}


- (void)getSearchNetDataWithMore:(BOOL)isMore
{
    if (!isMore) {
        self.currentSeachedPage = 1;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.currentSeachedPage);
    dic[@"pageSize"] = MOL_Data_COUNT;
    dic[@"type"] = @"user";
    dic[@"content"] =self.searchBar.text?self.searchBar.text:@"";

    __weak typeof(self) wself = self;

    [[[HomePageRequest alloc] initRequest_SearchParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {

            [wself.tableView.mj_header endRefreshing];
            [wself.tableView.mj_footer endRefreshing];

        // 解析数据
        MOLMsgUserGroupModel *groupModel = (MOLMsgUserGroupModel *)responseModel;
        
        if (!isMore) {
            [self.searchDataArray removeAllObjects];
        }
        // 添加到数据源
        [self.searchDataArray addObjectsFromArray:groupModel.resBody];
        
        [self.tableView reloadData];
        
        if (self.searchDataArray.count >= groupModel.total) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
            self.currentSeachedPage += 1;
        }
        
        if (!self.searchDataArray.count) {
            [self basevc_showBlankPageWithY:self.errorH image:@"search_empty" title:nil superView:self.view];
        }else{
            [self basevc_hiddenErrorView];
        }

    } failure:^(__kindof MOLBaseNetRequest *request) {
        [self basevc_showErrorPageWithY:self.errorH select:@selector(refresh_again) superView:self.view];
    }];
}
-(void)refresh_again{
    [self request_DataWithMore:NO];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * const searchCellID = @"searchCell";
    MOLCallFriendsCell *Cell =[tableView dequeueReusableCellWithIdentifier:searchCellID];
    if (!Cell) {
        
        Cell =[[MOLCallFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellID];
        Cell.selectionStyle= UITableViewCellSelectionStyleNone;
        
    }
    
    MOLMsgUserModel *model =[MOLMsgUserModel new];
    
    if (indexPath.row<self.currentDataArray.count) {
        model =self.currentDataArray[indexPath.row];
    }
    Cell.userModel =model;
    
    return Cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ( self.currentFriendType == MOLFriendType_focus) {
        return  40;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ( self.currentFriendType == MOLFriendType_seached) {
        return  [[UIView alloc] init];
    }
    UIView *view = [[UIView alloc] init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, MOL_SCREEN_WIDTH -15, 20)];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.5);
    lable.font = MOL_MEDIUM_FONT(14);
    lable.text = @"你关注的人";
    [view addSubview:lable];
   return view;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    MOLMsgUserModel *userModel =[MOLMsgUserModel new];
    if (indexPath.row < self.currentDataArray.count) {
        userModel = self.currentDataArray[indexPath.row];
        if (self.selectedBlock) {
            self.selectedBlock(userModel);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MOLCallFriendsViewController" object:nil];
                  [self dismissViewControllerAnimated:YES completion:nil];
            });
          
        }
    }

}

#pragma mark UISearchBarDelegateMethod

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(0 == searchText.length)
    {
        self.currentFriendType = MOLFriendType_focus;
        
        [self.tableView reloadData];
        [self basevc_hiddenErrorView];
        if (!(self.currentDataArray.count>0)) {
             [self basevc_showBlankPageWithY:self.errorH image:@"search_empty" title:nil superView:self.view];
        }
        return ;

    }
    self.currentFriendType = MOLFriendType_seached;
    [self getSearchNetDataWithMore:NO];
//    [self getSearchNetData];
    
}
//点击键盘搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text==nil || [searchBar.text isEqualToString:@""]) {
        return;
    }
    [self getSearchNetDataWithMore:NO];
    [searchBar resignFirstResponder];
}

#pragma mark 懒加载
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, MOL_StatusBarAndNavigationBarHeight,MOL_SCREEN_WIDTH -20, MOL_SCALEHeight(36))];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.barTintColor = [UIColor clearColor];
        [_searchBar setBackgroundImage:[UIImage new]];
        [_searchBar setTranslucent:YES];
        [_searchBar setImage:[UIImage imageNamed:@"search_"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        _searchBar.placeholder = @"请输入要@的好友昵称或ID";
        _searchBar.delegate = self;
        _searchBar.autoresizingMask = UIViewAutoresizingNone;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.showsCancelButton = NO;
        _searchBar.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.2);
        _searchBar.layer.cornerRadius = 3.0f;

    
        for (UIView *view in _searchBar.subviews.lastObject.subviews) {
            if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)view;
                //设置输入框的背景颜色

                textField.backgroundColor = [UIColor clearColor];

                
                //设置输入字体颜色
                textField.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 1);
                textField.font =MOL_REGULAR_FONT(15);
                
                //设置默认文字颜色
                textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户昵称或ID" attributes:@{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xFFFFFF, 0.4),NSFontAttributeName:MOL_REGULAR_FONT(13)}];
            }
        }
    }
    return _searchBar;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.searchBar.frame), MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT-CGRectGetMaxY(self.searchBar.frame)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setBackgroundColor:[UIColor clearColor]];
    }
    return _tableView;
    
    
}
-(NSMutableArray *)currentDataArray{
    
    if (self.currentFriendType == MOLFriendType_seached) {
        return self.searchDataArray;
    }
    return self.focusDataArray;
}

@end
