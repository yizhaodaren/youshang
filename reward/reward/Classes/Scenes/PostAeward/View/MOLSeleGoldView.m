//
//  MOLSeleGoldView.m
//  reward
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLSeleGoldView.h"
#import "MOLGiftCell.h"
#import "PPNumberButton.h"
#import "ELCVFlowLayout.h"
#import "MOLReleaseRequest.h"
#import "MOLUserPageRequest.h"
#import "MOLWalletViewController.h"
#define TopViewH MOL_SCALEHeight(36)

#define MOL_ppNumber 1  //默认值


@interface MOLSeleGoldView()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,PPNumberButtonDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceArray;//数据源

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UICollectionView *CollectionVeiw;
@property (nonatomic,strong)UIView *bottomGoldView;

@property (nonatomic,strong)PPNumberButton *ppNumberBTN;

@property (nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,strong)MOLGiftModel *currentGift;
@property(nonatomic,assign)NSInteger  currentNumber;

//UI
@property (nonatomic,strong) UIImageView *goldImageView;//钻石石图标
@property (nonatomic,strong) UILabel *goldNumLable;//钻石石数量
@property (nonatomic,strong) UIView *tagBgView;//滑动标
@property (nonatomic,strong) UIView *tagView;//滑动标
@property (nonatomic,strong) UIButton *chargeBtn;//充值按钮

@end
@implementation MOLSeleGoldView
//有导航栏的时候重写这个
- (void)showInView:(UIView *)view {
    [view addSubview:self];
    self.contentView.y = MOL_SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = MOL_SCREEN_HEIGHT - MOL_StatusBarAndNavigationBarHeight - self.contentView.height;
    }completion:^(BOOL finished) {
        
    }];
    
}
-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show{
    self = [super initWithCustomH:height showBottom:show];
    if (self) {
        [self configData];
        [self customUI];
         self.dataSourceArray = [NSMutableArray array];
    }
    return self;
}
-(void)customUI{
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
    [self.customView addSubview:self.topView];
    [self.customView addSubview:self.CollectionVeiw];
    [self.customView addSubview:self.bottomGoldView];
}
-(void)configData{
    self.currentNumber = MOL_ppNumber;//默认值
    [self request_data];
}
#pragma mark - 网络请求
- (void)request_data
{
    MOLReleaseRequest *r = [[MOLReleaseRequest alloc] initRequest_giftListWithParameter:nil];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        // 解析数据
        MOLGiftGroupModel *groupModel = (MOLGiftGroupModel *)responseModel;
        [self.dataSourceArray removeAllObjects];
        // 添加到数据源
        [self.dataSourceArray addObjectsFromArray:groupModel.resBody];
        [self.CollectionVeiw reloadData];
        //[self setOptionData];
    } failure:^(__kindof MOLBaseNetRequest *request) {
        
        
    }];
    
    MOLUserPageRequest *r1 = [[MOLUserPageRequest alloc] initRequest_getTreasureWithParameter:nil];
    [r1 baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {

        MOLTreasureModel *model = (MOLTreasureModel *)responseModel;
        self.goldNum = model.diamondAmount;
        self.goldNumLable.text = [NSString stringWithFormat:@"%.0f",model.diamondAmount];

    } failure:^(__kindof MOLBaseNetRequest *request) {

    }];
}
//数据加载完以后初始化数据默认选择第一个礼物 数量为ppNumber 10;
-(void)setOptionData{
    
    if (self.dataSourceArray.count < 1) {
        return;
    }
    MOLGiftModel *model = self.dataSourceArray[0];
    if ([self.delegate respondsToSelector:@selector(didSelectAt:)]) {
        [self.delegate didSelectAt:model];
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectGiftNumber:)]) {
        [self.delegate didSelectGiftNumber:MOL_ppNumber];
    }
}

#pragma mark collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
     return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

     MOLGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MOLGiftCell" forIndexPath:indexPath];
        // 滤镜
    if (indexPath.row == self.selectIndex) {
        self.currentGift = self.dataSourceArray[self.selectIndex];
        cell.backgroundColor = HEX_COLOR(0xFFEC00);
    }else{
        cell.backgroundColor = [UIColor blackColor];
    }
    
    cell.model = self.dataSourceArray[indexPath.row];
    

    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.selectIndex != indexPath.row) {
        self.ppNumberBTN.currentNumber = MOL_ppNumber;
        self.currentNumber = MOL_ppNumber;
    }
    self.selectIndex = indexPath.row;
    [self.CollectionVeiw reloadData];
     self.currentGift = self.dataSourceArray[self.selectIndex];
    
    
  
//    if ([self.delegate respondsToSelector:@selector(didSelectAt:)]) {
//        [self.delegate didSelectAt:model];
//    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat present = scrollView.contentOffset.x / MOL_SCREEN_WIDTH;
    self.tagView.x = self.tagView.width * present;
    
}
#pragma mark ppnumber 代理方法
- (void)pp_numberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus{
    
    self.currentNumber = number;
//    if ([self.delegate respondsToSelector:@selector(didSelectGiftNumber:)]) {
//        [self.delegate didSelectGiftNumber:number];
//    }
}
#pragma mark 充值
-(void)chargeBtnAction{
    if ([self.delegate respondsToSelector:@selector(didSelectAddGold)]) {
        [self.delegate didSelectAddGold];
    }
}


-(void)sureBtnAction{

    float money = self.currentGift.price * self.currentNumber - self.goldNum;
    if (money > 0) {
        NSString *Str = [NSString stringWithFormat:@"您的钻石石余额不足,需充值%.0f钻石石",money];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:Str preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"立即充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MOLWalletViewController *vc = [[MOLWalletViewController alloc] init];
             [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
        }]];
        [[CommUtls topViewController] presentViewController:alert animated:YES completion:nil];
      
    }else if ([self.delegate respondsToSelector:@selector(didSetGift:WithGiftNum:)] && self.currentGift) {
        [self.delegate didSetGift:self.currentGift WithGiftNum:self.currentNumber];
          [self dismissView];
    }else{
        [self dismissView];
    }
  
}
#pragma mark 懒加载
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width,TopViewH)];
       
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(_topView.width/2 - 30, 0, _topView.width/2 + 30, _topView.height)];
        imageV.image = [UIImage imageNamed:@"pw_Group 4"];
        [_topView addSubview:imageV];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(_topView.width/2, 0, 40, _topView.height)];
        lable.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
        lable.text = @"数量";
        lable.font  = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentCenter;
        [_topView addSubview:lable];
        
        [_topView addSubview:self.ppNumberBTN];
    }
return _topView;
}
- (UICollectionView *)CollectionVeiw {
    if (!_CollectionVeiw) {
        
        
        CGFloat w = MOL_SCREEN_WIDTH/4;
        CGFloat h = w/93.7*111;
        
        ELCVFlowLayout *layout = [[ELCVFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(w, h);

        _CollectionVeiw = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) , MOL_SCREEN_WIDTH, layout.itemSize.height * 2) collectionViewLayout:layout];
        _CollectionVeiw.backgroundColor = [UIColor blackColor];
        _CollectionVeiw.showsHorizontalScrollIndicator = NO;
        _CollectionVeiw.showsVerticalScrollIndicator = NO;
        _CollectionVeiw.pagingEnabled = YES;
        [_CollectionVeiw setExclusiveTouch:YES];
        
        [_CollectionVeiw registerClass:[MOLGiftCell class] forCellWithReuseIdentifier:@"MOLGiftCell"];
    

        _CollectionVeiw.delegate = self;
        _CollectionVeiw.dataSource = self;
    }
    return _CollectionVeiw;
}
-(UIView *)bottomGoldView{
    if (!_bottomGoldView) {
        _bottomGoldView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.CollectionVeiw.frame), self.width, MOL_SCALEHeight(50))];
        _bottomGoldView.backgroundColor =[UIColor blackColor];
        
        [_bottomGoldView addSubview:self.chargeBtn];
        [_bottomGoldView addSubview:self.goldImageView];
        [_bottomGoldView addSubview:self.goldNumLable];
        [_bottomGoldView addSubview:self.tagBgView];

        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(_bottomGoldView.width - 50 - 25, 0, 40, 25)];
        sureBtn.centerY = _bottomGoldView.height /2;
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [sureBtn setTitleColor:HEX_COLOR(0xFE6257) forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomGoldView addSubview:sureBtn];
        
    }
    return _bottomGoldView;
}
-(PPNumberButton *)ppNumberBTN{
    if (!_ppNumberBTN) {
        _ppNumberBTN = [[PPNumberButton alloc] initWithFrame:CGRectMake(self.width/2 + 40, 0, self.width/2 - 50, MOL_SCALEHeight(25))];
        _ppNumberBTN.backgroundColor = [UIColor clearColor];
        _ppNumberBTN.centerY = _topView.height/2;
        _ppNumberBTN.minValue = 1;
        _ppNumberBTN.currentNumber = MOL_ppNumber;
        _ppNumberBTN.increaseImage = [UIImage imageNamed:@"pw_add"];
        _ppNumberBTN.decreaseImage = [UIImage imageNamed:@"pw_reduction of"];
        _ppNumberBTN.delegate = self;
    }
    return _ppNumberBTN;
}

-(UIButton *)chargeBtn{
    if (!_chargeBtn) {
        _chargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _chargeBtn.centerY = _bottomGoldView.height /2;
        _chargeBtn.centerX = _bottomGoldView.width /4 + 30;
        
        [_chargeBtn setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateNormal];
        [_chargeBtn setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateHighlighted];
        [_chargeBtn setTitle:@"充值" forState:UIControlStateNormal];
         _chargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_chargeBtn setTitleColor:HEX_COLOR(0xFE6257) forState:UIControlStateNormal];
        
        [_chargeBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:0];
        [_chargeBtn addTarget:self action:@selector(chargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chargeBtn;
}
-(UIImageView *)goldImageView{
    if (!_goldImageView) {
        _goldImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, MOL_SCALEHeight(18), MOL_SCALEWidth(14))];
        _goldImageView.centerY = self.bottomGoldView.height/2;
        _goldImageView.image = [UIImage imageNamed:@"withdraw_diamond_small"];
    }
    return _goldImageView;
}

-(UILabel *)goldNumLable{
    if (!_goldNumLable) {
        _goldNumLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goldImageView.frame), 0, self.chargeBtn.frame.origin.x - CGRectGetMaxX(self.goldImageView.frame), 20)];
        _goldNumLable.x = CGRectGetMaxX(self.goldImageView.frame);
//        _goldNumLable.height = 20;
//        _goldNumLable.width = 100;
        _goldNumLable.centerY = self.bottomGoldView.height/2;
        _goldNumLable.text = @"0";
        _goldNumLable.textColor = HEX_COLOR(0xFFFEC00);
        _goldNumLable.font = MOL_FONT(14);
        
        
//        UILabel *textLabel = [[UILabel alloc] init];
//        4     textLabel.font = [UIFont systemFontOfSize:16];
//        5     NSString *str = @"222222222222222222222222222222222222222222";
//        6     textLabel.text = str;
//        7     textLabel.backgroundColor = [UIColor redColor];
//        8     textLabel.numberOfLines = 0;//根据最大行数需求来设置
//        9     textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        10     CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
//        11     //关键语句
//        12     CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
//        13     //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
//        14     textLabel.frame = CGRectMake(20, 70, expectSize.width, expectSize.height);

    }
    return _goldNumLable;
}
-(UIView *)tagBgView{
    if (!_tagBgView) {
        _tagBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCALEWidth(18), MOL_SCALEHeight(2))];
        _tagBgView.backgroundColor = HEX_COLOR(0x5C5C5C);
        _tagBgView.centerY = self.bottomGoldView.height/2;
        _tagBgView.centerX = self.bottomGoldView.width/2;
       [_tagBgView addSubview:self.tagView];
    }
    return _tagBgView;
}
-(UIView *)tagView{
    if (!_tagView) {
        _tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCALEWidth(18)/2, MOL_SCALEHeight(2))];
        _tagView.backgroundColor = HEX_COLOR(0xFFFFFF);
    }
    return _tagView;
}

@end
