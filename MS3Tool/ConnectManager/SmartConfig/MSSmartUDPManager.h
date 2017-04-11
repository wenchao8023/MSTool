//
//  MSSmartUDPManager.h
//  MS3Tool
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSSmartUDPManager : NSObject

+(instancetype)shareInstance;

-(void)smartConfig;

-(void)stopUdpTimer;

@end
