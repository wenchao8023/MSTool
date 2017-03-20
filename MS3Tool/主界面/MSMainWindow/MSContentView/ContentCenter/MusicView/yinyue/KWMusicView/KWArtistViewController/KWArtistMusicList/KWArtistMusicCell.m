//
//  KWArtistMusicCell.m
//  MS3Tool
//
//  Created by chao on 2017/3/7.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWArtistMusicCell.h"



@interface KWArtistMusicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end



@implementation KWArtistMusicCell

-(void)config:(KWArtistMusicModel *)model {
    
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    
    self.titleLabel.text = model.name;
    
    self.subTitleLabel.text = [self getStr:model];
}

-(NSString *)getStr:(KWArtistMusicModel *)model {
    
    if (model.album.length)
        return [NSString stringWithFormat:@"%@ - %@", model.artist, model.album];
    else
        return model.artist;
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
