//
//  KWArtistModel.h
//  MS3Tool
//
//  Created by chao on 2017/3/7.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWArtistModel : NSObject


@property (nonatomic, copy, nullable) NSString *h5ArtistUrl;

@property (nonatomic, copy, nullable) NSString *head;

@property (nonatomic, copy, nullable) NSString *name;

@property (nonatomic, copy, nullable) NSString *pcArtistUrl;

@property (nonatomic, copy, nullable) NSString *artistid;


- (NSDictionary * _Nonnull)toDictionary;

@end
