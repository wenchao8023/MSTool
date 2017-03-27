//
//  MSUDPManager.m
//  MS3Tool
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "MSUDPManager.h"

#import "GCDAsyncUdpSocket.h"



static MSUDPManager *manager = nil;

@interface MSUDPManager()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong, nullable) GCDAsyncUdpSocket *udpSocket;

@property (nonatomic, strong) GCDAysncSocketDataManager *dataManager;


@property (nonatomic, strong, nullable) NSTimer *udpTimer;

@property (nonatomic, strong, nullable) NSTimer *serviceTimer;


@end

@implementation MSUDPManager

#pragma mark - init

+(MSUDPManager *)sharedInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
    });
    
    return manager;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        self.dataManager = [GCDAysncSocketDataManager shareInstance];
        
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
            
            [_udpSocket setIPv4Enabled:YES];
            
            [_udpSocket setIPv6Enabled:NO];
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
            
            _udpTimer = [NSTimer timerWithTimeInterval:TIMEOUT                     // 每 0.3s 广播一次
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

    NSLog(@"broad IP = %@", [CommonUtil deviceIPAdress:IPType_desaddr]);
    
    //开始广播
    [self.udpSocket
     
     sendData:[self.dataManager getGetReturnHeadDataWithCMD:CMD_GET_SERVER]
     
     toHost:[CommonUtil deviceIPAdress:IPType_desaddr]
     
     port:UDP_PORT_S        // 协商好了的端口
     
     withTimeout:TIMEOUT    // 发送超时时长
     
     tag:0];
    
    [self.udpSocket beginReceiving:nil];
}

#if 0
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
#endif


#pragma mark - GCDAsyncUdpSocketDelegate
#pragma mark -- UDP_DATA
/**
 *  已经发送数据
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    
    NSLog(@"UDP 已经发送数据了");
}

/**
 *  已经收到返回的数据
 **/

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {
    
    NSLog(@"UDP 已经收到返回的数据了");

    self.udpDataBlock(data);

}


@end
