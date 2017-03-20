//
//  MSMusicModel.m
//  MS3Tool
//
//  Created by chao on 2016/12/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMusicModel.h"

@implementation MSMusicModel


//  喜马拉雅播放对象
- (instancetype)initWithTrack:(nonnull XMTrack *)track {
    
    if (self = [super init]) {

        self.duration = track.duration;
        
        self.coverImgLarge = /*track.coverUrlLarge;   */[NSString stringWithFormat:@"%@", track.coverUrlLarge];
        
        self.coverImgSmall = /*track.coverUrlSmall;   */[NSString stringWithFormat:@"%@", track.coverUrlSmall];
        
        self.songName = /*track.trackTitle;           */[NSString stringWithFormat:@"%@", track.trackTitle];
        
        self.singerName = /*track.announcer.nickname; */[NSString stringWithFormat:@"%@", track.announcer.nickname];
        
        self.albumName = track.subordinatedAlbum.albumTitle;
        
        if (track.playUrl64.length) {
            
            self.playUrl = track.playUrl64;
            
        } else if (track.playUrl64M4a.length) {
            
            self.playUrl = track.playUrl64M4a;
            
        } else if (track.playUrl32.length) {
            
            self.playUrl = track.playUrl32;
            
        } else if (track.playUrl24M4a.length) {
            
            self.playUrl = track.playUrl24M4a;
        }
    }
    
    return self;
}

/**
 *  用"酷我API-cateMusic"初始化模型
 */
- (nullable instancetype)initWithKWCateMusicModel:(nonnull KWCateMusicModel *)model {
    
    if (self = [super init]) {
        
        self.songName = model.songName;
        
        self.singerName = model.artist;
        
        self.choricsName = @"";
        
        self.albumName = model.albumName;
        
        self.coverImgSmall = model.pic;
        
        self.coverImgLarge = model.pic;
        
        self.playUrl = model.musicUrl;
        
        self.duration = (long)[model.duration longLongValue];
    }
    
    return self;
}

/**
 *  用"酷我API-艺术家歌曲"初始化模型
 */
- (instancetype)initWithKWArtistMusicModel:(nonnull KWArtistMusicModel *)model {
    
    if (self = [super init]) {
        
        self.songName = model.name;
        
        self.singerName = model.artist;
        
        self.choricsName = @"";
        
        self.albumName = model.album;
        
        self.duration = [model.duration longValue];
        
        self.coverImgSmall = model.pic;
        
        self.coverImgLarge = model.pic;
        
        self.playUrl = model.musicUrl;
    }
    
    return self;
}

/**
 *  用"酷我API-Fenlei"初始化模型
 */
- (nullable instancetype)initWithKWFenleiDetailModel:(nonnull KWFenleiDetailModel *)model {
 
    if (self = [super init]) {
        
        self.songName = model.songName;
        
        self.singerName = model.artist;
        
        self.choricsName = @"";
        
        self.albumName = model.albumName;
        
        self.coverImgSmall = model.pic100;
        
        self.coverImgLarge = model.pic500;
        
        self.playUrl = model.songName;
        
        self.duration = (long)[model.duration longLongValue];
    }
    
    return self;
}

/**
 *  用"酷我API-Search"初始化模型
 */
- (nullable instancetype)initWithKWSearchDetailModel:(nonnull KMSearchModel *)model {
    
    if (self = [super init]) {
        
        self.songName = model.songName;
        
        self.singerName = model.artist;
        
        self.choricsName = @"";
        
        self.albumName = model.album;
        
        self.coverImgSmall = model.pic100;
        
        self.coverImgLarge = model.pic500;
        
        self.playUrl = model.songUrl;
        
        self.duration = (long)[model.duration longLongValue];
    }
    
    return self;
}



//  将model保存到本地读取和存储
- (instancetype)initWithDictionary:(nonnull NSDictionary *)dic {
    
    if (self = [super init]) {
        
        if ([dic objectForKey:@"songName"]) {
            
            self.songName = [dic objectForKey:@"songName"];
        }
        
        if ([dic objectForKey:@"singerName"]) {
            
            self.singerName = [dic objectForKey:@"singerName"];
        }
        
        if ([dic objectForKey:@"choricsName"]) {
            
            self.choricsName = [dic objectForKey:@"choricsName"];
        }
        
        if ([dic objectForKey:@"albumName"]) {
            
            self.albumName = [dic objectForKey:@"albumName"];
        }
        
        if ([dic objectForKey:@"duration"]) {
            
            self.duration = [[dic objectForKey:@"duration"] integerValue];
        }
        
        if ([dic objectForKey:@"coverImgSmall"]) {
            
            self.coverImgSmall = [dic objectForKey:@"coverImgSmall"];
        }
        
        if ([dic objectForKey:@"coverImgLarge"]) {
            
            self.coverImgLarge = [dic objectForKey:@"coverImgLarge"];
        }
        
        if ([dic objectForKey:@"playUrl"]) {
            
            self.playUrl = [dic objectForKey:@"playUrl"];
        }
    }
    
    return self;
}

- (nonnull NSDictionary *)toDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (self.songName) {
        
        [dic setObject:self.songName forKey:@"songName"];
    }
    
    if (self.singerName) {
        
        [dic setObject:self.singerName forKey:@"singerName"];
    }
    
    if (self.coverImgLarge) {
        
        [dic setObject:self.coverImgLarge forKey:@"coverImgLarge"];
    }
    
    if (self.playUrl) {
        
        [dic setObject:self.playUrl forKey:@"playUrl"];
    }
    
    if (self.duration) {
        
        [dic setObject:@(self.duration) forKey:@"duration"];
    }

    if (self.choricsName) {
        
        [dic setObject:self.choricsName forKey:@"choricsName"];
    }
    
    if (self.choricsName) {
        
        [dic setObject:self.albumName forKey:@"albumName"];
    }
    
    return dic;
}
////  喜马拉雅播放对象
//- (void)configWithTrack:(XMTrack *)track {
//    self.songName = track.trackTitle;
//    self.singerName = track.announcer.nickname;
//    self.duration = track.duration;
//    
//    if (track.coverUrlLarge) {
//        self.coverImageUrl = track.coverUrlLarge;
//    } else if (track.coverUrlMiddle) {
//        self.coverImageUrl = track.coverUrlMiddle;
//    } else {
//        self.coverImageUrl = track.coverUrlSmall;
//    }
//    
//    if (track.playUrl64) {
//        self.playUrl = track.playUrl64;
//    } else {
//        self.playUrl = track.playUrl32;
//    }
//}
//
////  酷狗搜歌中的数据模型
//- (void)configWithKMModel:(KMSearchModel *)model {
//    self.songName = model.songName;
//    self.singerName = model.singerName;
//    self.duration = model.timeLength;
//    self.coverImageUrl = model.imgUrl;
//    self.playUrl = model.url;
//}

@end
