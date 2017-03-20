//
//  MSMusicAlbumView.m
//  MS3Tool
//
//  Created by chao on 2016/11/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMusicAlbumView.h"

#import "MSMusicAlbumCell.h"

#import "MSMusicPlayerConfig.h"



#define CONTENTHEIGHT SCREENH

#define CONTENTHEIGHT_3 (CONTENTHEIGHT / 3)


@interface MSMusicAlbumView ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>


@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIButton *bottomButton;


@property (nonatomic, strong) UITableView *playingTableView;

@property (nonatomic, strong) UITableView *lastPlayTableView;


@property (nonatomic, strong) NSMutableArray *playingDataArray;

@property (nonatomic, strong) NSMutableArray *lastPlayDataArray;


@property (nonatomic, strong) UIColor *cellColorUnselect;

@property (nonatomic, strong) UIColor *cellColorSelected;



@end

@implementation MSMusicAlbumView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
        [self loadData];
        
        [self addNotifycation];
    }
    
    return self;
}

- (void)loadData {
    
    self.lastPlayDataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self loadPlayingDataArray];
}

-(NSMutableArray *)playingDataArray {
    
    if (!_playingDataArray) {
        
        _playingDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _playingDataArray;
}

-(void)loadPlayingDataArray {
    
    if ([CMDDataConfig shareInstance].isAlbumChange) {
        
        [self.playingDataArray removeAllObjects];
        
        for (NSDictionary *dic in [CMDDataConfig shareInstance].playAlbum) {
            
            MSMusicInfoInBox *model = [[MSMusicInfoInBox alloc] init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.playingDataArray addObject:model];
        }
        
//        [[CMDDataConfig shareInstance] setIsAlbumChange:NO];
        
        [self.playingTableView reloadData];
    }
}

#pragma mark - createUI
- (void)createUI {    
    
    /**
     *  滑动背景
     */
    [self createScrollView];
    
    
    /**
     *  底部按钮
     */
    [self createBottomButton];
}
- (void)createScrollView {
    
    _bgScrollView = [[UIScrollView alloc ] initWithFrame:
                     CGRectMake(0, CONTENTHEIGHT_3 - HEIGHT_FOOTERVIEW, SCREENW, CONTENTHEIGHT_3 * 2)];
    
    _bgScrollView.delegate = self;
    
    _bgScrollView.directionalLockEnabled = YES;
    
    _bgScrollView.pagingEnabled = YES;
    
    [self addSubview:_bgScrollView];
    
    _bgScrollView.contentSize = CGSizeMake(SCREENW * 2, CONTENTHEIGHT_3 * 2);
    
    _bgScrollView.backgroundColor = WCBlack;
    
    
    [self createPlayingAlbum];
    
    [self createLastPlayAlbum];
}
// 正在播放歌曲的列表
- (void)createPlayingAlbum {
    
    _playingTableView = [[UITableView alloc] initWithFrame:
                         CGRectMake(0, 0, SCREENW, CONTENTHEIGHT_3 * 2) style:UITableViewStylePlain];
    
    _playingTableView.delegate = self;
    
    _playingTableView.dataSource = self;
    
    _playingTableView.backgroundColor = WCClear;
    
    [self.bgScrollView addSubview:_playingTableView];
}
// 上次播放歌曲的列表
- (void)createLastPlayAlbum {
    
}
- (void)createBottomButton {
    
//    _bottomButton = [WenChaoControl createButtonWithFrame:CGRectMake(0, CONTENTHEIGHT - HEIGHT_FOOTERVIEW, SCREENW, HEIGHT_FOOTERVIEW) ImageName:nil Target:self Action:@selector(close) Title:@"关闭"];
    
    _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _bottomButton.frame = CGRectMake(0, CONTENTHEIGHT - HEIGHT_FOOTERVIEW, SCREENW, HEIGHT_FOOTERVIEW);
    
    [_bottomButton setTitle:@"关闭"
                   forState:UIControlStateNormal];
    
    [_bottomButton addTarget:self
                      action:@selector(close)
            forControlEvents:UIControlEventTouchUpInside];
    
    _bottomButton.titleLabel.textColor = WCWhite;
    
    UILabel *lineLabel = [WenChaoControl createLabelWithFrame:CGRectMake(0, _bottomButton.frame.origin.y - 1, SCREENW, 1)
                                                         Font:0
                                                         Text:nil
                                                textAlignment:0];
    
    lineLabel.backgroundColor = WCLightGray;
    
    [self addSubview:lineLabel];
    
    [self addSubview:_bottomButton];
    
    _bottomButton.backgroundColor = WCBlack;
}


#pragma mark - 设置 歌单 背景样式
#pragma mark -- 设置成暗色系
- (void) setBgColorTypeDark {
    
    self.bgScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    self.bottomButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    [self.bottomButton setTitleColor:WCWhite forState:UIControlStateNormal];
    
    self.cellColorUnselect = WCWhite;
    
    self.cellColorSelected = WCRed;
    
    [self.playingTableView reloadData];
}

#pragma mark -- 设置成亮色系
- (void) setBgColorTypeLight {
    
    self.bgScrollView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    
    self.bottomButton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    
    [self.bottomButton setTitleColor:WCBlack forState:UIControlStateNormal];
    
    self.cellColorUnselect = WCBlack;
    
    self.cellColorSelected = WCRed;
    
    [self.playingTableView reloadData];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.playingDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSMusicAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSMusicAlbumCellID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSMusicAlbumCell" owner:self options:nil] firstObject];
    }
    
    if (self.playingDataArray.count) {
        
        [cell configWithBoxMusic:self.playingDataArray[indexPath.row]];
        
        if ([CMDDataConfig shareInstance].playIndex == indexPath.row) {
            
            [cell setSelectedSong:self.cellColorSelected];
            
        } else {
            
            [cell setUnselectedSong:self.cellColorUnselect];
        }
        
        __weak typeof(&*self) sself = self;
        
        // 删除 cell 的回调
        cell.delBlock = ^() {
          
            NSLog(@"indepath for cell is : %ld", (long)indexPath.row);
            
            [sself delCellWithIndex:indexPath.row];
        };
    }
    
    return cell;
}

- (void) delCellWithIndex:(NSInteger)index {
    
    MSMusicPlayerConfig *config = [MSMusicPlayerConfig sharedInstance];
    
    if (config.playAlbum.count > 1) {
        
        [config delModelFromMusicArrayWithIndex:index];
        
    } else {
        
        NSLog(@"清空当前播放列表");
    }
    
    [self loadPlayingDataArray];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self playMusicWithIndexPath:indexPath];
}


- (void)playMusicWithIndexPath:(NSIndexPath *)indexPath {
    
    MSMusicPlayerConfig *config = [MSMusicPlayerConfig sharedInstance];
    
    config.playIndex = indexPath.row;
    
    [self.playingTableView reloadData];
}

#pragma mark - addNotifycation
-(void)addNotifycation {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicStatus:) name:NOTIFY_PLAYSTATUS object:nil];
}
/**
 *  status
 *      -1 := 切歌
 *       0 := 暂停
 *       1 := 播放
 */
-(void)musicStatus:(NSNotification *)notify {
    
    // notify.object, notify.userInfo, notify.name
    
    if ([notify.object integerValue] == -1) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self loadData];
        });
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PLAYSTATUS object:nil];
}




#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.closeAlbum();
}

- (void)close {
    
    self.closeAlbum();
}
@end
