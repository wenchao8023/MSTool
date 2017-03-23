//
//  MSVoiceView.m
//  MS3Tool
//
//  Created by chao on 2017/3/3.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "MSVoiceView.h"

#import "SmartHomeVC.h"

#import "MSVoicecommandViewController.h"



static NSString *kCollectionCellID = @"MSVoiceViewCollectionCellID";


@interface MSVoiceView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, strong) NSArray *VCArray;

@property (nonatomic, assign) CGFloat sHeight;

@property (nonatomic, assign) CGFloat sWidth;



@end

@implementation MSVoiceView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _sHeight = frame.size.height;
        
        _sWidth = WIDTH;
        
        self.backgroundColor = WCBgGray;
        
        [self addSubview:self.headImage];
        
        [self addSubview:self.collectionView];
        
        
        
#warning 通知连接状态
    }
    
    return self;
}
//
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//
//    if ([keyPath isEqualToString:@"connectStatus"]) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self resetHeadImage];
//        });
//    }
//}
//
//- (void)resetHeadImage {
//    
//    if (self.socketManager.connectStatus == 1)
//        self.headImage.image = [UIImage imageNamed:@"voicebgConnect"];
//    else
//        self.headImage.image = [UIImage imageNamed:@"voicebgUnconnected"];
//}


-(UIImageView *)headImage {
    
    if (!_headImage) {
        
        _headImage = [WenChaoControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH) ImageName:@"voicebgUnconnected"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
        
        [_headImage addGestureRecognizer:tap];
    }
    
    return _headImage;
}

-(void)imageTap {
    
    
//    if (self.socketManager.connectStatus != 1)
//        [self postNotify:[NSIndexPath indexPathForRow:4 inSection:0]];
        
}


-(UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.itemSize = CGSizeMake((_sWidth - 3) / 2, (_sHeight - _sWidth) / 2);
        
        flowLayout.minimumLineSpacing = 1;
        
        flowLayout.minimumInteritemSpacing = 1;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 1, 1, 1);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _sWidth, _sWidth, _sHeight - _sWidth) collectionViewLayout:flowLayout];
        
        _collectionView.dataSource = self;
        
        _collectionView.delegate = self;
        
        _collectionView.backgroundColor = WCClear;
        
        _collectionView.scrollEnabled = NO;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellID];
    }
    
    return _collectionView;
}

-(NSArray *)nameArray {
    
    if (!_nameArray) {
        
        _nameArray = @[@"语音指令", @"新手帮助", @"音箱设置", @"智能音箱"];
    }
    
    return _nameArray;
}



#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.nameArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellID forIndexPath:indexPath];
    
    cell.backgroundColor = WCWhite;
    
    UILabel *titleLabel = [WenChaoControl createLabelWithFrame:cell.contentView.frame Font:16 Text:self.nameArray[indexPath.row] textAlignment:1];
    
    [cell addSubview:titleLabel];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self postNotify:indexPath];
}

-(void)postNotify:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PUSH_VOICE object:indexPath];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PUSH_VOICE object:nil];
    
//    [self removeObserver:self.socketManager forKeyPath:@"connectStatus"];
}

@end
