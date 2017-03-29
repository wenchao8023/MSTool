//
//  SmartHomeVC.m
//  MS3Tool
//
//  Created by chao on 2017/2/14.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "SmartHomeVC.h"

#import "SmartHomeCell.h"



@interface SmartHomeVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonnull, nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonnull, nonatomic, strong) UICollectionView *collectionView;

@property (nonnull, nonatomic, strong) NSArray *deviceNameArray;

@property (nonnull, nonatomic, strong) NSArray *deviceImgArray;

@property (nonnull, nonatomic, copy) NSString *introStr;


@end


static NSString *cateHeadViewID = @"SmartHomeVCheadViewID";



@implementation SmartHomeVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCBgGray;
    
    self.navigationItem.title = @"智能家居";
    
    [[MSFooterManager shareManager] setWindowHidden];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
}
-(void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    [self createUI];
}

- (void)loadData {
    
    _deviceNameArray = @[@"冰箱", @"插座", @"窗帘",
                         @"灯", @"电饭煲", @"电风扇",
                         @"加湿器", @"净化器", @"开关",
                         @"烤箱", @"空调", @"晾衣机",
                         @"热水器", @"水壶", @"洗衣机",
                         @"烟机"];
    
    _deviceImgArray = @[@"bx-01", @"cz-01", @"cl-01",
                         @"d-01", @"fg-01", @"fs-01",
                         @"jsq-01", @"jhq-01", @"kg-01",
                         @"wbl-01", @"kg-01", @"yj-01",
                         @"rsq-01", @"rsh-01", @"xyj-01",
                         @"yj-01"];
    
    _introStr = @"MS3音箱作为智能家居的控制中心，可以通过语音来控制加点，支持多种设备，点击下方的添加按钮，解放双手，开启智能生活!";
}

- (void)createUI {
    
    CGFloat selfHeight = self.view.frame.size.height - 64;
    
    CGFloat VideoCellWidth = WIDTH / 3;
    
    /**
     * 设置流布局
     */
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    _flowLayout.minimumLineSpacing = 1;
    
    _flowLayout.minimumInteritemSpacing = 0;
    
    _flowLayout.itemSize = CGSizeMake(VideoCellWidth, VideoCellWidth);
    
    //    _flowLayout.sectionInset = UIEdgeInsetsMake(40, 0, 0, 0);
    _flowLayout.headerReferenceSize = CGSizeMake(SCREENW, SCREENW + 40);
    
    /**
     * 创建UICollectionView
     */
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, selfHeight) collectionViewLayout:_flowLayout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = WCWhite;
    
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SmartHomeCell" bundle:nil] forCellWithReuseIdentifier:@"SmartHomeCellID"];
    
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cateHeadViewID];
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.deviceNameArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SmartHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmartHomeCellID" forIndexPath:indexPath];
    
    cell.backgroundColor = WCClear;
    
    [cell configNameStr:self.deviceNameArray[indexPath.row] imgStr:self.deviceImgArray[indexPath.row]];
    
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
    
    // 添加头视图
//    [reusableView addSubview:];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENW)];
    
    headView.backgroundColor = WCClear;
    
    [reusableView addSubview:headView];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENW / 2)];

    headImage.image = [UIImage imageNamed:@"smartHomeHeadImg"];
    
    headImage.backgroundColor = WCRed;
    
    [headView addSubview:headImage];
    
    UILabel *infoLabel = [WenChaoControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(headImage.frame), SCREENW - 40, SCREENW / 10 * 3) Font:14 Text:_introStr textAlignment:0];
    
    [headView addSubview:infoLabel];
    

    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(infoLabel.frame) + 10, SCREENW - 40, SCREENW / 10 * 2 - 20)];
    
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    
    [addButton setTitle:@"+添加设备" forState:UIControlStateNormal];
    
    addButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    addButton.layer.cornerRadius = (SCREENW / 10 * 2 - 20) / 2;
    
    addButton.backgroundColor = WCDarkBlue;
    
    [addButton setTitleColor:WCWhite forState:UIControlStateNormal];
    
    [headView addSubview:addButton];
    
    
    UILabel *lineLabel = [WenChaoControl createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), SCREENW, 40) Font:16 Text:@"\t推荐智能设备" textAlignment:0];
    
    lineLabel.backgroundColor = WCBgGray;
    
    [reusableView addSubview:lineLabel];
}

- (void)addClick {
    
    NSLog(@"添加设备");
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
