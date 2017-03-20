//
//  KWArtistMusicListViewController.m
//  MS3Tool
//
//  Created by chao on 2017/3/7.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWArtistMusicListViewController.h"

#import "KWMusicNet.h"

#import "KWArtistMusicCell.h"



static const CGFloat kTableViewHeadHeight = 270.f;

static const CGFloat kPlayAllViewHeight = 60.f;

static const NSInteger kLimitN = 30;

@interface KWArtistMusicListViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>


@property (nonatomic, strong, nonnull) UIView *headView;

@property (nonatomic, strong, nonnull) UILabel *headLabel;

@property (nonatomic, strong, nonnull) UIImageView *bgImgView;

@property (nonatomic, strong, nonnull) UITableView *tableView;

@property (nonatomic, strong, nonnull) NSMutableArray *dataArray;

@property (nonatomic, assign) int pageNum;


@end

@implementation KWArtistMusicListViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = WCBgGray;
    
    self.headLabel.text = self.artistModel.name;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [CommonUtil addKVNFullScreen:NO status:@"加载中..." onView:self.view];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self loadData];
    });
}

#pragma mark - 创建界面
-(void)createUI {
    
    [self.view addSubview:self.bgImgView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CONTENTVIEW_FRAME_NoNavi style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = WCClear;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = [self createTBHeadView];
    
    [self.view addSubview:self.tableView];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.tableView.mj_footer endRefreshing];
    
    
    [self.view addSubview:self.headView];
    
    
    [self createBackButton];
}

-(void)createBackButton {
    
    UIButton *backButton = [WenChaoControl createButtonWithFrame:CGRectMake(20, 20, 44, 44) ImageName:@"backLeftWhite" Target:self Action:@selector(clickToBack) Title:nil];
    
    [self.view addSubview:backButton];
}

-(void)clickToBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载全局变量
#pragma mark -- 懒加载视图容器
-(UIImageView *)bgImgView {
    
    if (!_bgImgView) {
        
        _bgImgView = [WenChaoControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH) ImageName:nil];
    }
    
    return _bgImgView;
}

-(UIView *)headView {
    
    if (!_headView) {
        
        _headView = [WenChaoControl viewWithFrame:CGRectMake(0, 0, WIDTH, NAVIGATIONBAR_HEIGHT)];
        
        _headView.backgroundColor = WCClear;
        
        [_headView addSubview:self.headLabel];
    }
    
    return _headView;
}

-(UILabel *)headLabel {
    
    if (!_headLabel) {
        
        _headLabel = [WenChaoControl createLabelWithFrame:CGRectMake((WIDTH - 200) / 2, 20, 200, 44) Font:20 Text:nil textAlignment:1];
        
        _headLabel.textColor = WCWhite;
        
        _headLabel.hidden = YES;
    }
    
    return _headLabel;
}

#pragma mark -- 懒加载数据容器
-(NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

#pragma mark - 导入数据
-(void)loadData {
    
    self.pageNum = 0;
    
    [self.dataArray removeAllObjects];
    
    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    [net loadKWArtistListDataWithArtistID:self.artistModel.artistid pn:self.pageNum rn:kLimitN];
    
    net.artistMusiclistBlock = ^(NSDictionary *dataDic) {
        
        if ([[dataDic objectForKey:@"isOk"] intValue] == 1) {    // 数据请求回来了
            
            if ([[dataDic objectForKey:@"data"] objectForKey:@"data"] != [NSNull null]) {
                
                if ([[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musiclist"] && [[[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musiclist"] count]) {
                    
                    [self dealDataWithDic:dataDic];
                    
                    self.tableView.mj_footer.hidden = NO;
                }
            }
        }
    };
}

-(void)loadMoreData {
    
    self.pageNum += 1;
    
    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    [net loadKWArtistListDataWithArtistID:self.artistModel.artistid pn:self.pageNum rn:kLimitN];
    
    net.artistMusiclistBlock = ^(NSDictionary *dataDic) {
        
        if ([[dataDic objectForKey:@"isOk"] intValue] == 1) {    // 数据请求回来了
            
            if ([[dataDic objectForKey:@"data"] objectForKey:@"data"] != [NSNull null]) {
                
                if ([[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musiclist"] && [[[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musiclist"] count]) {
                    
                    [self dealDataWithDic:dataDic];
                    
                    self.tableView.mj_footer.hidden = NO;
                }
            }
        }
    };
}

-(void)dealDataWithDic:(NSDictionary *)dataDic {
    
    for (NSDictionary *dic in [[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musiclist"]) {
        
        KWArtistMusicModel *model = [[KWArtistMusicModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dic];
        
        [self.dataArray addObject:model];
    }
    
    [self reloadURLData];
}

#pragma mark -- 循环获取每条item中的url并保存
- (void)reloadURLData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        KWArtistMusicModel *model = [self.dataArray firstObject];
        
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    });
    
    __weak typeof(&*self) sself = self;
    
    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    for (KWArtistMusicModel *model in self.dataArray) {
        
        [net loadKWMusicDataWithSongid:[self getMusicid:model.musicrid]];
        
        net.musicUrlBlock = ^(NSDictionary *dataDic) {
            // 保存 id 对应的 url
            [sself addMusicStrToModel:dataDic];
        };
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.tableView reloadData];
        
        if ([self.tableView.mj_header isRefreshing]) {
            
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            
            [self.tableView.mj_footer endRefreshing];
        }
        
        if ([KVNProgress isVisible]) {
            
            [KVNProgress dismiss];
        }
    });
}

-(void)addMusicStrToModel:(NSDictionary *)dataDic {
    
    for (KWArtistMusicModel *model in self.dataArray) {
        
        if ([[self getMusicid:model.musicrid] isEqualToString:[dataDic objectForKey:@"songid"]]) {
            
            model.musicUrl = [dataDic objectForKey:@"urlStr"];
        }
    }
}

- (NSString *)getMusicid:(NSString *)rStr {
    
    NSArray *strArr = [rStr componentsSeparatedByString:@"_"];
    
    return [strArr lastObject];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KWArtistMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KWArtistMusicCellID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KWArtistMusicCell" owner:self options:nil] firstObject];
        
        cell.backgroundColor = WCWhite;
    }
    
    if (self.dataArray.count) {
        
        [cell config:self.dataArray[indexPath.row]];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}


-(UIView *)createTBHeadView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kTableViewHeadHeight)];
    
    headView.backgroundColor = WCClear;
    
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, kTableViewHeadHeight - kPlayAllViewHeight, WIDTH, kPlayAllViewHeight)];
    
    buttonView.backgroundColor = WCWhite;
    
    [headView addSubview:buttonView];
    
    // 加载播放图标 和 全部播放Label
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 2, kPlayAllViewHeight)];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAllRandom)];
    
    [leftView addGestureRecognizer:gesture];
    
    [buttonView addSubview:leftView];
    
    UIImageView *playAllImg = [WenChaoControl createImageViewWithFrame:CGRectMake(10, 15, 30, 30) ImageName:nil];
    
    [leftView addSubview:playAllImg];
    
    UILabel *playAllLabel = [WenChaoControl createLabelWithFrame:CGRectMake(50, 0, WIDTH / 2 - 50, 60) Font:16 Text:@"随机播放全部" textAlignment:0];
    
    [leftView addSubview:playAllLabel];
    
    return headView;
}

- (void)playAllRandom {
    
    NSLog(@"随机播放全部");
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.tableView]) {
        
        CGFloat changeHeight = kTableViewHeadHeight - NAVIGATIONBAR_HEIGHT - kPlayAllViewHeight;
        
        CGFloat offsetY = self.tableView.contentOffset.y;
        
        if (offsetY >= 0) {
            
            self.headView.backgroundColor = [UIColor colorWithRed:6 / 255.0 green:71 / 255.0 blue:69 / 255.0 alpha:offsetY / changeHeight];
            
            if (offsetY >= kPlayAllViewHeight) {
                
                _headLabel.hidden = NO;
                
            } else if (offsetY <= kPlayAllViewHeight) {
                
                _headLabel.hidden = YES;
            }
            
            
        } else {
            
            CGRect frame = self.bgImgView.frame;
            
            CGPoint center = self.bgImgView.center;
            
            frame.size.width = fabs(offsetY) / 2 + WIDTH;
            
            frame.size.height = fabs(offsetY) / 2 + WIDTH;
            
            self.bgImgView.frame = frame;
            
            [self.bgImgView setCenter:center];
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *tempMutArr = [NSMutableArray arrayWithCapacity:0];
    
    for (KWArtistMusicModel *KWModel in self.dataArray) {
        
        MSMusicModel *model = [[MSMusicModel alloc] initWithKWArtistMusicModel:KWModel];
        
        [tempMutArr addObject:model];
    }
    
    [[VoicePlayer shareInstace] VPSetPlayAlbum:tempMutArr index:indexPath.row];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
