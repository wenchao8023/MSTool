//
//  KWArtistModel.m
//  MS3Tool
//
//  Created by chao on 2017/3/7.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWArtistModel.h"

@implementation KWArtistModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

-(NSDictionary *)toDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (self.name) {
    
        [dic setObject:self.name forKey:@"name"];
    }
    
    if (self.head) {
        
        [dic setObject:self.head forKey:@"head"];
    }
    
    if (self.artistid) {
        
        [dic setObject:self.artistid forKey:@"artistid"];
    }
    
    if (self.h5ArtistUrl) {
        
        [dic setObject:self.h5ArtistUrl forKey:@"h5ArtistUrl"];
    }
    
    if (self.pcArtistUrl) {
        
        [dic setObject:self.pcArtistUrl forKey:@"pcArtistUrl"];
    }
    
    return dic;
}

@end
