//
//  MSUDPManager.h
//  MS3Tool
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^UdpDataBlock)(NSData *data);


@interface MSUDPManager : NSObject

+(MSUDPManager *)sharedInstance;

/**
 *  socket 发送数据
 */

-(void)UDPSocketWriteData;

/**
 *  socket dataBlock
 */
@property (nonatomic, copy) UdpDataBlock udpDataBlock;


/** 开始广播
 *  重新配置网络的时候需要广播
 *  手机和音箱断开连接的时候需要广播
 */
- (void)beginBroadCast;

/** 暂停广播
 *  广播收到返回数据的时候停止广播
 *  
 */
- (void)stopBroadCast;





@end
