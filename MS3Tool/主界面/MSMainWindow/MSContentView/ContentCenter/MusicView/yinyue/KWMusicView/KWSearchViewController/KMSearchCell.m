//
//  KMSearchCell.m
//  MS3Tool
//
//  Created by chao on 2016/12/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "KMSearchCell.h"

@interface KMSearchCell ()

@property (weak, nonatomic) IBOutlet UILabel *songLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end
@implementation KMSearchCell

- (void)config:(KMSearchModel *)model {
    
    self.songLabel.text = model.songName;

    self.descLabel.text = model.album.length ? [NSString stringWithFormat:@"%@ - %@", model.artist, model.album] : model.artist;
}

- (void)configAlbumDetail:(MSMusicModel *)model {
    
    self.songLabel.text = model.songName;
    
    self.descLabel.text = model.albumName.length ? [NSString stringWithFormat:@"%@ - %@", model.singerName, model.albumName] : model.singerName;
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
