//
//  MOLBeautifyView.m
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBeautifyView.h"
#import "MOLFilterGroup.h"
#import "MOLFilterCell.h"
#import "MOLExfoliatingCell.h"
#define BottomViewHeight  160.f
@interface MOLBeautifyView()<SPPageMenuDelegate,UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic,strong) SPPageMenu *pageMenu;

@property(nonatomic,assign) MolBeautifyType currentBeautifyType;
//滤镜
@property(nonatomic,strong) UICollectionView *editVideoCollectionView;// 展示所有滤镜的集合视图
@property(nonatomic,strong) MOLFilterGroup *filterGroup;// 所有滤镜
@property(nonatomic,strong) NSMutableArray<NSDictionary *> *filtersArray;
@property(nonatomic,assign)NSInteger filterSelIndex;


//磨皮
@property(nonatomic,strong) NSMutableArray* ExfoliatingArray;


@end
@implementation MOLBeautifyView

-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show{
   self =  [super initWithCustomH:height showBottom:show];
    if (self) {
        [self configDataWith:nil];
        [self customUI];
    }
    return self;
}
//用自定义的封面图
-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show withfilterImage:(UIImage *)image{
    self = [super initWithCustomH:height showBottom:show];
    if (self) {
        [self configDataWith:image];
        [self customUI];
    }
    return self;
}

-(void)customUI{

    [self.customView addSubview:self.pageMenu];
    [self.customView addSubview:self.editVideoCollectionView];
}
-(void)configDataWith:(UIImage *)image{
    // 加载滤镜资源
    self.filtersArray = [[NSMutableArray alloc] init];
    if (MOL_isClipFilerImage) {
         self.filterGroup = [[MOLFilterGroup alloc] initWithImage:image];
       //self.filterGroup = [[MOLFilterGroup alloc] initWithImage:[UIImage imageNamed:@"discover_selecte"]];
    }else{
         self.filterGroup = [[MOLFilterGroup alloc] init];
    }
   
    for (NSDictionary *filterInfoDic in self.filterGroup.filtersInfo) {
        NSString *name = [filterInfoDic objectForKey:@"name"];
        NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
        NSString *coverImage = [filterInfoDic objectForKey:@"coverImage"];
        NSDictionary *dic = @{
                              @"name"            : name,
                              @"coverImagePath"  : coverImagePath,
                              @"coverImage"      : coverImage
                              };
        
        [self.filtersArray addObject:dic];
    }
    
    
  
    
    //磨皮等级
    self.ExfoliatingArray = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5", nil];
    
    //默认类型为滤镜
    self.currentBeautifyType = MolBeautifyfiletType;
}
-(void)setOptionFilter{
    self.filterGroup.filterIndex = MOL_DefaultFilter;
    _filterSelIndex = MOL_DefaultFilter;
//    [self.editVideoCollectionView reloadData];
    if (self.filterConfirmBlock) {
        self.filterConfirmBlock(self.filterGroup.currentFilter);
    }
}
-(void)hidePageView{
    self.pageMenu.height = 0;
    self.pageMenu.hidden = YES;
    
    CGRect rect =  self.editVideoCollectionView.frame;
    rect.origin.y = 0 ;
    self.editVideoCollectionView.frame = rect;
    [self layoutIfNeeded];
}

#pragma mark SPPageMenuDelegate
-(void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    self.currentBeautifyType = toIndex;
    [self.editVideoCollectionView reloadData];
    
    
}
#pragma mark collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.currentBeautifyType == MolBeautifyfiletType) {
        return self.filtersArray.count;
    }
    return self.ExfoliatingArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    MOLEditVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MOLEditVideoCell class]) forIndexPath:indexPath];
    UICollectionViewCell *lastCell;
    if (self.currentBeautifyType == MolBeautifyfiletType) {
     MOLFilterCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"MOLFilterCell" forIndexPath:indexPath];
         // 滤镜
        NSDictionary *filterInfoDic = self.filtersArray[indexPath.row];
        NSString *name = [filterInfoDic objectForKey:@"name"];
        NSString *coverImagePath = [filterInfoDic objectForKey:@"coverImagePath"];
         UIImage *coverImage = [filterInfoDic objectForKey:@"coverImage"];
        cell.titleLbale.text = name;
        cell.imageView.image = [UIImage imageWithContentsOfFile:coverImagePath];
        if ([self checkNSNullType:coverImage]) {
            cell.imageView.image = coverImage;
        }
        
        if (indexPath.row == _filterSelIndex) {
            cell.isSelected = YES;
        }else{
             cell.isSelected = NO;
        }
        lastCell = cell;
    }else{
          MOLExfoliatingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MOLExfoliatingCell" forIndexPath:indexPath];
          cell.titleLable.text  = self.ExfoliatingArray[indexPath.row];
        if (indexPath.row == _exfoliatingSelIndex) {
            cell.isSelected = YES;
        }else{
            cell.isSelected = NO;
        }
      lastCell = cell;
    }
    return  lastCell;
}
//类型识别:将 NSNull类型转化成 nil
- (id)checkNSNullType:(id)object {
    if([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    else {
        return object;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
        NSInteger index  = indexPath.row;
    if (_currentBeautifyType == MolBeautifyfiletType) {
        if (_filterSelIndex == index) {
            return;
        }
        self.filterGroup.filterIndex = index;
        _filterSelIndex = index;
        if (self.filterConfirmBlock) {
            self.filterConfirmBlock(self.filterGroup.currentFilter);
        }
        
    }else if (_currentBeautifyType == MolBeautifyExfoliatingType){
        if (_exfoliatingSelIndex == index) {
            return;
        }
        _exfoliatingSelIndex = index;
        if (self.BeautifyConfirmBlock) {
            if (index ==0) {
                self.BeautifyConfirmBlock(0.0);
            }else{
                self.BeautifyConfirmBlock(index/5.0f);
            }
        }
    }
    [_editVideoCollectionView reloadData];
}


#pragma mark 懒加载
- (UICollectionView *)editVideoCollectionView {
    if (!_editVideoCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(65, 100);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _editVideoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageMenu.frame) , MOL_SCREEN_WIDTH, layout.itemSize.height) collectionViewLayout:layout];
        _editVideoCollectionView.backgroundColor = [UIColor clearColor];
        _editVideoCollectionView.showsHorizontalScrollIndicator = NO;
        _editVideoCollectionView.showsVerticalScrollIndicator = NO;
        [_editVideoCollectionView setExclusiveTouch:YES];
        
        
        [_editVideoCollectionView registerNib:[UINib nibWithNibName:@"MOLFilterCell" bundle:nil] forCellWithReuseIdentifier:@"MOLFilterCell"];
        [_editVideoCollectionView registerNib:[UINib nibWithNibName:@"MOLExfoliatingCell" bundle:nil] forCellWithReuseIdentifier:@"MOLExfoliatingCell"];
        _editVideoCollectionView.delegate = self;
        _editVideoCollectionView.dataSource = self;
    }
    return _editVideoCollectionView;
}

-(SPPageMenu *)pageMenu{
    
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH, 43) trackerStyle:SPPageMenuTrackerStyleRect];
        _pageMenu.backgroundColor = [UIColor clearColor];//HEX_COLOR(0x0E0F1A);
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.itemTitleFont = MOL_MEDIUM_FONT(16);
        _pageMenu.selectedItemTitleColor = HEX_COLOR(0xffffff);
        _pageMenu.unSelectedItemTitleColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
        [_pageMenu setTrackerHeight:3 cornerRadius:0];
        _pageMenu.tracker.backgroundColor =[UIColor clearColor]; //HEX_COLOR(0xFFEC00);
        _pageMenu.needTextColorGradients = NO;
        _pageMenu.dividingLine.hidden = YES;
        _pageMenu.itemPadding = 20;
        _pageMenu.delegate = self;
        [_pageMenu setItems:@[@"滤镜",@"磨皮"] selectedItemIndex:0];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,1, _pageMenu.height/2)];
        lineView.backgroundColor = HEX_COLOR(0xFFFFFF);
        lineView.center = _pageMenu.center;
        [_pageMenu addSubview:lineView];
    }
    return _pageMenu;
}
@end
