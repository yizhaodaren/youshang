//
//  MOLSelectMusicViewController.m
//  reward
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLSelectMusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import "MOLSearchMusicResutView.h"
#import "MOLMusicListViewController.h"

@interface MOLSelectMusicViewController ()<SPPageMenuDelegate,JAHorizontalPageViewDelegate,UISearchBarDelegate>

//UI
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong)SPPageMenu  *pageMenu;

@property(nonatomic,strong)UIView  *headerView;
@property (nonatomic, strong) JAHorizontalPageView *pageView;
@property(nonatomic,strong)UIView  *lineView;
@property (nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIButton  *cancelBtn;
@property(nonatomic,strong)UILabel  *titleLabel;
@property(nonatomic,strong)MOLSearchMusicResutView *searchMRView;


@property(nonatomic,strong)MOLMusicListViewController  *musicListVC1;//收藏
@property(nonatomic,strong)MOLMusicListViewController  *musicListVC2;//推荐
@property(nonatomic,strong)MOLMusicListViewController  *musicListVC3;//热门
@property(nonatomic,strong)MOLMusicListViewController  *musicListVC4;//用过
@end

@implementation MOLSelectMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{

    [self.view addSubview:self.bgView];
    //取消
    [self.bgView addSubview:self.cancelBtn];
    [self.bgView addSubview:self.titleLabel];  //标题
    [self.bgView addSubview:self.searchBar];   //搜索bar

    [self.pageView reloadPage];//在page设置之前 好控制当前pageView的控制器的当前位置
    [self.bgView addSubview:self.pageMenu];//分页控制器
    self.pageMenu.bridgeScrollView = (UIScrollView *)_pageView.horizontalCollectionView;

    //lineView
    self.lineView.y = self.pageMenu.bottom + 5;
    [self.bgView addSubview:self.lineView];
    
    //pageView
    self.pageView.y = self.lineView.bottom;
    [self.bgView addSubview:self.pageView];
    
    //搜索结果
    self.searchMRView = [[MOLSearchMusicResutView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, _bgView.width, _bgView.height - self.searchBar.bottom)];
    MJWeakSelf
    self.searchMRView.useMusicBlock = ^(NSURL *musicUrl, MOLMusicModel *music) {
        if (weakSelf.selectedBlock) {
            weakSelf.selectedBlock(musicUrl, music);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}
-(void)showSearchResult:(BOOL)show{
    if (show) {
        _searchBar.showsCancelButton = YES;
        //改变取消按钮颜色
        UIButton *cancleBtn = [_searchBar valueForKey:@"cancelButton"];
        [cancleBtn setTitleColor:HEX_COLOR(0x3C3737) forState:UIControlStateNormal];
        [cancleBtn setTitleColor:HEX_COLOR(0x3C3737) forState:UIControlStateSelected];
        if (@available(iOS 9.0, *)) {
            [cancleBtn setTitleColor:HEX_COLOR(0x3C3737) forState:UIControlStateFocused];
        } else {
            // Fallback on earlier versions
        }
      
        [self.bgView addSubview:self.searchMRView];
        //暂停当前播放的音乐
        [self.musicListVC1 stopMusic];
        [self.musicListVC2 stopMusic];
        [self.musicListVC3 stopMusic];
        [self.musicListVC4 stopMusic];

    }else{
         _searchBar.showsCancelButton = NO;
          [self.searchMRView removeData];
         [self.searchMRView removeFromSuperview];
    }

}

-(void)cancelAction{
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //暂停音乐
        [self.musicListVC1 stopMusic];
        [self.musicListVC2 stopMusic];
        [self.musicListVC3 stopMusic];
        [self.musicListVC4 stopMusic];

    }];
  
}
#pragma mark - delegate
- (NSInteger)numberOfSectionPageView:(JAHorizontalPageView *)view   // 返回几个控制器
{
    return 4;
}
- (UIScrollView *)horizontalPageView:(JAHorizontalPageView *)pageView viewAtIndex:(NSInteger)index   // 返回每个控制器的view
{
    CGFloat dis = MOL_StatusBarHeight + 10 + self.lineView.bottom;
    MJWeakSelf
    if (index == 0) {
        //收藏
        MOLMusicListViewController *vc = [[MOLMusicListViewController alloc] initWithMusicTpey:MOLMusicType_collect TableH:dis];
        _musicListVC1 = vc;
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        vc.selectedBlock = ^{
            
            [self.musicListVC2 stopMusic];
            [self.musicListVC3 stopMusic];
            [self.musicListVC4 stopMusic];
        };
        vc.useMusicBlock = ^(NSURL *musicUrl, MOLMusicModel *music) {
            if (weakSelf.selectedBlock) {
                weakSelf.selectedBlock(musicUrl, music);
            }
             [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        return (UIScrollView *)vc.tableView;
    }else if (index == 1){
        //推荐
       MOLMusicListViewController *vc = [[MOLMusicListViewController alloc] initWithMusicTpey:MOLMusicType_recommend TableH:dis];
     
        _musicListVC2 = vc;
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        vc.selectedBlock = ^{
            [self.musicListVC1 stopMusic];
            [self.musicListVC3 stopMusic];
            [self.musicListVC4 stopMusic];
        };
        vc.useMusicBlock = ^(NSURL *musicUrl, MOLMusicModel *music) {
            if (weakSelf.selectedBlock) {
                weakSelf.selectedBlock(musicUrl, music);
            }
             [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };

        return (UIScrollView *)vc.tableView;
    }else if (index == 2){
        //热门
        MOLMusicListViewController *vc = [[MOLMusicListViewController alloc] initWithMusicTpey:MOLMusicType_hot TableH:dis];
        
        _musicListVC3 = vc;
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        vc.selectedBlock = ^{
            [self.musicListVC1 stopMusic];
            [self.musicListVC2 stopMusic];
            [self.musicListVC4 stopMusic];
        };
        vc.useMusicBlock = ^(NSURL *musicUrl, MOLMusicModel *music) {
            if (weakSelf.selectedBlock) {
                weakSelf.selectedBlock(musicUrl, music);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        
        return (UIScrollView *)vc.tableView;
    }else{
        //用过
       MOLMusicListViewController *vc = [[MOLMusicListViewController alloc] initWithMusicTpey:MOLMusicType_log TableH:dis];
        _musicListVC4 = vc;
        vc.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:vc];
        vc.selectedBlock = ^{
            [self.musicListVC1 stopMusic];
            [self.musicListVC2 stopMusic];
            [self.musicListVC3 stopMusic];
        };
        vc.useMusicBlock = ^(NSURL *musicUrl, MOLMusicModel *music) {
            if (weakSelf.selectedBlock) {
                weakSelf.selectedBlock(musicUrl, music);
            }
             [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };

        return (UIScrollView *)vc.tableView;
    }
}
- (UIView *)headerViewInPageView:(JAHorizontalPageView *)pageView     // 返回头部
{
    return nil;
}
- (CGFloat)headerHeightInPageView:(JAHorizontalPageView *)pageView    // 返回头部高度
{
    return 0;
}
- (CGFloat)topHeightInPageView:(JAHorizontalPageView *)pageView   // 控制在什么地方悬停
{
    return 0;
}
- (void)horizontalPageView:(JAHorizontalPageView *)pageView scrollTopOffset:(CGFloat)offset   // 滚动的偏移量
{

}

#pragma mark SPPageMenu代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
     [_pageView scrollToIndex:toIndex];
    NSLog(@"from:%ld to:%ld",fromIndex,toIndex);
    if (toIndex == 0) {
        //刷新收藏页面
        [_musicListVC1 request_getMusicDataList:NO];
    }
}
#pragma mark UISearchBarDelegateMethod
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self showSearchResult:YES];
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
    
    if (searchBar.text==nil || [searchBar.text isEqualToString:@""]) {
        [self.searchMRView removeData];
        return;
    }
    NSString *searStr  = searchBar.text;
    [self.searchMRView getSearchNetDataWith:searStr];
}
//点击键盘搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text==nil || [searchBar.text isEqualToString:@""]) {
        return;
    }
    NSString *searStr  = searchBar.text;
    [self.searchMRView getSearchNetDataWith:searStr];
    [searchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self showSearchResult:NO];
}

#pragma mark 懒加载
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH, 43) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu = pageMenu;
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.itemTitleFont = MOL_MEDIUM_FONT(15);
        _pageMenu.selectedItemTitleColor = HEX_COLOR(0x3C3737);
        _pageMenu.unSelectedItemTitleColor = HEX_COLOR_ALPHA(0x3C3737, 0.6);
        [_pageMenu setTrackerHeight:2 cornerRadius:0];
        [_pageMenu setTrackerWidth:30.0];
        _pageMenu.tracker.backgroundColor = HEX_COLOR(0xFACE15);
        _pageMenu.needTextColorGradients = NO;
        _pageMenu.dividingLine.hidden = YES;
        _pageMenu.itemPadding = 20;
        _pageMenu.delegate = self;
        [_pageMenu setItems:@[@"收藏",@"推荐",@"热门",@"用过"] selectedItemIndex:1];
        _pageMenu.y = self.searchBar.bottom;
        
    }
    return _pageMenu;
}


-(UIView *)bgView{
    if (!_bgView) {
       _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, MOL_StatusBarHeight + 10, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT - MOL_StatusBarHeight - 10)];
       _bgView.backgroundColor = [UIColor whiteColor];
        //设置切哪个直角
        //    UIRectCornerTopLeft     = 1 << 0,  左上角
        //    UIRectCornerTopRight    = 1 << 1,  右上角
        //    UIRectCornerBottomLeft  = 1 << 2,  左下角
        //    UIRectCornerBottomRight = 1 << 3,  右下角
        //    UIRectCornerAllCorners  = ~0UL     全部角
        //得到view的遮罩路径
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15,15)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _bgView.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }
    return _bgView;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn= [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 50, 30)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        //视频选择
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _titleLabel.text = @"更换音乐";
        _titleLabel.center = CGPointMake(MOL_SCREEN_WIDTH/2, self.cancelBtn.center.y);
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0,self.pageMenu.bottom + 5, _bgView.width, 5)];
        _lineView.backgroundColor = HEX_COLOR(0xF9F9F9);
    }
    return _lineView;
}
-(JAHorizontalPageView *)pageView{
    if (!_pageView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _pageView = [[JAHorizontalPageView alloc] initWithFrame:CGRectMake(0,0, size.width, size.height) delegate:self];
        _pageView.horizontalCollectionView.scrollEnabled = YES;
        //        _pageView.needHeadGestures = YES;
        _pageView.needMiddleRefresh = YES;
        
    }
    return _pageView;
}
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,  20 + 30 + 1,MOL_SCREEN_WIDTH, 44)];
        _searchBar.barTintColor = [UIColor redColor];
        [_searchBar setBackgroundImage:[UIImage new]];
        [_searchBar setTranslucent:YES];
        [_searchBar setImage:[UIImage imageNamed:@"search_music"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        _searchBar.delegate = self;
        _searchBar.autoresizingMask = UIViewAutoresizingNone;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.backgroundColor = [UIColor whiteColor];

     
        for (UIView *view in _searchBar.subviews.lastObject.subviews) {
            if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)view;
                
                //设置输入框的背景颜色
                textField.backgroundColor = HEX_COLOR(0xF4F4F4);
                
                //设置输入字体颜色
                textField.textColor = HEX_COLOR_ALPHA(0x181818, 1);
                textField.font =MOL_REGULAR_FONT(15);
                
                textField.layer.cornerRadius = textField.frame.size.height/2;
                textField.clipsToBounds = YES;
                //设置默认文字颜色
                textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索歌曲名称" attributes:@{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0x9B9B9B, 0.4),NSFontAttributeName:MOL_REGULAR_FONT(14)}];
            }
        }
    }
    return _searchBar;
}

@end
