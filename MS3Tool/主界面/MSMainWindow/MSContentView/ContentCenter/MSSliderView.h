//
//  MSSliderView.h
//  MS3Tool
//
//  Created by chao on 2016/12/14.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSMainContentView.h"


typedef void(^ClickBlock)(NSInteger clickTag);

typedef void(^CategoryBlock)( XMCategory * _Nonnull category);

typedef void(^KugouSearchVC)();

typedef void(^BroadClick)(NSInteger clickTag);

typedef void(^ButtonsViewClickBlock)(ButtonsClickTag ButtonsClickTag);

typedef void(^ShouldOpenLeftView)(UIPanGestureRecognizer * _Nonnull gesture);


typedef enum : NSInteger {
    
    leftButtonTag = 710,
    
    rightButtonTag,
    
    centerFirstButtonTag = 720
    
}topButtonsTag;


@interface MSSliderView : UIView

@property (nonatomic, copy, nullable) ClickBlock clickBlock;

@property (nonatomic, copy, nullable) CategoryBlock categoryBlock;

@property (nonatomic, copy, nullable) KugouSearchVC kugouSearchVC;

@property (nonatomic, copy, nullable) BroadClick broadClick;

@property (nonatomic, copy, nullable) ButtonsViewClickBlock buttonsViewClickBlock;

@property (nonatomic, copy, nullable) ShouldOpenLeftView shouldOpentLeftView;


@end
