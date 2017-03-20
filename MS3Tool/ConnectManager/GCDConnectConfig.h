//
//  GCDConnectConfig.h
//  MS3Tool
//
//  Created by chao on 2016/11/14.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>


//  连接过程
typedef enum {
    
    CProgressShouldToConnect = 400,     // tcp主动建连
    
    CProgressDidConnect,                // tcp已经连接
    
    CProgressShouldSendRoute,           // tcp发送路由信息
    
    CProgressDidSendRoute,              // tcp已经发送路由信息
    
    CProgressShouldBroadcast,           // 发送路由成功，开始广播
    
    CProgressDidBroadcast,              // udp已经发送广播了
    
    CProgressDidReceiveBroadcastData,   // 已经收到了广播数据
    
    CProgressShouldReConnect,           // 解析广播数据，重新连接音箱
    
    CProgressDidReConnect,              // 重新连接音箱成功
    
    CProgressShouldConnectSuccess       // 握手返回，连接成功

}ConnectProgress;


@interface GCDConnectConfig : NSObject


@property (nonatomic, assign) ConnectProgress connectProgress;  // 连接过程





+(GCDConnectConfig *)sharedInstance;


@end
