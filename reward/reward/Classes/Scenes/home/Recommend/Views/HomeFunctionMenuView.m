//
//  HomeFunctionMenuView.m
//  reward
//
//  Created by xujin on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HomeFunctionMenuView.h"
#import "MOLVideoOutsideModel.h"
#import "MOLVideoModel.h"
#import "MOLExamineCardModel.h"
#import "STSystemHelper.h"
#import "MOLUserManager.h"

@interface HomeFunctionMenuView()
@property (nonatomic,strong) MOLVideoOutsideModel*currentModel;
@property (nonatomic,assign)HomeFunctionMenuViewType currentFunctionType;
@property (nonatomic,assign)CGRect rect;
@property (nonatomic,strong)NSMutableArray *imageArr;
@property (nonatomic,weak)UILabel *praiseLable;
@property (nonatomic,weak)UIButton *focusButton;
@property (nonatomic,weak)UILabel *commentLable;
@property (nonatomic,weak)UILabel *shareLable;
@property (nonatomic, strong) MOLVideoModel *storyVO;  //作品模型
@property (nonatomic, strong) MOLExamineCardModel *rewardVO; //悬赏模型
@property (nonatomic,assign) NSInteger favorC;


@end

@implementation HomeFunctionMenuView
- (void)initData{
    NSArray *imgArr =@[@"video_praise",@"video_comment",@"video_share"];
    self.imageArr =[NSMutableArray arrayWithArray:imgArr];
    self.currentModel =[MOLVideoOutsideModel new];
    self.storyVO =[MOLVideoModel new];
    self.rewardVO =[MOLExamineCardModel new];
    self.favorC =0;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rect =frame;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.rect =frame;
    [self initData];
}

- (void)content:(MOLVideoOutsideModel *)model{

    if (model) {
        self.currentModel =[MOLVideoOutsideModel new];
        self.currentModel =model;
        if (model.contentType ==1) { //悬赏
            self.rewardVO =model.rewardVO;
            self.favorC =self.rewardVO.favorCount;
            [self.imageArr insertObject:self.rewardVO.userVO.avatar?self.rewardVO.userVO.avatar:@"" atIndex:0];
        }else{//作品
            self.storyVO =model.storyVO;
            self.favorC =self.storyVO.favorCount;
            [self.imageArr insertObject:self.storyVO.userVO.avatar?self.storyVO.userVO.avatar:@"" atIndex:0];
            if (!model.storyVO) { //自由作品
                
            }else{ //悬赏作品
                
            }
            
        }
    
    }
    
    for (NSInteger i=0; i<self.imageArr.count; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted=NO;
        if (self.imageArr.count>i) {
            if ([self.imageArr[i] containsString:@"http"] || [self.imageArr[i] containsString:@"https"]) {
                
                NSString *imageUrl =@"";
                if (i==0) {//用户头像 默认
                    imageUrl =@"headerD";
                }
                [button sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i]?self.imageArr[i]:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:imageUrl]];
                
            }else{
                
                if (i == 0) { //用户头像 默认
                    [button setImage:[UIImage imageNamed:@"headerD"] forState:UIControlStateNormal];
                }else{
                    [button setImage:[UIImage imageNamed:self.imageArr[i]] forState:UIControlStateNormal];
                }
            }
            
        }
        
        CGFloat width =48.0;
        CGFloat height =48.0;
        //CGFloat space =20.0;
        CGFloat space =10.0;
        CGFloat originalY =0.0;
        CGFloat rightSpace =10.0;
        CGFloat lableHeight =17.0;
        
        [button setFrame:CGRectMake(_rect.size.width-width-rightSpace,originalY+(height+lableHeight+space)*i, width, height)];
        if (i==0) {
            [button.layer setCornerRadius:width/2.0];
            [button.layer setMasksToBounds:YES];
            button.layer.borderColor =[UIColor whiteColor].CGColor;
            [button.layer setBorderWidth:1.0];
        }

        [button setTag:1000+i];
        [button addTarget:self action:@selector(menuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        
        if (i!=0) {
            UILabel *titleL=[UILabel new];
            [titleL setFrame:CGRectMake(0, button.bottom, _rect.size.width,12)];
            [titleL setTextAlignment:NSTextAlignmentCenter];
            [titleL setFont: MOL_MEDIUM_FONT(12)];
            [titleL setTextColor:HEX_COLOR(0xffffff)];
            //阴影颜色
            titleL.shadowColor = HEX_COLOR_ALPHA(0x000000, 0.3);
            //阴影偏移  x，y为正表示向右下偏移
            titleL.shadowOffset = CGSizeMake(1, 1);
            [self addSubview:titleL];
            
            
            
            switch (i) {
                case 1:
                {
                    [button setFrame:CGRectMake(_rect.size.width-width-rightSpace,originalY+(height+lableHeight+space)*i, width+2, height)];
                    [button setImage:[UIImage imageNamed:@"video_praise1"] forState:UIControlStateSelected];
                    
                    if (model.contentType ==1) { //悬赏
                        [titleL setText:[STSystemHelper getNum:self.favorC]];
                        if (self.rewardVO.isFavor) {
                            [button setSelected:YES];
                        }
                    }else{//作品
    
                        [titleL setText:[STSystemHelper getNum:self.favorC]];
                        if (self.storyVO.isFavor) {
                            [button setSelected:YES];
                        }
                    }
                    self.praiseLable =titleL;
                    
                    self.praiseButton =button;
                }
                    break;
                case 2:
                {
                    if (model.contentType ==1) { //悬赏
                        [titleL setText:[STSystemHelper getNum:self.rewardVO.commentCount]];
                    }else{//作品
                        
                        [titleL setText:[STSystemHelper getNum:self.storyVO.commentCount]];
                    }
                    self.commentLable =titleL;
                }
                    break;
                case 3:
                {
                    if (model.contentType ==1) { //悬赏
                        [titleL setText:[STSystemHelper getNum:self.rewardVO.shareCount]];
                    }else{//作品
                        
                        [titleL setText:[STSystemHelper getNum:self.storyVO.shareCount]];
                    }
                    self.shareLable =titleL;
                }
                    break;
            }
            
        }else{
            UIButton *addButton =[UIButton buttonWithType:UIButtonTypeCustom];
            addButton.adjustsImageWhenHighlighted=NO;
            [addButton setImage:[UIImage imageNamed:@"video_+attention"] forState:UIControlStateNormal];
            [addButton setImage:[UIImage imageNamed:@"video_+attention1"] forState:UIControlStateSelected];
            [addButton setFrame:CGRectMake(0,button.bottom-22/2.0, 22, 22)];
            [addButton setCenterX:button.centerX];
            [addButton setTag:10000];
            [addButton addTarget:self action:@selector(menuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            self.focusButton =addButton;
            
            [addButton setAlpha:0];
            [self addSubview: addButton];
            if (model.contentType ==1) { //悬赏
               
                if(model.rewardVO.userVO.isFriend==0 && ![[MOLGlobalManager shareGlobalManager] isUserself:model.rewardVO.userVO]){
                    [addButton setAlpha:1];
                }
            }else{//作品
                if(model.storyVO.userVO.isFriend==0 && ![[MOLGlobalManager shareGlobalManager] isUserself:model.storyVO.userVO]){
                    [addButton setAlpha:1];
                }
            }
        }
    }
 
}

- (void)menuButtonEvent:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1000://用户头像
            self.currentFunctionType =HomeFunctionMenuViewAvatars;
            break;
        case 1001://赞
        {
           
            if (![[MOLUserManager shareUserManager] user_isLogin]) {
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HomeFunctionMenuViewToLogin" object:nil];
                [[MOLGlobalManager shareGlobalManager] global_modalLogin];
                return;
            }

            sender.userInteractionEnabled = NO;
//            NSLog(@"sender selected--->%d",sender.selected);
            sender.selected =!sender.selected;
            self.currentFunctionType =HomeFunctionMenuViewPraise;
            
#if 0
            /////////////////////赞动画实现///////////////////////////
          //  if (sender.selected) {
                //放大动画
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.duration = 1 * 0.8;
                animation.fromValue = @0.1;
                animation.toValue = @1;
                
                //旋转动画
                CAKeyframeAnimation *keyAnimation =[CAKeyframeAnimation animationWithKeyPath: @"transform.rotation.z"];
                
                keyAnimation.values = @[@(M_PI * -0.25), @(0), @(M_PI * 0.1), @(M_PI * -0.05), @0];
                // keyAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
                keyAnimation.duration = 1;
                
                //合成动画组
                CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
                
                groupAnimation.duration = 1;
                //  groupAnimation.delegate = self;
                groupAnimation.animations = @[keyAnimation, animation];
                
                [sender.layer addAnimation:groupAnimation forKey:nil];
                
//            }else{
//
//                //缩小动画
//                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//                animation.duration = 1 ;
//                animation.fromValue = @1;
//                animation.toValue = @0;
//
//                //旋转动画
//                CAKeyframeAnimation *keyAnimation =[CAKeyframeAnimation animationWithKeyPath: @"transform.rotation.z"];
//
//                keyAnimation.values = @[@(0), @(M_PI * -0.25)];
//                // keyAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//                keyAnimation.fillMode = kCAFillModeForwards;
//                keyAnimation.duration = 1*0.4;
//
//                //合成动画组
//                CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
//
//                groupAnimation.duration = 1;
//                //  groupAnimation.delegate = self;
//                groupAnimation.animations = @[keyAnimation, animation];
//
//                [sender.layer addAnimation:groupAnimation forKey:nil];
//
//            }
#endif
            
            ////////////////////////////////////////////////
           
//             NSLog(@"sender selected--->%d",sender.selected);
           
            if (sender.selected) {
                if (self.currentModel.contentType ==1) { //悬赏
                    
                    self.favorC ++;
                    
                    [self.praiseLable setText:[STSystemHelper getNum:self.favorC]];
                }else{//作品
                    
                    self.favorC++;
                    [self.praiseLable setText:[STSystemHelper getNum:self.favorC]];
                }
            }else{
                if (self.currentModel.contentType ==1) { //悬赏
                    
                    if (self.favorC>0) {
                        self.favorC--;
                    }
                    
                    [self.praiseLable setText:[STSystemHelper getNum:self.favorC]];
                }else{//作品
                    
                    if (self.favorC>0) {
                        self.favorC--;
                    }
                    [self.praiseLable setText:[STSystemHelper getNum:self.favorC]];
                }
            }
        }
            
            break;
        case 1002://评论
            self.currentFunctionType =HomeFunctionMenuViewComments;
            break;
        case 1003://分享
            self.currentFunctionType =HomeFunctionMenuViewShare;
            break;
        case 10000://关注
        {
            
            if (![[MOLUserManager shareUserManager] user_isLogin]) {
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"HomeFunctionMenuViewToLogin" object:nil];
                [[MOLGlobalManager shareGlobalManager] global_modalLogin];
                return;
            }
            [sender setUserInteractionEnabled:NO];
            self.currentFunctionType =HomeFunctionMenuViewAttention;
        }
            
            break;
    }
    if (!self.currentModel) {
        self.currentModel =[MOLVideoOutsideModel new];
    }
    
    self.homeFunctionMenuViewBlock(self.currentFunctionType, self.currentModel,sender);
    
}

- (void)setPraise:(NSString *)praise{
    NSInteger count =0;
    count =praise.integerValue;
    [self.praiseLable setText:[STSystemHelper getNum:count]];
}
- (void)setComment:(NSString *)comment{
    NSInteger count =0;
    count =comment.integerValue;
    [self.commentLable setText:[STSystemHelper getNum:count]];
}

- (void)setShare:(NSString *)share{
    NSInteger count =0;
    count =share.integerValue;
    [self.shareLable setText:[STSystemHelper getNum:count]];
}

- (void)setType:(HomeFunctionMenuViewType)type{
    self.currentFunctionType =type;
}

- (void)focusHidden:(BOOL)isHidden{
    if (isHidden) {
        [self.focusButton setAlpha:0];
    }else{
        [self.focusButton setAlpha:1];
    }
}

- (void)currentModelSyn:(MOLVideoOutsideModel *)model{
    if (!self.currentModel) {
        self.currentModel =[MOLVideoOutsideModel new];
    }
    self.currentModel =model;
    if (model.contentType ==1) { //悬赏
        self.favorC =self.rewardVO.favorCount;
    }else{//作品
        self.favorC =self.storyVO.favorCount;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
