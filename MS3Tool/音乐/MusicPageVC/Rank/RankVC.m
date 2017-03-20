//
//  RankVC.m
//  sdkTest
//
//  Created by chao on 2016/11/4.
//  Copyright © 2016年 nali. All rights reserved.
//

#import "RankVC.h"
#import "XMDataManager.h"
#import "XMSDK.h"
#import "ItemCell.h"
#import "RankAlbumTableView.h"


#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface RankVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XMDataManager *dataManager;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UITableView *itemsTableView;
@property (nonatomic, strong) NSMutableArray *itemsArray;

@end

@implementation RankVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = [NSString stringWithFormat:@"Recommand"];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData];
    });
    
    [self createUI];
}
- (void)loadData {
    self.dataManager = [XMDataManager shareInstance];
    _itemsArray = [NSMutableArray arrayWithCapacity:0];
    
//    NSMutableArray *sectionListArr = [NSMutableArray array];
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:@1 forKey:@"rank_type"];
    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_RankList];
    
    __weak __typeof(&*self) sself = self;
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        NSArray *tempArr = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
        for (id obj in tempArr) {
            XMRankSectionList *rankList = [[XMRankSectionList alloc] initWithDictionary:obj];
            NSLog(@"coverImage: %@", rankList.coverUrl);
//            [sectionListArr addObject:rankList];
            [sself.itemsArray addObject:rankList];
        }
//        [sself.itemsArray addObject:sectionListArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [sself.itemsTableView reloadData];
       });
    };
    
//    NSMutableArray *radioArr = [NSMutableArray array];
//    
//    [requestDic removeAllObjects];
//    [requestDic setObject:@20 forKey:@"radio_count"];
//    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_RankRadio]; // 直播接口，返回电视台在线直播列表
//    
//    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
//        NSArray *tempArr = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
//        
//        NSDictionary *testDic = [NSDictionary dictionaryWithDictionary:[tempArr firstObject]];
//        
//        if ([[testDic objectForKey:@"kind"] isEqualToString:@"radio"]) {
//            for (id obj in tempArr) {
//                XMRadio *radio = [[XMRadio alloc] initWithDictionary:obj];
//                NSLog(@"coverImage: %@", radio.coverUrlSmall);
//                [radioArr addObject:radio];
//            }
//            
////            [sself.itemsArray insertObject:radioArr atIndex:1];
//            [sself.itemsArray addObject:radioArr];
//        } else {
//            for (id obj in tempArr) {
//            XMRankSectionList *rankList = [[XMRankSectionList alloc] initWithDictionary:obj];
//            NSLog(@"coverImage: %@", rankList.coverUrl);
//            [sectionListArr addObject:rankList];
//            }
//            
////            [sself.itemsArray insertObject:sectionListArr atIndex:0];
//            [sself.itemsArray addObject:sectionListArr];
//        }
//        
//        if (sself.itemsArray.count == 2) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [sself.itemsTableView reloadData];
//            });
//        }
//        
//    };
}

- (void)createUI {
    self.itemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH - 24) style:UITableViewStyleGrouped];
    self.itemsTableView.delegate = self;
    self.itemsTableView.dataSource = self;
    [self.view addSubview:self.itemsTableView];
}

#pragma mark - UITableViewDelegate

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (_itemsArray.count) {
//        return _itemsArray.count;
//    }
//    
//    return 0;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_itemsArray.count) {
        return [_itemsArray count];
    }
    
    return 0;
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (_itemsArray.count) {
//        return [_itemsArray[section] count];
//    }
//    
//    return 0;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil] firstObject];
    }
    

    if (_itemsArray.count) {
        [cell config:_itemsArray[indexPath.row]];
    }
//    if (_itemsArray.count) {
//        [cell config:_itemsArray[indexPath.section][indexPath.row]];
//    }
    
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 150)];
        headView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 100)];
        imageV.backgroundColor = [UIColor cyanColor];
        [headView addSubview:imageV];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imageV.frame), 80, 50)];
        descLabel.text = @"节目榜单";
        [headView addSubview:descLabel];
        
        return headView;
    }
    
    if (section == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 50)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        descLabel.text = @"主播榜单";
        [headView addSubview:descLabel];
        
        return headView;
    }
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 150.0;
    }
    
    if (section == 1) {
        return 50;
    }
    
    return 0.01;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMRankSectionList *list = _itemsArray[indexPath.row];
    
    RankAlbumTableView *vc = [[RankAlbumTableView alloc] init];
    vc.rankKey = list.rankKey;
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
