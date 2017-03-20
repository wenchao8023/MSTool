//
//  RankAlbumCell.h
//  sdkTest
//
//  Created by chao on 2016/11/4.
//  Copyright © 2016年 nali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMSDK.h"

@interface RankAlbumCell : UITableViewCell

-(void)config:(XMAlbum *)album andIndex:(NSInteger)row;

@end
