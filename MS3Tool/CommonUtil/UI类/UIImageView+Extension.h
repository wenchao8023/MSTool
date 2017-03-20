//
//  UIImageView+Extension.h
//  MS3Tool
//
//  Created by chao on 2016/11/23.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

// 在图片边缘添加一个像素的透明区域，去掉图片锯齿
-(void)imageDrawRect;

@end
