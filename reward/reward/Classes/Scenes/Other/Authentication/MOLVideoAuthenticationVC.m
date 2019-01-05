//
//  MOLVideoAuthenticationVC.m
//  reward
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLVideoAuthenticationVC.h"
#import "MOLRecordViewController.h"
@interface MOLVideoAuthenticationVC ()
@property(nonatomic,strong)UIImageView  *topImageView;
@property(nonatomic,strong)UIButton  *recordBtn;
@end

@implementation MOLVideoAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self calculatorMineViewControllerFrame];
}
-(void)initUI{
    [self basevc_setCenterTitle:@"认证形象视频" titleColor:HEX_COLOR_ALPHA(0xFFFFFF, 0.9)];
    self.showNavigationLine = YES;
    
    //
    self.topImageView = [[UIImageView alloc] init];
    self.topImageView.image = [UIImage imageNamed:@"au_video"];
    [self.view addSubview:self.topImageView];
    
    //
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn addTarget:self action:@selector(recordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn setImage:[UIImage imageNamed:@"au_paishe"] forState:UIControlStateNormal];
    [self.view addSubview:self.recordBtn];
    [self calculatorMineViewControllerFrame];
}
-(void)calculatorMineViewControllerFrame{
    
    self.topImageView.width = MOL_SCREEN_WIDTH -40;
    self.topImageView.height = MOL_SCREEN_WIDTH -40;
    self.topImageView.x = 20;
    self.topImageView.y = MOL_StatusBarAndNavigationBarHeight + 20;
    
    self.recordBtn.centerX = self.topImageView.centerX;
    self.recordBtn.y = self.topImageView.bottom + 20;
    self.recordBtn.width = self.topImageView.width/2;
    self.recordBtn.height  = self.topImageView.width /2;
}

-(void)recordBtnAction:(UIButton *)sender{
    MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
    [MOLReleaseManager manager].rewardID = -1;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
