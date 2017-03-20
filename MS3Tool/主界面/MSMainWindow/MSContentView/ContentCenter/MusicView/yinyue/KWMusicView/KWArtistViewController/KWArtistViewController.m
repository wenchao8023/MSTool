//
//  KWArtistViewController.m
//  MS3Tool
//
//  Created by chao on 2017/3/7.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWArtistViewController.h"

#import "KWArtistMusicListViewController.h"

#import "KWArtistCell.h"

#import "KWMusicNet.h"


static const NSInteger kNetRN = 30;

@interface KWArtistViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger pageNum;


@end




@implementation KWArtistViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = WCBgGray;
    
    self.navigationItem.title = self.titleStr;
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
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
        
        [self refreshData];
    });
}


-(NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (void)createUI {
    
    CGFloat selfHeight = self.view.height;
    
    CGFloat cWidth = (self.view.width - 40) / 3;
    
    /**
     * 设置流布局
     */
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.minimumLineSpacing = 0;
    
    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.itemSize = CGSizeMake(cWidth, cWidth + 40);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    /**
     * 创建UICollectionView
     */
    _collectionView = [[UICollectionView alloc] initWithFrame:CONTENTVIEW_FRAME collectionViewLayout:flowLayout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = WCClear;
    
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"KWArtistCell" bundle:nil] forCellWithReuseIdentifier:@"KWArtistCellID"];
    
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - loadData
//    加载数据
- (void)refreshData {

    self.pageNum = 0;
    
    [self.dataArray removeAllObjects];
    
    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    [net loadKWArtistListDataWithCate:self.cateid pn:self.pageNum rn:kNetRN];
    
    net.artistListBlock = ^(NSDictionary *dataDic) {
        
        if ([[dataDic objectForKey:@"isOk"] isEqualToString:@"1"]) {    // 数据请求回来了
            
            if ([[dataDic objectForKey:@"data"] objectForKey:@"data"] != [NSNull null]) {
                
                if ([[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"list"] && [[[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"list"] count]) {
                    
                    [self dealDataWithDic:dataDic];
                    
                    self.collectionView.mj_footer.hidden = NO;
                }
            }
        }
    };
}

//    加载更多数据
- (void)loadMoreData {

    self.pageNum += 1;
    
    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    [net loadKWArtistListDataWithCate:self.cateid pn:self.pageNum rn:kNetRN];
    
    net.artistListBlock = ^(NSDictionary *dataDic) {
        
        if ([[dataDic objectForKey:@"isOk"] isEqualToString:@"1"]) {    // 数据请求回来了
            
            if ([[dataDic objectForKey:@"data"] objectForKey:@"data"] != [NSNull null]) {
                
                if ([[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"list"] && [[[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"list"] count]) {
                    
                    [self dealDataWithDic:dataDic];
                } else
                    self.collectionView.mj_footer.hidden = YES;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView.mj_footer endRefreshing];
        });
    };
}

//    处理数据，dataDic 一定有值，判断在回调里面判断，这里只要处理数据就ok了
-(void)dealDataWithDic:(NSDictionary *)dataDic {
    
    for (NSDictionary *dic in [[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"list"]) {
        
        KWArtistModel *model = [[KWArtistModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dic];
        
        model.artistid = [dic objectForKey:@"id"];
        
        [self.dataArray addObject:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
        
        if ([self.collectionView.mj_header isRefreshing]) {
            
            [self.collectionView.mj_header endRefreshing];
        }
        
        if ([self.collectionView.mj_footer isRefreshing]) {
            
            [self.collectionView.mj_footer endRefreshing];
        }
        
        if ([KVNProgress isVisible]) {
            
            [KVNProgress dismiss];
        }
    });
}



#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
        return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KWArtistCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KWArtistCellID" forIndexPath:indexPath];
    
    if (self.dataArray.count) {
        
        [cell config:self.dataArray[indexPath.row]];
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KWArtistMusicListViewController *vc = [[KWArtistMusicListViewController alloc] init];
    
    vc.artistModel = self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];    
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
