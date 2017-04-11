//
//  SmartHomeCell.m
//  MS3Tool
//
//  Created by chao on 2017/2/14.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "SmartHomeCell.h"

@interface SmartHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;

@property (weak, nonatomic) IBOutlet UILabel *deviceName;

@end

@implementation SmartHomeCell


-(void)configNameStr:(NSString *)nameStr imgStr:(NSString *)imgStr {
    
    self.deviceName.text = nameStr;
    
    self.deviceImage.image = [UIImage imageNamed:imgStr];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
