//
//  KWMusicView.m
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWMusicView.h"

#import "KWCategoryCell.h"

#import "KWMusicNet.h"



static const NSInteger kButtonsHeight = 60;

typedef enum : NSInteger {
    
    tag_gequbtn,
    
    tag_geshoubtn
    
}ButtonTag;

@interface KWMusicView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, nonnull, strong) UICollectionView *collectionView;

@property (nonatomic, nonnull, strong) NSMutableArray *dataArray;

@property (nonatomic, nonnull, strong) KWCategoryListModel *geshouModel;

@property (nonatomic, nonnull, strong) KWCategoryListModel *bangModel;

@end

@implementation KWMusicView

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self loadData];
        });
    }
    
    return self;
}

#pragma mark - 导入数据
-(void)loadData {
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self loadCateData];
    
    [self loadBangData];
    
    [self loadGeshouData];
}

-(void)loadCateData {
    
    NSArray *imgsArr = @[@"xinqing", @"xinqing", @"changjing", @"zhuti", @"yuyan", @"tese", @"fengge"];
    
    KWMusicNet *net = [KWMusicNet new];
    
    [net loadKWCategory];
    
    net.categoryListBlock = ^(NSDictionary *dataDic) {
        
        NSArray *tempArr = [[dataDic objectForKey:@"data"] objectForKey:@"data"];
        
        for (int i = 0; i < tempArr.count; i++) {
            
            NSDictionary *tempDic = tempArr[i];
            
            KWCategoryListModel *model = [KWCategoryListModel new];
            
            [model setValuesForKeysWithDictionary:tempDic];
            
            model.catePic = imgsArr[i];
            
            [self.dataArray addObject:model];
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
            
            [self.collectionView.mj_header endRefreshing];
        });
        
    };
}

-(void)loadBangData {
    
    self.bangModel = [[KWCategoryListModel alloc] init];
    
    KWMusicNet *net = [KWMusicNet new];
    
    [net loadKWBang];
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    
    net.bangListBlock = ^(NSDictionary *dataDic) {
      
        NSArray *classArr = [[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"classify"]; //内地榜
        
        NSArray *worldArr = [[[dataDic objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"world"]; //世界榜
        
        /*
         name id pic info
         */
        
        [tempArr addObjectsFromArray:classArr];
        
        [tempArr addObjectsFromArray:worldArr];
        
        self.bangModel.name = @"歌曲排行榜";
        
        self.bangModel.children = tempArr;
    };
}



-(void)loadGeshouData {
    
    self.geshouModel = [[KWCategoryListModel alloc] init];
    
    NSArray *tempArr = @[@"全部歌手", @"华语男歌手", @"华语女歌手", @"华语组合", @"日韩男歌手", @"日韩女歌手", @"日韩歌手", @"欧美男歌手", @"欧美女歌手", @"欧美歌手"];
    
    NSMutableArray *childArr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < tempArr.count; i++) {
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        
        [tempDic setObject:tempArr[i] forKey:@"name"];
        
        [tempDic setObject:@(i) forKey:@"id"];
        
        [childArr addObject:tempDic];
    }
    
    self.geshouModel.name = @"歌手大全";
    
    self.geshouModel.children = childArr;
    
    self.geshouModel.catId = -1;
}

#pragma mark - 创建界面
-(void)createUI {
    
    self.backgroundColor = WCBgGray;
    
    [self createHeadButtons];
    
    [self createCollectionView];
}

- (void)createHeadButtons {
    
    NSArray *btnTitleArr = @[@"歌曲排行榜", @"歌手排行榜"];
    
    for (int i = 0; i < btnTitleArr.count; i++) {
        
        UIButton *button = [WenChaoControl createButtonWithFrame:CGRectMake(WIDTH / 2 * i, 10, WIDTH / 2, 40) ImageName:nil Target:self Action:@selector(buttonClick:) Title:btnTitleArr[i]];
        
        button.tag = tag_gequbtn + i;
        
        button.layer.borderColor = WCLightGray.CGColor;
        
        button.layer.borderWidth = 1;
        
        button.layer.masksToBounds = YES;
        
        [self addSubview:button];
    }
}
- (void)buttonClick:(UIButton *)button {
    
    if (button.tag == tag_geshoubtn) {
        
        [self postNotify:self.geshouModel];
        
    } else {
        
        [self postNotify:self.bangModel];
    }
}
- (void)createCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
 
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kButtonsHeight, self.frame.size.width, self.frame.size.height - kButtonsHeight) collectionViewLayout:flowLayout];
    
    collectionView.backgroundColor = WCClear;
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    [self addSubview:collectionView];
    
    _collectionView = collectionView;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"KWCategoryCell" bundle:nil] forCellWithReuseIdentifier:@"KWCategoryCellID"];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    KWCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KWCategoryCellID" forIndexPath:indexPath];
    
    if (self.dataArray.count) {
        
        [cell config:self.dataArray[indexPath.row]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self postNotify:self.dataArray[indexPath.row]];
}


#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat albumCellWidth = (self.width - 33) / 2;

    return CGSizeMake(albumCellWidth, albumCellWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 11, 0, 11);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(WIDTH, 11);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 11;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

-(void)postNotify:(KWCategoryListModel *)model {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PUSH_CATELIST object:model];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PUSH_CATELIST object:nil];
}
@end
