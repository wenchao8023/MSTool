//
//  VoiceSettingCell.m
//  MS3Tool
//
//  Created by chao on 2017/3/10.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "VoiceSettingCell.h"

@interface VoiceSettingCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;

@property (weak, nonatomic) IBOutlet UIImageView *directImageV;

@end

@implementation VoiceSettingCell


-(void)configWithImageHidden:(NSString *)title subTitle:(NSString *)subTitle {
    
    self.directImageV.hidden = YES;
    
    self.titleLabel.text = title;
    
    self.subTitleLable.text = subTitle;
}

-(void)config:(NSString *)title subTitle:(NSString *)subTitle {
    
    self.titleLabel.text = title;
    
    self.subTitleLable.text = subTitle;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
