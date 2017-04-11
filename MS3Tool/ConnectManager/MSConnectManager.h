//
//  MSConnectManager.h
//  MS3Tool
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuild. All rights reserved.
//


/*************************************************************************
 ****************                连接说明               *******************
 ** 1. 每次启动程序的时候就进行udp广播
 **    如果广播的时候有数据返回，说明音箱已经连接WiFi，通过返回的数据进入STA模式连接
 **    如果在限定的次数（时间）内没有收到数据返回,提示用户打开音箱WiFi进入AP模式配对
 ** 2. 所有的连接方法都封装在了GCDAsyncSocketCommunicationManager里面
 **    通过连接的进度来判断如何去做下一步操作
 ** 3. 类说明
 **    packet.h 定义协议
 **    GCDConnectConfig.h 记录连接步骤  (17_03_23 移除，使用smartconfig，不再需要记录步骤了，都是单向的)
 **    GCDAysncSocketDataManager 处理协议数据
 **    GCDAsyncSocketManager tcp连接协议
 **    UDPAsyncSocketManager udp连接协议
 **    GCDAsyncSocketCommunicationManager 调用接口
 *************************************************************************/

#import <Foundation/Foundation.h>

#import "packet.h"

#import "GCDHeaderFile.h"

#import "GCDAysncSocketDataManager.h"


@interface MSConnectManager : NSObject

@property (nonatomic, strong, nullable) GCDAysncSocketDataManager *dataManager;

#pragma mark - manager connect
+ (nonnull MSConnectManager *)sharedInstance;


#pragma mark - manager TCP

- (void)tcpWriteDataWithData:(nonnull NSData *)requestData andTag:(long)tag;

- (void)tcpDisconnect;

- (BOOL)tcpConnectStatus;


#pragma mark - manager UDP

/**
 *  开始广播
 */
-(void)udpBroadcast;

/**
 *  停止广播
 */
-(void)udpStopBroadcast;


#pragma mark - manager smart config
-(void)smartConfig ;

-(void)smartStopConfig;


@end
