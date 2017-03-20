//
//  SmartUDPManager.m
//  MS3Tool
//
//  Created by chao on 2017/3/18.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "SmartUDPManager.h"


#import "AsyncUdpSocket.h"

#import "SmartTCPManager.h"

#import "GCDAysncSocketDataManager.h"




#import "cooee.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

static SmartUDPManager *manager = nil;

@interface SmartUDPManager()<AsyncUdpSocketDelegate> {
    const char *_sid;
    
    const char *_pwd;
    
    const char *_key;
}

//@property (nullable, nonatomic, assign) const char *sid;
//
//@property (nullable, nonatomic, assign) const char *pwd;
//
//@property (nullable, nonatomic, assign) const char *key;

@property (nonatomic, assign) uint32_t ip;

@property (nullable, nonatomic, strong) NSTimer *udpTimer;

@property (nullable, nonatomic, strong) AsyncUdpSocket *udpSocket;

@property (nonatomic, strong, nonnull) GCDAysncSocketDataManager *dataManager;

@property (nullable, nonatomic, strong) NSTimer *broadTimer;

@property (nonatomic, nonnull, strong) NSString *wifiName;

@end

@implementation SmartUDPManager

+(instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SmartUDPManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init {
 
    if (self = [super init]) {
        
        self.dataManager = [GCDAysncSocketDataManager shareInstance];
    }
    
    return self;
}

-(void)sendRouteInfoSSID:(NSString *)ssid pswd:(NSString *)pswd {
    
    self.wifiName = [[NSUserDefaults standardUserDefaults] objectForKey:@"wifiname"];
    
    _sid = [self.wifiName UTF8String];
    
    NSString *pswdddd = [CommonUtil getPasswordFromWifiTableWithSSID:self.wifiName];
    
    _pwd  = [pswdddd UTF8String];
    
    _key  = [@"" UTF8String];
    
    struct in_addr addr;
    
    inet_aton([[CommonUtil deviceIPAdress:IPType_addr] UTF8String], &addr);
    
    self.ip = CFSwapInt32BigToHost(ntohl(addr.s_addr));
    
    [self createSocketIsJoinGroup:YES];
    
    // 开启广播路由信息
    [self udpTimer];
}

-(void)createSocketIsJoinGroup:(BOOL)isJoinGroup {
    
    if (!_udpSocket) {
        
        _udpSocket = [[AsyncUdpSocket alloc]
                      initWithDelegate:self];
    }
    
    NSError *error = nil;
    
    [_udpSocket bindToPort:UDP_PORT_C
                     error:&error];
    [_udpSocket enableBroadcast:YES
                          error:&error];
    
    if (isJoinGroup) {
       
        [_udpSocket joinMulticastGroup:UDP_HOST_C
                                 error:&error];
    }
    
    [_udpSocket receiveWithTimeout:-1
                               tag:0];
}


-(NSTimer *)udpTimer {
    
    if (!_udpTimer) {
        
        _udpTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                     target:self
                                                   selector:@selector(startCooee)
                                                   userInfo:nil
                                                    repeats:YES];
        
        [_udpTimer fire];
        
        [self.udpTimer addObserver:self
                        forKeyPath:@"isValid"
                           options:NSKeyValueObservingOptionNew
                           context:nil];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self stopUdpTimer];
//        });
    }
    
    return _udpTimer;
}

-(void)startCooee{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"AsyncUdpSocket smartconfig......");
        
        send_cooee(_sid, (int)strlen(_sid), _pwd, (int)strlen(_pwd), _key, 0, self.ip);
    });
}

-(void)stopUdpTimer {
    
    if ([self.udpTimer isValid]) {
        
        [self.udpTimer invalidate];
        self.udpTimer = nil;
        
        [self closeSocket];
        
        [self createSocketIsJoinGroup:NO];
        
        [self broadTimer];
    }
}


-(NSTimer *)broadTimer {
    
    if (!_broadTimer) {
        
        _broadTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(startBroadCast)
                                                     userInfo:nil
                                                      repeats:YES];
        
        [_broadTimer fire];
    }
    
    return _broadTimer;
}

-(void)startBroadCast {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"AsyncUdpSocket broadcast......");
        
        [_udpSocket sendData:[self.dataManager getGetReturnHeadDataWithCMD:CMD_GET_SERVER]
                      toHost:[CommonUtil deviceIPAdress:IPType_desaddr]
                        port:UDP_PORT_S
                 withTimeout:TIMEOUT
                         tag:0];
        
        [self.udpSocket receiveWithTimeout:TIMEOUT tag:0];
    });
}

-(void)stopBroadTimer {
    
    if ([self.broadTimer isValid]) {
        
        [self.broadTimer invalidate];
        self.broadTimer = nil;
        
        [self closeSocket];
    }
}

-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString *Wifi_Config_Success = @"lapsule:success";
    //    NSString *Wifi_Config_Fail = @"lapsule:fail";
    
    NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if([info containsString:Wifi_Config_Success]){
        
        [self stopUdpTimer];
        
        NSString *alertStr = [NSString stringWithFormat:@"info: %@\nhost: %@\nport: %d", info, host, port];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取信息" message:alertStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    NSLog(@"on udp did receive data...");
    
    [self stopUdpTimer];
    
//    [[GCDAsyncSocketCommunicationManager sharedInstance] createSocketWithDelegate:nil andHost:host andPort:port];
    
//    [self broadTimer];
    
    return YES;
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    
    NSLog(@"on udp did send data...");
}

-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    
    NSLog(@"on udp did close...");
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"on udp did not receive data...");
}

-(void)closeSocket {
    if (![self.udpSocket isClosed])
        [self.udpSocket close];
    
    self.udpSocket = nil;
}


@end
