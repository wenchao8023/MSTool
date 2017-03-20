//
//  MSMainGuessLikeModel.m
//  MS3Tool
//
//  Created by chao on 2016/12/15.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMainGuessLikeModel.h"

@implementation MSMainGuessLikeModel

/*
 @property (nonatomic, assign) NSInteger playCount;
 @property (nonatomic, assign) NSInteger includeTrackCount;
 @property (nonatomic, assign) NSInteger favoriteCount;
 @property (nonatomic, assign) NSInteger basedRelativeAlbumId;
 @property (nonatomic, assign) NSInteger id;
 @property (nonatomic, assign) double updatedAt;
 @property (nonatomic, assign) double createdAt;
 
 @property (nonatomic, copy) NSString * albumTitle;
 @property (nonatomic, copy) NSString * albumTags;
 @property (nonatomic, copy) NSString * albumIntro;
 @property (nonatomic, copy) NSString * coverUrlLarge;
 @property (nonatomic, copy) NSString * coverUrlMiddle;
 @property (nonatomic, copy) NSString * coverUrlSmall;
 @property (nonatomic, copy) NSString * recommendSrc;
 @property (nonatomic, copy) NSString * recommendTrace;
 @property (nonatomic, copy) NSString * kind;
 
 @property (nonatomic, strong) XMLastUptrack * lastUptrack;
 @property (nonatomic, strong) XMAnnouncer * announcer;
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        
        self.playCount = [[dictionary objectForKey:@"play_count"] integerValue];
        self.includeTrackCount = [[dictionary objectForKey:@"include_track_count"] integerValue];
        self.favoriteCount = [[dictionary objectForKey:@"favorite_count"] integerValue];
        self.basedRelativeAlbumId = [[dictionary objectForKey:@"based_relative_album_id"] integerValue];
        self.identity = [[dictionary objectForKey:@"id"] integerValue];
        self.updatedAt = [[dictionary objectForKey:@"updated_at"] doubleValue];
        self.createdAt = [[dictionary objectForKey:@"created_at"] doubleValue];
        
        self.albumTitle = [dictionary objectForKey:@"album_title"];
        self.albumTags = [dictionary objectForKey:@"album_tags"];
        self.albumIntro = [dictionary objectForKey:@"album_intro"];
        self.coverUrlLarge = [dictionary objectForKey:@"cover_url_large"];
        self.coverUrlMiddle = [dictionary objectForKey:@"cover_url_middle"];
        self.coverUrlSmall = [dictionary objectForKey:@"cover_url_small"];
        self.recommendSrc = [dictionary objectForKey:@"recommend_src"];
        self.recommendTrace = [dictionary objectForKey:@"recommend_trace"];
        self.kind = [dictionary objectForKey:@"kind"];
        
        self.lastUptrack = [[XMLastUptrack alloc] initWithDictionary:[dictionary objectForKey:@"last_uptrack"]];
        self.announcer = [[XMAnnouncer alloc] initWithDictionary:[dictionary objectForKey:@"announcer"]];
        
    }
    
    return self;
}

-(NSDictionary *)toDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [dic setObject:@(self.playCount) forKey:@"play_count"];
    [dic setObject:@(self.includeTrackCount) forKey:@"include_track_count"];
    [dic setObject:@(self.favoriteCount) forKey:@"favorite_count"];
    [dic setObject:@(self.basedRelativeAlbumId) forKey:@"based_relative_album_id"];
    [dic setObject:@(self.identity) forKey:@"id"];
    [dic setObject:@(self.updatedAt) forKey:@"updated_at"];
    [dic setObject:@(self.createdAt) forKey:@"created_at"];
    
    [dic setObject:self.albumTitle forKey:@"album_title"];
    [dic setObject:self.albumTags forKey:@"album_tags"];
    [dic setObject:self.albumIntro forKey:@"album_intro"];
    [dic setObject:self.coverUrlLarge forKey:@"cover_url_large"];
    [dic setObject:self.coverUrlMiddle forKey:@"cover_url_middle"];
    [dic setObject:self.coverUrlSmall forKey:@"cover_url_small"];
    [dic setObject:self.recommendSrc forKey:@"recommend_src"];
    [dic setObject:self.recommendTrace forKey:@"recommend_trace"];
    [dic setObject:self.kind forKey:@"kind"];
    
    [dic setObject:self.lastUptrack forKey:@"last_uptrack"];
    [dic setObject:self.announcer forKey:@"announcer"];
    
    return dic;
}

@end
