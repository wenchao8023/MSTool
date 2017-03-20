//
//  KWCateMusicModel.h
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWCateMusicModel : NSObject


@property (nonatomic, copy, nullable) NSString *albumid;

@property (nonatomic, copy, nullable) NSString *albumName;

@property (nonatomic, copy, nullable) NSString *artist;

@property (nonatomic, copy, nullable) NSString *artistId;

@property (nonatomic, copy, nullable) NSString *duration;

@property (nonatomic, copy, nullable) NSString *h5ArtistUrl;

@property (nonatomic, copy, nullable) NSString *h5PlayUrl;

@property (nonatomic, copy, nullable) NSString *pcArtistUrl;

@property (nonatomic, copy, nullable) NSString *pcPlayUrl;

@property (nonatomic, copy, nullable) NSString *pic;

@property (nonatomic, copy, nullable) NSString *songName;


@property (nonatomic, copy, nullable) NSString *musicid;

@property (nonatomic, copy, nullable) NSString *musicUrl;

@property (nonatomic, strong, nullable) NSArray *formats;



@end
