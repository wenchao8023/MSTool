//
//  CategoryView.m
//  MS3Tool
//
//  Created by chao on 2016/11/10.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "CategoryView.h"

#import "CategoryCell.h"

#import "HeadImageView.h"




static NSString *cateHeadViewID = @"cateheadViewIDididid";

#define MSMainHeight_headScrollView (WIDTH * 300 / 640)


@interface CategoryView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) HeadImageView *headView;


@end

@implementation CategoryView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        
        self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
        
        self.dataArray = [NSMutableArray array];
        
        [self createCollection:frame];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self loadData];
        });
    }
    
    return self;
}

#pragma mark - -- 导入数据
- (void)loadData {
    
    [self loadBannerData];
    
    [self loadCategoryData];
}

#pragma mark -- 焦点图数据
// 分类中原焦点图是收费中的焦点图，没有开放，默认用音乐分类的焦点图
- (void)loadBannerData {

    NSMutableArray *bannerArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@10 forKey:@"channel"];
    
    [params setObject:@10 forKey:@"app_version"];
    
    [params setObject:@2 forKey:@"image_scale"];
    
    [params setObject:@2 forKey:@"category_id"];
    
    [params setObject:@"album" forKey:@"content_type"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_CategoryBanner params:params withCompletionHander:^(id result, XMErrorModel *error) {
        
        __weak typeof(&*self) sself = self;
        
        if (![(NSArray *)result count]) {
            
            [sself loadBannerData];
            
            return ;
        }
        
        for (NSDictionary *dic in result) {
            
            XMBanner *banner = [[XMBanner alloc] initWithDictionary:dic];
            
            [bannerArray addObject:banner];
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sself.headView configBanner:bannerArray];
        });
        
    }];
    
}

#pragma mark -- 音乐分类数据
- (void) loadCategoryData {
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_CategoriesList params:nil withCompletionHander:^(id result, XMErrorModel *error) {
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];

        __weak typeof(&*self) sself = self;
        
        if (![(NSArray *)result count]) {
            
            [sself loadCategoryData];
            
            return ;
        }

        for (int i = 0; i < [result count]; i++) {

            XMCategory *category = [[XMCategory alloc] initWithDictionary:[result objectAtIndex:i]];

            [tempArr addObject:category];

            if ((!((i + 1) % 6) && i != 0) || i == [result count] - 1) {

                NSArray *dArr = [NSArray arrayWithArray:tempArr];

                [sself.dataArray addObject:dArr];

                [tempArr removeAllObjects];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sself.collectionView reloadData];
        });
    }];
}

#pragma mark - -- createUI
- (void)createCollection:(CGRect)frame {
    
    CGFloat selfHeight = frame.size.height;
    
    CGFloat VideoCellWidth = WIDTH / 2 - 0.5;
    
    /**
     * 设置流布局
     */
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
//    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    _flowLayout.minimumLineSpacing = 1;
    
    _flowLayout.minimumInteritemSpacing = 0;
    
    _flowLayout.itemSize = CGSizeMake(VideoCellWidth, 40);
    
//    _flowLayout.sectionInset = UIEdgeInsetsMake(40, 0, 0, 0);
    
    /**
     * 创建UICollectionView
     */
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, selfHeight) collectionViewLayout:_flowLayout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = WCClear;
    
    [self addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCellID"];
    
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cateHeadViewID];
}


- (HeadImageView *)headView {
    
    if (!_headView) {
        
        _headView = [[HeadImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, MSMainHeight_headScrollView)];
    }
    
    return _headView;
}


#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (self.dataArray) {
        
        return self.dataArray.count;
        
    }
    
    return 0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.dataArray) {
        
        return [self.dataArray[section] count];
    }
    
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCellID" forIndexPath:indexPath];
    
    cell.layer.borderColor = WCWhite.CGColor;
    
    cell.layer.borderWidth = 0.5;
    
    cell.layer.masksToBounds = YES;
    
    cell.backgroundColor = WCClear;
    
    if (self.dataArray.count) {
        
        [cell config:self.dataArray[indexPath.section][indexPath.row]];
        
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cateHeadViewID forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            
            [self setReusableView:reusableView];
            
        } else {
            
            for (UIView *subView in reusableView.subviews) {
                
                [subView removeFromSuperview];
            }
        }
        
        return reusableView;
    }
    
    return [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
}

- (void)setReusableView:(UICollectionReusableView *)reusableView {
    
    [reusableView addSubview:self.headView];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size = CGSizeMake(WIDTH, 0);
    
    if (section == 0) {
        
        size.height = MSMainHeight_headScrollView;
        
    } else {
        
        size.height = 40;
    }
    
    return size;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XMCategory *category = self.dataArray[indexPath.section][indexPath.row];
    
    self.categoryBlock(category);
}



@end


