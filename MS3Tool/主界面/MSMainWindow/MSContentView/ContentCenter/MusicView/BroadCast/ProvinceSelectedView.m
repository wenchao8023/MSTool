//
//  ProvinceSelectedView.m
//  MS3Tool
//
//  Created by chao on 2016/11/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "ProvinceSelectedView.h"
#import "ProvinceSelectedCell.h"

@interface ProvinceSelectedView ()<UICollectionViewDelegate, UICollectionViewDataSource>





@end

@implementation ProvinceSelectedView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.selectedIndex = 0;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    /**
     * 设置头部视图
     */
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 40)];
    
    self.headView.backgroundColor = WCWhite;
    
    UILabel *headTitleLabel = [WenChaoControl createLabelWithFrame:CGRectMake(20, 10, 100, 20) Font:12 Text:@"切换省市台" textAlignment:0];
    
    headTitleLabel.textColor = WCLightGray;
    
    [self.headView addSubview:headTitleLabel];
    
    
    UIButton *selectedBtn = [WenChaoControl createButtonWithFrame:CGRectMake(SCREENW - 60, 0, 40, 40) ImageName:nil Target:self Action:@selector(btnClick) Title:nil];
    
    [selectedBtn setBackgroundImage:[UIImage imageNamed:@"backUpBlue"] forState:UIControlStateNormal];
    
    [self.headView addSubview:selectedBtn];
    
    
    UILabel *lineLabel = [WenChaoControl createLabelWithFrame:CGRectMake(0, 39, SCREENW, 1) Font:0 Text:nil textAlignment:0];
    
    lineLabel.backgroundColor = WCLightGray;
    
    [self.headView addSubview:lineLabel];
    
    [self addSubview:self.headView];
    
    CGFloat VideoCellWidth = SCREENW / 5;
    
    /**
     * 设置流布局
     */
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(VideoCellWidth, 30);
    //设置头部size
    flowLayout.headerReferenceSize = CGSizeMake(SCREENW, 0);
    
    /**
     * 创建UICollectionView
     */
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREENW, 0) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = WCWhite;
    [self addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ProvinceSelectedCell" bundle:nil] forCellWithReuseIdentifier:@"ProvinceSelectedCellID"];
}

- (void)btnClick {
    NSLog(@"收起来吧，骚年");
    self.hidSelfBlock();
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"收起来吧，骚年");
    self.hidSelfBlock();
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray) {
        return self.dataArray.count;
    }
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProvinceSelectedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProvinceSelectedCellID" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.dataArray.count) {
        XMProvince *province = self.dataArray[indexPath.row];
        [cell config:province];
        [cell setBgColor:WCClear andTextColor:WCBlack];
        if (self.selectedIndex == indexPath.row) {
            [cell setBgColor:headViewBackColor andTextColor:WCWhite];
        }
    }
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    [self.collectionView reloadData];
    self.hidSelfBlock();
    self.selectedIndexBlock(self.selectedIndex);
}























@end
