//
//  MSMainAlbumCell.m
//  MS3Tool
//
//  Created by chao on 2016/12/15.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMainAlbumCell.h"



@interface MSMainAlbumCell ()


@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;

@end

@implementation MSMainAlbumCell

- (void)config:(MSMainGuessLikeModel *)model {
    
    self.descLabel.text = model.albumIntro;
    
    self.playCountLabel.text = [self getPlaycountStr:model.playCount];
    
    self.playCountLabel.hidden = YES;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.coverUrlMiddle]];
}


- (NSString *) getPlaycountStr : (long)playCount {
    
    return (playCount > 10000 ? [NSString stringWithFormat:@"%ld万", playCount / 10000] : [NSString stringWithFormat:@"%ld", playCount]);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
