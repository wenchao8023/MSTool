//
//  CategoryView.h
//  MS3Tool
//
//  Created by chao on 2016/11/10.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CategoryBlock)(XMCategory *category);

typedef void(^ShouldHiddenSearchView)(BOOL shouldHidden);


@interface CategoryView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) CategoryBlock categoryBlock;

@property (nonatomic, copy) ShouldHiddenSearchView shouldHiddenSearchView;

@end
