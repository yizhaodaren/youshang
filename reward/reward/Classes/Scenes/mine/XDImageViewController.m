//
//  XDImageViewController.m
//  seeYouTime
//
//  Created by 形点网络 on 16/7/7.
//  Copyright © 2016年 形点网络. All rights reserved.
//

#import "XDImageViewController.h"

//#define iPhone5 ([UIScreen mainScreen].bounds.size.width == 320)
//#define iPhone6 ([UIScreen mainScreen].bounds.size.width == 375)
#define iPhone6p ([UIScreen mainScreen].bounds.size.width == 414)

#define H6Plus (414.0/375.0)
#define H6 (1.0/1.0)
#define H5 (320.0/375.0)

#define XDScreenW [UIScreen mainScreen].bounds.size.width
#define XDScreenH [UIScreen mainScreen].bounds.size.height

@interface XDImageViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIView *middleView;
@property (nonatomic, weak) UIView *toolView;
@property (nonatomic, weak) UIButton *cancleButton;
@property (nonatomic, weak) UIButton *selectButton;

// 图片
@property (nonatomic, weak) UIImageView *pictureImageView;
@property (nonatomic, assign) CGRect oriFrame;
@end

@implementation XDImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_COLOR(0xf3f3f3);
    [self setUpFirst];
    [self jisuan:[self screenFitFactor]];
}

- (void)setUpFirst
{
    UIImageView *pictureImageView = [[UIImageView alloc] init];
    self.pictureImageView = pictureImageView;
    pictureImageView.userInteractionEnabled = YES;
    [self.view addSubview:pictureImageView];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    //1.创建手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //2.添加手势
    pinch.delegate = self;
    pan.delegate = self;
    [pictureImageView addGestureRecognizer:pinch];
    [pictureImageView addGestureRecognizer:pan];

    
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    topView.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.6);
    topView.userInteractionEnabled = NO;
    [self.view addSubview:topView];
    
    UIView *middleView = [[UIView alloc] init];
    self.middleView = middleView;
    middleView.backgroundColor = [UIColor clearColor];
    middleView.userInteractionEnabled = NO;
    [self.view addSubview:middleView];
    
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    bottomView.backgroundColor = HEX_COLOR_ALPHA(0x000000, 0.6);
    bottomView.userInteractionEnabled = NO;
    [self.view addSubview:bottomView];
    
    UIView *toolView = [[UIView alloc] init];
    self.toolView = toolView;
    toolView.backgroundColor = HEX_COLOR(0x000000);
    [self.view addSubview:toolView];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancleButton addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleButton = cancleButton;
    [self.toolView addSubview:cancleButton];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setTitle:@"选取" forState:UIControlStateNormal];
    [selectButton setTitleColor:HEX_COLOR(0xffffff) forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [selectButton addTarget:self action:@selector(selectImageClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectButton = selectButton;
    [self.toolView addSubview:selectButton];
}

- (void)jisuan:(CGFloat)scale
{
    self.pictureImageView.width = XDScreenW;
    if (self.userImage.size.width) {
        
        self.pictureImageView.height = self.pictureImageView.width * self.userImage.size.height / self.userImage.size.width;
    }else{
        self.pictureImageView.height = self.pictureImageView.width;
    }
    self.pictureImageView.center = CGPointMake(XDScreenW * 0.5, XDScreenH * 0.5);
    self.pictureImageView.image = self.userImage;
    self.oriFrame = self.pictureImageView.frame;
    
    self.middleView.width = XDScreenW - 1;
    self.middleView.height = self.middleView.width;
    self.middleView.center = CGPointMake(XDScreenW * 0.5, XDScreenH * 0.5);
    self.middleView.layer.borderWidth = 2;
    self.middleView.layer.borderColor = HEX_COLOR(0xffffff).CGColor;
    
    self.topView.x = 0;
    self.topView.y = 0;
    self.topView.width = XDScreenW;
    self.topView.height = (XDScreenH - self.middleView.width) * 0.5;
    
    self.bottomView.x = 0;
    self.bottomView.y = CGRectGetMaxY(self.middleView.frame);
    self.bottomView.width = XDScreenW;
    self.bottomView.height = self.topView.height;
    
    self.toolView.x = 0;
    self.toolView.y = XDScreenH - 48;
    self.toolView.width = XDScreenW;
    self.toolView.height = 48;
    
    self.cancleButton.x = 10;
    self.cancleButton.y = 0;
    self.cancleButton.height = 48;
    self.cancleButton.width = self.cancleButton.height;
    
    self.selectButton.x = XDScreenW - 10 - 48;
    self.selectButton.y = 0;
    self.selectButton.height = 48;
    self.selectButton.width = self.selectButton.height;
}

- (void)cancleClick:(UIButton *)btn  // 点击取消按钮
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectImageClick:(UIButton *)btn // 点击选取图片按钮
{
    /*
     绘制图片总结： 
        1 图片绘制的时候开启的上下文和图片一样大，drawAtPoint
     */
    // 开启上下文 -- 开启
    UIGraphicsBeginImageContext(self.view.bounds.size);
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.view.layer renderInContext:ctx];
    
    UIImage *new = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGSize size = CGSizeMake(self.middleView.bounds.size.width - 5, self.middleView.bounds.size.height - 5);
    UIGraphicsBeginImageContext(size);
    
    [new drawAtPoint:CGPointMake(-3, -(XDScreenH - self.middleView.height)*0.5-2.5)];
    
    
    UIImage *new1 = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.imageBlock(new1);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch  // 图片的缩放
{
    self.pictureImageView.transform = CGAffineTransformScale(self.pictureImageView.transform, pinch.scale, pinch.scale);
    //复位
    [pinch setScale:1];
    if (pinch.state == UIGestureRecognizerStateEnded && self.pictureImageView.width < XDScreenW) {
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.pictureImageView.frame = self.oriFrame;
        }];
    }
}

//拖动手势
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint transP = [pan translationInView:pan.view];
    
    self.pictureImageView.transform = CGAffineTransformTranslate(self.pictureImageView.transform, transP.x, transP.y);
    
    //复位(相对于上一次的操作)
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {   // 限制位置
        
        if (self.pictureImageView.x > 0) {
            [UIView animateWithDuration:.3 animations:^{
                
                self.pictureImageView.x = 0;
                
            }];
        }
        
        if (self.pictureImageView.x < XDScreenW - self.pictureImageView.width) {
            [UIView animateWithDuration:.3 animations:^{
                
                self.pictureImageView.x = XDScreenW - self.pictureImageView.width;
                
            }];
        }
        
        if (self.pictureImageView.y > self.topView.height) {
            [UIView animateWithDuration:.3 animations:^{
                
                self.pictureImageView.y = self.topView.height;
                
            }];
        }
        
        if (self.pictureImageView.y < XDScreenH - self.pictureImageView.height - self.topView.height) {
            [UIView animateWithDuration:.3 animations:^{
                
                self.pictureImageView.y = XDScreenH - self.pictureImageView.height - self.topView.height;
                
            }];
        }
    }
}

//是否允许支持多个手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}

- (CGFloat)screenFitFactor {
    if (iPhone5) {
        return H5;
    }else if (iPhone6) {
        return H6;
    }else {
        return H6Plus;
    }
}

@end
