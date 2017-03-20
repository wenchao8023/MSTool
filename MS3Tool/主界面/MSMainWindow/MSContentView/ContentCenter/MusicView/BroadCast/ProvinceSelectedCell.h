//
//  ProvinceSelectedCell.h
//  MS3Tool
//
//  Created by chao on 2016/11/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceSelectedCell : UICollectionViewCell

- (void)config:(XMProvince *)province;

-(void)setBgColor:(UIColor *)bgColor andTextColor:(UIColor *)textColor;

@end
