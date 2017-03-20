//
//  RankAlbumCell.m
//  sdkTest
//
//  Created by chao on 2016/11/4.
//  Copyright © 2016年 nali. All rights reserved.
//

#import "RankAlbumCell.h"



@interface RankAlbumCell ()


@property (weak, nonatomic) IBOutlet UILabel *sortNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLaberl;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation RankAlbumCell

-(void)config:(XMAlbum *)album andIndex:(NSInteger)row { 
    self.sortNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)(row + 1)];
    self.iconImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:album.coverUrlSmall]]];
    self.titleLabel.text = album.albumTitle;
    self.descLaberl.text = album.albumIntro;
    self.totalLabel.text = [NSString stringWithFormat:@"共%ld集", (long)album.includeTrackCount];
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
