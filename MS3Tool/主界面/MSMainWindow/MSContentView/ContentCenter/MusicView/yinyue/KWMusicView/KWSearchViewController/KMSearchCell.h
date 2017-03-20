//
//  KMSearchCell.h
//  MS3Tool
//
//  Created by chao on 2016/12/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KMSearchModel.h"

@interface KMSearchCell : UITableViewCell

- (void)config:(KMSearchModel *)model;

- (void)configAlbumDetail:(MSMusicModel *)model;

@end
