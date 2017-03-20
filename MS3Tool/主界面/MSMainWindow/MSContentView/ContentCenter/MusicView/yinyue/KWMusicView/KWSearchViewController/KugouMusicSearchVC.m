//
//  KugouMusicSearchVC.m
//  MS3Tool
//
//  Created by chao on 2016/12/8.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "KugouMusicSearchVC.h"

#import "KWMusicNet.h"

#import "KMSearchCell.h"

#import "KMRecordCell.h"

#import "KMSearchModel.h"










@interface KugouMusicSearchVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *textField;


@property (nonatomic, strong) UITableView *searchTableView;

@property (nonatomic, strong) NSMutableArray *searchDataArray;


@property (nonatomic, strong) UITableView *recordTableView;

@property (nonatomic, strong) NSMutableArray *recordDataArray;


@property (nonatomic, strong) NSString *searchStr;


@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation KugouMusicSearchVC

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCWhite;
    
    self.navigationController.navigationBar.hidden = NO;
    
    [[MSFooterManager shareManager] setWindowHidden];
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
}
-(void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self loadData];
    });
}

#pragma mark - 创建界面

- (void) createUI {
    
    /**
     *  创建搜索栏
     */
    [self createTextField];
    
    /**
     *  创建热门搜索和搜索记录
     */
    [self createContentView];
    
    
}


- (void) createTextField {
    
    self.textField = [WenChaoControl createTextFieldWithFrame:CGRectMake(0, 0, WIDTH - 60, 40) placeholder:@"  搜索歌曲" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    
    self.textField.delegate = self;
    
    self.textField.layer.borderColor = WCGray.CGColor;
    
    self.textField.layer.borderWidth = 1;
    
    [self.textField resignFirstResponder];
    
    self.textField.returnKeyType = UIReturnKeySearch;
    
    self.textField.backgroundColor = WCBgGray;
    
    self.textField.layer.cornerRadius = 4;
    
    self.navigationItem.titleView = self.textField;
    
    UIButton *rightButton = [WenChaoControl createButtonWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil Target:self Action:@selector(buttonClick) Title:@"取消"];
    
    [rightButton setTitleColorWithColor:WCWhite andText:@"取消"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void) buttonClick {
    
    NSLog(@"取消搜索");
    
    self.recordTableView.hidden = NO;
    
    self.searchTableView.hidden = YES;
}

- (void) createContentView {
    
    self.searchTableView = [WenChaoControl createTableViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - NAVIGATIONBAR_HEIGHT) delegate:self  style:UITableViewStylePlain];
    
    self.searchTableView.hidden = YES;
    
    self.searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSearchData)];
    
    [self.view addSubview:self.searchTableView];
    
    
    
    self.recordTableView = [WenChaoControl createTableViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - NAVIGATIONBAR_HEIGHT) delegate:self  style:UITableViewStylePlain];
    
    self.recordTableView.hidden = NO;
    
    [self.view addSubview:self.recordTableView];
}


#pragma mark - UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.recordTableView]) {
        
        return _recordDataArray.count;
        
    } else if ([tableView isEqual:self.searchTableView]) {
        
        return _searchDataArray.count;
    }
    
    return 20;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.searchTableView]) {
        
        KMSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMSearchCellID"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"KMSearchCell" owner:self options:nil] firstObject];
        }
        
        if (_searchDataArray.count) {
            
            [cell config:_searchDataArray[indexPath.row]];
        }
        
        return cell;
        
    } else {
        
        KMRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMRecordCellID"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"KMRecordCell" owner:self options:nil] firstObject];
        }
        
        if (_recordDataArray.count) {
            
            [cell config:_recordDataArray[indexPath.row]];
        }
        
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.searchTableView]) {
        
        return 50;
        
    } else {
        
        return 40;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.searchTableView]) {
        
        NSMutableArray *tempMutArr = [NSMutableArray arrayWithCapacity:0];
        
        for (KMSearchModel *KWModel in self.searchDataArray) {
            
            MSMusicModel *model = [[MSMusicModel alloc] initWithKWSearchDetailModel:KWModel];
            
            [tempMutArr addObject:model];
        }
        
        [[VoicePlayer shareInstace] VPSetPlayAlbum:tempMutArr index:(int)indexPath.row];
        
    } else {
        
        NSString *searchStr = _recordDataArray[indexPath.row];
        
        [self loadSearchData:searchStr];
    }
}

#pragma mark - UItextFieldDelegate 
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [self loadSearchData:textField.text];
    
    //这里都写YES
    return YES;
}


#pragma mark - 导入数据
-(NSMutableArray *)searchDataArray {
    
    if (!_searchDataArray) {
        
        _searchDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _searchDataArray;
}

-(NSMutableArray *)recordDataArray {
    
    if (!_recordDataArray) {
        
        _recordDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _recordDataArray;
}


- (void) loadData {

    [self loadRecordData];
    
    self.pageNum = 0;
    
    self.pageCount = 30;
}

- (void) loadSearchData:(NSString *)searchStr {
    
    [CommonUtil addKVNFullScreen:NO status:@"正在搜索..." onView:self.view];
 
    self.searchStr = searchStr;
    
    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    [self.searchDataArray removeAllObjects];
    
    self.pageNum = 0;
    
    [net loadKWSearchData:self.searchStr pn:self.pageNum rn:self.pageCount];
    
    net.searchUrlBlock = ^(NSDictionary *dataDic) {
      
        if ([[dataDic objectForKey:@"data"] objectForKey:@"data"] != [NSNull null]) {
            
            if ([[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"] && [[[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"] count]) {
                
                for (NSDictionary *dic in [[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"]) {
                    
                    KMSearchModel *model = [KMSearchModel new];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    model.songid = [dic objectForKey:@"id"];
                    
                    [self.searchDataArray addObject:model];
                }
                
                [self reloadURLData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [KVNProgress dismiss];
                    
                    self.searchTableView.hidden = NO;
                    
                    self.recordTableView.hidden = YES;
                    
                    [self.searchTableView reloadData];
                });
                
            }
            
            
        }
    };
}

- (void)loadMoreSearchData {

    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    self.pageNum += 1;
    
    [net loadKWSearchData:self.searchStr pn:self.pageNum rn:self.pageCount];
    
    net.searchUrlBlock = ^(NSDictionary *dataDic) {
        
        if ([[dataDic objectForKey:@"data"] objectForKey:@"data"] != [NSNull null]) {
            
            if ([[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"] && [[[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"] count]) {
                
                for (NSDictionary *dic in [[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"musicList"]) {
                    
                    KMSearchModel *model = [KMSearchModel new];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    model.songid = [dic objectForKey:@"id"];
                    
                    [self.searchDataArray addObject:model];
                }
                
                [self reloadURLData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.searchTableView reloadData];

                    [self.searchTableView.mj_footer endRefreshing];
                });
            }
            
        } else {
            
        }
    };
}


- (void)reloadURLData {
    
    __weak typeof(&*self) sself = self;
    
    KWMusicNet *net = [[KWMusicNet alloc] init];
    
    for (KMSearchModel *model in self.searchDataArray) {
        
        [net loadKWMusicDataWithSongid:model.songid];
        
        net.musicUrlBlock = ^(NSDictionary *dataDic) {
            
            // 保存 id 对应的 url
            [sself addMusicStrToModel:dataDic];
        };
    }
}
-(void)addMusicStrToModel:(NSDictionary *)dataDic {
    
    for (KMSearchModel *model in self.searchDataArray) {
        
        if ([model.songid isEqualToString:[dataDic objectForKey:@"songid"]]) {
            
            model.songUrl = [dataDic objectForKey:@"urlStr"];
        }
    }
}





- (void)loadRecordData {
    
    [self.recordDataArray addObjectsFromArray:@[@"成都", @"hotel california", @"刚好遇见你", @"汪峰", @"信", @"梁静茹", @"七月上", @"告白气球"]];
    
    [self.recordTableView reloadData];
}

#pragma mark - touches
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
