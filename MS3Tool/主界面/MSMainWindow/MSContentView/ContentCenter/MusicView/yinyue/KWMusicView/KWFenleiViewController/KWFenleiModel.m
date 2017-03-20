//
//  KWFenleiModel.m
//  MS3Tool
//
//  Created by chao on 2017/3/7.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWFenleiModel.h"

@implementation KWFenleiModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

-(NSDictionary *)toDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (self.disName) {
        
        [dic setObject:self.disName forKey:@"disName"];
    }
    
    if (self.name) {
        
        [dic setObject:self.name forKey:@"name"];
    }
    
    if (self.pic) {
        
        [dic setObject:self.pic forKey:@"pic"];
    }
    
    if (self.playId) {
        
        [dic setObject:self.playId forKey:@"playId"];
    }
    
    if (self.type) {
        
        [dic setObject:self.type forKey:@"type"];
    }
    
    return dic;
}


@end
