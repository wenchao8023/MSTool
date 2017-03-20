//
//  SmartUDPManager.h
//  MS3Tool
//
//  Created by chao on 2017/3/18.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartUDPManager : NSObject

+(instancetype)shareInstance;

-(void)sendRouteInfoSSID:(NSString *)ssid pswd:(NSString *)pswd;

-(void)stopUdpTimer;

@end
