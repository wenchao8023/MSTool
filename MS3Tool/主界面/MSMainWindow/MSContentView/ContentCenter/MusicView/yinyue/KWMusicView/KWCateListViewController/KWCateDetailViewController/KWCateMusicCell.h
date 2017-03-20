//
//  KWCateMusicCell.h
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KWCateMusicModel.h"

@interface KWCateMusicCell : UITableViewCell

-(void)config:(KWCateMusicModel *)model index:(NSInteger)index;

@end
