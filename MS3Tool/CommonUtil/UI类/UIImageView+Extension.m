//
//  UIImageView+Extension.m
//  MS3Tool
//
//  Created by chao on 2016/11/23.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "UIImageView+Extension.h"



@implementation UIImageView (Extension)

-(void)imageDrawRect {
    
    CGRect imageRrect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    UIGraphicsBeginImageContext(imageRrect.size);
    
    [self.image drawInRect:CGRectMake(1, 1, self.frame.size.width - 2, self.frame.size.height - 2)];
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

@end
