//
//  HomeShareView.m
//  reward
//
//  Created by xujin on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HomeShareView.h"

static const CGFloat kContentHeight =258.0;
static const NSInteger kMenuCout =5;

@interface HomeShareView()
@property (nonatomic,assign)CGRect rect;
@property (nonatomic,assign)HomeShareViewType currentShareType;
@property (nonatomic,strong)MOLVideoOutsideModel *currentModel;
@end

@implementation HomeShareView
{
    UIView *bgView;
    UIView *contentView;

    UIButton *cancelBtn;
    
    NSArray *iconArr;

}


+ (void)showHomeShareViewIcon:(NSArray *)_iconArr{
    HomeShareView *share =[[HomeShareView alloc] initWithIcon:_iconArr];
    [share show];
}

- (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window setUserInteractionEnabled:YES];
    [window addSubview:bgView];
    
    // ------View出现动画
    contentView.transform = CGAffineTransformMakeTranslation(0.01, kContentHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self-> contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        iconArr =[NSArray new];
        self.currentModel =[MOLVideoOutsideModel new];
    }
    return self;
}

- (instancetype)initWithIcon:(NSArray *)iconArr_
{
    self = [super init];
    if (self) {
        iconArr =[NSArray new];
        iconArr = iconArr_;
        [self contentIcon:iconArr];
        
    }
    return self;
}



//需要分享图标  分享名称
- (void)contentIcon:(NSArray *)_iconArr{
    iconArr = _iconArr;
    
    bgView =[UIView new];
    [bgView setFrame:[[UIScreen mainScreen] bounds]];
    [bgView setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.1)];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundEvent:)];
    [bgView addGestureRecognizer:tap];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window setUserInteractionEnabled:YES];
    [window addSubview:bgView];
    
    contentView =[UIView new];
    
    [contentView setFrame:CGRectMake(0,MOL_SCREEN_HEIGHT-kContentHeight, MOL_SCREEN_WIDTH,kContentHeight)];
    if (self.currentBusinessType == HomeShareViewBusinessRewardType) {
        [contentView setFrame:CGRectMake(0,MOL_SCREEN_HEIGHT-kContentHeight+75, MOL_SCREEN_WIDTH,kContentHeight-75)];
    }
    
    [contentView setBackgroundColor:HEX_COLOR_ALPHA(0x000000,0.0)];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    contentView.layer.mask = maskLayer;
    

    [bgView addSubview:contentView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    //blurEffectView.alpha =0.8;
    blurEffectView.frame = contentView.bounds;
    [contentView addSubview:blurEffectView];
    
    UILabel *titleL =[UILabel new];
    [titleL setText: @"分享到"];
    [titleL setTextAlignment:NSTextAlignmentCenter];
    [titleL setFont:MOL_MEDIUM_FONT(16)];
    [titleL setTextColor:HEX_COLOR(0xffffff)];
    [titleL setFrame:CGRectMake(0, 0, 100, 10*2+22)];
    [titleL setCenterX:contentView.centerX];
    [contentView addSubview:titleL];
    
    cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(contentView.width-17-16,0, 16, 16)];
    [cancelBtn setCenterY: titleL.centerY];
    [cancelBtn setImage:[UIImage imageNamed:@"close_reply"] forState:UIControlStateNormal];
    [cancelBtn setTag:1004];
    [cancelBtn addTarget:self action:@selector(cancelActionEvent) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    
    // ------View出现动画
    contentView.transform = CGAffineTransformMakeTranslation(0.01, kContentHeight);

    [UIView animateWithDuration:0.3 animations:^{

        self-> contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);

    }];
    
    
    
 //   NSLog(@"iconArr.count :%lf",ceil(iconArr.count/5.0));

    //左右间距 21
    //上下间距 25
    //宽高 W * H 50*75
    //顶部 17
    //left = right 20
    
    //列 5  行2
    
    for (int i=0; i<ceil(iconArr.count/5.0); i++) {
        //应该有更好的解决方案
        for (int j=0; j<kMenuCout; j++) {
            // x 20+j*(w+w1)
            // y 17+i*(w+w1)  68 61
            
            if ((kMenuCout*i+j)>=iconArr.count) {
                return;
            }
//            NSLog(@"i:%d --- j:%d",i,j);
            UIButton *iconBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [iconBtn setFrame:CGRectMake(20+j*(50+(MOL_SCREEN_WIDTH-20*2.0-5*50)/4.0),titleL.bottom+17+i*(75+25),50, 75)];

            [iconBtn setImage:[UIImage imageNamed:iconArr[kMenuCout*i+j]] forState:UIControlStateNormal];
            iconBtn.tag =1000+kMenuCout*i+j;
            [iconBtn addTarget:self action:@selector(shareActionEvent:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:iconBtn];
        }
        
    }
    
    

}

-(void)tapBackgroundEvent:(UITapGestureRecognizer *)tap{
    [self cancelActionEvent];
}


- (void)shareActionEvent:(UIButton *)btn{
    if (self.currentBusinessType == HomeShareViewBusinessOneselfRecommendOtherType) {// 自己推荐其它分享
        switch (btn.tag%1000) {
            case 0: //朋友圈
                self.currentShareType =HomeShareViewWechat;
                break;
            case 1: //微信好友
                self.currentShareType =HomeShareViewWeixin;
                break;
            case 2: //QQ空间
                self.currentShareType =HomeShareViewMqMzone;
                break;
            case 3: //QQ
                self.currentShareType =HomeShareViewQQ;
                break;
            case 4: //微博
                self.currentShareType =HomeShareViewSinaweibo;
                break;
            case 5: //删除
                self.currentShareType =HomeShareViewDelete;
                break;
            case 6: //复制链接
                self.currentShareType =HomeShareViewCopyUrl;
                break;
            case 7: //保存本地
                self.currentShareType =HomeShareViewSave;
                break;
            case 8: //合拍
                self.currentShareType =HomeShareViewInTune;
                break;
        }
    }
    else if(self.currentBusinessType == HomeShareViewBusinessOneselfRecommendRewardType){//自己推荐悬赏分享
    
        switch (btn.tag%1000) {
            case 0: //朋友圈
                self.currentShareType =HomeShareViewWechat;
                break;
            case 1: //微信好友
                self.currentShareType =HomeShareViewWeixin;
                break;
            case 2: //QQ空间
                self.currentShareType =HomeShareViewMqMzone;
                break;
            case 3: //QQ
                self.currentShareType =HomeShareViewQQ;
                break;
            case 4: //微博
                self.currentShareType =HomeShareViewSinaweibo;
                break;
            case 5: //复制链接
                self.currentShareType =HomeShareViewCopyUrl;
                break;
            case 6: //保存本地
                self.currentShareType =HomeShareViewSave;
                break;
            case 7: //合拍
                self.currentShareType =HomeShareViewInTune;
                break;
        }
    }
    else if(self.currentBusinessType == HomeShareViewBusinessOtherRecommendType){// 非自己推荐分享
        switch (btn.tag%1000) {
            case 0: //朋友圈
                self.currentShareType =HomeShareViewWechat;
                break;
            case 1: //微信好友
                self.currentShareType =HomeShareViewWeixin;
                break;
            case 2: //QQ空间
                self.currentShareType =HomeShareViewMqMzone;
                break;
            case 3: //QQ
                self.currentShareType =HomeShareViewQQ;
                break;
            case 4: //微博
                self.currentShareType =HomeShareViewSinaweibo;
                break;
            case 5: //举报
                self.currentShareType =HomeShareViewReport;
                break;
            case 6: //复制链接
                self.currentShareType =HomeShareViewCopyUrl;
                break;
            case 7: //保存本地
                self.currentShareType =HomeShareViewSave;
                break;
            case 8: //不感兴趣
                self.currentShareType =HomeShareViewUnLike;
                break;
            case 9: //合拍
                self.currentShareType =HomeShareViewInTune;
                break;
        }
    }
    else if(self.currentBusinessType == HomeShareViewBusinessAttentionType){//关注业务分享
       
        switch ((btn.tag%1000)) {
            case 0: //朋友圈
                self.currentShareType =HomeShareViewWechat;
                break;
            case 1: //微信好友
                self.currentShareType =HomeShareViewWeixin;
                break;
            case 2: //QQ空间
                self.currentShareType =HomeShareViewMqMzone;
                break;
            case 3: //QQ
                self.currentShareType =HomeShareViewQQ;
                break;
            case 4: //微博
                self.currentShareType =HomeShareViewSinaweibo;
                break;
            case 5: //举报
                self.currentShareType =HomeShareViewReport;
                break;
            case 6: //复制链接
                self.currentShareType =HomeShareViewCopyUrl;
                break;
            case 7: //保存本地
                self.currentShareType =HomeShareViewSave;
                break;
            case 8: //合拍
                self.currentShareType =HomeShareViewInTune;
                break;
            
        }
    }
    else{// 悬赏分享
        switch (btn.tag%1000) {
            case 0: //朋友圈
                self.currentShareType =HomeShareViewWechat;
                break;
            case 1: //微信好友
                self.currentShareType =HomeShareViewWeixin;
                break;
            case 2: //QQ空间
                self.currentShareType =HomeShareViewMqMzone;
                break;
            case 3: //QQ
                self.currentShareType =HomeShareViewQQ;
                break;
            case 4: //微博
                self.currentShareType =HomeShareViewSinaweibo;
                break;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(homeShareView: businessType: type:)]) {
        
        [_delegate homeShareView:self.currentModel businessType:self.currentBusinessType type:self.currentShareType];
        self.currentShareType =HomeShareViewCancel;
        [self cancelUI];
    }
}

- (void)cancelActionEvent{
    self.currentShareType =HomeShareViewCancel;
    if (_delegate && [_delegate respondsToSelector:@selector(homeShareView: businessType:type:)]) {
        [self cancelUI];
        [_delegate homeShareView:self.currentModel businessType:self.currentBusinessType type:self.currentShareType];
    }
}

-(void)cancelUI{
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        self->contentView.transform = CGAffineTransformMakeTranslation(0.01, kContentHeight);

    } completion:^(BOOL finished) {
        
        [self->contentView removeFromSuperview];
        [self->bgView removeFromSuperview];
        [wself removeFromSuperview];
        
        
    }];

}

- (void)setDto:(MOLVideoOutsideModel *)dto{
    if (!self.currentModel) {
        self.currentModel =[MOLVideoOutsideModel new];
    }
    self.currentModel =dto;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
