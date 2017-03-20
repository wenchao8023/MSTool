//
//  KWArtistMusicModel.h
//  MS3Tool
//
//  Created by chao on 2017/3/7.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWArtistMusicModel : NSObject

@property (nonatomic, copy, nullable) NSString *album;

@property (nonatomic, copy, nullable) NSString *albumid;

@property (nonatomic, copy, nullable) NSString *artist;

@property (nonatomic, copy, nullable) NSString *artistid;

@property (nonatomic, copy, nullable) NSNumber *duration;

@property (nonatomic, copy, nullable) NSString *musicrid;

@property (nonatomic, copy, nullable) NSString *name;

@property (nonatomic, copy, nullable) NSString *pay;

@property (nonatomic, copy, nullable) NSString *pcUrl;

@property (nonatomic, copy, nullable) NSString *pic;

@property (nonatomic, copy, nullable) NSString *playcnt;


@property (nonatomic, copy, nullable) NSString *score100;

@property (nonatomic, copy, nullable) NSString *wapUrl;

@property (nonatomic, copy, nullable) NSString *musicUrl;


@property (nonatomic, strong, nullable) NSArray *formats;

@property (nonatomic, strong, nullable) NSArray *formats1;

@end
