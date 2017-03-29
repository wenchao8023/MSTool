//
//  KWFenleiDetailVC.m
//  MS3Tool
//
//  Created by chao on 2017/3/8.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWFenleiDetailVC.h"

#import "KWMusicNet.h"

#import "KWCateListCell.h"






static const NSInteger kLimitN = 30;

@interface KWFenleiDetailVC ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong, nonnull) UITableView *tableView;

@property (nonatomic, strong, nonnull) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation KWFenleiDetailVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCBgGray;
    
    self.navigationItem.title = [self.nameDic objectForKey:@"name"];
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
    if ([[MSFooterManager shareManager] getHiddenState]) {
        
        [[MSFooterManager shareManager] setWindowUnHidden];
    }
    
}
-(void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    CGRect frame = self.view.frame;
    
    frame.size.height -= NAVIGATIONBAR_HEIGHT;
    
    self.tableView = [[UITableView alloc] initWithFrame:CONTENTVIEW_FRAME style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = WCClear;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.tableView.mj_footer setHidden:YES];
}



#pragma mark - 懒加载全局变量
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
    
    [net loadKWCategoryDetailDataWithPID:[[self.nameDic objectForKey:@"playId"] integerValue] pn:self.pageNum rn:kLimitN];
    
    net.categoryDetailBlock = ^(NSDictionary *dataDic) {
        
        if ([[dataDic objectForKey:@"data"] objectForKey:@"data"] != [NSNull null]) {
            
            if ([[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"] && [[[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"] count]) {
                
                for (NSDictionary *dic in [[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"]) {
                    
                    KWFenleiDetailModel *model = [KWFenleiDetailModel new];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    model.songId = [dic objectForKey:@"id"];
                    
                    [self.dataArray addObject:model];
                }
                
                [self reloadURLData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [KVNProgress dismiss];
                    
                    [self.tableView reloadData];
                    
                    [self.tableView.mj_header endRefreshing];
                    
                    [self.tableView.mj_footer setHidden:NO];
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView.mj_header endRefreshing];
                    
                    [self.tableView.mj_header setHidden:YES];
                });
            }
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_header endRefreshing];
                
                [self.tableView.mj_header setHidden:YES];
            });
        }
    };
}



-(void)loadMoreData {
    
    self.pageNum += 1;
    
    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    [net loadKWCategoryDetailDataWithPID:[[self.nameDic objectForKey:@"playId"] integerValue] pn:self.pageNum rn:kLimitN];
    
    net.categoryDetailBlock = ^(NSDictionary *dataDic) {
        
        if ([[dataDic objectForKey:@"data"] objectForKey:@"data"] != [NSNull null]) {
            
            if ([[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"] && [[[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"] count]) {
                
                for (NSDictionary *dic in [[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"]) {
                    
                    KWFenleiDetailModel *model = [KWFenleiDetailModel new];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    model.songId = [dic objectForKey:@"id"];
                    
                    [self.dataArray addObject:model];
                }
                
                [self reloadURLData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                    [self.tableView.mj_footer endRefreshing];
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView.mj_footer endRefreshing];
                    
                    [self.tableView.mj_footer setHidden:YES];
                });
            }
            
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_footer endRefreshing];
                
                [self.tableView.mj_footer setHidden:YES];
            });
        }
    };
}

#pragma mark - url
- (void)reloadURLData {
    
    __weak typeof(&*self) sself = self;
    
    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    for (KWFenleiDetailModel *model in self.dataArray) {
        
        [net loadKWMusicDataWithSongid:[self getMusicid:model.songId]];
        
        net.musicUrlBlock = ^(NSDictionary *dataDic) {
            
            // 保存 id 对应的 url
            [sself addMusicStrToModel:dataDic];
        };
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
    });
}
-(void)addMusicStrToModel:(NSDictionary *)dataDic {
    
    for (KWFenleiDetailModel *model in self.dataArray) {
        
        if ([model.songId isEqualToString:[dataDic objectForKey:@"songid"]]) {
            
            model.songUrl = [dataDic objectForKey:@"urlStr"];
        }
    }
}
- (NSString *)getMusicid:(NSString *)rStr {
    
    NSArray *strArr = [rStr componentsSeparatedByString:@"_"];
    
    return [strArr lastObject];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KWCateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KWCateListCellID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KWCateListCell" owner:self options:nil] firstObject];
    }
    
    if (self.dataArray.count) {
        
        [cell configFenleiDetail:self.dataArray[indexPath.row]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *tempMutArr = [NSMutableArray arrayWithCapacity:0];
    
    for (KWFenleiDetailModel *KWModel in self.dataArray) {
        
        MSMusicModel *model = [[MSMusicModel alloc] initWithKWFenleiDetailModel:KWModel];
        
        [tempMutArr addObject:model];
    }
    
    [[VoicePlayer shareInstace] VPSetPlayAlbum:tempMutArr index:(int)indexPath.row];
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
