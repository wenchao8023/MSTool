//
//  KWFenleiModel.h
//  MS3Tool
//
//  Created by chao on 2017/3/7.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWFenleiModel : NSObject

@property (nonatomic, copy, nullable) NSString *disName;

@property (nonatomic, copy, nullable) NSString *name;

@property (nonatomic, copy, nullable) NSString *pic;

@property (nonatomic, copy, nullable) NSString *playId;

@property (nonatomic, copy, nullable) NSString *type;

-(NSDictionary * _Nonnull)toDictionary ;

@end
