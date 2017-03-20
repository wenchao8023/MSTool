//
//  ProvinceScrollView.h
//  MS3Tool
//
//  Created by chao on 2016/11/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HidSelfBlock)();

typedef void(^SelectedIndexBlock)(NSInteger selectedIndex);

@interface ProvinceScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) NSArray *buttonsArray;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) HidSelfBlock hidSelfBlock;

@property (nonatomic, copy) SelectedIndexBlock selectedIndexBlock;

- (void)addButtonsToScrollView;

- (void)setButtonsState;

@end
