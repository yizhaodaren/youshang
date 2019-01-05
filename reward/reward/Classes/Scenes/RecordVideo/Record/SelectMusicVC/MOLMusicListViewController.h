//
//  MOLMusicListViewController.h
//  reward
//
//  Created by apple on 2018/11/17.
//  Copyright © 2018 reward. All rights reserved.
//

#import "MOLBaseViewController.h"
#import "MOLMusicModel.h"
typedef void (^SelectedMusicBlock) (NSURL *musicUrl,MOLMusicModel *music);

typedef NS_ENUM(NSUInteger, MOLMusicType) {
    MOLMusicType_collect,//收藏
    MOLMusicType_recommend,//推荐
    MOLMusicType_hot,//热门
    MOLMusicType_log,//用过
    MOLMusicType_search,//搜索
};
@interface MOLMusicListViewController : MOLBaseViewController

@property(nonatomic,assign)MOLMusicType currentMusicType;

@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)CGFloat tableViewHeight;
@property(nonatomic,strong)dispatch_block_t  selectedBlock;
@property(nonatomic,strong)SelectedMusicBlock useMusicBlock;

@property (nonatomic,assign)NSInteger index;
//初始化的时候设置tableView的高度
-(instancetype)initWithMusicTpey:(MOLMusicType)type TableH:(CGFloat)height;
//#pragma mark - 网络请求音乐数据
- (void)request_getMusicDataList:(BOOL)isMore;


-(void)stopMusic;

@end
