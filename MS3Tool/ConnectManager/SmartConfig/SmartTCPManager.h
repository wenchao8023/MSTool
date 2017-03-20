//
//  SmartTCPManager.h
//  MS3Tool
//
//  Created by chao on 2017/3/18.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartTCPManager : NSObject

+(SmartTCPManager *)sharedInstance;

-(void)connectSocketWithHost:(NSString *)host andPort:(uint16_t)port;

@end
