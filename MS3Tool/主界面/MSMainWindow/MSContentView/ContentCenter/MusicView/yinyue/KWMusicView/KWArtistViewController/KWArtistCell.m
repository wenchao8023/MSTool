//
//  KWArtistCell.m
//  MS3Tool
//
//  Created by chao on 2017/3/7.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWArtistCell.h"



@interface KWArtistCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end



@implementation KWArtistCell


-(void)config:(KWArtistModel *)model {
    
    [self resetSubViews];
    
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.head]];
    
    self.titleLabel.text = model.name;
}

- (void)resetSubViews {
    
    self.contentView.layer.shadowColor = WCLightGray.CGColor;
    
    self.contentView.layer.shadowOpacity = 0.8f;
    
    self.contentView.layer.shadowRadius = 4.f;
    
    self.contentView.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    
    
    self.iconImgV.layer.borderColor = WCLightGray.CGColor;
    
    self.iconImgV.layer.borderWidth = 0.5;
    
    self.iconImgV.layer.masksToBounds = YES;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
