//
//  UDPAsyncSocketManager.m
//  MS3Tool
//
//  Created by chao on 2016/10/19.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "UDPAsyncSocketManager.h"

#import "GCDAsyncUdpSocket.h"

#import "GCDAysncSocketDataManager.h"

#import "GCDHeaderFile.h"

#import "GCDConnectConfig.h"

#import "packet.h"

#import "GCDAsyncSocketManager.h"

#import "SmartUDPManager.h"



static UDPAsyncSocketManager *manager = nil;

@interface UDPAsyncSocketManager()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong, nullable) GCDAsyncUdpSocket *udpSocket;

@property (nonatomic, strong) GCDAysncSocketDataManager *dataManager;

@property (nonatomic, strong) GCDConnectConfig *connectConfig;


@property (nonatomic, strong, nullable) NSTimer *udpTimer;

@property (nonatomic, strong, nullable) NSTimer *serviceTimer;


@end

@implementation UDPAsyncSocketManager

#pragma mark - init

+(UDPAsyncSocketManager *)sharedInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
    });
    
    return manager;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        self.dataManager = [GCDAysncSocketDataManager shareInstance];
        
        self.connectConfig = [GCDConnectConfig sharedInstance];
        
        [self udpSocket];
    }
    
    return self;
}


#pragma mark - UDPSocket manage
/**
 *  socket 绑定端口
 */
-(GCDAsyncUdpSocket *)udpSocket {
    
    if (!_udpSocket || !_udpSocket.localPort) {
     
        if (!_udpSocket) {
        
            _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
        }
        
        NSError *error = nil;
        
        if (!_udpSocket.localPort) {
            
            [_udpSocket bindToPort:UDP_PORT_C error:&error];
        }
        
        [_udpSocket enableBroadcast:YES error:&error];
    }
    
    return _udpSocket;
}

/**
 *  socket 发送数据 在子线程中
 */
-(void)UDPSocketWriteData  {
    
    [self udpTimer];
}

-(NSTimer *)udpTimer {
    
    if (!_udpTimer) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
            _udpTimer = [NSTimer timerWithTimeInterval:1.0                     // 每1s广播一次
                                                target:self
                                              selector:@selector(broadCastData)
                                              userInfo:nil
                                               repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_udpTimer forMode:NSDefaultRunLoopMode];
            
            CFRunLoopRun();
        });
    }
    
    return _udpTimer;
}

- (void)beginBroadCast {
    
    [self udpTimer];
}

- (void)stopBroadCast {
    
    if ([_udpTimer isValid]) {
        
        [_udpTimer invalidate];
        _udpTimer = nil;
    }
    
    if ([_udpSocket isClosed] == YES) {
        [_udpSocket close];
    }
    
    if (_udpSocket) {
        _udpSocket = nil;
    }
}

- (void)broadCastData {
        
    NSData *serverData = [self.dataManager getGetReturnHeadDataWithCMD:CMD_GET_SERVER];
    
    NSString *wifiIPStr = [CommonUtil deviceIPAdress:IPType_desaddr];
    
    NSLog(@"broad IP = %@", wifiIPStr);
    
    [self.connectConfig setConnectProgress:CProgressShouldBroadcast];
    
    [GCDAsyncSocketManager sharedInstance].connectStatus = -1;
    
    //开始广播
    [self.udpSocket
     
     sendData:serverData
     
     toHost:wifiIPStr
     
     port:UDP_PORT_S        // 协商好了的端口
     
     withTimeout:TIMEOUT    // 发送超时时长
     
     tag:0];
    
    [self.udpSocket beginReceiving:nil];
}

- (void)receiveService {
    
    NSError *error ;
    
    [self.udpSocket beginReceiving:&error];
}

- (void)udpStopGetService {
    
    if ([self.serviceTimer isValid]) {
        
        [self.serviceTimer invalidate];
        
        self.serviceTimer = nil;
    }
}

#pragma mark - GCDAsyncUdpSocketDelegate
#pragma mark -- UDP_DATA
/**
 *  已经发送数据
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    
    NSLog(@"UDP 已经发送数据了");
    self.connectConfig.connectProgress = CProgressDidBroadcast;
}


/**
 *  已经收到返回的数据
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.connectConfig.connectProgress >= CProgressDidReceiveBroadcastData) {
            
            return ;
        }
        
        NSLog(@"UDP 已经收到返回的数据了");
        
        [[SmartUDPManager shareInstance] stopUdpTimer];
        
        [self stopBroadCast];
        
        [self udpStopGetService];
        
        self.connectConfig.connectProgress = CProgressDidReceiveBroadcastData;
        
        self.udpDataBlock(data);
    });
}


@end





