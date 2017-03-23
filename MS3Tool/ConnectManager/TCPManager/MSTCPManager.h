//
//  MSTCPManager.h
//  MS3Tool
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^TcpDataBlock)(NSData * _Nonnull data);

@interface MSTCPManager : NSObject



@property (nonatomic, copy, nonnull) TcpDataBlock tcpDataBlock;



+(nullable MSTCPManager *)sharedInstance;

/**
 *  连接 socket
 */
-(void)tcpSocketwithHost:(nonnull NSString *)host andPort:(uint16_t)port;

/**
 *  socket 向服务器发送数据
 */
-(void)tcpWriteData:(nonnull NSData *)data andTag:(long)tag;
/**
 *  socket 读取数据
 */
-(void)tcpReadData;
@end
