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

@property (nonatomic, strong) NSArray *imagesArray;

@end

@implementation MSMusicAlbumCell

-(NSArray *)imagesArray {
    
    if (!_imagesArray) {
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 1; i < 12; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"playingInAlbum%d", i]];
            
            [tempArr  addObject:image];
        }

//        for (int i = 0; i < 28; i++) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%d", i]];
//            
//            [tempArr  addObject:image];
//        }
        _imagesArray = [NSArray arrayWithArray:tempArr];
    }
    
    return _imagesArray;
}

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
    
    self.playingImageV.image = [UIImage imageNamed:@"playingInAlbum2"];
    
    self.playingImageV.hidden = YES;
    
    [self addAnimation];
}


- (void)setSelectedSong:(UIColor *)color isPlaying:(BOOL)isPlaying {
    
    self.titleLabel.textColor = color;
    
    self.songerLabel.textColor = color;
    
    self.playingImageV.hidden = NO;
    
    if (isPlaying)
        [self startAnimation];
    else
        [self stopAnimation];
}

- (void)startAnimation {
    
    if (![self.playingImageV isAnimating]) {
        [self.playingImageV startAnimating];
    }
    
}

- (void)stopAnimation {
    
    if ([self.playingImageV isAnimating]) {
        [self.playingImageV stopAnimating];
    }
}

- (void)addAnimation {
    
    self.playingImageV.animationImages = self.imagesArray;
    
    self.playingImageV.animationRepeatCount = 0;
    
    self.playingImageV.animationDuration = 3.0;
    
    [self.playingImageV startAnimating];
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
