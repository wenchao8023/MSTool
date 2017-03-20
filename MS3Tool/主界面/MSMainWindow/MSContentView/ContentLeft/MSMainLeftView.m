//
//  MSMainLeftView.m
//  MS3Tool
//
//  Created by chao on 2016/12/16.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMainLeftView.h"

#import "UserFooterview.h"

static NSInteger kUserHeaderHeight = 170.f;

static const NSInteger kUserFooterHeight = 175.f;



@interface MSMainLeftView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MSMainLeftView

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        
        self.backgroundColor = WCBgGray;
        
        kUserHeaderHeight = WIDTH - 60.f;
        
        [self createUI];
    }
    
    return self;
}

#pragma mark - createUI
- (void) createUI {
    
    _dataArray = [NSMutableArray arrayWithArray:@[@[@"我的消息"], @[@"账号绑定"], @[@"意见反馈", @"新手帮助", @"联系我们"]]];
    
    [self createHeadView];
    
    [self createTableView];
}

- (void) createHeadView {
    
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kUserHeaderHeight)];
    
    [self addSubview:headV];
    
    _headView = headV;
    
    UIImageView *imageV = [WenChaoControl createImageViewWithFrame:self.headView.frame ImageName:@"voicebgConnect"];
    
    [self.headView addSubview:imageV];
}

- (void) createTableView {
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, kUserHeaderHeight, self.width, self.height - kUserHeaderHeight) style:UITableViewStyleGrouped];
    
    tableV.delegate = self;
    
    tableV.dataSource = self;
    
    tableV.backgroundColor = WCClear;
    
    tableV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    tableV.showsVerticalScrollIndicator = NO;
    
    [self addSubview:tableV];
    
    _tableView = tableV;
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_dataArray) {
        
        return _dataArray.count;
    }
    
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataArray) {
        
        return [_dataArray[section] count];
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *userCellId = @"USERCELLID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellId];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCellId];
        
        cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
        
        cell.textLabel.textColor = WCBlack;
        
        cell.backgroundColor = WCClear;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == _dataArray.count - 1) {
        
        UserFooterview *footerView = [[UserFooterview alloc] initWithFrame:CGRectMake(0, 0, self.width, 150)];
        
        return footerView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section) {
        
        return 10;
    }
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == _dataArray.count - 1) {
        
        return kUserFooterHeight;
    }
    
    return 0.1;
}



@end
