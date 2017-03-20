//
//  MSMusicModel.h
//  MS3Tool
//
//  Created by chao on 2016/12/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KWArtistMusicModel.h"

#import "KWFenleiDetailModel.h"

#import "KWCateMusicModel.h"

#import "KMSearchModel.h"



@interface MSMusicModel : NSObject

// 歌曲名
@property (nonatomic, copy, nonnull) NSString *songName;
// 歌手名
@property (nonatomic, copy, nonnull) NSString *singerName;

@property (nonatomic, copy, nonnull) NSString *choricsName;  //酷狗音乐中的合唱组合
// 专辑名
@property (nonatomic, copy, nonnull) NSString *albumName;
// 专辑图片 - 大
@property (nonatomic, copy, nonnull) NSString *coverImgLarge;
// 专辑图片 - 小
@property (nonatomic, copy, nonnull) NSString *coverImgSmall;
// 播放时长
@property (nonatomic, assign) long duration;
// 播放url
@property (nonatomic, copy, nonnull) NSString *playUrl;

/**
 *  用“喜马拉雅数据"初始化模型
 */
- (nullable instancetype)initWithTrack:(nonnull XMTrack *)track;

/**
 *  用"酷我API-cateMusic"初始化模型
 */
- (nullable instancetype)initWithKWCateMusicModel:(nonnull KWCateMusicModel *)model;

/**
 *  用"酷我API-艺术家歌曲"初始化模型
 */
- (nullable instancetype)initWithKWArtistMusicModel:(nonnull KWArtistMusicModel *)model;

/**
 *  用"酷我API-Fenlei"初始化模型
 */
- (nullable instancetype)initWithKWFenleiDetailModel:(nonnull KWFenleiDetailModel *)model;

/**
 *  用"酷我API-Search"初始化模型
 */
- (nullable instancetype)initWithKWSearchDetailModel:(nonnull KMSearchModel *)model;

/**
 *  用"酷狗搜歌数据"初始化模型
 */
//- (nullable instancetype)initWithKMModel:(nonnull KMSearchModel *)model;

/**
 *  取出本地保存的信息
 */
- (nullable instancetype)initWithDictionary:(nonnull NSDictionary *)dic;
/**
 *  转成字典进行本地保存
 */
- (nonnull NSDictionary *)toDictionary;

@end
