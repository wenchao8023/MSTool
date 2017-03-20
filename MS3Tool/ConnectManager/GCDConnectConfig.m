//
//  GCDConnectConfig.m
//  MS3Tool
//
//  Created by chao on 2016/11/14.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "GCDConnectConfig.h"



static GCDConnectConfig *manager = nil;

@implementation GCDConnectConfig

/**
 *  创建config单例
 */
+(GCDConnectConfig *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

/**
 *  初始化，用于创建config单例
 */
-(instancetype)init{
    
    if (self = [super init]) {
        
        
    }
    
    return self;
}


@end
