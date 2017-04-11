//
//  MSMusicAlbumCell.h
//  MS3Tool
//
//  Created by chao on 2016/12/5.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSMusicInfoInBox.h"


typedef void(^DelBlock)();


@interface MSMusicAlbumCell : UITableViewCell


@property (nonatomic, copy) DelBlock delBlock;



- (void)config:(MSMusicModel *)model;

- (void)setSelectedSong:(UIColor *)color isPlaying:(BOOL)isPlaying;

- (void)setUnselectedSong:(UIColor *)color ;

- (void)configWithBoxMusic:(MSMusicInfoInBox *)boxModel ;

- (void)startAnimation ;

- (void)stopAnimation ;

@end
