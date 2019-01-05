//
//  SearchViewController.m
//  reward
//
//  Created by xujin on 2018/9/12.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "SearchViewController.h"
#import "MOLUserRelationCell.h"
#import "HomePageRequest.h"
#import "MOLAttentionUsersModel.h"
#import "MOLUserModel.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
#import "MOLMsgUserModel.h"
#import "MOLMsgUserGroupModel.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *sourceArr;
@property (nonatomic,strong)NSMutableArray *recommendArr;
@property (nonatomic,strong)UIButton *cancleButton;
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong)UITableView *searchTalble;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,assign)UIBehaviorTypeStyle refreshType;
@property (nonatomic,strong)UIImageView *emptyImgView;
@property (nonatomic,assign)BOOL isSerchEd; //yes 表示已经搜索🔍 no表示为发生搜索🔍
@end

@implementation SearchViewController

- (BOOL)showNavigation{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseData];
    [self layoutNavigation];
    [self layoutUI];
    [self getAttentionUsersNetworkData];
}

- (void)initBaseData{
    self.sourceArr =[NSMutableArray new];
    self.recommendArr =[NSMutableArray new];
    self.isSerchEd =NO;
    [self initData];
}

- (void)initData{
    self.refreshType = UIBehaviorTypeStyle_Normal;
    self.pageNumber =20;
    self.pageIndex =1;
}

- (void)layoutNavigation{
    //self.showNavigation =NO;

}

- (void)layoutUI{
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.cancleButton];
    __weak __typeof(self) weakSelf = self;
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.searchBar.mas_right);
        make.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(MOL_StatusBarHeight);
        make.height.mas_equalTo(44);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [self.view addSubview:bottomLine];
    
    
    bottomLine.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);

    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.searchBar.mas_bottom).offset(5);
        make.height.mas_equalTo(1.0);
    }];
    [self.view addSubview:self.searchTalble];
    
    [self.searchTalble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(bottomLine.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-MOL_TabbarSafeBottomMargin);
    }];
    
    [self.view addSubview:self.emptyImgView];

}

- (UIImageView *)emptyImgView{
    if (!_emptyImgView) {
        _emptyImgView =[UIImageView new];
        [_emptyImgView setImage: [UIImage imageNamed:@"search_empty"]];
        [_emptyImgView setFrame:CGRectMake((MOL_SCREEN_WIDTH-308/2.0)/2.0,self.searchBar.bottom+60, 308/2.0, 188/2.0)];
        [_emptyImgView setAlpha:0];
    }
    return _emptyImgView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, MOL_StatusBarHeight,MOL_SCREEN_WIDTH-13-32, 44)];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.barTintColor = [UIColor clearColor];
        [_searchBar setBackgroundImage:[UIImage new]];
        [_searchBar setTranslucent:YES];
        [_searchBar setImage:[UIImage imageNamed:@"search_"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        _searchBar.placeholder = @"请输入用户昵称或ID";
        _searchBar.delegate = self;
        _searchBar.autoresizingMask = UIViewAutoresizingNone;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.showsCancelButton = NO;
        
        
        
        for (UIView *view in _searchBar.subviews.lastObject.subviews) {
            if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)view;
                //设置输入框的背景颜色
                textField.clipsToBounds = YES;
                textField.backgroundColor = HEX_COLOR(0x3A3A44);
                
                //设置输入框边框的圆角以及颜色
                textField.layer.cornerRadius = 15.0f;
                textField.layer.borderColor = HEX_COLOR(0x3A3A44).CGColor;
                textField.layer.borderWidth = 1;
                
                //设置输入字体颜色
                textField.textColor = HEX_COLOR(0xE6E7EC);
                textField.font =MOL_REGULAR_FONT(13);
                
                //设置默认文字颜色
                textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户昵称或ID" attributes:@{NSForegroundColorAttributeName:HEX_COLOR(0xE6E7EC),NSFontAttributeName:MOL_REGULAR_FONT(13)}];
            }
        }
           
        //[self.view addSubview:_searchBar];
    }
    return _searchBar;
}

-(UIButton *)cancleButton{
    
    if (!_cancleButton) {
        _cancleButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
        [_cancleButton.titleLabel setFont:MOL_REGULAR_FONT(16)];
        [_cancleButton addTarget:self action:@selector(cancleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_cancleButton setBackgroundColor:[UIColor clearColor]];
    }
    
    return _cancleButton;
    
}

-(UITableView *)searchTalble{
    
    if (!_searchTalble) {
        _searchTalble = [[UITableView alloc]initWithFrame:CGRectMake(0,64, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _searchTalble.delegate = self;
        _searchTalble.dataSource = self;
        _searchTalble.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTalble.estimatedRowHeight = 0;
        _searchTalble.estimatedSectionHeaderHeight = 0;
        _searchTalble.estimatedSectionFooterHeight = 0;
        [_searchTalble setBackgroundColor:[UIColor clearColor]];
    }
    return _searchTalble;
    
    
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * const searchCellID = @"searchCell";
    MOLUserRelationCell *searchCell =[tableView dequeueReusableCellWithIdentifier:searchCellID];
    if (!searchCell) {
        
        searchCell =[[MOLUserRelationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellID];
        searchCell.selectionStyle= UITableViewCellSelectionStyleNone;
        
    }
    
    MOLMsgUserModel *model =[MOLMsgUserModel new];
    
    if (indexPath.row<self.sourceArr.count) {
        model =self.sourceArr[indexPath.row];
    }
    searchCell.userModel =model;
    
    return searchCell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89+1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}


#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        MOLMsgUserModel *userDto =[MOLMsgUserModel new];
        if (indexPath.row < self.sourceArr.count) {
            userDto = self.sourceArr[indexPath.row];
        }
        
        if ([[MOLGlobalManager shareGlobalManager] isUserself:userDto.userVO]) {
            MOLMineViewController *mineView =[MOLMineViewController new];
            [self.navigationController pushViewController:mineView animated:YES];
        }else{
            MOLOtherUserViewController *otherView =[MOLOtherUserViewController new];
            otherView.userId = userDto.userVO.userId?userDto.userVO.userId:@"";
            [self.navigationController pushViewController:otherView animated:YES];
            
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
    self.isSerchEd =YES;
    
    if(0 == searchText.length)
    {
        [self.sourceArr removeAllObjects];
        [self.searchTalble reloadData];
        [self emptyDataShow];
        return ;
        
    }
    [self initData];
    [self getSearchNetData];
    
    
    
}
//点击键盘搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text==nil || [searchBar.text isEqualToString:@""]) {
        return;
    }
    
    [self getSearchNetData];
    [self viewResignFirstResbonder];
}

- (void)viewResignFirstResbonder
{
    [_searchBar resignFirstResponder];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self viewResignFirstResbonder];
}

/*
 * 收起键盘
 */
-(void)handlePan:(UIPanGestureRecognizer*)recognizer {
    [self viewResignFirstResbonder];
}

#pragma mark-
#pragma mark 获取网络数据

- (void)getNetworkType{
    if (self.isSerchEd) {
        [self getSearchNetData];
    }else{
        [self getAttentionUsersNetworkData];
    }
}

- (void)refresh{
    self.pageIndex =1;
    self.refreshType =UIBehaviorTypeStyle_Refresh;
    self.sourceArr =[NSMutableArray new];
    [self getNetworkType];
};

- (void)loadMore{
    self.pageIndex++;
    self.refreshType =UIBehaviorTypeStyle_More;
    [self getNetworkType];
}
- (void)getSearchNetData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.pageIndex);
    dic[@"pageSize"] = @(self.pageNumber);
    dic[@"type"] = @"user";
    dic[@"content"] =self.searchBar.text?self.searchBar.text:@"";
    
    __weak typeof(self) wself = self;
    
    [[[HomePageRequest alloc] initRequest_SearchParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.searchTalble.mj_header endRefreshing];
            [wself.searchTalble.mj_footer endRefreshing];
        }
        
        if (code == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                // 解析数据
                MOLMsgUserGroupModel *groupModel = (MOLMsgUserGroupModel *)responseModel;
                
                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.sourceArr removeAllObjects];
                }
                
                // 添加到数据源
                [wself.sourceArr addObjectsFromArray:groupModel.resBody];
                
                [wself.searchTalble reloadData];
              
                
            }
            
        }else{
            [OMGToast showWithText:message];
        }
        
        [wself emptyDataShow];
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.searchTalble.mj_header endRefreshing];
            [wself.searchTalble.mj_footer endRefreshing];
        }
        
        [wself emptyDataShow];
        
    }];
}


- (void)getAttentionUsersNetworkData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pageNum"] = @(self.pageIndex);
    dic[@"pageSize"] = @(self.pageNumber);
    __weak typeof(self) wself = self;
    [[[HomePageRequest alloc] initRequest_SearchRecommendUsersParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.searchTalble.mj_header endRefreshing];
            [wself.searchTalble.mj_footer endRefreshing];
        }
        
        if (code == MOL_SUCCESS_REQUEST) {
            if (responseModel) {
                // 解析数据
                MOLMsgUserGroupModel *groupModel = (MOLMsgUserGroupModel *)responseModel;
                
                if (wself.refreshType != UIBehaviorTypeStyle_More) {
                    [wself.sourceArr removeAllObjects];
                }
                
                // 添加到数据源
                [wself.sourceArr addObjectsFromArray:groupModel.resBody];
                [wself.searchTalble reloadData];
            
            }
        }else{
            
        }
        
        [wself emptyDataShow];
        
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.searchTalble.mj_header endRefreshing];
            [wself.searchTalble.mj_footer endRefreshing];
        }
        
        [wself emptyDataShow];
        
    }];
}

/// 搜索🔍空数据显示
- (void)emptyDataShow{
    if (self.sourceArr.count<=0) { //表示无数据
        [self.emptyImgView setAlpha:1];
    }else{
        [self.emptyImgView setAlpha:0];
    }
}


- (void)cancleButtonEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
