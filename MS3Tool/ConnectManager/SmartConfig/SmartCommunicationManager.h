//
//  SmartCommunicationManager.h
//  MS3Tool
//
//  Created by chao on 2017/3/17.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "packet.h"

#import "GCDHeaderFile.h"

#import "GCDAysncSocketDataManager.h"

@interface SmartCommunicationManager : NSObject


@property (nonatomic, strong, nullable) GCDAysncSocketDataManager *dataManager;


+ (nonnull GCDAsyncSocketCommunicationManager *)sharedInstance;

/**
 *  记住 WiFi账号 和WiFi密码
 */
- (void)rememberWifi:(NSString * _Nonnull)ssid pswd:(NSString * _Nonnull)pswd;

/**
 *  连接tcpSocket
 */
- (void)createSocketWithDelegate:(nonnull id)delegate andHost:(nonnull NSString *)host andPort:(uint16_t)port;

/**
 *  连接tcpSocket -- 恢复出厂设置
 */
- (void)createSocketToReset;

/**
 *  写数据
 */
- (void)socketWriteDataWithData:(nonnull NSData *)requestData andTag:(long)tag;

/**
 *  还原所有连接设置，准备下次连接
 */
- (void)resetToConnect ;


/**
 *  开始广播
 */
-(void)udpBroadcast;

/**
 *  停止广播
 */
-(void)udpStopBroadcast;



/**
 *  主动断开连接
 */
- (void)disconnectSocket;



@end
