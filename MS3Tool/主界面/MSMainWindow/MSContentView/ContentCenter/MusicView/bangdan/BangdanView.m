//
//  BangdanView.m
//  MS3Tool
//
//  Created by chao on 2016/12/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "BangdanView.h"

#import "BangdanCell.h"

#import "HeadImageView.h"


static CGFloat const kTitleHeight = 40.f;

@interface BangdanView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *bannerArray;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation BangdanView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self =  [super initWithFrame:frame]) {
        
        [self loadData];
        
        [self createUI];
    }
    
    return self;
}


#pragma mark - -- createUI 
- (void)createUI {
    
    [self addSubview:self.tableView];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
    }
    
    return _tableView;
}


#pragma mark - -- UITableViewDelegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.dataArray.count) {
        
        return self.dataArray.count;
        
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.dataArray[section] count]) {
        
        return [self.dataArray[section] count];
        
    }  else {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BangdanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BangdanCellID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BangdanCell" owner:self options:nil] firstObject];
    }
    
    
    if ([self.dataArray[indexPath.section] count]) {
        
        if (indexPath.section == 0) {
            
            [cell configRankList:self.dataArray[0][indexPath.row]];
            
        } else {
            
            [cell configRadio:self.dataArray[1][indexPath.row]];
        }
    }

    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView;
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, MSMainHeight_headScrollView + kTitleHeight)];
    
    HeadImageView *head = [[HeadImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, MSMainHeight_headScrollView)];
    
    [headView addSubview:head];
    
    UILabel *titleLabel = [WenChaoControl createLabelWithFrame:CGRectMake(20, 10 + MSMainHeight_headScrollView, 100, 20) Font:14 Text:_titleArray[section] textAlignment:0];
    
    [headView addSubview:titleLabel];
    
    if (self.bannerArray.count) {
        
        [head configBanner:self.bannerArray];
    }
    
    if (section == 1) {
        
        head.hidden = YES;
        
        headView.frame = CGRectMake(0, 0, WIDTH, kTitleHeight);
        
        titleLabel.frame = CGRectMake(20, 10, 100, 20);
    }

    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return MSMainHeight_headScrollView + kTitleHeight;
        
    } else {
        
        return kTitleHeight;
    }
}



#pragma mark - -- loadData
- (void)loadData {

    _titleArray = @[@"节目榜单", @"电台榜单"];
    
    _bannerArray = [NSMutableArray arrayWithCapacity:0];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self loadBDBannerData];
        
        [self loadJimuData];
        
        [self loadGuangboData];
    });
}

- (void)loadBDBannerData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@10 forKey:@"channel"];
    
    [params setObject:@10 forKey:@"app_version"];
    
    [params setObject:@2 forKey:@"image_scale"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_RankBanner params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        XMBanner *banner = [[XMBanner alloc] initWithDictionary:(NSDictionary *)[result firstObject]];
        
        [self.bannerArray addObject:banner];
        
        [self reloadTableView];
    }];
}

- (void)loadJimuData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@1 forKey:@"rank_type"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_RankList params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *dic in result) {
            
            XMRankSectionList *rankList = [[XMRankSectionList alloc] initWithDictionary:dic];
            
            [tempArr addObject:rankList];
        }
        
        [self.dataArray addObject:tempArr];
        
        [self reloadTableView];
    }];
    
}

- (void)loadGuangboData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@10 forKey:@"radio_count"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_RankRadio params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *dic in result) {
            
            XMRadio *radio = [[XMRadio alloc] initWithDictionary:dic];
            
            [tempArr addObject:radio];
        }
        
        [self.dataArray addObject:tempArr];
        
        [self reloadTableView];
    }];
}

- (void)reloadTableView {
    
    if (self.dataArray.count && [self.dataArray[0] count] && self.dataArray.count == 2 && self.bannerArray.count) {
        
        id obj = self.dataArray[0][0];
        
        if (![obj isKindOfClass:[XMRankSectionList class]]) {
            
            [self.dataArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }
        
        __weak typeof(&*self) sself = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sself.tableView reloadData];
        });
    }
}


@end
