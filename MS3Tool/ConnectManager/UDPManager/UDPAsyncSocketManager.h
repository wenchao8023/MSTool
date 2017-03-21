//
//  UDPAsyncSocketManager.h
//  MS3Tool
//
//  Created by chao on 2016/10/19.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^UdpDataBlock)(NSData *data);

@interface UDPAsyncSocketManager : NSObject


+(UDPAsyncSocketManager *)sharedInstance;

/**
 *  socket 发送数据
 */

-(void)UDPSocketWriteData;

/**
 *  socket dataBlock
 */
@property (nonatomic, copy) UdpDataBlock udpDataBlock;


/**
 开始广播
 */
- (void)beginBroadCast;

/**
 暂停广播
 */
- (void)stopBroadCast;



@end
