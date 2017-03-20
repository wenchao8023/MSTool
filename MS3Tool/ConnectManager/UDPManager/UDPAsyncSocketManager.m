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



static UDPAsyncSocketManager *manager = nil;

@interface UDPAsyncSocketManager()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

@property (nonatomic, strong) GCDAysncSocketDataManager *dataManager;

@property (nonatomic, strong) GCDConnectConfig *connectConfig;


@property (nonatomic, strong, nonnull) NSTimer *udpTimer;


@end

@implementation UDPAsyncSocketManager

#pragma mark - init
/**
 *  创建socket单例
 */
+(UDPAsyncSocketManager *)sharedInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
//        manager = [[self alloc] init];
        
//        [manager UDPBindPort];
    });
    
    return manager;
}

/**
 *  初始化，用于创建socket单例
 */
-(instancetype)init{
    
    if (self = [super init]) {
        
        self.dataManager = [GCDAysncSocketDataManager shareInstance];
        
        self.connectConfig = [GCDConnectConfig sharedInstance];
    }
    
    return self;
}


#pragma mark - UDPSocket manage
/**
 *  socket 绑定端口
 */
-(void)UDPBindWithDelegate:(id)delegate {
    
    if (!self.udpSocket) {
        
        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
        
        NSError *error = nil;
        
        [self.udpSocket enableBroadcast:YES error:&error];
        
        [self.udpSocket bindToPort:UDP_PORT_C error:&error];
    }
    
}

- (void) UDPBindPort {
    
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    
    NSError *error = nil;
    
    [self.udpSocket enableBroadcast:YES error:&error];
    
    [self.udpSocket bindToPort:UDP_PORT_C error:&error];
}

/**
 *  socket 发送数据 在子线程中
 */
-(void)UDPSocketWriteData  {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self udpTimer];
    });
}

-(NSTimer *)udpTimer {
    
    if (!_udpTimer) {
        
        _udpTimer = [NSTimer timerWithTimeInterval:1.0                     // 每1s广播一次
                                            target:self
                                          selector:@selector(broadCastData)
                                          userInfo:nil
                                           repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_udpTimer forMode:NSDefaultRunLoopMode];
        
        CFRunLoopRun();
    }
    
    return _udpTimer;
}

- (void)beginBroadCast {
    
    [self.udpTimer setFireDate:[NSDate distantPast]];
}

- (void)stopBroadCast {
    
    [self.udpTimer setFireDate:[NSDate distantFuture]];
}


- (void)broadCastData {

    NSData *serverData = [self.dataManager getGetReturnHeadDataWithCMD:CMD_GET_SERVER];
    
    NSString *wifiIPStr = [CommonUtil deviceIPAdress:IPType_desaddr];
    
    NSLog(@"broad IP = %@", wifiIPStr);
    
    self.connectConfig.connectProgress = CProgressShouldBroadcast;
    
    [GCDAsyncSocketManager sharedInstance].connectStatus = -1;
    
    sleep(TIMEOUT);
    
    // 开始广播
    [self.udpSocket
     
     sendData:serverData
     
     toHost:wifiIPStr
     
     port:UDP_PORT_S        // 协商好了的端口
     
     withTimeout:TIMEOUT    // 发送超时时长
     
     tag:0];
    
    [self.udpSocket beginReceiving:nil];
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

    if (self.connectConfig.connectProgress == CProgressDidReceiveBroadcastData) {
        
        return ;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
         NSLog(@"UDP 已经收到返回的数据了");
        
        self.udpDataBlock(data);
        
        self.connectConfig.connectProgress = CProgressDidReceiveBroadcastData;
    });
}
@end





