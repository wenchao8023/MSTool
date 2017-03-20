//
//  CABasicAnimation+Extension.h
//  MS3Tool
//
//  Created by chao on 2016/11/29.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CABasicAnimation (Extension)

// duration表示半圈时间
-(void)rotate360DegreeWithDuration:(CGFloat)duration;

@end
