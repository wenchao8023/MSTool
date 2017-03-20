//
//  ProvinceSelectedView.h
//  MS3Tool
//
//  Created by chao on 2016/11/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HidSelfBlock)();
typedef void(^SelectedIndexBlock)(NSInteger selectedIndex);

@interface ProvinceSelectedView : UIView

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;


@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) HidSelfBlock hidSelfBlock;
@property (nonatomic, copy) SelectedIndexBlock selectedIndexBlock;

@end
