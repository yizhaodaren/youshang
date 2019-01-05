//
//  MOLSupLinkeViewController.m
//  reward
//
//  Created by apple on 2018/9/22.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLSupLinkeViewController.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MOLEditViewController.h"
#import "MOLReleaseRequest.h"
#import "MOLClipMovieViewController.h"
@interface MOLSupLinkeViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UITextField *myTF;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@end

@implementation MOLSupLinkeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cheakPasteBoardUrlFromNotifaction) name:MOL_NOTI_LINK_CHEAKPASTBOARD object:nil];
    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      self.navigationController.navigationBar.frame = CGRectMake(0, MOL_StatusBarHeight, self.navigationController.navigationBar.frame.size.width, 44);
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self cheakPasteBoardUrl];
}
-(void)cheakPasteBoardUrl{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *pastStr = pasteboard.string;
    
    if (!self.ishowWarn || ![pastStr containsString:@"http"]) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"检测到剪切板上有站外视频链接,确认粘贴" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [cancelAction setValue:HEX_COLOR_ALPHA(0x221E1E, 0.6) forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.myTF.text = pastStr;
        [self nextStepAction];
    }];
    [sureAction setValue:HEX_COLOR(0xFE6257) forKey:@"titleTextColor"];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)cheakPasteBoardUrlFromNotifaction{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *pastStr = pasteboard.string;
    
    if (![pastStr containsString:@"http"]) {
        return;
    }
    UIViewController * vc = [CommUtls topViewController];
    if (![vc isKindOfClass:[MOLSupLinkeViewController class]]) {
        //如果当前页面不在外链页面 return
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"检测到剪切板上有站外视频链接,确认粘贴" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
      [cancelAction setValue:HEX_COLOR_ALPHA(0x221E1E, 0.6) forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.myTF.text = pastStr;
        [self nextStepAction];
    }];
    [sureAction setValue:HEX_COLOR(0xFE6257) forKey:@"titleTextColor"];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)requestData{
    
    [MBProgressHUD showMessage:@"解析中..."];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"videoUrl"] = self.myTF.text;
    MOLReleaseRequest *r = [[MOLReleaseRequest alloc] initRequest_videoParserWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        if (code == MOL_SUCCESS_REQUEST) {
            [MBProgressHUD hideHUD];
            // 解析数据
            MOLParserVideoModel *model = (MOLParserVideoModel *)responseModel;
            
            if (model.videoUrl.length < 1) {
            [MBProgressHUD showMessageAMoment:@"输入链接不合法!"];
            }else{
            [self linkVideoTo:model.videoUrl];
            }
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showMessageAMoment:@"输入链接不合法!"];
        }

    } failure:^(__kindof MOLBaseNetRequest *request) {
        
    }];
}
-(void)initUI{
    self.showNavigationLine = YES;
    [self basevc_setCenterTitle:@"输入链接" titleColor:[UIColor whiteColor]];
    self.tagView.backgroundColor = HEX_COLOR_ALPHA(0x0E0F1A, 0.9);
    
    UIBarButtonItem *backItem = [UIBarButtonItem mol_barButtonItemWithTitleName:@"下一步" targat:self action:@selector(nextStepAction)];
    backItem.tintColor = [UIColor whiteColor];
    [backItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:(0.9)] ,NSFontAttributeName:MOL_FONT(14)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = backItem;
    
    _myTF.centerX = self.view.centerX;
    _myTF.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.3);
    _myTF.layer.borderWidth = 1.0f;
    _myTF.layer.borderColor = [UIColor clearColor].CGColor;
    _myTF.layer.cornerRadius = _myTF.height/2;
    _myTF.clipsToBounds = YES ;

    _myTF.placeholder =@"请输入外链";
    
    //设置输入框内容的字体样式和大小
    _myTF.font = [UIFont fontWithName:@"Arial" size:14];
    
    //设置文字的颜色
    
    _myTF.textColor = [UIColor whiteColor];
    
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    
    _myTF.clearButtonMode = UITextFieldViewModeAlways;
    
    _myTF.enablesReturnKeyAutomatically = YES;
    
    //内容对齐方式
    
    _myTF.textAlignment = NSTextAlignmentLeft;
    
    //内容的垂直对齐方式  UITextField继承自UIControl,此类中有一个属性contentVerticalAlignment
    
    _myTF.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    
    //设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
    
    _myTF.adjustsFontSizeToFitWidth =YES;
    
    //设置自动缩小显示的最小字体大小
    
    _myTF.minimumFontSize = 14;
    
    
    
    //设置键盘的样式
    
    _myTF.keyboardType =UIKeyboardTypeURL;
    //    UIKeyboardTypeURL
    //return键变成什么键
    _myTF.returnKeyType =UIReturnKeyDone;
    
    //键盘外观
    
    _myTF.keyboardAppearance=UIKeyboardAppearanceAlert;
    
    /*
     
     UIKeyboardAppearanceDefault， 默认外观，浅灰色
     
     UIKeyboardAppearanceAlert，　 　深灰 石墨色
     
     */
    
    _myTF.delegate = self;
    
    
}
#pragma mark 下一步
-(void)nextStepAction{
    [self.view endEditing:YES];
    if (self.myTF.text.length < 1) {
        [MBProgressHUD showMessageAMoment:@"请输入链接"];
        return;
    }
    [self requestData];
}

#pragma mark 选择视频的代理方法
- (void)linkVideoTo:(NSString *)str{
    NSURL *url = [NSURL URLWithString:str];
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    AVAsset *asset = [AVAsset assetWithURL:url];
    plsMovieSettings[PLSURLKey] = url;
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    
    NSNumber *num = [NSNumber numberWithFloat:CMTimeGetSeconds(asset.duration)-0.01];
    plsMovieSettings[PLSDurationKey] = num;
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;
    
    MOLClipMovieViewController *clipMovieViewController = [[MOLClipMovieViewController alloc] init];
    clipMovieViewController.settings = outputSettings;
    clipMovieViewController.source = 3;
    
    self.ishowWarn = NO;
    [self.navigationController pushViewController:clipMovieViewController animated:YES];
}

#pragma mark 代理方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //返回一个BOOL值，YES代表允许编辑，NO不允许编辑.
    
    return YES;
    
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    return YES;
}

//文本框已经进入编辑模式
-(void)textFieldDidBeginEditing:(UITextField *)textField

{
    //开始编辑时触发
}

//文本框是否可以结束编辑模式
-(BOOL)textFieldShowEndEditing:(UITextField *)textField

{
    //返回NO，无法结束编辑状态
    return YES;
}
//文本框已结束编辑模式

-(void)textFieldDidEndEditing:(UITextField *)textField

{
    
}

//是否可以点击clear按钮

-(BOOL)textFieldShouldClear:(UITextField *)textField

{
    //返回NO，点击clear按钮无响应
    
    return YES;
    
}
//是否可以点击return按钮

-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [self.view endEditing:YES];
    return YES;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
