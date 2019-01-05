//
//  AlbumShowView.m
//  aletter
//
//  Created by xiaolong li on 2018/8/16.
//  Copyright © 2018年 aletter-2018. All rights reserved.
//

#import "AlbumShowView.h"
#import "AlbumCell.h"
#import "TZAssetModel.h"

@interface AlbumShowView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGRect _frame;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *bgView;


@end

@implementation AlbumShowView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor: [UIColor whiteColor]];
         self.dataArr =[NSMutableArray new];
        _frame =frame;
    }
    return self;
}

-(void)setShowTableCell:(NSMutableArray *)dataArr{
    self.dataArr =dataArr;
    [self initUI:_frame];
 
}

- (void)initUI:(CGRect)frame{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.bgView =[UIView new];
    [self.bgView setFrame:CGRectMake(0, 44+MOL_StatusBarHeight,MOL_SCREEN_WIDTH,MOL_SCREEN_HEIGHT-64)];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self.bgView];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
      weakSelf.bgView.backgroundColor =HEX_COLOR_ALPHA(0x000000, 0.2);
    }];
    
    //[bgView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEvent:)];
    [self.bgView addGestureRecognizer:tap];
    
    CGFloat height =self.dataArr.count*(56+20);
    if (self.dataArr.count*(56+20)>MOL_SCREEN_HEIGHT-64-128) {
        height =MOL_SCREEN_HEIGHT-64-128;
    }
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,height) style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    [self addSubview:self.tableView];
  
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const cellID =@"AlbumCell";
    AlbumCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell =[[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone; //显示最右边的箭头
    }

    
    TZAlbumModel *model =[TZAlbumModel new];
    if (self.dataArr.count>indexPath.row) {
        model =self.dataArr[indexPath.row];
    }
    
    [cell setAlbumCellViewContentBy:model indexPath:indexPath];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56+20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, 20)];
    [headerView setBackgroundColor: [UIColor whiteColor]];
    return headerView;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TZAlbumModel *model =[TZAlbumModel new];
    if (self.dataArr.count>indexPath.row) {
        model =self.dataArr[indexPath.row];
        self.selectRowBlock(indexPath, model);
    }
    
}


-(void)cancelEvent:(UITapGestureRecognizer *)tap{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlbumShowView" object:nil userInfo:nil];
    [self cancelView];
    
}

-(void)cancelView{
    
    [UIView animateWithDuration:0.1 animations:^{
        self.bgView.backgroundColor = [UIColor clearColor];
        self.backgroundColor =[UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.tableView removeFromSuperview];
            [self.bgView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
    
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
