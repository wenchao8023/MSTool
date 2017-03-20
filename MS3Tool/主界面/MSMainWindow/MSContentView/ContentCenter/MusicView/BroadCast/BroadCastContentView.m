//
//  BroadCastContentView.m
//  MS3Tool
//
//  Created by chao on 2016/11/8.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "BroadCastContentView.h"

#import "BroadCastCell.h"

#import "BroadCastView.h"




#define IMAGEHEADHEIGHT ((SCREENW - 100) / 4)

#define BROADCASTTBHEADVIEW_HEIGHT (80 + IMAGEHEADHEIGHT)



@interface BroadCastContentView ()<UITableViewDelegate, UITableViewDataSource, XMLivePlayerDelegate>


@property (nonatomic, strong) XMSDKPlayer *player;

@end

@implementation BroadCastContentView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        
        [self createUIWithFrame:frame];
        
        self.player = [XMSDKPlayer sharedPlayer];
        
        self.player.livePlayDelegate = self;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self loadData];
        });
        
        
    }
    
    return self;
}

- (void)loadData {
    
    self.dataArray = [NSMutableArray array];
    
    NSArray *firstArr = [NSArray array];
    
    [self.dataArray addObject:firstArr];
    
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@10 forKey:@"radio_count"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_RankRadio params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        __weak typeof(&*self) sself = self;
        
        if (![(NSArray *)result count]) {
            
            [sself loadData];
            
            return ;
        }
        
        for (NSDictionary *dic in result) {
            
            XMRadio *radio = [[XMRadio alloc] initWithDictionary:dic];
            
            [tempArr addObject:radio];
        }
        
        [self.dataArray addObject:tempArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    }];
}

-(void)createUIWithFrame:(CGRect)frame {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray) {
        return self.dataArray.count;
    }
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray) {
        return [self.dataArray[section] count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BroadCastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BroadCastCellID"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BroadCastCell" owner:self options:nil] firstObject];
    }
    
    if ([self.dataArray[indexPath.section] count]) {
        XMRadio *radio = self.dataArray[indexPath.section][indexPath.row];
        [cell config:radio andIndex:indexPath.row + 1];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        BroadCastView *bcView = [[BroadCastView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, BROADCASTTBHEADVIEW_HEIGHT)];
        
        __weak typeof(&*self) sself = self;
        bcView.clickBlock = ^(NSInteger clickTag) {
            sself.presentClickBlock(clickTag);
        };
        
        return bcView;
    }
    
    if (section == 1) {
        UIView *shView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 50)];
        
        shView.backgroundColor = WCWhite;
        
        UILabel *titleLabel = [WenChaoControl createLabelWithFrame:CGRectMake(10, 0, 100, 50) Font:14 Text:@"广播排行榜" textAlignment:0];
        [shView addSubview:titleLabel];
        
        UIButton *moreBtn = [WenChaoControl createButtonWithFrame:CGRectMake(SCREENW - 50, 0, 40, 50) ImageName:@"backRightBlue" Target:self Action:@selector(clickToMoreBroadCast) Title:nil];
        [shView addSubview:moreBtn];
        
        return shView;
    }
    
    return nil;
}

-(void)clickToMoreBroadCast {
    NSLog(@"点击去更多广播啊");
    self.presentClickBlock(224);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80 + IMAGEHEADHEIGHT;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    XMRadio *radio = self.dataArray[indexPath.section][indexPath.row];
//    [self.playerManager playerWithUrl:radio.rate64TsUrl];
    
//    [self.player startLivePlayWithRadio:radio];
    
    
    
}

#pragma mark - UITableViewDataSource
@end
