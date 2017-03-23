//
//  MSTCPManager.m
//  MS3Tool
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "MSTCPManager.h"

#import "GCDAsyncSocket.h"



static MSTCPManager *manager = nil;

@interface MSTCPManager ()<GCDAsyncSocketDelegate>


@property (nonatomic, strong) GCDAsyncSocket *tcpSocket;

@property (nonatomic, assign) NSInteger connectStatus;  // 连接状态：1 - 已连接， -1 - 未连接， 0 - 连接中

@property (nonatomic, assign) NSInteger connectCount;

@property (nonatomic, strong) NSTimer *connectTimer;    // 重连定时器

@property (nonatomic, copy) NSString *currentHost;      // 目前正在连接的host

@property (nonatomic, assign) uint16_t currentPort;     // 目前正在连接的port

@end

@implementation MSTCPManager

#pragma mark - init
+(nullable MSTCPManager *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MSTCPManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init {
    
    if (self = [super init]) {
        
        self.connectStatus = -1;
        
        self.connectCount = 0;
        
        [self tcpReadDataInRunLoop];
    }
    
    return self;
}

#pragma mark - connect
-(void)tcpSocketwithHost:(nonnull NSString *)host andPort:(uint16_t)port {
    
    self.currentHost = host;
    
    self.currentPort = port;
    
    if (self.connectStatus == 1) {
        
        NSLog(@"Socket Connect: YES!");
        
        return ;
    }
    
    self.connectStatus = 0;
    
    self.tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                                delegateQueue:dispatch_get_global_queue(0, 0)];
    
    NSError *error = nil;
    
    if (![self.tcpSocket connectToHost:self.currentHost
                                onPort:self.currentPort
                                 error:&error]) {
        
        self.connectStatus = -1;
        
        NSLog(@"connect error: --- %@", error);
    }
}

/**
 *  socket 连接失败后重连的操作
 */
-(void)socketDidDisconnectBeginSendReconnect {
    
    self.connectStatus = -1;
    
    if (self.connectCount >= 0 && self.connectCount < TCPConnectLimit) {
        
        NSTimeInterval time = pow(2, self.connectCount);
        
        if (!self.connectTimer) {
            
            self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                   target:self
                                                                 selector:@selector(reconnection)
                                                                 userInfo:nil
                                                                  repeats:NO];
            
            [[NSRunLoop mainRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
            
            [self.connectTimer fire];
        }
        
        self.connectCount++;
        
        [self socketDidDisconnectBeginSendReconnect];
    }
    else{
        
        return ;
    }
}

// socket 重连
-(void)reconnection {
    
    NSError *error = nil;
    
    if (![self.tcpSocket connectToHost:self.currentHost
                                onPort:self.currentPort
                           withTimeout:TIMEOUT
                                 error:&error]) {
        
        self.connectStatus = -1;
        
        NSLog(@"connect error: --- %@", error);
    }
}

-(void)socketStopReconnect {
    
    self.connectCount = TCPConnectLimit;
}


-(void)disconnectSocket {
    
    self.connectStatus = -1;
    
    self.connectCount = 0;
    
    [self.tcpSocket disconnect];
}


#pragma mark - data exchange
#pragma mark -- send data
-(void)tcpWriteData:(nonnull NSData *)data andTag:(long)tag {
    [self.tcpSocket writeData:data withTimeout:-1 tag:tag];
}

#pragma mark -- read data
-(void)tcpReadData {
    
    [self.tcpSocket readDataWithTimeout:-1 tag:0];
}

-(void)tcpReadDataWithTag:(long)tag {
    [self.tcpSocket readDataWithTimeout:TIMEOUT tag:tag];
}

-(void)tcpReadDataInRunLoop {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1                     // 给个0.1s 的间隔，不然CPU消耗太大
                                                 target:self
                                               selector:@selector(tcpReadData)
                                               userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        CFRunLoopRun();
    });
}

#pragma mark - delegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    self.connectStatus = 1;
    
    [self socketStopReconnect];
    
    NSLog(@"tcp connect success");
    // 发送握手
    [self tcpWriteData:[[MSConnectManager sharedInstance].dataManager getHandShakeData]
                andTag:0];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    self.connectStatus = -1;
    
    NSLog(@"tcp connect failed : %@", err);
    
    [self socketDidDisconnectBeginSendReconnect];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    NSLog(@"tcp did receive data");
    
    if (data) {
        self.tcpDataBlock(data);
    }
}


@end
