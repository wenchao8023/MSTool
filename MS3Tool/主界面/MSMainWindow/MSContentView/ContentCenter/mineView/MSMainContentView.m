//
//  MSMainContentView.m
//  MS3Tool
//
//  Created by chao on 2016/12/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMainContentView.h"


#import "MSMainGuessLikeModel.h"

#import "MSMainAlbumCell.h"

#import "MSMainNetWork.h"

#import "HeadImageView.h"

//#import "GCDAsyncSocketManager.h"



typedef enum : NSInteger {
    
    headView_leftBtn_tag = 700,
    
    headView_rightBtn_tag
    
} HEADVIEW_TAG;




static const NSInteger kMSHeight_buttonsView = 110.f;

static NSString *kMSAlbumHeadID = @"KMSALBUMHEADID";

static UIColor *kContentBgColor = nil;




@interface MSMainContentView () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>



@property (nonatomic, strong) MSMainNetWork *netWork;

// 背景视图
@property (nonatomic, strong) UIScrollView *bgScrollView;


// 轮滑视图中的数据
@property (nonatomic, strong) NSMutableArray *bannerArray;

@property (nonatomic, strong) HeadImageView *headView;


// 按钮视图 - 我喜欢、音乐、音乐圈、音箱
@property (nonatomic, strong) UIView *buttonsView4;

// 推荐歌单和热门歌单视图
@property (nonatomic, strong) UICollectionView *collectionView5;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *albumArray;

// 我的歌单视图
@property (nonatomic, strong) UITableView *tableView6;

@property (nonatomic, strong) NSMutableArray *playAlbumArray;




@end

@implementation MSMainContentView

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        kContentBgColor = WCBgGray;

        
        [self createUI];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self loadData];
        });
        
        
    }
    
    return self;
}

#pragma mark - createUI
- (void) createUI {
    
    [self createScrollView];
    
    [self createView3];
    
    [self createView4];
    
    [self createView5];
    
    [self createView6];
    
    [self resetScrollContent];
}
//  最底层的画布
- (void) createScrollView {
    
    CGRect sFrame = CGRectMake(0, 0, self.width, self.height);
    
    NSLog(@"self.height == %f", self.height);
    
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:sFrame];
    
    scr.delegate = self;
    
    scr.backgroundColor = kContentBgColor;
    
    [self addSubview:scr];
    
    _bgScrollView = scr;
    
    self.bgScrollView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)closeHeaderRefresh {
    if ([self.bgScrollView.mj_header isRefreshing]) {
        [self.bgScrollView.mj_header endRefreshing];
    }
    
    if (!self.bgScrollView.mj_header.hidden) {
        self.bgScrollView.mj_header.hidden = YES;
    }
}


//  头部的滑动视图
- (void) createView3 {
 
    // 透过 searchView 的高度40
    CGRect vframe = CGRectMake(0, 40, self.width, MSMainHeight_headScrollView);
    
    
    _headView = [[HeadImageView alloc] initWithFrame:vframe];
    
    [_bgScrollView addSubview:_headView];
    
}

//  按钮视图
- (void) createView4 {
    
    CGRect vframe = CGRectMake(0, CGRectGetMaxY(_headView.frame) + 10, self.width, kMSHeight_buttonsView);
    
    MSMainButtonsView *view = [[MSMainButtonsView alloc] initWithFrame:vframe];
    
    view.backgroundColor = WCWhite;
    
    [_bgScrollView addSubview:view];
    
    _buttonsView4 = view;
    
    __weak typeof(&*self) sself = self;
    
    view.buttonsClickBlock = ^(ButtonsClickTag clickTag) {
        
        sself.buttonViewClickBlock(clickTag);
    };
}



- (void) createView5 {
    
    CGFloat albumCellWidth = (self.width - 32) / 3;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // minimumInteritemSpacing 和 sectionInset 可以控制 cell 的平均分配
    flowLayout.minimumInteritemSpacing = 8;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    
    flowLayout.itemSize = CGSizeMake(albumCellWidth, albumCellWidth + 43);
    
    //设置头部size
    flowLayout.headerReferenceSize = CGSizeMake(self.width, 40);
    
    
    
    CGRect v4Frame = CGRectMake(0, CGRectGetMaxY(_buttonsView4.frame) + 10, self.width, (albumCellWidth + 43 + 40 + 2) * 2);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:v4Frame collectionViewLayout:flowLayout];
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    collectionView.scrollEnabled = NO;
    
    collectionView.backgroundColor = WCWhite;
    
    [_bgScrollView addSubview:collectionView];
    
    _collectionView5 = collectionView;
    
    [_collectionView5 registerNib:[UINib nibWithNibName:@"MSMainAlbumCell" bundle:nil] forCellWithReuseIdentifier:@"MSMainAlbumCellID"];
    
    [_collectionView5 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMSAlbumHeadID];
    
}

- (void) createView6 {
    
    CGRect vFrame = CGRectMake(0, CGRectGetMaxY(_collectionView5.frame) + 10, self.width, 40);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:vFrame style:UITableViewStylePlain];
    
    tableView.backgroundColor = WCWhite;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.scrollEnabled = NO;
    
    [_bgScrollView addSubview:tableView];
    
    _tableView6 = tableView;
    
    
    [self.playAlbumArray addObject:@"收藏歌曲"];
}

-(NSMutableArray *)playAlbumArray {
    
    if (!_playAlbumArray) {
        
        _playAlbumArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _playAlbumArray;
}

#pragma mark - resetView

#pragma mark -- 重新设置背景画布高度
- (void) resetScrollContent {
    
    CGRect tFrame = self.tableView6.frame;
    
    tFrame.size.height = (self.playAlbumArray.count + 1) * 40;
    
    self.tableView6.frame = tFrame;
    
    CGFloat scrHeight = CGRectGetMaxY(_tableView6.frame) + 10;
    
    _bgScrollView.contentSize = CGSizeMake(self.width, scrHeight);
    
    NSLog(@"bgHeight = %f", scrHeight);
}

#pragma mark -- 重新设置 collectionView
- (void) resetCollectionView {
    
    if (_titleArray.count == 2) {
        
        if ([[_titleArray firstObject] isEqualToString:@"热门音乐"]) {
            
            [_titleArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
            [_albumArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView5 reloadData];
            
            if ([KVNProgress isVisible]) {
                
                [KVNProgress dismiss];
            }
            
            [self.bgScrollView.mj_header endRefreshing];
        });
    }
}


#pragma mark - loadData
- (void) loadData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [CommonUtil addKVNToMainView:self];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([KVNProgress isVisible]) {
                
                [KVNProgress dismiss];
            }
        });
    });
    
    
    _netWork = [MSMainNetWork shareManager];
    
    [self.bannerArray removeAllObjects];
    
    [self.titleArray removeAllObjects];
    
    [self.albumArray removeAllObjects];
    
    [self loadData1];
    
    [self loadData2];
    
    [self loadData3];
}

- (void)reloadData {
    
    if ([KVNProgress isVisible]) {
        
        [self loadData];
    }
}

-(NSMutableArray *)bannerArray {
    
    if (!_bannerArray) {
        
        _bannerArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _bannerArray;
}

-(NSMutableArray *)titleArray {
    
    if (!_titleArray) {
        
        _titleArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _titleArray;
}

-(NSMutableArray *)albumArray {
    
    if (!_albumArray) {
        
        _albumArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _albumArray;
}

#pragma mark -- 热门下的推荐 - 共20条
- (void) loadData1 {
    
    __weak typeof(&*self) sself = self;    
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_DiscoveryRecommendAlbums params:nil withCompletionHander:^(id result, XMErrorModel *error) {
        if(!error) {
            
            [sself.titleArray addObject:@"热门音乐"];
            
            NSMutableArray *tempMArr = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary *dic in result) {
                
                if ([[dic objectForKey:@"category_id"] integerValue] == 2) {
                    
                    NSArray *albumsArr = [dic objectForKey:@"albums"];
                    
                    for (NSDictionary *objDic in albumsArr) {
                        
                        MSMainGuessLikeModel *model = [[MSMainGuessLikeModel alloc] initWithDictionary:objDic];
                        
                        [tempMArr addObject:model];
                    }
                    
                    [self.albumArray addObject:tempMArr];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [sself resetCollectionView];
                        
                        [self closeHeaderRefresh];
                    });
                }
            }
            
            
        }

        else
            NSLog(@"%@",error.description);
    }];
    
    
}

#pragma mark -- 猜你喜欢 - 推荐模块分组 - XMAlbumGuessLike

- (void) loadData2 {
    
    __weak typeof(&*self) sself = self;
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:@3 forKey:@"like_count"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_AlbumsGuessLike params:requestDic withCompletionHander:^(id result, XMErrorModel *error) {
        if(!error) {
            
            [sself.titleArray addObject:@"推荐音乐"];
            
            NSMutableArray *tempMArr = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary *dic in result) {
                
                MSMainGuessLikeModel *model = [[MSMainGuessLikeModel alloc] initWithDictionary:dic];
                
                [tempMArr addObject:model];
            }
            
            [self.albumArray addObject:tempMArr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [sself resetCollectionView];
                
                [self closeHeaderRefresh];
            });
        }
        
        else
            NSLog(@"%@   %@",error.description,result);
    }];
}




#pragma mark -- 热门 - 焦点图
- (void) loadData3 {
    
    __weak typeof(&*self) sself = self;
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_DiscoveryBanner params:nil withCompletionHander:^(id result, XMErrorModel *error) {
        
        for (NSDictionary *dic in result) {
            
            XMBanner *banner = [[XMBanner alloc] initWithDictionary:dic];
            
            [self.bannerArray addObject:banner];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sself.headView configBanner:sself.bannerArray];
            
            [self closeHeaderRefresh];
            
        });
    }];
}





#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_bgScrollView]) {
        
        if ((_bgScrollView.contentOffset.y - 40/*MSMainHeight_headScrollView - kMSHeight_buttonsView*/) > 0) {
            
            self.shouldHiddenSearchView(YES);
            
        } else {
            
            self.shouldHiddenSearchView(NO);    
        }
    }
}






#pragma mark - UICollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _titleArray.count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_albumArray.count) {
        
        return [_albumArray[section] count];
    }
    
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MSMainAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSMainAlbumCellID" forIndexPath:indexPath];
    
    if (_albumArray.count) {
        
        if ([_albumArray[indexPath.section] count]) {
            
            cell.backgroundColor = WCClear;
            
            [cell config:_albumArray[indexPath.section][indexPath.row]];            
        }
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMSAlbumHeadID forIndexPath:indexPath];
        
        [self setReusableView:reusableView indexPath:indexPath];
        
        return reusableView;
    }
    
    return [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
}

- (void)setReusableView:(UICollectionReusableView *)reusableView indexPath:(NSIndexPath *)indexPath {
    
    UIImageView *iconImage = [WenChaoControl createImageViewWithFrame:CGRectMake(8, 10, 20, 20) ImageName:nil];
    
    [reusableView addSubview:iconImage];
    
    UILabel *titleLabel = [WenChaoControl createLabelWithFrame:CGRectMake(30, 10, 80, 20) Font:15 Text:nil textAlignment:0];
    
    titleLabel.textColor = WCBlack;
    
    [reusableView addSubview:titleLabel];
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 45, 0, 45, 38)];
    
    UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreClick)];
    
    [moreView addGestureRecognizer:moreTap];
    
    [reusableView addSubview:moreView];
    
    UILabel *rightLabel = [WenChaoControl createLabelWithFrame:CGRectMake(0, 14, 30, 14) Font:13 Text:@"更多" textAlignment:0];
    
    rightLabel.textColor = WCDarkGray;
    
    [moreView addSubview:rightLabel];
    
    UIImageView *rightIcon = [WenChaoControl createImageViewWithFrame:CGRectMake(30, 14, 7, 14) ImageName:@"gengduo"];
    
    [moreView addSubview:rightIcon];
    
    if (_titleArray.count) {
        
        titleLabel.text = _titleArray[indexPath.section];
        
        if ([_titleArray[indexPath.section] isEqualToString:@"推荐音乐"]) {
            
            iconImage.image = [UIImage imageNamed:@"tuijian"];
            
        } else {
            iconImage.image = [UIImage imageNamed:@"redian"];
        }
    }
}

- (void) moreClick {
    NSLog(@"点击去更多");
}





#pragma mark - UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.playAlbumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        
        cell.backgroundColor = WCClear;
        
        cell.textLabel.text = self.playAlbumArray[indexPath.row];
        
        cell.textLabel.textColor = WCDarkGray;
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    headView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    
    
    UILabel *titleLabel = [WenChaoControl createLabelWithFrame:CGRectMake((WIDTH - 100 ) / 2, 0, 100, 40) Font:18 Text:@"我 的 歌 单" textAlignment:1];
    
    titleLabel.textColor = WCBlack;
    
    [headView addSubview:titleLabel];
    
    
    UIButton *rightBtton = [WenChaoControl createButtonWithFrame:CGRectMake(WIDTH - 40, 0, 40, 40) ImageName:@"backRightBlue" Target:self Action:@selector(moreAlbumClick) Title:nil];
    
    [headView addSubview:rightBtton];

    return headView;
}

- (void) moreAlbumClick {
    
    NSLog(@"更多我的歌单");
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([GCDAsyncSocketManager sharedInstance].connectStatus == 1) {    // 已连接
//        
//        [self postNotify];
//    } else {
//        
//        [CommonUtil showAlertToUnConnected];
//    }
}

-(void)postNotify {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PUSH_ALBUMDETAIL object:nil];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PUSH_ALBUMDETAIL object:nil];
}


@end
