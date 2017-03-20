//
//  ZhuboView.m
//  MS3Tool
//
//  Created by chao on 2016/12/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "ZhuboView.h"

#import "ZhuboCell.h"

#import "ZhuboModel.h"




static NSString *zhuboHeadID = @"zhuboHeadIDdddd";


@interface ZhuboView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation ZhuboView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self =  [super initWithFrame:frame]) {
        
        [self loadData];
        
        [self createUI];
    }
    
    return self;
}


#pragma mark - -- createUI
- (void)createUI {
    
    CGFloat selfHeight = self.height;
    
    CGFloat cWidth = self.width / 3;
    
    /**
     * 设置流布局
     */
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.minimumLineSpacing = 0;
    
    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.itemSize = CGSizeMake(cWidth, cWidth + 68);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    /**
     * 创建UICollectionView
     */
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, selfHeight) collectionViewLayout:flowLayout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    [self addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ZhuboCell" bundle:nil] forCellWithReuseIdentifier:@"ZhuboCellID"];
    
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:zhuboHeadID];
    
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.dataArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.dataArray.count) {
        
        return [self.dataArray[section] count];
    }
    
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZhuboCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZhuboCellID" forIndexPath:indexPath];
    
    if ([self.dataArray count] && [self.dataArray[indexPath.row] count]) {
        
        [cell config:[self.dataArray[indexPath.section] objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:zhuboHeadID forIndexPath:indexPath];
        
        [self setReusableView:reusableView indexPath:indexPath];
        
        return reusableView;
    }
    
    return [[UICollectionReusableView alloc] init];
}

- (void)setReusableView:(UICollectionReusableView *)reusableView indexPath:(NSIndexPath *)indexpath{
    
    for (UIView *subView in reusableView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    reusableView.backgroundColor = WCWhite;
    
    UILabel *titleLabel = [WenChaoControl createLabelWithFrame:CGRectMake(10, 15, 100, 20) Font:16 Text:nil textAlignment:0];
    
    [reusableView addSubview:titleLabel];
    
    UILabel *lineLabel = [WenChaoControl createLabelWithFrame:CGRectMake(10, 40, WIDTH - 20, 1) Font:0 Text:nil textAlignment:0];
    
    lineLabel.backgroundColor = WCGray;
    
//    [reusableView addSubview:lineLabel];
    
    
    if (self.titleArray) {
        
        XMAnnouncerCategory *ac = self.titleArray[indexpath.section];
        
        titleLabel.text = ac.vcategoryName;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(WIDTH, 50);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
}




#pragma mark - -- loadData
- (void)loadData {
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _titleArray = [NSMutableArray arrayWithCapacity:0];
    
    _resultArray = [NSMutableArray arrayWithCapacity:0];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self loadTitleArray];
    });
}

- (void)loadTitleArray {
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_AnnouncerCategory params:nil withCompletionHander:^(id result, XMErrorModel *error) {
        
        __weak typeof(&*self) sself = self;
        
        if (![(NSArray *)result count]) {
            
            [sself loadTitleArray];
            
            return ;
        }
        
        for (NSDictionary *dic in result) {
            
            XMAnnouncerCategory *ac = [[XMAnnouncerCategory alloc] initWithDictionary:dic];
            
            [_titleArray addObject:ac];
        }
        
        [sself loadListArray];
        
    }];
}

- (void)loadListArray {
    
    for (XMAnnouncerCategory *announcer in self.titleArray) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:@(announcer.id) forKey:@"vcategory_id"];
        
        [params setObject:@1 forKey:@"calc_dimension"];
        
        [params setObject:@3 forKey:@"count"];
        
        [params setObject:@1 forKey:@"page"];
        
        
        [[XMReqMgr sharedInstance] requestXMData:XMReqType_AnnouncerList params:params withCompletionHander:^(id result, XMErrorModel *error) {
            
            if (result) {
                
                [self.resultArray addObject:(NSDictionary *)result];
                
                if (self.resultArray.count == self.titleArray.count) {
                    
                    NSLog(@"我找完了");
                    [self reloadDataArray]; //数据全部请求完了并全部保存在了数组中，但是block回调的顺序不能控制，需要重新排序
                }
            } else
                
                [self loadListArray];
            
            
        }];
    }
}

- (void)reloadDataArray {
    
    for (XMAnnouncerCategory *announcerCate in self.titleArray) {
        
        long announcerID = announcerCate.id;
        
        for (NSDictionary *dic in self.resultArray) {
            
            long resultID = [[dic objectForKey:@"vcategory_id"] longValue];
            
            if (announcerID == resultID) {
                
                NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
                
                for (NSDictionary *dataDic in [dic objectForKey:@"announcers"]) {
                    
                    ZhuboModel *model = [ZhuboModel new];
                    
                    [model setValuesForKeysWithDictionary:dataDic];
                    
                    [tempArr addObject:model];
                }
                
                [self.dataArray addObject:tempArr];
            }
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
    });

}
@end
