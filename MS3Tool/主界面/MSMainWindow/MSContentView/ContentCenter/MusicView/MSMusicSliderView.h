//
//  MSMusicSliderView.h
//  MS3Tool
//
//  Created by chao on 2016/12/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef void(^CategoryBlock)(XMCategory *category);

typedef void(^BroadCastClick)(NSInteger clickTag);




@interface MSMusicSliderView : UIView


@property (assign) NSInteger tabCount;

@property (nonatomic, copy) CategoryBlock categoryBlock;

@property (nonatomic, copy) BroadCastClick broadCastClick;

-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count;


@end
