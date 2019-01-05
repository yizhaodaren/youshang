//
//  MOLPostRewardView.m
//  reward
//
//  Created by apple on 2018/10/24.
//  Copyright © 2018年 reward. All rights reserved.
//

#import "MOLPostRewardView.h"
#import <UITextView+ZWPlaceHolder.h>
#import "MOLShowGiftBigView.h"
#import "MOLSeleGoldView.h"
#import "MOLCallFriendsViewController.h"
#import "RegexKitLite.h"
#define edgeW 15.0f//边界
#define MAX_LIMIT_NUMS 140//行数限制


@interface MOLPostRewardView()<UITextFieldDelegate,UITextViewDelegate>
////////////////////////

// 文字选择或光标位置
@property (nonatomic, assign) NSRange textRange;
///////////////////////
@end

@implementation MOLPostRewardView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MOLCallFriendsViewController" object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.atInfo =[NSMutableDictionary dictionary];
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
   
    [self addSubview:self.headView];
    [self addSubview:self.RewardGoldView];
    [self addSubview:self.RewardTimeView];
    [self addSubview:self.RewardMoneyView];
    [self addSubview:self.upTextView];
    [self addSubview:self.mixBtn];
    
    [self addSubview:self.bottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:@"MOLCallFriendsViewController" object:nil];
}


- (void)show{
    if (self.upTextView) {
        if (!self.upTextView.isFirstResponder) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.upTextView becomeFirstResponder];
            }];
        }
    }
}

#pragma mark 懒加载
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MOL_SCREEN_WIDTH, 45)];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
        line.width = MOL_SCREEN_WIDTH;
        line.height = 1;
        line.y =0;
        [_headView addSubview:line];
        [_headView addSubview:self.pageMenu];
        
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = HEX_COLOR_ALPHA(0xffffff, 0.1);
        line1.width = MOL_SCREEN_WIDTH;
        line1.height = 1;
        line1.y = _headView.height - 1;
        [_headView addSubview:line1];
    }
    return _headView;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        _pageMenu= [SPPageMenu pageMenuWithFrame:CGRectMake(0,1, MOL_SCREEN_WIDTH, 43) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.backgroundColor = HEX_COLOR(0x0E0F1A);
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.itemTitleFont = MOL_MEDIUM_FONT(16);
        _pageMenu.selectedItemTitleColor = HEX_COLOR(0xffffff);
        _pageMenu.unSelectedItemTitleColor = HEX_COLOR_ALPHA(0xffffff, 0.6);
        [_pageMenu setTrackerHeight:3 cornerRadius:0];
        _pageMenu.tracker.backgroundColor = HEX_COLOR(0xFFEC00);
        _pageMenu.needTextColorGradients = NO;
        _pageMenu.dividingLine.hidden = YES;
        _pageMenu.itemPadding = 20;
//        _pageMenu.delegate = self;
    }
    return _pageMenu;
}
//悬赏金币
-(UIView *)RewardGoldView{
    if (!_RewardGoldView) {
        _RewardGoldView = [[UIView alloc] initWithFrame:CGRectMake(edgeW,CGRectGetMaxY(self.headView.frame) + 20,  MOL_SCREEN_WIDTH - 2 * edgeW, MOL_SCALEHeight(100))];
        _RewardGoldView.layer.cornerRadius = 5;
        _RewardGoldView.backgroundColor = HEX_COLOR_ALPHA(0x777575, 0.1);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(MOL_SCALEWidth(15), 0, 60, 20)];
        lable.centerY = _RewardGoldView.height/2;
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = @"悬赏金币";
        lable.textColor = [UIColor whiteColor];
        [_RewardGoldView addSubview:lable];
        
        
        
        self.selGoldButton = [[UIButton alloc] initWithFrame:CGRectMake(_RewardGoldView.width - MOL_SCALEWidth(50), 0, MOL_SCALEWidth(50), _RewardGoldView.height)];
        self.selGoldButton.centerY = _RewardGoldView.height /2;
        [ self.selGoldButton setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateNormal];
        [ self.selGoldButton setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateHighlighted];
        [_RewardGoldView addSubview: self.selGoldButton];
     
        
        
        self.showGiftView.frame = CGRectMake(CGRectGetMinX(self.selGoldButton.frame) - MOL_SCALEWidth(100), 0, MOL_SCALEWidth(100), _RewardGoldView.height);
        
        [_RewardGoldView addSubview:self.showGiftView];
        
        
        
    }
    return _RewardGoldView;
}


-(MOLShowGiftBigView *)showGiftView{
    if (!_showGiftView) {
        _showGiftView = [[[NSBundle mainBundle] loadNibNamed:@"MOLShowGiftBigView" owner:nil options:nil] firstObject];
    }
    return _showGiftView;
}

//悬赏时间
-(UIView *)RewardTimeView{
    if (!_RewardTimeView) {
        _RewardTimeView = [[UIView alloc] initWithFrame:CGRectMake(edgeW,CGRectGetMaxY(self.RewardGoldView.frame) + 10,  MOL_SCREEN_WIDTH - 2 * edgeW, MOL_SCALEHeight(60))];
        _RewardTimeView.layer.cornerRadius = 5;
        _RewardTimeView.backgroundColor = HEX_COLOR_ALPHA(0x777575, 0.1);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(MOL_SCALEWidth(15), 0, 60, 20)];
        lable.centerY = _RewardTimeView.height/2;
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = @"悬赏时间";
        lable.textColor = [UIColor whiteColor];
        [_RewardTimeView addSubview:lable];
        
        self.timeLable.centerY = lable.centerY;
        self.timeLable.x = CGRectGetMaxX(lable.frame) + 5;
        [_RewardTimeView addSubview:self.timeLable];
        [_RewardTimeView addSubview:self.goButton];
        [_RewardTimeView addSubview:self.dueToTimeLable];
        
    }
    return _RewardTimeView;
}
//悬赏时间
-(UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 20)];
//        _timeLable.text = @"7天";
        _timeLable.textColor = HEX_COLOR(0xFFEC00);
        _timeLable.font = [UIFont systemFontOfSize:14];
    }
    return _timeLable;
}
-(UIButton *)goButton{
    
    if (!_goButton) {
        _goButton = [[UIButton alloc] initWithFrame:CGRectMake(_RewardTimeView.width - MOL_SCALEWidth(50), 0, MOL_SCALEWidth(50), _RewardTimeView.height)];
        _goButton.centerY = _RewardTimeView.height /2;
        
        [_goButton setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateNormal];
        [_goButton setImage:[UIImage imageNamed:@"Group"] forState:UIControlStateHighlighted];
        
      
    }
    return _goButton;
}

-(UILabel *)dueToTimeLable{
    if (!_dueToTimeLable) {
        CGRect rect = CGRectMake(CGRectGetMaxX(_timeLable.frame), 0,CGRectGetMinX(_goButton.frame) - CGRectGetMaxX(_timeLable.frame), 20);
        _dueToTimeLable = [[UILabel alloc] initWithFrame:rect];
        _dueToTimeLable.centerY = _RewardTimeView.height/2;
//        _dueToTimeLable.text = [[CommUtls theDateAfterDays:7] stringByAppendingString:@"结束"];
        _dueToTimeLable.textAlignment = NSTextAlignmentRight;
        _dueToTimeLable.textColor = HEX_COLOR(0xFE6257);
        _dueToTimeLable.font = [UIFont systemFontOfSize:14];
        if (iPhone5) {
            _dueToTimeLable.font = [UIFont systemFontOfSize:13];
        }
        _dueToTimeLable.userInteractionEnabled = YES;
    }
    return  _dueToTimeLable;
}

//红包个数
-(UIView *)RewardMoneyView{
    if (!_RewardMoneyView) {
        _RewardMoneyView = [[UIView alloc] initWithFrame:CGRectMake(edgeW,CGRectGetMaxY(self.RewardGoldView.frame) + 10,  MOL_SCREEN_WIDTH - 2 * edgeW, MOL_SCALEHeight(60))];
        _RewardMoneyView.layer.cornerRadius = 5;
        _RewardMoneyView.backgroundColor = HEX_COLOR_ALPHA(0x777575, 0.1);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(MOL_SCALEWidth(15), 0, 60, 20)];
        lable.centerY = _RewardMoneyView.height/2;
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = @"红包个数";
        lable.textColor = [UIColor whiteColor];
        [_RewardMoneyView addSubview:lable];
        
        [_RewardMoneyView addSubview:self.moneyTF];
        
        UILabel *labe2 = [[UILabel alloc] initWithFrame:CGRectMake(_RewardMoneyView.width - MOL_SCALEWidth(50), 0, MOL_SCALEWidth(50), 20)];
        labe2.centerY = _RewardMoneyView.height/2;
        labe2.font = [UIFont systemFontOfSize:14];
        labe2.text = @"个";
        labe2.textColor = [UIColor whiteColor];
        labe2.textAlignment = NSTextAlignmentCenter;
        [_RewardMoneyView addSubview:labe2];
    }
    return _RewardMoneyView;
}
-(UITextField *)moneyTF{
    if (!_moneyTF) {
        _moneyTF = [[UITextField alloc] initWithFrame:CGRectMake(_RewardMoneyView.width - MOL_SCALEWidth(90 + 50), 0, MOL_SCALEHeight(90), MOL_SCALEHeight(26))];
        _moneyTF.centerY = _RewardMoneyView.height/2;
        _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyTF.layer.borderWidth = 1;
        _moneyTF.layer.cornerRadius = 3;
        _moneyTF.font = MOL_FONT(14);
        _moneyTF.layer.borderColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.3).CGColor;
        _moneyTF.textColor = [UIColor whiteColor];
        _moneyTF.textAlignment = NSTextAlignmentCenter;
        _moneyTF.delegate = self;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"输入数量" attributes:
                                          @{NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.6],
                                            NSFontAttributeName:_moneyTF.font
                                            }];
        _moneyTF.attributedPlaceholder = attrString;
        
    }
    return _moneyTF;
}

-(UITextView *)upTextView{
    if (!_upTextView) {
        _upTextView = [[UITextView alloc] initWithFrame:CGRectMake(edgeW,CGRectGetMaxY(self.RewardMoneyView.frame) + 10,  MOL_SCREEN_WIDTH - 2 * edgeW, MOL_SCALEHeight(150))];
        _upTextView.backgroundColor = HEX_COLOR_ALPHA(0x777575, 0.1);
        _upTextView.layer.cornerRadius = 5;
        
        _upTextView.zw_placeHolder = @"  请至少输入5个字";
        _upTextView.zw_placeHolderColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
        _upTextView.font = [UIFont systemFontOfSize:14];
        _upTextView.textColor = [UIColor whiteColor];
        
        _upTextView.delegate = self;
        _upTextView.returnKeyType =  UIReturnKeyDone;
        [_upTextView addSubview:self.textNumLab];
        [_upTextView addSubview:self.addUserButton];
    }
    return _upTextView;
}
-(UIButton *)addUserButton{
    if (!_addUserButton) {
        _addUserButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _upTextView.height - 30, 80, 40)];
        [_addUserButton setImage:[UIImage imageNamed:@"addUser"] forState:UIControlStateNormal];
        
        [_addUserButton addTarget:self action:@selector(CallFriendsAction:) forControlEvents:UIControlEventTouchUpInside];
        [_upTextView addSubview:_addUserButton];
    }
    return _addUserButton;
}

-(UILabel *)textNumLab{
    if (!_textNumLab) {
        _textNumLab = [[UILabel alloc] initWithFrame:CGRectMake(_upTextView.width - 50,_upTextView.height - 30, 50, 30)];
        _textNumLab.textColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.6);
        _textNumLab.text = [NSString stringWithFormat:@"0/%d",MAX_LIMIT_NUMS];
        _textNumLab.font = [UIFont systemFontOfSize:12];
        
    }
    
    return  _textNumLab;
}
-(UIButton *)mixBtn{
    if (!_mixBtn) {
        _mixBtn = [[UIButton alloc] init];
        _mixBtn.x = edgeW;
        _mixBtn.y = CGRectGetMaxY(self.upTextView.frame) + 10;
        _mixBtn.titleLabel.font = MOL_FONT(13);
        [_mixBtn setTitleColor:HEX_COLOR_ALPHA(0xFFFFFF, 0.5) forState:UIControlStateNormal];
        [_mixBtn setImage:[UIImage imageNamed:@"rc_mix_DisSelect"] forState:UIControlStateNormal];
        [_mixBtn setImage:[UIImage imageNamed:@"rc_mix_selected"] forState:UIControlStateSelected];
        [_mixBtn setTitle:@" 以合拍形式发布悬赏" forState:UIControlStateNormal];
        [_mixBtn  sizeToFit];
    }
    return _mixBtn;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(edgeW, MOL_SCREEN_HEIGHT-MOL_StatusBarAndNavigationBarHeight - MOL_TabbarSafeBottomMargin - 20  - MOL_SCALEHeight(44), MOL_SCREEN_WIDTH - 2 *edgeW, MOL_SCALEHeight(44))];
        [_bottomView addSubview:self.jumpBtn];
        [_bottomView addSubview:self.recordBtn];
        
    }
    return _bottomView;
}
-(UIButton *)jumpBtn{
    if (!_jumpBtn) {
        _jumpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,( _bottomView.width -edgeW)/3, _bottomView.height)];
        [_jumpBtn setTitle:@"跳过视频" forState:UIControlStateNormal];
        _jumpBtn.backgroundColor = HEX_COLOR_ALPHA(0xFFFFFF, 0.2);
        _jumpBtn.layer.cornerRadius = 3;
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_jumpBtn setTitleColor:HEX_COLOR_ALPHA(0xFFFFFF, 0.6) forState:UIControlStateNormal];
   
    }
    return _jumpBtn;
}
-(UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc] init];
        _recordBtn.x = CGRectGetMaxX(_jumpBtn.frame) + edgeW;
        _recordBtn.y = 0;
        _recordBtn.width = (_bottomView.width -edgeW)/3 *2;
        _recordBtn.height = _bottomView.height;
        
//    WithFrame:CGRectMake(,0,( _bottomView.width -edgeW)/3 *2, _bottomView.height)];
        [_recordBtn setTitle:@"录制悬赏视频" forState:UIControlStateNormal];
        _recordBtn.backgroundColor = HEX_COLOR(0xFFEC00);
        _recordBtn.layer.cornerRadius = 3;
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_recordBtn setTitleColor:HEX_COLOR(0x322200) forState:UIControlStateNormal];
     
    }
    return _recordBtn;
}

-(void)mixRecordBtnAnimate{
    
    if (self.mixBtn.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            self.jumpBtn.hidden = NO;
            self.recordBtn.x = CGRectGetMaxX(self.jumpBtn.frame) + edgeW;
            self.recordBtn.width = (self.bottomView.width -edgeW)/3 *2;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.jumpBtn.hidden = YES;
            self.recordBtn.x = 0;
            self.recordBtn.width = self.bottomView.width;
        }];
       
    }
    self.mixBtn.selected = !self.mixBtn.selected;
  
    
}

#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //友盟统计
        //红包个数
        [MobClick event:ST_input_quantity_success];

}
#pragma mark textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //友盟统计
    if (self.pageMenu.selectedItemIndex == 0) {
        //红包悬赏
        [MobClick event:ST_input_describe_success];
    }else{
        //排位悬赏
        [MobClick event:ST_input_rank_describe_success];
    }
}
//self.textNumLab为显示剩余字数的label#pragma mark -限制病情描述输入字数(最多不超过255个字)
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    
    //////////////////////////////////////////////////////
    if ([text isEqualToString:@"@"]) { //@事件
        [self callFriendsEvent];
    }
    // 退格
    if (text.length == 0) {
        if (range.length == 1) {
            return [self backspace];
        } else {
            return YES;
        }
    }
    //////////////////////////////////////////////////////
    
    
    //点击完成回收键盘
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    //不支持系统表情的输入
    if ([[textView textInputMode] primaryLanguage]==nil||[[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen =MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >=0){
        return YES;
    } else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时,使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0){
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }else{
                __block NSInteger idx = 0;
                __block NSString *trimString = @"";//截取出的字串
                //使用字符串遍历,这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange,NSRange enclosingRange, BOOL* stop) {
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break,提高效率
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          idx++;
                                      }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了,哪一定是最大限制了。
            self.textNumLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)MAX_LIMIT_NUMS,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
}
#pragma mark -显示当前可输入字数/总字数
- (void)textViewDidChange:(UITextView *)textView{
    

    [[MOLAltHelper shared] changeAltColorWith:textView WithOriginalFont:nil AndFontColor:nil];
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变,就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum >MAX_LIMIT_NUMS){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    //    不让显示负数?
    self.textNumLab.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,existTextNum),MAX_LIMIT_NUMS];

}




#pragma mark -
#pragma mark @功能
- (void)callFriendsEvent{
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
            
            if (self.upTextView.text.length + strName.length > MAX_LIMIT_NUMS) {
                return;
            }
            [self.atInfo setObject:model forKey:strName];
            [self.upTextView insertText:strName];
            [self resetTextViewSelectedRange];
            
        }else{
            [OMGToast showWithText:@"不能@自己呦"];
        }
    };
    
}
-(void)CallFriendsAction:(UIButton *)sender{
    [self callFriendsEvent];
}
// 得到@Range数组
- (NSArray *)atRangeArray {
    NSArray *allKeys = self.atInfo.allKeys;
    if (!allKeys || allKeys.count == 0) {
        return nil;
    }

    NSString *pattern = [allKeys componentsJoinedByString:@"|"];

    NSMutableArray *atRanges = [NSMutableArray array];
    
    
    [self.upTextView.text enumerateStringsMatchedByRegex:pattern
                                            usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings,
                                                         const NSRange *capturedRanges, volatile BOOL *const stop) {
                                                if ((*capturedRanges).length == 0) return;
                                                [atRanges addObject:[NSValue valueWithRange:*capturedRanges]];
                                            }];
    return atRanges;
}

// 解决@某人后，光标位置保持在@某人后面
- (void)resetTextViewSelectedRange {
    NSRange selectedRange = self.upTextView.selectedRange;
    self.textRange = self.upTextView.selectedRange;
    __weak UITextView *tempTextView = self.upTextView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tempTextView.selectedRange = selectedRange;
    });
}





// 定位光标位置，@标签内部不允许编辑
-(void)textViewDidChangeSelection:(UITextView *)textView{
        if (self.atInfo && self.atInfo.count > 0) {
            if (!textView.selectedRange.length) {
                NSArray *rangeArray = [self atRangeArray];
                for (NSInteger i = 0; i < rangeArray.count; i++) {
                    NSRange range = [rangeArray[i] rangeValue];
                    NSRange selectedRange = textView.selectedRange;
    
                    if (selectedRange.location > range.location &&
                        selectedRange.location < range.location + range.length / 2) {
                       textView.selectedRange = NSMakeRange(range.location, selectedRange.length);
                        break;
                    } else if (selectedRange.location >= range.location + range.length / 2 &&
                               selectedRange.location < range.location + range.length) {
                        textView.selectedRange = NSMakeRange(range.location + range.length, selectedRange.length);
                        break;
                    }
                }
            }else{
    
                NSArray *rangeArray = [self atRangeArray];
                for (NSInteger i = 0; i < rangeArray.count; i++) {
                    NSRange range = [rangeArray[i] rangeValue];
                    NSRange selectedRange = textView.selectedRange;
    
                    if ((selectedRange.location > range.location &&
                         selectedRange.location < range.location + range.length / 2) || ((selectedRange.location + selectedRange.length) > range.location && (selectedRange.location +selectedRange.length) < range.location + range.length / 2)) {
                        textView.selectedRange = NSMakeRange(range.location, selectedRange.length);
                        break;
                    } else if ((selectedRange.location >= range.location + range.length / 2 &&
                                selectedRange.location < range.location + range.length) || (((selectedRange.location +selectedRange.length) >= (range.location + range.length /2)) && ((selectedRange.location + selectedRange.length) < (range.location + range.length)))) {
                        textView.selectedRange = NSMakeRange(range.location + range.length, selectedRange.length);
                        break;
                    }
                }
            }
        }
        self.textRange = textView.selectedRange;
}

- (BOOL)backspace {
    UITextView *intextView = self.upTextView;
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
                NSRange newRange = [intextView.text rangeOfString:temp];
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

- (void)replaceTextInRange:(UITextRange *)range withText:(NSString *)text {
    if (range && [self textInputShouldReplaceTextInRange:range replacementText:text]) {
        [self.upTextView replaceRange:range withText:text];
    }
}
- (BOOL)textInputShouldReplaceTextInRange:(UITextRange *)range replacementText:(NSString *)replacementText {
    BOOL shouldChange = YES;
    NSInteger startOffset = [self.upTextView offsetFromPosition:self.upTextView.beginningOfDocument toPosition:range.start];
    NSInteger endOffset = [self.upTextView offsetFromPosition:self.upTextView.beginningOfDocument toPosition:range.end];
    NSRange replacementRange = NSMakeRange((NSUInteger)startOffset, (NSUInteger)(endOffset - startOffset));
    NSMutableString *newValue = [self.upTextView.text mutableCopy];
    [newValue replaceCharactersInRange:replacementRange withString:replacementText];

    return shouldChange;
}

//- (void)setupTextView:(UITextView *)textView text:(NSString *)text color:(UIColor *)color {
//
//
//    _upTextView.font = [UIFont systemFontOfSize:14];
//    _upTextView.textColor = [UIColor whiteColor];
//   NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:textView.text];
//    string.yy_color = [UIColor whiteColor];
//
//   [string addAttribute:NSForegroundColorAttributeName value:color range:[textView.text rangeOfString:text]];
//
//    [textView setAttributedText:string];
//
//
//}



@end
