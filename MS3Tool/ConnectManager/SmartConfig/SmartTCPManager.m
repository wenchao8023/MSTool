//
//  SmartTCPManager.m
//  MS3Tool
//
//  Created by chao on 2017/3/18.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "SmartTCPManager.h"

#import "AsyncSocket.h"


static SmartTCPManager *manager = nil;


@interface SmartTCPManager ()<AsyncSocketDelegate>

@property (nonatomic, nullable, strong) AsyncSocket *socket;

@property (nonatomic, strong) NSTimer *reconnectTimer;  //重连定时器

@property (nonatomic, assign) NSInteger reconnectionCount;  //建连失败重连次数

@property (nonatomic, copy) NSString *currentHost;  // 目前正在连接的host

@property (nonatomic, assign) uint16_t currentPort;  // 目前正在连接的port

@property (nonatomic, assign) NSInteger connectStatus;  // 连接状态：1 - 已连接， -1 - 未连接， 0 - 连接中



@end

@implementation SmartTCPManager
/**
 *  创建socket单例
 */
+(SmartTCPManager *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SmartTCPManager alloc] init];
    });
    
    return manager;
}

/**
 *  初始化，用于创建socket单例
 */
-(instancetype)init{
    
    if (self = [super init]) {

    }
    
    return self;
}

#pragma mark - socket actions
#pragma mark -- socket 建连代理
-(void)connectSocketWithHost:(NSString *)host andPort:(uint16_t)port {
    
    self.currentHost = host;
    self.currentPort = port;
    
    if (self.connectStatus == 1) {
        
        NSLog(@"Socket Connect: YES!");
        return ;
    }
    
    self.connectStatus = 0;
    if (!self.socket)
        self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    if (![self.socket connectToHost:host
                             onPort:port
                        withTimeout:TIMEOUT
                              error:&error])
        [self socketDidDisconnectBeginSendReconnect];
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    
    NSLog(@"已经连上网络");
    [self.socket readDataWithTimeout:TIMEOUT tag:0];
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
    
}
/**
 *  socket 连接失败后重连的操作
 */
-(void)socketDidDisconnectBeginSendReconnect {
    
    self.connectStatus = -1;
    
    if (self.reconnectionCount >= 0 && self.reconnectionCount < TCPConnectLimit) {
        
        NSTimeInterval time = pow(2, self.reconnectionCount);
        
        [self performSelector:@selector(reconnection) withObject:nil afterDelay:time];

        self.reconnectionCount++;
        
        [self socketDidDisconnectBeginSendReconnect];
    }
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
    
    NSLog(@"reconnection");
    
    NSError *error = nil;
    
    if (![self.socket connectToHost:self.currentHost onPort:self.currentPort withTimeout:TIMEOUT error:&error]) {
        
        self.connectStatus = -1;
        
        NSLog(@"connect error: --- %@", error);
    }
}



@end
