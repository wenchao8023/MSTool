//
//  MSMusicAlbumCell.m
//  MS3Tool
//
//  Created by chao on 2016/12/5.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMusicAlbumCell.h"




@interface MSMusicAlbumCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *songerLabel;

@property (weak, nonatomic) IBOutlet UIImageView *playingImageV;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation MSMusicAlbumCell

- (void)config:(MSMusicModel *)model {
    
    self.titleLabel.text = model.songName;
    
    self.songerLabel.text = [NSString stringWithFormat:@"-%@", model.singerName];
}


- (void)configWithBoxMusic:(MSMusicInfoInBox *)boxModel {
    
    self.titleLabel.text = boxModel.songName;
    
    self.songerLabel.text =
    boxModel.artistic ?
    [NSString stringWithFormat:@"%d - %@", boxModel.index + 1, boxModel.artistic] :
    [NSString stringWithFormat:@"%d", boxModel.index + 1];
}


- (void)setSelectedSong:(UIColor *)color {
    
    self.titleLabel.textColor = color;
    
    self.songerLabel.textColor = color;
}



- (void)setUnselectedSong:(UIColor *)color {
    
    self.titleLabel.textColor = color;
    
    self.songerLabel.textColor = color;
}



- (IBAction)collectClick:(id)sender {
    NSLog(@"收藏");
    
    
}



- (IBAction)delClick:(id)sender {
    NSLog(@"删除歌曲");
    
    self.delBlock();
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
