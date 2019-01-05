//
//  HomeCommentView.m
//  reward
//
//  Created by xujin on 2018/9/13.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "HomeCommentView.h"
#import "JAGrowingTextView.h"
#import "HoursCell.h"
#import "HomeCommentModel.h"
#import "MOLVideoOutsideModel.h"
#import "HomePageRequest.h"
#import "UIView+Alert.h"
#import "CommentSetModel.h"
#import "MOLMineViewController.h"
#import "MOLOtherUserViewController.h"
#import "RegexKitLite.h"
#import "MOLCallFriendsViewController.h"

static const CGFloat KcontentOriginY =187;

static const NSInteger kMaxChar =80;
@interface HomeCommentView()<UITableViewDelegate,UITableViewDataSource,JAGrowingTextViewDelegate,YYTextKeyboardObserver,CommentCellDelegate>
@property (nonatomic,assign)CGRect rect;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *sourceData;
@property (nonatomic,strong)JAGrowingTextView *textView;  // 文本框

@property (nonatomic,strong)UIView *keyBoardView;
@property (nonatomic,strong)UIView *textBgView;
@property (nonatomic,assign)BOOL isKeyBoardShow;
@property (nonatomic,strong)NSMutableAttributedString *place;
@property (nonatomic,assign)CGFloat originalH;
@property (nonatomic,assign)HomeCommentViewSelectType selectType;
@property (nonatomic,strong)MOLVideoOutsideModel *currentModel;
@property (nonatomic,assign)HomeCommentBusinessType currentBusinessType;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)UIBehaviorTypeStyle refreshType; //刷新类型
@property (nonatomic,strong)UILabel *titleL;
@property (nonatomic,strong)HomeCommentModel *commentModel;
@property (nonatomic,assign)NSInteger commentCount;
@property (nonatomic,strong)HomeCommentModel *deleteModel;
@property (nonatomic,strong)UILabel *emptyLable; //无数据提示
@property (nonatomic,strong)UIButton *sendContentBtn; //@
////////////////////////
// @的匹配信息
@property (nonatomic, strong) NSMutableDictionary *atInfo;
// 文字选择或光标位置

@property (nonatomic, assign) NSRange textRange;

///////////////////////

@end

@implementation HomeCommentView
{
    UIView *bgView;
    UIView *contentView;
    UIButton *cancelBtn;
    NSArray *iconArr;
}

-(void)dealloc
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.sourceData =[NSMutableArray new];
        iconArr =[NSArray new];
        self.currentModel =[MOLVideoOutsideModel new];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
        self.isKeyBoardShow =NO;
        self.currentBusinessType = HomeCommentBusinessType_List;
        self.refreshType = UIBehaviorTypeStyle_Normal;
        self.pageNum =1;
        self.pageSize =20;
        self.commentCount =0;
        
        self.atInfo =[NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:@"MOLCallFriendsViewController" object:nil];
    }
    return self;
}

- (void)show{
    
    [UIView animateWithDuration:0.1 animations:^{
        [self->bgView setAlpha:1];
    } completion:^(BOOL finished) {
        
        if (!self.textView.isFirstResponder) {
            [UIView animateWithDuration:0.1 animations:^{
                [self.textView becomeFirstResponder];
            }];
        }
            
    }];
}

- (instancetype)initWithIcon:(NSArray *)iconArr_
{
    self = [super init];
    if (self) {
        iconArr =[NSArray new];
        iconArr = iconArr_;
    }
    return self;
}



//需要分享图标  分享名称
- (void)cottent:(MOLVideoOutsideModel *)model{
    self.currentModel =model;
    [self getCommentList];
//    NSLog(@"1--->%@-----%@",self.currentModel,model);
    bgView =[UIView new];
    [bgView setFrame:[[UIScreen mainScreen] bounds]];
    [bgView setBackgroundColor:HEX_COLOR_ALPHA(0x000000, 0.1)];
    [bgView setUserInteractionEnabled:YES];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window setUserInteractionEnabled:YES];
    [window addSubview:bgView];
    
    
    
    contentView =[UIView new];
    [contentView setFrame:CGRectMake(0,KcontentOriginY, MOL_SCREEN_WIDTH,MOL_SCREEN_HEIGHT-KcontentOriginY)];
    [contentView setBackgroundColor:HEX_COLOR_ALPHA(0x000000,0.8)];
    [contentView setUserInteractionEnabled:YES];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    contentView.layer.mask = maskLayer;
    
    [bgView addSubview:contentView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
   // blurEffectView.alpha =0.9;
    blurEffectView.frame = contentView.bounds;
    [contentView addSubview:blurEffectView];
    
   
    
    [contentView addSubview:self.emptyLable];
    [self.emptyLable setFrame:CGRectMake(0, contentView.height/2.0,MOL_SCREEN_WIDTH, 20)];
    
    
    UIView *topView =[UIView new];
    [topView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundEvent:)];
    [topView addGestureRecognizer:tap];
    [topView setBackgroundColor:[UIColor clearColor]];
    [topView setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH,KcontentOriginY)];
    [bgView addSubview:topView];
    
    self.titleL =[UILabel new];
    [self.titleL setFont:MOL_MEDIUM_FONT(12)];
    [self.titleL setTextColor:HEX_COLOR_ALPHA(0xffffff, 0.3)];
    [contentView addSubview:self.titleL];
    
    cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"close_reply"] forState:UIControlStateNormal];
    [cancelBtn setTag:1004];
    [cancelBtn addTarget:self action:@selector(cancelActionEvent) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    __weak typeof(self) wself = self;
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self->cancelBtn.mas_left);
        make.height.mas_equalTo(17);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17);
        make.centerY.mas_equalTo(wself.titleL.mas_centerY);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [contentView addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self ->contentView);
        make.top.mas_equalTo(wself.titleL.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self->contentView).offset(-MOL_TabbarHeight);
    }];
    
    
    
    self.keyBoardView =[UIView new];
    UITapGestureRecognizer *keyBoardTag =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapKeyBoardEvent:)];
    [self.keyBoardView addGestureRecognizer:keyBoardTag];
    [bgView addSubview:self.keyBoardView];
    [self.keyBoardView setFrame:CGRectMake(0, MOL_SCREEN_HEIGHT-MOL_TabbarHeight,MOL_SCREEN_WIDTH, 49)];
    self.textBgView =[UIView new];
    [self.textBgView setFrame:CGRectMake(0,0, MOL_SCREEN_WIDTH, 49)];
   
    [self.textBgView setBackgroundColor:HEX_COLOR(0x181818)];
    [self.keyBoardView addSubview:self.textBgView];
    
    
    self.textView = [[JAGrowingTextView alloc] initWithFrame:CGRectMake(15,0,MOL_SCREEN_WIDTH-15-20*2.0-30, 49)];
  
    
    self.textView.maxNumberOfLines = 5;
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfWords =kMaxChar;
    self.textView.font = MOL_REGULAR_FONT(14);
    self.textView.textColor = HEX_COLOR(0xffffff);
    [self.textView setBackgroundColor: HEX_COLOR(0x181818)];
    self.textView.size = [self.textView intrinsicContentSize];
    self.textView.returnKeyType =UIReturnKeySend;
    
    
    self.place = [[NSMutableAttributedString alloc] initWithString:@"说点什么~"];
    [self.place addAttributes:@{NSFontAttributeName : MOL_REGULAR_FONT(14), NSForegroundColorAttributeName : HEX_COLOR_ALPHA(0xffffff, 0.3)} range:[@"说点什么~" rangeOfString:@"说点什么~"]];
    self.textView.placeholderAttributedText = self.place;
    self.textView.textViewDelegate = self;
    [self.textBgView addSubview:self.textView];
    
    self.textView.y =(self.textBgView.height-self.textView.height)/2.0;
    
    self.originalH =self.textView.height;
    
    self.sendContentBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendContentBtn setFrame:CGRectMake(self.textBgView.width-20-30, self.textView.y+(44-30)/2.0, 30, 30)];
    [self.sendContentBtn setImage:[UIImage imageNamed:@"comment1"] forState:UIControlStateNormal];
    [self.sendContentBtn addTarget:self action:@selector(sendCommentButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
   // [self.sendContentBtn setBackgroundColor:[UIColor redColor]];
    [self.textBgView addSubview:self.sendContentBtn];

    
    // ------View出现动画
    contentView.transform = CGAffineTransformMakeTranslation(0.01, MOL_SCREEN_HEIGHT-KcontentOriginY);
    self.textView.transform = CGAffineTransformMakeTranslation(0.01, 49);

    [UIView animateWithDuration:0.3 animations:^{
        self-> contentView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        wself.textView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
    
//    NSLog(@"iconArr.count :%lf",ceil(iconArr.count/5.0));
}

- (UILabel *)emptyLable{
    if (!_emptyLable) {
        _emptyLable =[UILabel new];
        [_emptyLable setText: @"暂无评论，快去抢沙发吧"];
        [_emptyLable setTextAlignment:NSTextAlignmentCenter];
        [_emptyLable setFont:MOL_MEDIUM_FONT(12)];
        [_emptyLable setTextColor:HEX_COLOR_ALPHA(0xffffff, 0.3)];
        [_emptyLable setHidden:YES];
    }
    return _emptyLable;
}


-(UITableView *)tableview{
    
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,64, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
        [_tableview setBackgroundColor:[UIColor clearColor]];
        
        __weak typeof(self) wself = self;

        _tableview.mj_footer = [MOLDIYRefreshFooter footerWithRefreshingBlock:^{
            [wself loadMore];
        }];
        
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }

    }
    return _tableview;
    
    
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.sourceData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * const commentCellID = @"commentCell";
    CommentCell *commentCell =[tableView dequeueReusableCellWithIdentifier:commentCellID];
    if (!commentCell) {
        
        commentCell =[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellID];
        commentCell.selectionStyle= UITableViewCellSelectionStyleNone;
        
    }
    
    commentCell.delegate =self;
    
    HomeCommentModel *model =[HomeCommentModel new];
    if (self.sourceData.count>indexPath.row) {
        model =self.sourceData[indexPath.row];
        
        if (self.currentModel.contentType ==1) {//悬赏
            if (model.userId == self.currentModel.rewardVO.userVO.userId.integerValue) { //悬赏主
                model.userType = 2;
            }
            
        }else if(self.currentModel.contentType ==2){ //作品
            
            if (!self.currentModel.storyVO.rewardVO) {//其它作品
                if (model.userId == self.currentModel.storyVO.userVO.userId.integerValue) {//作者
                    model.userType =1;
                }
            }else{//悬赏作品
                if (model.userId == self.currentModel.storyVO.rewardVO.userId.integerValue) {//悬赏作品
                    model.userType =2;
                }
            }
            
        }
    }
    
    [commentCell commentCell:model indexPath:indexPath];

    return commentCell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCommentModel *model =[HomeCommentModel new];
    if (indexPath.row<self.sourceData.count) {
        model =self.sourceData[indexPath.row];
    }
    return model.cellHeight;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![MOLUserManagerInstance user_isLogin]) {
        [self cancelUI];
        [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        return;
    }
    
    HomeCommentModel *model =[HomeCommentModel new];
    if (indexPath.row<self.sourceData.count) {
        model =self.sourceData[indexPath.row];
    }
    self.selectType =HomeCommentViewSelectOther;
    MOLUserModel *user = [MOLUserManagerInstance user_getUserInfo];
    if (model.userId == user.userId.integerValue) { //自己
        self.selectType =HomeCommentViewSelectOneself;
        NSArray *titleButtons = @[@"复制",@"删除"];
        @weakify(self);
        LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:5 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
            @strongify(self);
            if (buttonIndex >= titleButtons.count) {
                return;
            }
            NSString *title = titleButtons[buttonIndex];
            if ([title isEqualToString:@"复制"]) {
                // 复制
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [NSString stringWithFormat:@"@%@:%@",model.userName?model.userName:@"",model.content?model.content:@""];
                [OMGToast showWithText:@"复制成功"];
                
            }else if ([title isEqualToString:@"删除"]){
                self.deleteModel = [HomeCommentModel new];
                self.deleteModel = model;
                // 删除
                self.currentBusinessType = HomeCommentBusinessType_Delete;
                [self getCommentList];
            }
        }];
        [actionS show];
    }else{
        NSArray *titleButtons = @[@"回复",@"举报"];
        @weakify(self);
        LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:5 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
            @strongify(self);
            if (buttonIndex >= titleButtons.count) {
                return;
            }
            NSString *title = titleButtons[buttonIndex];
            if ([title isEqualToString:@"回复"]) {
                // 回复
                self.place = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复@%@",model.userName?model.userName:@""]];
                [self.place addAttributes:@{NSFontAttributeName : MOL_REGULAR_FONT(14), NSForegroundColorAttributeName : HEX_COLOR_ALPHA(0x000000, 0.3)} range:[[NSString stringWithFormat:@"回复@%@",model.userName?model.userName:@""] rangeOfString:[NSString stringWithFormat:@"回复@%@",model.userName?model.userName:@""]]];
                self.textView.placeholderAttributedText = self.place;
                [self.textView becomeFirstResponder];
                self.commentModel =[HomeCommentModel new];
                self.commentModel =model;
            }else if ([title isEqualToString:@"举报"]){
                // 举报
                NSArray *titleButtons = @[@"色情低俗",@"垃圾广告",@"政治敏感",@"抄袭复制",@"违规内容"];
                LCActionSheet *actionS = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:titleButtons redButtonIndex:5 completion:^(NSInteger buttonIndex, LCActionSheet *actionSheet) {
                    
                    if (buttonIndex >= titleButtons.count) {
                        return;
                    }
                    NSString *title = titleButtons[buttonIndex];
//                    NSLog(@"title :%@",title);
                    
                //////////////////
                    NSMutableDictionary *dic =[NSMutableDictionary new];
                    [dic setObject:[NSString stringWithFormat:@"%@",title?title:@""] forKey:@"cause"];
                    
                    //举报评论
                    [dic setObject:@"3" forKey:@"reportType"];
                    [dic setObject:[NSString stringWithFormat:@"%ld",model.commentId] forKey:@"typeId"];
              
                    [[[HomePageRequest alloc] initRequest_ReportParameter:dic] baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
                        if (code  != MOL_SUCCESS_REQUEST) {
                            [OMGToast showWithText:message];
                        }
                        
                    } failure:^(__kindof MOLBaseNetRequest *request) {
                        
                    }];
                ///////////////////
                }];
                [actionS show];
                
            }
        }];
        [actionS show];
    }

}

-(void)tapBackgroundEvent:(UITapGestureRecognizer *)tap{
    [self cancelActionEvent];
}




- (void)cancelActionEvent{
    
    //    if (_delegate && [_delegate respondsToSelector:@selector(homeShareView:type:)]) {
    [self cancelUI];
    //        [_delegate homeShareView:self.currentModel type:self.currentShareType];
    //    }
    
}



-(void)cancelUI{
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        self->contentView.transform = CGAffineTransformMakeTranslation(0.01, MOL_SCREEN_HEIGHT-KcontentOriginY);
        wself.textView.transform = CGAffineTransformMakeTranslation(0.01,49);
        
    } completion:^(BOOL finished) {
        [wself.textView removeFromSuperview];
        [self->contentView removeFromSuperview];
        [self->bgView removeFromSuperview];
        [wself removeFromSuperview];
    }];
    
}

#pragma mark - JAGrowingTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(JAGrowingTextView *)growingTextView{
    if (![MOLUserManagerInstance user_isLogin]) {
        [self.textView resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self cancelUI];
            [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        });
    }
    return YES;
}
- (void)didChangeHeight:(CGFloat)height
{
    //当前高度   需要重新设置输入框的Y值 用变化高度-当前高度
    float diff = height-self.textBgView.height;
    CGRect frame = self.textBgView.frame;
    frame.origin.y -=diff;
    frame.size.height +=diff;
    if (self.originalH != self.textBgView.height) {
        self.originalH = self.textBgView.height;
    }
    
    if (frame.size.height<49) {
        frame.origin.y -= (49 -frame.size.height);
        frame.size.height =49;
    }
    [self.textBgView setFrame:frame];
    self.textView.y =(self.textBgView.height-self.textView.height)/2.0;
    self.sendContentBtn.y =self.textView.y+(44-30)/2.0;
    
}


- (void)textViewDidChange:(JAGrowingTextView *)growingTextView
{
   // [[MOLAltHelper shared] changeAltColorWith:growingTextView.textView WithOriginalFont:MOL_REGULAR_FONT(14) AndFontColor:HEX_COLOR(0x000000)];
}


// 发送文本
- (BOOL)growingTextView:(JAGrowingTextView*)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText
{
    // 空字符串直接返回
    if (!replacementText) {
        return NO;
    }
    
    //////////////////////////////////////////////////////
    if ([replacementText isEqualToString:@"@"]) { //@事件
        [self callFriendsEvent];
    }
    //////////////////////////////////////////////////////
    // 退格
    if (replacementText.length == 0) {
        if (range.length == 1) {
            return [self backspace];
        } else {
            return YES;
        }
    }
    else if ([replacementText isEqualToString:@"\n"]) {
//        if (![MOLUserManagerInstance user_isLogin]) {
//            [self cancelUI];
//            [[MOLGlobalManager shareGlobalManager] global_modalLogin];
//            return YES;
//        }
        // 发送
        if (self.textView.text.length) {
            self.currentBusinessType =HomePageBusinessType_SendComment_Comment;
            
            if (!self.commentModel) {
                self.currentBusinessType =HomePageBusinessType_SendComment;
            }
            
            [self getCommentList];
            [self.textView resignFirstResponder];
            
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark @功能
// 得到@Range数组
- (NSArray *)atRangeArray {
    NSArray *allKeys = self.atInfo.allKeys;
    if (!allKeys || allKeys.count == 0) {
        return nil;
    }
    
    NSString *pattern = [allKeys componentsJoinedByString:@"|"];
    
    NSMutableArray *atRanges = [NSMutableArray array];
    [self.textView.text enumerateStringsMatchedByRegex:pattern
                                            usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings,
                                                         const NSRange *capturedRanges, volatile BOOL *const stop) {
                                                if ((*capturedRanges).length == 0) return;
                                                [atRanges addObject:[NSValue valueWithRange:*capturedRanges]];
                                            }];
    return atRanges;
}

// 解决@某人后，光标位置保持在@某人后面
- (void)resetTextViewSelectedRange {
    NSRange selectedRange = self.textView.selectedRange;
    self.textRange = self.textView.selectedRange;
    __weak UITextView *tempTextView = self.textView.textView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tempTextView.selectedRange = selectedRange;
    });
}





// 定位光标位置，@标签内部不允许编辑
- (void)textViewDidChangeSelection:(JAGrowingTextView *)growingTextView{
    if (self.atInfo && self.atInfo.count > 0) {
        
        if (!growingTextView.textView.selectedRange.length) {
            NSArray *rangeArray = [self atRangeArray];
            for (NSInteger i = 0; i < rangeArray.count; i++) {
                NSRange range = [rangeArray[i] rangeValue];
                NSRange selectedRange = growingTextView.textView.selectedRange;
                
                if (selectedRange.location > range.location &&
                    selectedRange.location < range.location + range.length / 2) {
                    growingTextView.textView.selectedRange = NSMakeRange(range.location, selectedRange.length);
                    break;
                } else if (selectedRange.location >= range.location + range.length / 2 &&
                           selectedRange.location < range.location + range.length) {
                    growingTextView.textView.selectedRange = NSMakeRange(range.location + range.length, selectedRange.length);
                    break;
                }
            }
        }else{
            
            NSArray *rangeArray = [self atRangeArray];
            for (NSInteger i = 0; i < rangeArray.count; i++) {
                NSRange range = [rangeArray[i] rangeValue];
                NSRange selectedRange = growingTextView.textView.selectedRange;
                
                if ((selectedRange.location > range.location &&
                     selectedRange.location < range.location + range.length / 2) || ((selectedRange.location + selectedRange.length) > range.location && (selectedRange.location +selectedRange.length) < range.location + range.length / 2)) {
                    growingTextView.textView.selectedRange = NSMakeRange(range.location, selectedRange.length);
                    break;
                } else if ((selectedRange.location >= range.location + range.length / 2 &&
                            selectedRange.location < range.location + range.length) || (((selectedRange.location +selectedRange.length) >= (range.location + range.length /2)) && ((selectedRange.location + selectedRange.length) < (range.location + range.length)))) {
                    growingTextView.textView.selectedRange = NSMakeRange(range.location + range.length, selectedRange.length);
                    break;
                }
            }
        }
    }
    self.textRange = growingTextView.textView.selectedRange;
}

- (BOOL)backspace {
    JAGrowingInternalTextView *intextView = self.textView.textView;
    // Find the last thing we may input and delete it. And RETURN
    NSString *text = [intextView textInRange:[intextView textRangeFromPosition:intextView.beginningOfDocument toPosition:intextView.selectedTextRange.start]];
    
    
    NSArray *tempArray = [self.atInfo allKeys];
    for (NSString *temp in tempArray) {
        if ([text hasSuffix:temp]) {
            __block NSUInteger composedCharacterLength = 0;
            [temp enumerateSubstringsInRange:NSMakeRange(0, temp.length)
                                     options:NSStringEnumerationByComposedCharacterSequences
                                  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                      composedCharacterLength++;
                                  }];
            UITextRange *rangeToDelete = [intextView
                                          textRangeFromPosition:[intextView
                                                                 positionFromPosition:intextView.selectedTextRange.start
                                                                 offset:(NSInteger) - composedCharacterLength]
                                          toPosition:intextView.selectedTextRange.start];
            if (rangeToDelete) {
                [self replaceTextInRange:rangeToDelete withText:@""];
                NSRange newRange = [_textView.text rangeOfString:temp];
                if (newRange.location == NSNotFound) {
                    //新的text里面已经没有该@信息了，则从字典中清除掉
                    [self.atInfo removeObjectForKey:temp];
                }
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)textInputShouldReplaceTextInRange:(UITextRange *)range replacementText:(NSString *)replacementText {
    BOOL shouldChange = YES;
    
    NSInteger startOffset = [self.textView.textView offsetFromPosition:self.textView.textView.beginningOfDocument toPosition:range.start];
    NSInteger endOffset = [self.textView.textView offsetFromPosition:self.textView.textView.beginningOfDocument toPosition:range.end];
    NSRange replacementRange = NSMakeRange((NSUInteger)startOffset, (NSUInteger)(endOffset - startOffset));
    
    NSMutableString *newValue = [self.textView.textView.text mutableCopy];
    
    [newValue replaceCharactersInRange:replacementRange withString:replacementText];
    
    return shouldChange;
}

- (void)replaceTextInRange:(UITextRange *)range withText:(NSString *)text {
    if (range && [self textInputShouldReplaceTextInRange:range replacementText:text]) {
        [self.textView.textView replaceRange:range withText:text];
    }
}

#pragma mark - YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition
{
    
    CGRect kbFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self];
    self.isKeyBoardShow =transition.toVisible;
    // __weak typeof(self) wself = self;
    
    if (self.isKeyBoardShow) {
        [self.keyBoardView setFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, MOL_SCREEN_HEIGHT)];
        CGRect containerFrame = self.textBgView.frame;
        containerFrame.origin.y = MOL_SCREEN_HEIGHT- kbFrame.size.height- containerFrame.size.height;
        self.textBgView.frame = containerFrame;
//        self.textView.centerY =self.textBgView.centerY;
        // [self.textView setFrame:CGRectMake(15,0,MOL_SCREEN_WIDTH-15*2.0, 49)];;
        
    }else{
        
        [self.keyBoardView setFrame:CGRectMake(0, MOL_SCREEN_HEIGHT-self.textBgView.height-MOL_TabbarSafeBottomMargin, MOL_SCREEN_WIDTH, self.textBgView.height)];
        self.textBgView.y =0;
        //[self.textBgView setFrame: CGRectMake(0, 0, self.keyBoardView.width, self.keyBoardView.height)];
       // self.textView.centerY =self.textBgView.centerY;
        //[self.textView setFrame:CGRectMake(15,0,MOL_SCREEN_WIDTH-15*2.0,self.textBgView.height)];
    }
    
    if (self.isKeyBoardShow) {
        [self.textBgView setBackgroundColor:HEX_COLOR(0xffffff)];
        self.textView.textColor = HEX_COLOR(0x000000);
        [self.textView setBackgroundColor: HEX_COLOR(0xffffff)];
         
// [self.place addAttributes:@{NSFontAttributeName : MOL_REGULAR_FONT(14), NSForegroundColorAttributeName : HEX_COLOR_ALPHA(0x000000, 0.3)} range:[@"说点什么~" rangeOfString:@"说点什么~"]];
         [self.place addAttributes:@{NSFontAttributeName : MOL_REGULAR_FONT(14), NSForegroundColorAttributeName : HEX_COLOR_ALPHA(0x000000, 0.3)} range:NSMakeRange(0, self.place.length)];
        self.textView.placeholderAttributedText = self.place;
    }else{
        [self.textBgView setBackgroundColor:HEX_COLOR(0x181818)];
        self.textView.textColor = HEX_COLOR(0xffffff);
        [self.textView setBackgroundColor: HEX_COLOR(0x181818)];
        self.place = [[NSMutableAttributedString alloc] initWithString:@"说点什么~"];
        [self.place addAttributes:@{NSFontAttributeName : MOL_REGULAR_FONT(14), NSForegroundColorAttributeName : HEX_COLOR_ALPHA(0xffffff, 0.3)} range:[@"说点什么~" rangeOfString:@"说点什么~"]];
        self.textView.placeholderAttributedText = self.place;
    }
    
    self.textView.y =(self.textBgView.height-self.textView.height)/2.0;
    self.sendContentBtn.y = self.textView.y+(44-30)/2.0;
}



- (void)tapKeyBoardEvent:(UITapGestureRecognizer *)tap{
    [self.textView resignFirstResponder];
}

#pragma mark-
#pragma mark CommentCellDelegate
- (void)commentCellEvent:(HomeCommentModel *)modle eventType:(CommentCellEventType)type{
    
    [self cancelUI];
    
    if (type == CommentCellEventFavor) {
        return;
    }
    
    if (modle.userType == 3) {
        MOLMineViewController *vc = [[MOLMineViewController alloc] init];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }else{
        MOLOtherUserViewController *vc = [[MOLOtherUserViewController alloc] init];
        vc.userId = [NSString stringWithFormat:@"%ld",(long)modle.userId];
        [[[MOLGlobalManager shareGlobalManager] global_currentNavigationViewControl] pushViewController:vc animated:YES];
    }
 
}


#pragma mark
#pragma mark 获取评论列表

- (void)loadMore{
    self.pageNum++;
    self.refreshType =UIBehaviorTypeStyle_More;
    self.currentBusinessType = HomeCommentBusinessType_List;
    [self getCommentList];
}
- (void)getCommentList {
    
//    [self showLoadingHUD];
    __weak typeof(self) wself = self;
    NSMutableDictionary *dic =[NSMutableDictionary new];
    id r ;
    
    switch (self.currentBusinessType) {
        case HomeCommentBusinessType_List:
        {
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.currentModel.contentType] forKey:@"commentType"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"pageNum"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageSize] forKey:@"pageSize"];
            if (self.currentModel.contentType == 1) {//悬赏
                [dic setObject:self.currentModel.rewardVO.rewardId?self.currentModel.rewardVO.rewardId:@"" forKey:@"typeId"];
            }else if (self.currentModel.contentType ==2){//作品
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.currentModel.storyVO.storyId] forKey:@"typeId"];
            }
            
            r = [[HomePageRequest alloc] initRequest_CommentListParameter:dic];
            
        }
            break;
        case HomePageBusinessType_SendComment:
        {
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.currentModel.contentType] forKey:@"commentType"];
            //[dic setObject:self.textView.text?self.textView.text:@"" forKey:@"contents"];
            [dic setObject:[BMSHelpers getContent:self.textView.text?self.textView.text:@"" userSet:self.atInfo] forKey:@"contents"];
           
            if (self.currentModel.contentType == 1) {//悬赏
                [dic setObject:self.currentModel.rewardVO.rewardId?self.currentModel.rewardVO.rewardId:@"" forKey:@"typeId"];
                
            }else if (self.currentModel.contentType ==2){//作品
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.currentModel.storyVO.storyId] forKey:@"typeId"];
            }
            r = [[HomePageRequest alloc] initRequest_SendCommentParameter:dic];
        }
            
            break;
        case HomePageBusinessType_SendComment_Comment:
        {
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.commentModel.commentId] forKey:@"commentId"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.currentModel.contentType] forKey:@"commentType"];
            //[dic setObject:self.textView.text?self.textView.text:@"" forKey:@"contents"];
            [dic setObject:[BMSHelpers getContent:self.textView.text?self.textView.text:@"" userSet:self.atInfo] forKey:@"contents"];
            if (self.currentModel.contentType == 1) {//悬赏
                [dic setObject:self.currentModel.rewardVO.rewardId?self.currentModel.rewardVO.rewardId:@"" forKey:@"typeId"];

            }else if (self.currentModel.contentType ==2){//作品
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.currentModel.storyVO.storyId] forKey:@"typeId"];
            }
            
            r = [[HomePageRequest alloc] initRequest_SendCommentParameter:dic];
        }
            
            break;
        case HomeCommentBusinessType_Delete:
        {
            r =[[HomePageRequest alloc] initRequest_DeleteCommentParameter:@{} parameterId:[NSString stringWithFormat:@"%ld",(long)self.deleteModel.commentId]];
        }
            break;
    }
    [r baseNetwork_startRequestWithcompletion:^(__kindof MOLBaseNetRequest *request, MOLBaseModel *responseModel, NSInteger code, NSString *message) {
//        NSLog(@"2--->%@-----",self.currentModel);
//         [wself hideLoadingHUD];
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableview.mj_footer endRefreshing];
        }
        
        if (code  == MOL_SUCCESS_REQUEST) {
            if (responseModel) {

                switch (self.currentBusinessType) {
                    case HomeCommentBusinessType_List:
                    {
                        // 解析数据
                        CommentSetModel *mediaInfoList = (CommentSetModel *)responseModel;
                        
                        if (wself.refreshType != UIBehaviorTypeStyle_More) {
                            [wself.sourceData removeAllObjects];
                        }
                        
                        [wself.sourceData addObjectsFromArray:mediaInfoList.resBody];
                        
                        [wself.tableview reloadData];
                        
                        if (wself.sourceData.count >= mediaInfoList.total) {
                            wself.tableview.mj_footer.hidden = YES;
                            
                        }else{
                            wself.tableview.mj_footer.hidden = NO;
                        }
                        wself.commentCount =mediaInfoList.total;
                        [self.titleL setText: [NSString stringWithFormat:@"%ld条评论",wself.commentCount]];
                        
                    }
                        break;
                    case HomePageBusinessType_SendComment:
                    {
                        // 解析数据
                        HomeCommentModel *model = (HomeCommentModel *)responseModel;
                        
                        [wself.sourceData insertObject:model atIndex:0];
                        
                        [wself.tableview reloadData];
                        wself.commentCount++;
                        [wself.titleL setText: [NSString stringWithFormat:@"%ld条评论",(long)wself.commentCount]];
                        wself.textView.text =@"";
                        wself.commentModel =nil;
                        if (wself.currentModel.contentType == 1) {//悬赏
                            wself.currentModel.rewardVO.commentCount +=1;
                        }else if (wself.currentModel.contentType ==2){//作品
                            wself.currentModel.storyVO.commentCount +=1;
                        }
                       
                        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SEND_COMMENT object:wself.currentModel];
                        [OMGToast showWithText:@"评论成功"];
                    }
                        
                        break;
                    case HomePageBusinessType_SendComment_Comment:
                    {
                        // 解析数据
                        HomeCommentModel *model = (HomeCommentModel *)responseModel;
                        
                        [wself.sourceData insertObject:model atIndex:0];
                        
                        [wself.tableview reloadData];
                        wself.commentCount++;
                        [wself.titleL setText: [NSString stringWithFormat:@"%ld条评论",wself.commentCount]];
                        wself.textView.text =@"";
                        wself.commentModel =nil;
                        if (wself.currentModel.contentType == 1) {//悬赏
                            wself.currentModel.rewardVO.commentCount +=1;
                        }else if (wself.currentModel.contentType ==2){//作品
                            wself.currentModel.storyVO.commentCount +=1;
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SEND_COMMENT object:wself.currentModel];
                        [OMGToast showWithText:@"评论成功"];
                    }
                        
                        break;
                    case HomeCommentBusinessType_Delete:
                    {
                        NSInteger idx =[wself.sourceData indexOfObject: wself.deleteModel];
                        if (wself.sourceData.count>idx) {
                            [wself.sourceData removeObjectAtIndex: idx];
                            [wself.tableview reloadData];
                        }
                        wself.commentCount--;
                        if (wself.commentCount<0) {
                            wself.commentCount=0;
                        }
                        [wself.titleL setText: [NSString stringWithFormat:@"%ld条评论",wself.commentCount]];
                        [OMGToast showWithText:@"删除成功"];
                        wself.delegate =nil;
                        if (wself.currentModel.contentType == 1) {//悬赏
                            wself.currentModel.rewardVO.commentCount -=1;
                        }else if (wself.currentModel.contentType ==2){//作品
                            wself.currentModel.storyVO.commentCount -=1;
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:MOL_SEND_COMMENT object:wself.currentModel];
                    }
                        break;
                }
            }
            
        }else{
            [OMGToast showWithText: message];
        }
        
        if (wself.sourceData.count>0) {
            [self.emptyLable setHidden:YES];
        }else{
            [self.emptyLable setHidden:NO];
        }
        
    } failure:^(__kindof MOLBaseNetRequest *request) {
        if (wself.refreshType != UIBehaviorTypeStyle_Normal) {
            [wself.tableview.mj_footer endRefreshing];
        }
//        [wself hideLoadingHUD];
        if (wself.sourceData.count>0) {
            [self.emptyLable setHidden:YES];
        }else{
            [self.emptyLable setHidden:NO];
        }
    }];
}


#pragma mark -
#pragma mark
- (void)sendCommentButtonEvent:(UIButton *)sender{
    
    if (![MOLUserManagerInstance user_isLogin]) {
        [self.textView resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self cancelUI];
            [[MOLGlobalManager shareGlobalManager] global_modalLogin];
        });
        return;
    }
    
    [self callFriendsEvent];
    
}

- (void)callFriendsEvent{
    [bgView setAlpha: 0];
    [MOLCallFriendsViewController show].selectedBlock = ^(MOLMsgUserModel *model) {
        NSLog(@"%@",model.userVO.userName);
        
        if (![[MOLGlobalManager shareGlobalManager] isUserself:model.userVO]) {
            NSString *strName = [NSString stringWithFormat:@"\b@%@\b", model.userVO.userName];
            if (self.atInfo.count) {
                if (self.atInfo[strName]) {
                    [OMGToast showWithText:@"你已经@过了"];
                    return;
                }
            }
            
            if (self.textView.textView.text.length + strName.length > kMaxChar) {
                return;
            }
            [self.atInfo setObject:model forKey:strName];
            [self.textView.textView insertText:strName];
            [self resetTextViewSelectedRange];
        }else{
            [OMGToast showWithText:@"不能@自己呦"];
        }
        
    };
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
