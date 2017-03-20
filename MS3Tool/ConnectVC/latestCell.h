//
//  latestCell.h
//  MS3Tool
//
//  Created by chao on 2017/2/10.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)( NSString * _Nonnull wifiStr);

@interface latestCell : UITableViewCell

- (void)config:(NSString * _Nonnull)wifiStr;

@property (nonatomic, copy, nullable) SelectBlock selectBlock;

@end
