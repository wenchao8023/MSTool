//
//  MSMusicInfoInBox.h
//  MS3Tool
//
//  Created by chao on 2017/3/15.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSMusicInfoInBox : NSObject


@property (nonatomic, assign) int flag;

@property (nonatomic, assign) int index;

@property (nonatomic, copy, nullable) NSString *songName;

@property (nonatomic, copy, nullable) NSString *artistic;

@end
