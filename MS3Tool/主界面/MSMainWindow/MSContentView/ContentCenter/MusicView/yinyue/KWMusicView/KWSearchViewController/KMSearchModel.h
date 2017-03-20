//
//  KMSearchModel.h
//  MS3Tool
//
//  Created by chao on 2016/12/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMSearchModel : NSObject


@property (nonatomic, assign) BOOL downFee;
@property (nonatomic, assign) BOOL listenFee;
@property (nonatomic, assign) BOOL copyright;

@property (nonatomic, copy, nonnull) NSString *album;
@property (nonatomic, copy, nonnull) NSString *artist;
@property (nonatomic, copy, nonnull) NSString *artistId;
@property (nonatomic, copy, nonnull) NSString *artistPic;
@property (nonatomic, copy, nonnull) NSString *artistPic500;
@property (nonatomic, copy, nonnull) NSString *artistPic700;
@property (nonatomic, copy, nonnull) NSString *duration;
@property (nonatomic, copy, nonnull) NSString *h5ArtistUrl;
@property (nonatomic, copy, nonnull) NSString *h5PlayUrl;
@property (nonatomic, copy, nonnull) NSString *h5SongNameSearchUrl;

@property (nonatomic, copy, nonnull) NSString *pcArtistUrl;
@property (nonatomic, copy, nonnull) NSString *pcPlayUrl;
@property (nonatomic, copy, nonnull) NSString *pic100;
@property (nonatomic, copy, nonnull) NSString *pic300;
@property (nonatomic, copy, nonnull) NSString *pic500;
@property (nonatomic, copy, nonnull) NSString *score;
@property (nonatomic, copy, nonnull) NSString *size;
@property (nonatomic, copy, nonnull) NSString *songName;

@property (nonatomic, copy, nonnull) NSString *songid;

@property (nonatomic, copy, nonnull) NSString *songUrl;

//其他的hash值
@property (nonatomic, strong, nonnull) NSArray *formats;

@end
