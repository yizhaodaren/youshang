//
//  MOLIdentityAuthentionVC.m
//  reward
//
//  Created by apple on 2018/11/28.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLIdentityAuthentionVC.h"
#import "TZImagePickerController.h"
#import "XDImageViewController.h"
#import "MOLLoginRequest.h"
#import "MOLWebViewController.h"
#define origH 435

@interface MOLIdentityAuthentionVC ()<TZImagePickerControllerDelegate,UITextFieldDelegate>
//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainScrollViewtopConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConstraints;

//UI
@property (weak, nonatomic) IBOutlet UIView *subBgView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;//用户名
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;//提示标签
@property (weak, nonatomic) IBOutlet UITextField *identityTF;//身份号码
@property (weak, nonatomic) IBOutlet UIButton *userAgreementBtn;//用户协议
@property (weak, nonatomic) IBOutlet UIImageView *identityImageView;//图片
@property (weak, nonatomic) IBOutlet UIButton *selectImageBtn;//选择图片
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;//提交审核


@property(nonatomic,strong) UIImage  *identityImage;//身份证照片

@property(nonatomic,copy) NSString  *identityURLStr;//身份证照地址

@end

@implementation MOLIdentityAuthentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollViewContranints];
    [self initUI];
    [self setOption];
    [self setupNavigation];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.userNameTF];
    
}
-(void)setupNavigation{
    self.showNavigationLine = YES;
    [self basevc_setCenterTitle:@"身份认证" titleColor:[UIColor whiteColor]];
}
#pragma mark 设置约束
-(void)setupScrollViewContranints{
    self.mainScrollViewtopConstraints.constant = MOL_StatusBarAndNavigationBarHeight;
    //设置scrollView的滚动范围
    CGFloat  bgviewHeight = origH + ((5.0/9.0)*(MOL_SCREEN_WIDTH - 15 * 2));
    if ((MOL_SCREEN_HEIGHT- MOL_StatusBarAndNavigationBarHeight)>bgviewHeight) {
        self.bgViewHeightConstraints.constant = MOL_SCREEN_HEIGHT- MOL_StatusBarAndNavigationBarHeight;
    }else{
        self.bgViewHeightConstraints.constant = bgviewHeight;
    }
}
-(void)initUI{
    self.userNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xFFFFFF, 0.4)}];
    self.userNameTF.returnKeyType = UIReturnKeyDone;
    self.identityTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入身份证号码" attributes:@{NSForegroundColorAttributeName:HEX_COLOR_ALPHA(0xFFFFFF, 0.4)}];
    self.identityTF.returnKeyType = UIReturnKeyDone;
    
    self.userNameTF.delegate = self;
    self.identityTF.delegate = self;
    [self.selectImageBtn setImage:[[UIImage imageNamed:@"au_upLoad"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.selectImageBtn setTitle:@"点击上传" forState:UIControlStateNormal];
    
     [self.selectImageBtn mol_setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];
    
    self.warnLabel.tintColor = HEX_COLOR(0xFE6257);
    
}
-(void)setOption{
    
    [self.selectImageBtn addTarget:self action:@selector(selectImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.userAgreementBtn addTarget:self action:@selector(userAgreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.checkBtn.layer.cornerRadius = 3;
    [self.checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (self.autnInfoModel && self.autnInfoModel.realAuth == 1) {
        [self setOrigValue];
        [self.checkBtn setTitle:@"审核中…1-3个工作日反馈审核结果" forState:UIControlStateNormal];
        self.checkBtn.backgroundColor = HEX_COLOR_ALPHA(0x9B9B9B, 1);
        self.checkBtn.enabled = NO;
        //认证中
    }else if (self.autnInfoModel.realAuth == 2){
        [self setOrigValue];
        //认证通过
        [self haveIdentityAuthentication];
    }
}
-(void)setOrigValue{
    NSString *name =self.autnInfoModel.name;
    NSString *card =self.autnInfoModel.card;
    
    
    name = [self replaceStringWithAsterisk:name startLocation:0  lenght:name.length - 1];
    card = [self replaceStringWithAsterisk:card startLocation:4  lenght:card.length - 8];
    
    self.userNameTF.text = name;
    self.identityTF.text = card;
    self.userNameTF.enabled = NO;
    self.identityTF.enabled = NO;
    [self.identityImageView sd_setImageWithURL:[NSURL URLWithString:self.autnInfoModel.imgUrl] placeholderImage:nil];
    self.selectImageBtn.enabled = NO;
    
}
-(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght

{
    
    NSString *newStr = originalStr;
    
    for (int i = 0; i < lenght; i++) {
        
        NSRange range = NSMakeRange(startLocation, 1);
        
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        
        startLocation ++;
        
    }
    return newStr;
}
#pragma mark 选择图片
-(void)selectImageBtnAction:(UIButton *)sender{
    
    // 弹出图片选择
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark 用户协议
-(void)userAgreementBtnAction:(UIButton *)sender{
    MOLWebViewController *vc = [[MOLWebViewController alloc] init];
    NSString *offic = MOL_OFFIC_SERVICE_H5;  // 正式
#ifdef MOL_TEST_HOST
    offic = MOL_TEST_SERVICE;  // 测试
#endif
    vc.urlString = [NSString stringWithFormat:@"%@/static/views/app/about/privacyPolicy.html",offic];
    vc.titleString = @"隐私政策";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 提交审核
-(void)checkBtnAction:(UIButton *)sender{
    
    
    NSString *name = self.userNameTF.text;
    if (name.length < 1) {
        [MBProgressHUD showMessageAMoment:@"请输入姓名"];
        return;
    }
    if (name.length < 2) {
        [MBProgressHUD showMessageAMoment:@"请输入真实姓名"];
        return;
    }
    NSString *identityStr = self.identityTF.text;
    if (identityStr.length < 1) {
        [MBProgressHUD showMessageAMoment:@"请输入身份证号码"];
        return;
    }
    if (![CommUtls validateIdentityCard:identityStr]) {
        [MBProgressHUD showMessageAMoment:@"请选输入正确的身份证号码"];
        return;
    }
    if (identityStr.length > 18) {
        [MBProgressHUD showMessageAMoment:@"身份证号码不能超过18位"];
    }
    if (!self.identityImage) {
          [MBProgressHUD showMessageAMoment:@"请选取照片"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"authType"] = @1;// 1身份认证 2视频认证
    dic[@"name"] = name;
    dic[@"card"] = identityStr;
    [self uploadCorverImageWith:dic];
    
}
-(void)uploadCorverImageWith:(NSMutableDictionary *)dic{
    MJWeakSelf
    [[MOLUploadManager shareUploadManager] qiNiu_uploadImage:self.identityImage complete:^(NSString *name) {
        if (!name) {
            [MBProgressHUD showMessage:@"操作失败,请重试!"];
            return;
        }
        //保存图片URL
        weakSelf.identityURLStr = name;
        dic[@"imgUrl"] = name;
        [weakSelf identityAuthWith:dic];
        
    }];
}
#pragma mark 身份认证
-(void)identityAuthWith:(NSMutableDictionary *)dic{
  
    MOLLoginRequest *r =  [[MOLLoginRequest alloc] initRequest_videoAuthWithParameter:dic];
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
        if (code == MOL_SUCCESS_REQUEST) {
            [MBProgressHUD showMessageAMoment:@"我们将在1-3个工作日反馈审核结果"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(__kindof MOLBaseNetRequest *request) {
             [MBProgressHUD showMessageAMoment:@"操作失败,请重试!"];
    }];
}
-(void)haveIdentityAuthentication{
    //移除
        for (UIView * v in self.subBgView.subviews) {
            [v removeFromSuperview];
        }
    //
    UILabel *label1 =  [[UILabel alloc] init];
    label1.text = @"已认证，实名信息认证后不能修改";
    label1.font = MOL_MEDIUM_FONT(13);
    label1.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.7);
    [label1 sizeToFit];
    label1.x = 15;
    label1.y = 15;
    label1.height = 20;
    
    [self.subBgView addSubview:label1];
    
    UILabel *label2 =  [[UILabel alloc] init];
    label2.text = @"如有疑问联系官方客服QQ:3270575490";
    label2.font = MOL_MEDIUM_FONT(13);
    label2.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.7);
    label2.x = 15;
    label2.y = label1.bottom + 10;
    label2.height = 20;
    [label2 sizeToFit];
    [self.subBgView addSubview:label2];
    
}

#pragma mark 代理方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    // 去编辑界面
    UIImage *image = photos.firstObject;
    XDImageViewController *vc = [[XDImageViewController alloc] init];
    vc.userImage = image;
    
    @weakify(self);
    vc.imageBlock = ^(UIImage *newImg){
        @strongify(self);
        self.identityImageView.image = newImg;
        self.identityImage = newImg;
    };
    
    [[[MOLGlobalManager shareGlobalManager] global_currentViewControl] presentViewController:vc animated:NO completion:nil];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    //过滤非汉字字符
    textField.text = [self filterCharactor:textField.text withRegex:@"[^\u4e00-\u9fa5]"];

    return NO;
}

- (void)textFiledEditChanged:(id)notification{
    
    UITextRange *selectedRange = self.userNameTF.markedTextRange;
    UITextPosition *position = [self.userNameTF positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        //过滤非汉字字符
        self.userNameTF.text = [self filterCharactor:self.userNameTF.text withRegex:@"[^\u4e00-\u9fa5]"];
        
    }else { //有高亮文字
        //do nothing
    }
}

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

@end
