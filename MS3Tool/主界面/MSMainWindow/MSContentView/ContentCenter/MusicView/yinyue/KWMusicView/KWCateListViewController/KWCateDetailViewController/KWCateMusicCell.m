//
//  KWCateMusicCell.m
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWCateMusicCell.h"


@interface KWCateMusicCell ()

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation KWCateMusicCell


-(void)config:(KWCateMusicModel *)model index:(NSInteger)index {
    
    self.numLabel.text = [NSString stringWithFormat:@"%02ld", (long)(index + 1)];
    
    self.titleLabel.text = model.songName;
    
    self.subTitleLabel.text = [NSString stringWithFormat:@"%@ - %@", model.artist, model.albumName];
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
