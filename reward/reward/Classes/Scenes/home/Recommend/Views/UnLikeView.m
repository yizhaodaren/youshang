//
//  UnLikeView.m
//  reward
//
//  Created by xujin on 2018/11/2.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "UnLikeView.h"
#import "MOLVideoOutsideModel.h"

@interface UnLikeView()
@property (nonatomic,assign)CGRect rect;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)MOLVideoOutsideModel *currentModel;
@end

@implementation UnLikeView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.currentModel =[MOLVideoOutsideModel new];
    }
    return self;
}

///content
- (void)content:(MOLVideoOutsideModel *)model{
    self.currentModel =model;
    self.bgView =[UIView new];
    [self.bgView setFrame:[[UIScreen mainScreen] bounds]];
    [self.bgView setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.5)];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundEvent:)];
    [self.bgView addGestureRecognizer:tap];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window setUserInteractionEnabled:YES];
    [window addSubview:self.bgView];
    
    
    UIButton *iconBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setImage:[UIImage imageNamed:@"UnInterested"] forState:UIControlStateNormal];
    [iconBtn setFrame:CGRectMake(0, 0, 196/2.0, 266/2.0)];
    [iconBtn setCenter: self.bgView.center];
    [iconBtn addTarget:self action:@selector(unInterestedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:iconBtn];
   
   
    [UIView animateWithDuration:0.3 animations:^{
        
    }];

    
}

- (void)unInterestedEvent:(UIButton *)sender{
     [self cancelUI];
    [OMGToast showWithText:@"将减少此类视频推荐"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLPlayViewControllerLoseInterest" object:self.currentModel];
}

-(void)tapBackgroundEvent:(UITapGestureRecognizer *)tap{
    [self cancelUI];
}


-(void)cancelUI{
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        
      
    } completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        [wself removeFromSuperview];
        
        
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
