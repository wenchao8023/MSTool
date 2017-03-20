//
//  CABasicAnimation+Extension.m
//  MS3Tool
//
//  Created by chao on 2016/11/29.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "CABasicAnimation+Extension.h"

@implementation CABasicAnimation (Extension)

-(void)rotate360DegreeWithDuration:(CGFloat)duration {
    
    // 开始值
    self.fromValue = [NSNumber numberWithFloat:0.0];
    // 终了值
    self.toValue = [NSNumber numberWithFloat:M_PI];
    // 动画时长
    self.duration = duration;
    // 重复次数 永久重复设置为HUGE_VALF
    self.repeatCount = HUGE_VALF;
    // 设置动画变化速度
    self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    // 旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    self.cumulative = YES;
    // 动画终了后不返回初始状态
    self.removedOnCompletion = NO;
    self.fillMode = kCAFillModeForwards;
}



@end
