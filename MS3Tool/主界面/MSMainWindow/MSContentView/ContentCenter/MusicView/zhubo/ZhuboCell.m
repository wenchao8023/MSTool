//
//  ZhuboCell.m
//  MS3Tool
//
//  Created by chao on 2017/1/3.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "ZhuboCell.h"



@interface ZhuboCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@property (weak, nonatomic) IBOutlet UIView *bgView;

@end



@implementation ZhuboCell


- (void)config:(ZhuboModel *)model {
    
    [self resetSubViews];
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:nil];
    
    self.titleLabel.text = model.nickname;
    
    if (model.vdesc.length) {
        
        self.descLabel.text = model.vdesc;
        
    } else if (model.announcer_position.length) {
        
        self.descLabel.text = model.announcer_position;
        
    } else if (model.vsignature.length) {
        
        self.descLabel.text = model.vsignature;
    }
}

- (void)resetSubViews {
 
    self.bgView.layer.shadowColor = WCLightGray.CGColor;
    
    self.bgView.layer.shadowOpacity = 0.8f;
    
    self.bgView.layer.shadowRadius = 4.f;
    
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    
    
    self.backgroundColor = WCWhite;
    
    self.iconImage.layer.borderColor = WCLightGray.CGColor;
    
    self.iconImage.layer.borderWidth = 0.5;
    
    self.iconImage.layer.masksToBounds = YES;
    
    self.descLabel.numberOfLines = 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
