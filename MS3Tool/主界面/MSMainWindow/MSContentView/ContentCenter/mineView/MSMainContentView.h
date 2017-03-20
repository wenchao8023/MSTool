//
//  MSMainContentView.h
//  MS3Tool
//
//  Created by chao on 2016/12/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSMainButtonsView.h"


typedef void(^ShouldHiddenSearchView)(BOOL shouldHidden);

typedef void(^ButtonViewClickBlock)(ButtonsClickTag clickTag);


@interface MSMainContentView : UIView


@property (nonatomic, copy) ShouldHiddenSearchView shouldHiddenSearchView;

@property (nonatomic, copy) ButtonViewClickBlock buttonViewClickBlock;

@end
