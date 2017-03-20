//
//  KWFenleiDetailModel.h
//  MS3Tool
//
//  Created by chao on 2017/3/8.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWFenleiDetailModel : NSObject

@property (nonatomic, copy, nullable) NSString *albumName;

@property (nonatomic, copy, nullable) NSString *albumId;

@property (nonatomic, copy, nullable) NSString *artist;

@property (nonatomic, copy, nullable) NSString *artistId;


@property (nonatomic, copy, nullable) NSString *songId; // to id

@property (nonatomic, copy, nullable) NSString *duration;

@property (nonatomic, copy, nullable) NSString *songName;

@property (nonatomic, copy, nullable) NSString *pic100;

@property (nonatomic, copy, nullable) NSString *pic300;

@property (nonatomic, copy, nullable) NSString *pic500;

@property (nonatomic, copy, nullable) NSString *score;

@property (nonatomic, copy, nullable) NSString *size;

@property (nonatomic, copy, nullable) NSString *songUrl;


@end
