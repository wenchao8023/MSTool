//
//  AlbumDetailViewController.m
//  MS3Tool
//
//  Created by 郭文超 on 2017/3/12.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "AlbumDetailViewController.h"

#import "MSMusicModel.h"

#import "KMSearchCell.h"




@interface AlbumDetailViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) CMDDataConfig *dataConfig;

@end

@implementation AlbumDetailViewController

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCWhite;
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"收藏歌曲";
    
    [[MSFooterManager shareManager] setWindowHidden];
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
}
-(void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    self.dataConfig = [CMDDataConfig shareInstance];
    
    MSMusicModel *model = [[MSMusicModel alloc] init];
    
    model.songName = @"成都";
    
    model.singerName = @"赵雷";
    
    model.albumName = @"歌手第一季 第三期";
    
    model.coverImgLarge = @"http://img1.kwcdn.kuwo.cn/star/albumcover/500/65/63/79091060.jpg";
    
    model.coverImgSmall = @"http://img1.kwcdn.kuwo.cn/star/albumcover/500/65/63/79091060.jpg";
    
    model.duration = 329;
    
    model.playUrl = @"http://ip.h5.ri01.sycdn.kuwo.cn/c78b9f66c3d38ae1eaed99845d83c5fa/58c6189c/resource/n1/60/76/1761940283.mp3";
    
    [self.dataArray addObject:model];
    
    
    MSMusicModel *model1 = [[MSMusicModel alloc] init];
    
    model1.songName = @"HOTEL CALIFORNIA 加州旅馆";
    
    model1.singerName = @"HIVI:惠威试音天碟2";
    
    model1.albumName = @"歌手第一季 第三期";
    
    model1.coverImgLarge = @"http://img1.kwcdn.kuwo.cn/star/albumcover/100/98/74/2780547595.jpg";
    
    model1.coverImgSmall = @"http://img1.kwcdn.kuwo.cn/star/albumcover/100/98/74/2780547595.jpg";
    
    model1.duration = 259;
    
    model1.playUrl = @"http://ip.h5.rb01.sycdn.kuwo.cn/211b5d9c9e7899b7c332559b09c2955c/58c61f16/resource/n3/48/73/2419450487.mp3";
    
    [self.dataArray addObject:model1];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        [self loadData];
//    });
}

-(UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

-(NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

-(void)loadData {
    
    [self.dataConfig addObserver:self forKeyPath:@"collectAlbum" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"collectAlbum"]) {
        
        [self.dataArray removeAllObjects];
        
        [self.dataArray addObjectsFromArray:self.dataConfig.collectAlbum];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KMSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMSearchCellID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KMSearchCell" owner:self options:nil] firstObject];
    }
    
    
        
    [cell configAlbumDetail:self.dataArray[indexPath.row]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[VoicePlayer shareInstace] VPSetPlayAlbum:self.dataArray index:(int)indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.f;
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
