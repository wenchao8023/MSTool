//
//  KWCateListViewController.m
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWCateListViewController.h"

#import "KWCateDetailViewController.h"

#import "KWArtistViewController.h"

#import "KWFenleiViewController.h"

#import "KWCateListCell.h"


@interface KWCateListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nonnull) UITableView *tableView;

@property (nonatomic, strong, nullable) NSMutableArray *dataArray;

@end

@implementation KWCateListViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = WCBgGray;
    
    self.navigationItem.title = self.cateModel.name;
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
}
-(void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
       [self loadData];
    });
}

- (void)loadData {
    
    self.dataArray = [NSMutableArray arrayWithArray:self.cateModel.children];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

- (void)createUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CONTENTVIEW_FRAME style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
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
        if ([self.cateModel.name isEqualToString:@"歌手大全"])
            [cell configGeShou:self.dataArray[indexPath.row]];
        else if ([self.cateModel.name isEqualToString:@"歌曲排行榜"])
            [cell config:self.dataArray[indexPath.row]];
        else
            [cell config:self.dataArray[indexPath.row] localPic:self.cateModel.catePic];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.cateModel.name isEqualToString:@"歌曲排行榜"]) {   // 歌曲排行榜
        
        KWCateDetailViewController *vc = [[KWCateDetailViewController alloc] init];
        
        vc.headDic = self.dataArray[indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([self.cateModel.name isEqualToString:@"歌手大全"]) { // 歌手
        
        NSDictionary *dataDic = self.dataArray[indexPath.row];
        
        KWArtistViewController *vc = [[KWArtistViewController alloc] init];
        
        vc.cateid = [[dataDic objectForKey:@"id"] integerValue];
        
        vc.titleStr = [dataDic objectForKey:@"name"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {    // 分类
        
        KWFenleiViewController *vc = [[KWFenleiViewController alloc] init];
        
        vc.nameDic = self.dataArray[indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
