//
//  BroadCastDetailVC.m
//  MS3Tool
//
//  Created by chao on 2016/11/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "BroadCastDetailVC.h"

#import "BroadCastCell.h"

#import "MSMusicPlayViewController.h"

#import "XMDataManager.h"

#import "ProvinceSelectedView.h"

#import "ProvinceScrollView.h"

#import "MSFooterManager.h"


#define provinceScrollViewHeight (SCREENH - headViewHeight)



static const NSInteger kPageCount = 20;

static NSInteger kPageNum = 0;



@interface BroadCastDetailVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) XMDataManager *dataManager;

@property (nonatomic, strong) NSMutableArray *shengShiArray;

@property (nonatomic, strong) ProvinceSelectedView *pcollectionView;

@property (nonatomic, strong) ProvinceScrollView *pscrollView;

@property (nonatomic, assign) BOOL isHidPCollectionView;

@property (nonatomic, assign) NSInteger shengShiTaiIndex;



@end

@implementation BroadCastDetailVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = self.titleName;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = WCBgGray;
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
}
-(void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[MSFooterManager shareManager] setWindowVisible];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initContainers];
    
    
    [self createUI];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self loadData];
    });
}

- (void)initContainers {
    
    self.dataManager = [XMDataManager shareInstance];
    
    [self dataArray];
}
#pragma mark - createUI
- (void)createUI {

    /**
     * 创建tableView
     */
    [self myTableViewSetting];
    
    
}
- (void)myTableViewSetting {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH - NAVIGATIONBAR_HEIGHT - HEIGHT_FOOTERVIEW) style:UITableViewStylePlain];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    if (self.clickTag == 222) {
        
        //  scrollView
        self.pscrollView = [[ProvinceScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        
        [self.view addSubview:self.pscrollView];

        
        //  collectionView
        self.pcollectionView = [[ProvinceSelectedView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, provinceScrollViewHeight)];
        
        [self.view addSubview:self.pcollectionView];
        
        self.pcollectionView.hidden = YES;
        
        self.pcollectionView.headView.hidden = YES;
        
        
        
        //  重新设置tableView的frame
        CGRect tbFrame = self.tableView.frame;
        
        self.tableView.frame = CGRectMake(tbFrame.origin.x, tbFrame.origin.y + 40, tbFrame.size.width, tbFrame.size.height - 40);
        
        
        //  点击视图中的控制按钮控制状态
        __weak typeof(&*self) sself = self;
        
        self.pcollectionView.hidSelfBlock = ^() {
            
            sself.isHidPCollectionView = YES;
            
            [sself setTheTwoViewState];
        };
        
        self.pscrollView.hidSelfBlock = ^() {
            
            sself.isHidPCollectionView = NO;
            
            [sself setTheTwoViewState];
        };
        
        //  点击视图中的选项控制
        self.pcollectionView.selectedIndexBlock = ^(NSInteger selectedIndex) {
            
            sself.pscrollView.selectedIndex = selectedIndex;
            
            [sself.pscrollView setButtonsState];
            
            sself.shengShiTaiIndex = selectedIndex;
            
            [sself loadShengshitaiBroadCastData];
        };
        
        self.pscrollView.selectedIndexBlock = ^(NSInteger selectedIndex) {
            
            sself.pcollectionView.selectedIndex = selectedIndex;
            
            [sself.pcollectionView.collectionView reloadData];
            
            sself.shengShiTaiIndex = selectedIndex;
            
            [sself loadShengshitaiBroadCastData];
        };
        
    }
}

- (void)setTheTwoViewState {
    
    if (self.isHidPCollectionView) {
        // 隐藏
        NSLog(@"隐藏");
        [UIView animateWithDuration:0.5 animations:^{
            
            self.pscrollView.hidden = !self.isHidPCollectionView;
            
             self.pcollectionView.headView.alpha = 0;
            
            CGRect frame = self.pcollectionView.collectionView.frame;
            
            frame.size.height = 0;
            
            self.pcollectionView.collectionView.frame = frame;
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                
                self.pcollectionView.headView.hidden = self.isHidPCollectionView;
                
                self.pcollectionView.hidden = self.isHidPCollectionView;
            }
        }];
    } else {
        // 打开
        NSLog(@"打开");
        [UIView animateWithDuration:0.5 animations:^{
            
            self.pcollectionView.hidden = self.isHidPCollectionView;
            
            self.pcollectionView.headView.hidden = self.isHidPCollectionView;
            
            self.pcollectionView.headView.alpha = 1;
            
            CGRect frame = self.pcollectionView.collectionView.frame;
            
            frame.size.height = 340;
            
            self.pcollectionView.collectionView.frame = frame;
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                
                self.pscrollView.hidden = !self.isHidPCollectionView;
            }
        }];
    }
}
#pragma mark - loadData

-(NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (void)loadData {
    
    [self.dataArray removeAllObjects];
    
    self.shengShiTaiIndex = 0;
    
    switch (self.clickTag) {
        case 220:
        {
            [self loadShengShiData];
        }
            break;
        case 221:
        {
            [self loadGuojiataiBroadCastData];
        }
            break;
        case 222:
        {
            [self loadShengShiData];
        }
            break;
        case 223:
        {
            [self loadWangluotaiBroadCastData];
        }
            break;
        case 224:
        {
            [self loadLiveBroadCastData];
        }
            break;
            
        default:
            break;
    }
}
/**
 *  导入省市信息数据
 */
-(void)loadShengShiData {
    
    self.shengShiArray = [NSMutableArray array];
    
    [self.dataManager loadDataWithDic:nil andXMReqType:XMReqType_LiveProvince];
    
    __weak typeof(&*self) sself = self;
    
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        if ([dataDic objectForKey:@"isOk"]) {
            
            NSArray *dataArr = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
            
            for (id obj in dataArr) {
                
                XMProvince *province = [[XMProvince alloc] initWithDictionary:obj];
                
                [sself.shengShiArray addObject:province];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.clickTag == 220) {
                    
                    [sself loadBenditaiBroadCastData];
                    
                } else if (self.clickTag == 222) {
                    
                    [sself loadShengshitaiBroadCastData];
                    
                    //  给省市View赋值
                    sself.pcollectionView.dataArray = sself.shengShiArray;
                    
                    sself.pscrollView.buttonsArray = sself.shengShiArray;
                    
                    //  刷新省市View的UI
                    [sself.pcollectionView.collectionView reloadData];
                    
                    [sself.pscrollView addButtonsToScrollView];
                }
            });
            
        } else {
            
            NSLog(@"数据请求失败, error = %@", [dataDic objectForKey:@"error"]);
        }
        
    };
}

/**
 *  导入本地台数据
 *  正式版需要根据定位获取 用户地理位置
 *  测试版直接定位在 广东
 */
-(void)loadBenditaiBroadCastData {
    
    for (id obj in self.shengShiArray) {
        XMProvince *province = obj;
        
        //  获取本地省份编码
        if ([province.provinceName isEqualToString:@"广东"]) {
            
            /*
             * 开始请求本地数据
             */
            NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
            
            [requestDic setObject:@2 forKey:@"radio_type"];
            
            [requestDic setObject:@(province.provinceCode) forKey:@"province_code"];
            
            [requestDic setObject:@1 forKey:@"page"];
            
            [requestDic setObject:@20 forKey:@"count"];
            
            [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_LiveRadio];
            
            __weak typeof(&*self) sself = self;
            
            self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
                
                if ([dataDic objectForKey:@"isOk"]) {
                    
                    NSArray *dataArr = [NSArray arrayWithArray:[[dataDic objectForKey:@"data"] objectForKey:@"radios"]];
                    
                    for (id obj in dataArr) {
                        
                        XMRadio *radio = [[XMRadio alloc] initWithDictionary:obj];
                        
                        [sself.dataArray addObject:radio];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [sself.tableView reloadData];
                    });
                    
                } else {
                    
                    NSLog(@"数据请求失败, error = %@", [dataDic objectForKey:@"error"]);
                }
                
            };
            
            break;
        }
    }
}


/**
 *  导入国家台数据
 */
-(void)loadGuojiataiBroadCastData {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:@1 forKey:@"radio_type"];
    
    [requestDic setObject:@(kPageNum) forKey:@"page"];
    
    [requestDic setObject:@(kPageCount) forKey:@"count"];
    
    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_LiveRadio];
    
    __weak typeof(&*self) sself = self;
    
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        if ([dataDic objectForKey:@"isOk"]) {
            
            NSArray *dataArr = [NSArray arrayWithArray:[[dataDic objectForKey:@"data"] objectForKey:@"radios"]];
            
            for (id obj in dataArr) {
                
                XMRadio *radio = [[XMRadio alloc] initWithDictionary:obj];
                
                [sself.dataArray addObject:radio];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [sself.tableView reloadData];
            });
            
        } else {
            
            NSLog(@"数据请求失败, error = %@", [dataDic objectForKey:@"error"]);
        }
        
    };
}


/**
 *  导入省市台数据
 */
-(void)loadShengshitaiBroadCastData {
    
    XMProvince *province = self.shengShiArray[self.shengShiTaiIndex];
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:@2 forKey:@"radio_type"];
    
    [requestDic setObject:@1 forKey:@"page"];
    
    [requestDic setObject:@20 forKey:@"count"];
    
    [requestDic setObject:@(province.provinceCode) forKey:@"province_code"];
    
    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_LiveRadio];
    
    __weak typeof(&*self) sself = self;
    
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        if ([dataDic objectForKey:@"isOk"]) {
            
            [sself.dataArray removeAllObjects];
            
            NSArray *dataArr = [NSArray arrayWithArray:[[dataDic objectForKey:@"data"] objectForKey:@"radios"]];
            
            for (id obj in dataArr) {
                
                XMRadio *radio = [[XMRadio alloc] initWithDictionary:obj];
                
                [sself.dataArray addObject:radio];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [sself.tableView reloadData];
            });
            
        } else {
            NSLog(@"数据请求失败, error = %@", [dataDic objectForKey:@"error"]);
        }
        
    };
}


/**
 *  导入网络台数据
 */
-(void)loadWangluotaiBroadCastData {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:@3 forKey:@"radio_type"];
    
    [requestDic setObject:@1 forKey:@"page"];
    
    [requestDic setObject:@20 forKey:@"count"];
    
    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_LiveRadio];
    
    __weak typeof(&*self) sself = self;
    
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        if ([dataDic objectForKey:@"isOk"]) {
            
            NSArray *dataArr = [NSArray arrayWithArray:[[dataDic objectForKey:@"data"] objectForKey:@"radios"]];
            
            for (id obj in dataArr) {
                
                XMRadio *radio = [[XMRadio alloc] initWithDictionary:obj];
                
                [sself.dataArray addObject:radio];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [sself.tableView reloadData];
            });
            
        } else {
            NSLog(@"数据请求失败, error = %@", [dataDic objectForKey:@"error"]);
        }
        
    };
}


/**
 *  导入广播排行榜数据
 */
-(void)loadLiveBroadCastData {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:@40 forKey:@"radio_count"];
    
    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_RankRadio];
    
    __weak typeof(&*self) sself = self;
    
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        if ([dataDic objectForKey:@"isOk"]) {
            
            NSArray *dataArr = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
            
            for (id obj in dataArr) {
                
                XMRadio *radio = [[XMRadio alloc] initWithDictionary:obj];
                
                [sself.dataArray addObject:radio];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [sself.tableView reloadData];
            });
            
        } else {
            NSLog(@"数据请求失败, error = %@", [dataDic objectForKey:@"error"]);
        }
        
    };
}

#pragma mark -- 刷新加载更多数据
- (void)loadMoreData {
    
    self.dataArray = [NSMutableArray array];
    
    self.dataManager = [XMDataManager shareInstance];
    
    self.shengShiTaiIndex = 0;
    
    switch (self.clickTag) {
        case 220:
        {
            [self loadShengShiData];
        }
            break;
        case 221:
        {
            [self loadGuojiataiBroadCastData];
        }
            break;
        case 222:
        {
            [self loadShengShiData];
        }
            break;
        case 223:
        {
            [self loadWangluotaiBroadCastData];
        }
            break;
        case 224:
        {
            [self loadLiveBroadCastData];
        }
            break;
            
        default:
            break;
    }
}




#pragma makr - actions


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray) {
        
        return self.dataArray.count;
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BroadCastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BroadCastCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BroadCastCell" owner:self options:nil] firstObject];
    }
    
    if (self.dataArray) {
        [cell config:self.dataArray[indexPath.row] andIndex:indexPath.row + 1];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
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
