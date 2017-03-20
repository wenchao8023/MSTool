//
//  ProvinceSelectedCell.m
//  MS3Tool
//
//  Created by chao on 2016/11/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "ProvinceSelectedCell.h"

@interface ProvinceSelectedCell ()

@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;

@end

@implementation ProvinceSelectedCell


- (void)config:(XMProvince *)province {
    
    self.provinceLabel.layer.cornerRadius = 15;
    self.provinceLabel.layer.masksToBounds = YES;
    self.provinceLabel.layer.borderWidth = 0.5;
    self.provinceLabel.layer.borderColor = WCGray.CGColor;
    self.provinceLabel.text = province.provinceName;
    
}

-(void)setBgColor:(UIColor *)bgColor andTextColor:(UIColor *)textColor {
    self.provinceLabel.backgroundColor = bgColor;
    self.provinceLabel.textColor = textColor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
