//
//  MSMainGuessLikeModel.h
//  MS3Tool
//
//  Created by chao on 2016/12/15.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSMainGuessLikeModel : NSObject


@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger includeTrackCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger basedRelativeAlbumId;
@property (nonatomic, assign) NSInteger identity;
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


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;




@end
