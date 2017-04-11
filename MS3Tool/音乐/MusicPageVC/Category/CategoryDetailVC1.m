//
//  CategoryDetailVC1.m
//  MS3Tool
//
//  Created by chao on 2016/11/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "CategoryDetailVC1.h"

#import "CategoryDataManager.h"

#import "MusicFooterView.h"

#import "MSMusicPlayViewController.h"

//#import "MSMusicAlbumView.h"

#import "CDTableViewCell.h"

#import "CDCollectionCell.h"






#define CONTENTVIEW_HEIGHT (SCREENH - NAVIGATIONBAR_HEIGHT - HEIGHT_FOOTERVIEW)

#define TABLEVIEW_WIDTH 80.0f

#define COLLECTION_HEAD_HEIGHT 40.0f

#define TABLEVIEW_CELL_HEIGHT 60.0f



@interface CategoryDetailVC1 ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArrayGet;             // 保存获取的某个分类的所有标题对应的内容，二维数组
@property (nonatomic, strong) NSArray *totalArrayGet;            // 保存获取的某个分类的所有标题对应内容的总数，一维数组
@property (nonatomic, strong) NSArray *titleArrayGet;            // 保存获取的某个分类的所有标题，一维数组，（筛选过的）
@property (nonatomic, strong) NSMutableArray *contentArray;      // 保存获取的某个分类的所有标题，一维数组，（未筛选的，可能有的标题请求回来的数据中的albums为空）
@property (nonatomic, strong) NSMutableArray *dataArrayReloadUI; // 用于点击操作之后刷新UI的数组
@property (nonatomic, strong) NSMutableArray *isOpenArray;       // 用于记录每个分组的点击状态
@property (nonatomic, strong) NSMutableArray *positionArray;     // 用于记录collection每个分组所在的offset.y
@property (nonatomic, assign) NSInteger clickIndex;


@property (nonatomic, strong) CategoryDataManager *dataManager;

@property (nonatomic, strong) MusicFooterView *footerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;




@end

static NSString *CDCollectionHeaderID = @"CDCOLLECTIONHEADERID";

@implementation CategoryDetailVC1

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCBgGray;
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = self.categoryName;
    
    [self.footerView resetSubviews];
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
}
-(void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self createUI];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData];
    });
}
#pragma mark - createUI
-(void)createUI {
    /**
     * 添加tableView
     */
    [self createTableView];
    
    
    /**
     * 添加collectionView
     */
    [self createCollectionView];
    
    
    /**
     * 添加底部视图
     */
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH - HEIGHT_FOOTERVIEW - NAVIGATIONBAR_HEIGHT, SCREENW, HEIGHT_FOOTERVIEW)];
//    [self.view addSubview:bgView];
    
    _footerView = [[MusicFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, HEIGHT_FOOTERVIEW)];
//    [bgView addSubview:_footerView];
    
    __weak typeof(&*self) sself = self;
    
    _footerView.goMusicVC = ^() {
        
        MSMusicPlayViewController *vc = [[MSMusicPlayViewController alloc] init];
        
        [sself presentViewController:vc animated:YES completion:nil];
    };
    
    
    /**
     * 设置歌单视图
     */
//    UIView *albumBgView = [[UIView alloc] initWithFrame:self.view.bounds];
//    
//    albumBgView.y = SCREENH;
//
//    MSMusicAlbumView *albumView = [[MSMusicAlbumView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
//    
//    [albumBgView addSubview:albumView];

    // 打开歌单
//    _footerView.goAlbumView = ^() {
//        
//        [[[UIApplication sharedApplication] keyWindow] addSubview:albumBgView];
//        
//        [UIView animateWithDuration:0.4 animations:^{
//            
//            bgView.y = SCREENH;
//            
//        } completion:^(BOOL finished) {
//            
//            if (finished) {
//                
//                [UIView animateWithDuration:0.2 animations:^{
//                    
//                    albumBgView.y = 0;
//                }];
//            }
//        }];
//    };
//    
//    // 关闭歌单
//    albumView.closeAlbum = ^() {
//        [UIView animateWithDuration:0.4 animations:^{
//            albumBgView.y = SCREENH;
//        } completion:^(BOOL finished) {
//            if (finished) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    bgView.y = SCREENH - HEIGHT_FOOTERVIEW - NAVIGATIONBAR_HEIGHT;
//                } completion:^(BOOL finished) {
//                    [albumBgView removeFromSuperview];
//                }];
//            }
//        }];
//    };
    
    /**
     *  添加通知
     */
//    [self addNotifycation];
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TABLEVIEW_WIDTH, CONTENTVIEW_HEIGHT) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = WCClear;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
}


- (void)createCollectionView {
    
    CGFloat albumCellWidth = (SCREENW - TABLEVIEW_WIDTH) / 2 - 15;
    
    /**
     * 设置流布局
     */
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    flowLayout.itemSize = CGSizeMake(albumCellWidth, albumCellWidth);
    
    //设置头部size
    flowLayout.headerReferenceSize = CGSizeMake(SCREENW, COLLECTION_HEAD_HEIGHT);
    
    /**
     * 创建UICollectionView
     */
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TABLEVIEW_WIDTH, 0, SCREENW - TABLEVIEW_WIDTH, CONTENTVIEW_HEIGHT) collectionViewLayout:flowLayout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = WCClear;
    
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CDCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CDCollectionCellID"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CDCollectionHeaderID];
}

#pragma mark - loadData
-(void)loadData {
    
    self.dataManager = [CategoryDataManager shareInstance];
    
    self.contentArray = [NSMutableArray array];
    
    self.positionArray = [NSMutableArray array];
    
    self.selectIndexPath = [[NSIndexPath alloc] init];
    
    self.clickIndex = 0;
    
    [self loadTitleArray1];
}

//  获取声音标签
- (void)loadTitleArray1 {
    
    __weak typeof(&*self) sself = self;
    
    [self.dataManager loadSoundsAlbumData:self.categoryID];
    
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        if ([dataDic objectForKey:@"isOk"]) {
            
            NSArray *tempArr = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
            
            for (id obj in tempArr) {
                
                XMTag *tag = [[XMTag alloc] initWithDictionary:obj];
                
                [sself.contentArray addObject:tag];
            }
            
            [sself loadTitleArray2];
            
        } else {
            NSLog(@"请求数据失败");
        }
    };
}

//  获取专辑标签
-(void)loadTitleArray2 {
    
    __weak typeof(&*self) sself = self;
    
    [self.dataManager loadZhuanjiAlbumData:self.categoryID];
    
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        if ([dataDic objectForKey:@"isOk"]) {
            
            NSArray *tempArr = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
            
            for (int i = 0; i < tempArr.count; i++) {
                
                XMTag *tag = [[XMTag alloc] initWithDictionary:tempArr[i]];
                // 筛选重复的标题
                if ([self isTagExist:tag] == NO) {
                    
                    [sself.contentArray addObject:tag];
                }
            }
            
            [sself reloadDetailData];
            
        } else {
            NSLog(@"请求数据失败");
        }
    };
    
}

//  判断XMTag是否存在于数组里面
- (BOOL)isTagExist:(XMTag *)tag {
    
    for (XMTag *obj in self.contentArray) {
        
        if ([tag.tagName isEqualToString:obj.tagName]) {
            
            return YES;
        }
    }
    
    return NO;
}

/**
 *  根据上面获取的标签来获取标签里面的数据
 *  点击标题之后再进行请求这里面的数据
 */
-(void)reloadDetailData {
    
    __weak typeof(&*self) sself = self;
    
    self.dataManager = [CategoryDataManager shareInstance];
    
    [self.dataManager loadDetailAlbumData:self.categoryID andArray:self.contentArray];
    
    self.dataManager.dataArrayBlock = ^(NSArray *titleArray, NSArray *dataArray, NSArray *totalCountArray) {
        
        //  titleArray: 字符串标题    dataArray: 对应标题里面的数据,albums  totalCountArray: 每一个标签下的所有数据
        [sself setArrays:titleArray array2:dataArray array3:totalCountArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sself.tableView reloadData];
            [sself.collectionView reloadData];
        });
    };
}

- (void)setArrays:(NSArray *)array1 array2:(NSArray *)array2 array3:(NSArray *)array3 {
    
    NSMutableArray *tempArr1 = [NSMutableArray arrayWithArray:array1];
    NSMutableArray *tempArr2 = [NSMutableArray arrayWithArray:array2];
    NSMutableArray *tempArr3 = [NSMutableArray arrayWithArray:array3];
    
    for (int i = 0; i < tempArr1.count; i++) {
        
        for (int j = i + 1; j < tempArr1.count; j++) {
            
            if (((NSString *)tempArr1[i]).length > ((NSString *)tempArr1[j]).length) {
                [tempArr1 exchangeObjectAtIndex:i withObjectAtIndex:j];
                [tempArr2 exchangeObjectAtIndex:i withObjectAtIndex:j];
                [tempArr3 exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    self.titleArrayGet = [NSArray arrayWithArray:tempArr1];
    self.dataArrayGet = [NSArray arrayWithArray:tempArr2];
    self.totalArrayGet = [NSArray arrayWithArray:tempArr3];
    
    
    [self setOffsetArray];
}

/**
 *  记录每个分组的位置，比标题数组多一个元素
 *  记录了第0个和最后一个的位置
 *  eg：self.clickIndex = 0，对应的位置是 下标为0的位置，下标为1的是记录该分组的最下面的位置
 *  整个分组的位置在 0 - 1
 */
- (void)setOffsetArray {
    CGFloat collectionHeight = (SCREENW - TABLEVIEW_WIDTH) / 2 - 5;
    
    CGFloat nextPosition = 0;
    [self.positionArray addObject:@(nextPosition)];
    for (int i = 0; i < self.dataArrayGet.count; i++) {
        NSInteger count = [self.dataArrayGet[i] count];
        nextPosition += COLLECTION_HEAD_HEIGHT + (count % 2 == 0 ? count / 2 : count / 2 + 1) * collectionHeight;
        [self.positionArray addObject:@(nextPosition)];
    }
}

// 对数组进行排序，按数组中元素的长短顺序排序
-(void)setTitleArrayGet:(NSArray *)titleArrayGet {

    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:titleArrayGet];
    for (int i = 0; i < tempArr.count; i++) {
        
        for (int j = i + 1; j < tempArr.count; j++) {
            
            if (((NSString *)tempArr[i]).length > ((NSString *)tempArr[j]).length) {
                [tempArr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    _titleArrayGet = [NSArray arrayWithArray:tempArr];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArrayGet.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDTableViewCellID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CDTableViewCell" owner:self options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.titleArrayGet.count) {
        
        BOOL isClick = self.clickIndex == indexPath.row ? YES : NO;
        
        [cell config:self.titleArrayGet[indexPath.row] andisClick:isClick];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return TABLEVIEW_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.clickIndex = indexPath.row;
    
    [self.tableView reloadData];
    
    [self setCollectionOffset];
}
- (void)setCollectionOffset {

    [UIView animateWithDuration:0.5 animations:^{
        
        CGPoint offset = self.collectionView.contentOffset;
        
        offset.y = [self.positionArray[self.clickIndex] floatValue];
        
        self.collectionView.contentOffset = offset;
    }];

}


#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.titleArrayGet.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArrayGet[section] count];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDCollectionCellID" forIndexPath:indexPath];
    
    
    // 设置被选中的那个cell的边框
    if (self.dataArrayGet.count) {
        if ([self.dataArrayGet[indexPath.section] count]) {
            [cell config:self.dataArrayGet[indexPath.section][indexPath.row]];
            if ([indexPath isEqual:self.selectIndexPath]) {
                cell.layer.borderWidth = 4;
                cell.layer.borderColor = WCWhite.CGColor;
            } else {
                cell.layer.borderWidth = 0;
            }
        }
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CDCollectionHeaderID forIndexPath:indexPath];
        
        [self setReusableView:reusableView indexPath:indexPath];
        
        return reusableView;
    }
    
    return [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
}

- (void)setReusableView:(UICollectionReusableView *)reusableView indexPath:(NSIndexPath *)indexPath{
    
    for (UIView *subView in reusableView.subviews) {
        [subView removeFromSuperview];
    }
    
    UILabel *centerLabel = [WenChaoControl createLabelWithFrame:CGRectZero Font:14 Text:@"阿斯顿发到付标题" textAlignment:0];
    centerLabel.textColor = WCBlack;
    [reusableView addSubview:centerLabel];
    
    UILabel *leftLineLabel = [WenChaoControl createLabelWithFrame:CGRectZero Font:0 Text:nil textAlignment:0];
    leftLineLabel.backgroundColor = WCDarkGray;
    [reusableView addSubview:leftLineLabel];
    
    UILabel *rightLineLabel = [WenChaoControl createLabelWithFrame:CGRectZero Font:0 Text:nil textAlignment:0];
    rightLineLabel.backgroundColor = WCDarkGray;
    [reusableView addSubview:rightLineLabel];
    
    /**
     *  在重新设置frame之前必须要先赋值
     */
    if (self.titleArrayGet.count) {
        centerLabel.text = self.titleArrayGet[indexPath.section];
    }
    
    if ([self.selectIndexPath isEqual:indexPath]) {
        centerLabel.textColor = WCWhite;
        leftLineLabel.textColor = WCWhite;
        rightLineLabel.textColor = WCWhite;
    } else {
        centerLabel.textColor = WCLightGray;
        leftLineLabel.textColor = WCLightGray;
        rightLineLabel.textColor = WCLightGray;
    }
    
    [self setThreeLabelsFrame:centerLabel label2:leftLineLabel label3:rightLineLabel inView:reusableView];
}

- (void)setThreeLabelsFrame:(UILabel *)label1 label2:(UILabel *)label2 label3:(UILabel *)label3 inView:(UICollectionReusableView *)reusableView {
    
    CGFloat viewWidth = (reusableView.frame.size.width - 20);
    
    CGFloat centerWidth = [label1.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.width;
    
    CGFloat lineWidth = (viewWidth - centerWidth) / 2 - 5;
    
    CGRect centerRect = CGRectMake((viewWidth - centerWidth) / 2 + 10, 20, centerWidth, 20);
    
    label1.frame = centerRect;
    
    
    label2.frame = CGRectMake(10, 0, lineWidth, 1);
    
    label3.frame = CGRectMake(CGRectGetMaxX(label1.frame) + 5, 0, lineWidth, 1);
    
    label2.centerY = label1.centerY;
    
    label3.centerY = label1.centerY;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectIndexPath = indexPath;
    
    [self.collectionView reloadData];
    
    [self.footerView pauseRotate];
    
    // 开辟分线程去请求数据并播放音乐
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self loadMusicWithAlbum:indexPath];
    });
}

- (void)loadMusicWithAlbum:(NSIndexPath *)indexPath {
    [self.dataManager loadMusicWithAlbum:self.dataArrayGet[indexPath.section][indexPath.row]];

    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {

        if ([[dataDic objectForKey:@"isOk"] isEqualToString:@"1"]) {

            NSArray *tempArr = [NSArray arrayWithArray:[[dataDic objectForKey:@"data"] objectForKey:@"tracks"]];
            
            NSMutableArray *tempMutArr = [NSMutableArray arrayWithCapacity:0];

            
            for (NSDictionary *obj in tempArr) {
                
                XMTrack *track = [[XMTrack alloc] initWithDictionary:obj];
                
                MSMusicModel *model = [[MSMusicModel alloc] initWithTrack:track];
                
                [tempMutArr addObject:model];
            }


            [[VoicePlayer shareInstace] VPSetPlayAlbum:tempMutArr index:0];

        } else {
            
            NSLog(@"数据请求失败");
        }
    };
}

#pragma mark - UIScrollViewDelegate - UICollectionViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        [self setTableViewOffset];
    }
}
- (void)setTableViewOffset {

    CGFloat yyy = self.collectionView.contentOffset.y;
    
    if (self.tableView.contentSize.height > CONTENTVIEW_HEIGHT) {
        NSInteger i = 0;
        while ((yyy + CONTENTVIEW_HEIGHT / 2) > [self.positionArray[i] floatValue]) {
            i++;
        }
        self.clickIndex = i == 0 ? 0 : i - 1;
        
        [self.tableView reloadData];
        
        NSInteger cellnumOfContent = CONTENTVIEW_HEIGHT / TABLEVIEW_CELL_HEIGHT;
        
        [UIView animateWithDuration:0.4 animations:^{
            if (self.clickIndex < cellnumOfContent / 2) {   // 最前面几个
                self.tableView.contentOffset = CGPointMake(0, 0);
                
            } else if (self.titleArrayGet.count - self.clickIndex < cellnumOfContent / 2) { //最后面几个
                self.tableView.contentOffset = CGPointMake(0, self.titleArrayGet.count * TABLEVIEW_CELL_HEIGHT - CONTENTVIEW_HEIGHT);
                
            } else {
                self.tableView.contentOffset = CGPointMake(0, (self.clickIndex - cellnumOfContent / 2) * TABLEVIEW_CELL_HEIGHT);
            }
        }];

    }
}

//#pragma mark - addNotifycation
//-(void)addNotifycation {
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicStatus:) name:NOTIFY_PLAYSTATUS object:nil];
//}
//-(void)musicStatus:(NSNotification *)notify {
//    // notify.object, notify.userInfo, notify.name
////    NSInteger status = [notify.object integerValue];
////    if (status == -1) {
////        [self.footerView resetSubviews];
////    }
//}
//-(void)dealloc
//{
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PLAYSTATUS object:nil];
//}



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
