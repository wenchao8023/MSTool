//
//  GCDAsyncSocketManager.h
//  MS3Tool
//
//  Created by 郭文超 on 2016/10/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReceiveDataBlock)( NSData * _Nonnull data);

@interface GCDAsyncSocketManager : NSObject

/**
 *  连接状态：1 - 已连接， -1 - 未连接， 0 - 连接中
 */
@property (nonatomic, assign) NSInteger connectStatus;

@property (nonatomic, assign) NSInteger reconnectionCount;  //建连失败重连次数

@property (nonatomic, copy, nonnull) ReceiveDataBlock receiveDataBlock;

/**
 *  获取单例
 *  @return 单例对象
 */
+(nullable GCDAsyncSocketManager *)sharedInstance;

/**
 *  连接 socket
 */
-(void)connectSocketWithDelegate:(nonnull id)delegate withHost:(nonnull NSString *)host andPort:(uint16_t)port;

/**
 *  socket 连接失败后重连的操作
 */
-(void)socketDidDisconnectBeginSendReconnect;

/**
 *  socket 向服务器发送数据
 */
-(void)socketWriteData:(nonnull NSData *)data andTag:(long)tag;
/**
 *  socket 读取数据
 */
-(void)socketReadData;


/**
 *  socket 主动断开连接
 */
-(void)disconnectSocket;




@end
