//
//  MOLVideoAuthPlayVC.m
//  reward
//
//  Created by apple on 2018/11/29.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLVideoAuthPlayVC.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "MOLRecordViewController.h"
@interface MOLVideoAuthPlayVC ()<PLPlayerDelegate>
@property (nonatomic,strong) PLPlayer *player;// 视频播放
@property (nonatomic,strong) UIImageView  *reEditImageView;
@property (nonatomic,strong) UIImageView  *statusImageView;
@end

@implementation MOLVideoAuthPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initPlayer];
} 
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.player play];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)initUI{
    //返回
    self.navigationItem.leftBarButtonItem.image = [[UIImage imageNamed:@"au_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (self.isSelf && self.authInfoModel.audioAuth == 2) {
            // 编辑
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [editButton setImage:[UIImage imageNamed:@"au_edit"] forState:UIControlStateNormal];
//            [editButton setImage:[UIImage imageNamed:@"au_editDisable"] forState:UIControlStateDisabled];
            [editButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:editButton];
            self.navigationItem.rightBarButtonItem = item;
            [self.view addSubview:self.reEditImageView];
//        if (self.authInfoModel.audioAuth == 1) {
//            editButton.enabled = NO;
//            self.reEditImageView.di
//        }
     }
    
    [self.view addSubview:self.statusImageView];

}
#pragma mark -- 播放器初始化
- (void)initPlayer {
    if (!self.authInfoModel.audioUrl) {
        return;
    }
    // 初始化 PLPlayerOption 对象
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
//    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    
    // 初始化 PLPlayer
    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:self.authInfoModel.audioUrl] option:option];
    self.player.loopPlay = YES;
    // 设定代理 (optional)
    self.player.delegate = self;
    //获取视频输出视图并添加为到当前 UIView 对象的 Subview
    self.player.playerView.frame = self.view.bounds;
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view insertSubview:self.player.playerView atIndex:0];
    [self.player play];
}

-(void)nextButtonClick:(UIButton *)sender{
    [self.player stop];
    MOLRecordViewController *vc = [[MOLRecordViewController alloc] init];
    [MOLReleaseManager manager].rewardID = -1;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 懒加载
-(UIImageView *)reEditImageView{
    if (!_reEditImageView) {
        _reEditImageView = [[UIImageView alloc] init];
   
        _reEditImageView.width = MOL_SCREEN_WIDTH - 130;
        _reEditImageView.height = _reEditImageView.width/5.0;
        _reEditImageView.right = MOL_SCREEN_WIDTH - 45;
        _reEditImageView.y = MOL_StatusBarHeight + 15;
    }
    return _reEditImageView;
}
-(UIImageView *)statusImageView{
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
        _statusImageView.width = MOL_SCREEN_WIDTH * 2 /3.0;
        _statusImageView.height = _statusImageView.width /28.0 * 7;
        _statusImageView.y = MOL_SCREEN_HEIGHT * 2 /3.0;
        _statusImageView.x = 0;
    }
    return _statusImageView;
}

#pragma mark 播放器代理
-(void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    if (state == PLPlayerStatusPlaying) {
        if (self.authInfoModel.audioAuth == 2) {
            //审核通过的
            self.statusImageView.image = [UIImage imageNamed:@"au_checked"];
        }else if(self.authInfoModel.audioAuth == 1){
            //审核中
            self.statusImageView.image = [UIImage imageNamed:@"au_checking"];
        }
         self.reEditImageView.image = [UIImage imageNamed:@"au_reEdit"];
    }
}
-(void)playerWillEndBackgroundTask:(PLPlayer *)player{
    
}
-(void)playerWillBeginBackgroundTask:(PLPlayer *)player{
    
}
@end
