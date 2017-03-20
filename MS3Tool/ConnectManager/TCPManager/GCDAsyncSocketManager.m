//
//  GCDAsyncSocketManager.m
//  MS3Tool
//
//  Created by 郭文超 on 2016/10/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "GCDAsyncSocketManager.h"
#import "GCDAsyncSocket.h"
#import "GCDHeaderFile.h"
#import "packet.h"
#import "UDPAsyncSocketManager.h"


static GCDAsyncSocketManager *manager = nil;

@interface GCDAsyncSocketManager ()

@property (nonatomic, strong) GCDAsyncSocket *socket;

@property (nonatomic, strong) NSTimer *reconnectTimer;  //重连定时器

@property (nonatomic, copy) NSString *currentHost;  // 目前正在连接的host

@property (nonatomic, assign) uint16_t currentPort;  // 目前正在连接的port

@property (nonatomic, strong, nonnull) UDPAsyncSocketManager *udpManager;

@end

@implementation GCDAsyncSocketManager


/**
 *  创建socket单例
 */
+(GCDAsyncSocketManager *)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[GCDAsyncSocketManager alloc] init];
    });
    
    return manager;
}

/**
 *  初始化，用于创建socket单例
 */
-(instancetype)init{
    
    if (self = [super init]) {
        
        self.connectStatus = -1;
        
        self.udpManager = [UDPAsyncSocketManager sharedInstance];
        
        [self addObserver:self forKeyPath:@"connectStatus" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"connectStatus"]) {
        
        self.connectStatus == 1 ? [self.udpManager stopBroadCast] : [self.udpManager beginBroadCast];
    }
}

#pragma mark - socket actions
/**
 *  socket 建连代理
 */
-(void)connectSocketWithDelegate:(id)delegate withHost:(NSString *)host andPort:(uint16_t)port {
    
    self.currentHost = host;
    
    self.currentPort = port;
    
    if (self.connectStatus == 1) {
        
        NSLog(@"Socket Connect: YES!");
        
        return ;
    }
    
    self.connectStatus = 0;
    
    //初始化socket对象
    self.socket =
    [[GCDAsyncSocket alloc] initWithDelegate:delegate delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    NSError *error = nil;
    //socket 连接服务器
    if (![self.socket connectToHost:host onPort:port withTimeout:TIMEOUT error:&error]) {
        
        self.connectStatus = -1;
        
        NSLog(@"connect error: --- %@", error);
    }
}

/**
 *  socket 连接失败后重连的操作
 */
-(void)socketDidDisconnectBeginSendReconnect {
    
    self.connectStatus = -1;
    
    if (self.reconnectionCount >= 0 && self.reconnectionCount < TCPConnectLimit) {
        
        NSTimeInterval time = pow(2, self.reconnectionCount);
        
        if (!self.reconnectTimer) {
            
            self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                   target:self
                                                                 selector:@selector(reconnection)
                                                                 userInfo:nil
                                                                  repeats:NO];
            
            [[NSRunLoop mainRunLoop] addTimer:self.reconnectTimer forMode:NSRunLoopCommonModes];
            
            [self.reconnectTimer fire];
        }
        
        self.reconnectionCount++;
        
        [self socketDidDisconnectBeginSendReconnect];
    }
    else{
        
        [self.reconnectTimer invalidate];
        
        self.reconnectTimer = nil;
        
        self.reconnectionCount = 0;
    }
}

-(void)socketWriteData:(NSData *)data andTag:(long)tag {
    
    [self.socket writeData:data withTimeout:-1 tag:tag];
    
}

/**
 *  socket 读取数据
 */
-(void)socketReadData {
    
    [self.socket readDataWithTimeout:-1 tag:0];
}


/**
 *  socket 主动断开连接
 */
-(void)disconnectSocket{
    
    self.connectStatus = -1;
    
    self.reconnectionCount = 0;
    
    [self.socket disconnect];
}

#pragma mark - private method
/**
 *  socket 重连
 */
-(void)reconnection {
    
    NSError *error = nil;
    
    if (![self.socket connectToHost:self.currentHost onPort:self.currentPort withTimeout:TIMEOUT error:&error]) {
        
        self.connectStatus = -1;
        
        NSLog(@"connect error: --- %@", error);
    }
}

@end
