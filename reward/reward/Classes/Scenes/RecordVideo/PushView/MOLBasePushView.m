//
//  MOLBasePushView.m
//  reward
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLBasePushView.h"

#define BottomViewHeight  50.0f

@interface MOLBasePushView()
@property (strong,nonatomic)UIImageView *backImageView;
@property (strong,nonatomic)UIView *bottomView;
//bottom
@property (nonatomic, strong) UILabel *bottomTitleLable; // 底部标题
@property (nonatomic, strong) UIButton *closeButton; // 关闭按钮
@property (nonatomic, strong) UIButton *endButton; // 选择结束



@property (assign,nonatomic)BOOL showBottomView;//默认为NO
@property (assign,nonatomic)CGFloat customViewHeight;//自定义View的高度

@property(nonatomic,assign) BOOL keyBoardlsVisible;


@end
@implementation MOLBasePushView

-(instancetype)initWithCustomH:(CGFloat)height showBottom:(BOOL)show{
    self = [super initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
    if (self) {
        self.customViewHeight = height;
        self.showBottomView = show;
        [self configData];
        [self initUI];
        [self addPanGesture];
    }
    return self;
}
-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
    if (self) {
        [self configData];
        [self initUI];
        [self addPanGesture];
    }
    return self;
}
-(void)configData{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
}
//  键盘弹出触发该方法
- (void)keyboardDidShow
{
    
    _keyBoardlsVisible =YES;
}
//  键盘隐藏触发该方法
- (void)keyboardDidHide
{
    
    _keyBoardlsVisible =NO;
}


-(void)initUI{
    [self addSubview:self.backImageView];
    [self addSubview:self.contentView];
    
    if (_showBottomView) {
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.bottomTitleLable];
        [self.bottomView addSubview:self.closeButton];
        [self.bottomView addSubview:self.endButton];
    }
    [self.contentView addSubview:self.customView];
    
}
-(void)addPanGesture{
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack:)];
    [self.backImageView  addGestureRecognizer:tap];
}

- (void)tapBack:(UITapGestureRecognizer *)tap {
    if (_keyBoardlsVisible) {
        [self endEditing:YES];
    }else{
         [self dismissView];
    }
}
-(void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = MOL_SCREEN_HEIGHT ;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}
- (void)showInView:(UIView *)view {
    [view addSubview:self];
    self.contentView.y = MOL_SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = MOL_SCREEN_HEIGHT - self.contentView.height;
    }completion:^(BOOL finished) {
        
    }];
    
}
-(CGFloat)getContentHeight{
    return  _showBottomView ? (BottomViewHeight + self.customViewHeight + MOL_TabbarSafeBottomMargin) : (self.customViewHeight + MOL_TabbarSafeBottomMargin);
}
-(void)setBottomViewTitle:(NSString *)title{
    self.bottomTitleLable.text = title;
}


#pragma mark 懒加载
- (UIImageView *)backImageView {
    if(!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithFrame:self.frame];
        _backImageView.backgroundColor  = [UIColor clearColor];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}
- (UIView *)contentView{
    if(!_contentView) {
        _contentView  = [[UIView alloc]initWithFrame:CGRectMake(0, MOL_SCREEN_HEIGHT-[self getContentHeight], MOL_SCREEN_WIDTH, [self getContentHeight])];
        _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    }
    return _contentView;
}
-(UIView *)customView{
    if (!_customView) {
        _customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, self.customViewHeight)];
    }
    return _customView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.customViewHeight, MOL_SCREEN_WIDTH, BottomViewHeight)]; 
        
    }
    return _bottomView;
}

-(UILabel *)bottomTitleLable{
    if (!_bottomTitleLable) {
        _bottomTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bottomView.width - (20 + 40)*2, BottomViewHeight)];
        _bottomTitleLable.center = CGPointMake(MOL_SCREEN_WIDTH / 2, BottomViewHeight /2);
        _bottomTitleLable.text = @"标题";
        _bottomTitleLable.font = [UIFont systemFontOfSize:17];
        _bottomTitleLable.textColor = [UIColor whiteColor];
        _bottomTitleLable.textAlignment = NSTextAlignmentCenter;

        
    }
    return _bottomTitleLable;
}
-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton  = [[UIButton alloc] initWithFrame: CGRectMake(20, 0, 40, 40)];
        _closeButton.centerY = self.bottomTitleLable.centerY;
        [_closeButton setImage:[UIImage imageNamed:@"rc_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
   
    }
    return _closeButton;
}
-(UIButton *)endButton{
    if (!_endButton) {
        _endButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.width - 20 -40, 0, 40, 40)];
        _endButton.centerY = self.bottomTitleLable.centerY;
        [_endButton setImage:[UIImage imageNamed:@"rc_confirm"] forState:UIControlStateNormal];
        [_endButton  addTarget:self action:@selector(endButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        

    }
    return _endButton;
}
#pragma mark 关闭事件
-(void)closeButtonAction{
    [self dismissView];
    if (self.closeBlock) {
        self.closeBlock();
    }
}
#pragma mark 结束事件
-(void)endButtonAction{
    [self dismissView];
    if (self.endBlock) {
        self.endBlock();
    }
}
@end
