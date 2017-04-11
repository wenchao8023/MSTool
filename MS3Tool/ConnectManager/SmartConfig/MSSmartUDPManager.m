//
//  MSSmartUDPManager.m
//  MS3Tool
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "MSSmartUDPManager.h"

#import "AsyncUdpSocket.h"

#import "MSConnectManager.h"

#import "cooee.h"
#import <ifaddrs.h>
#import <arpa/inet.h>


static MSSmartUDPManager *manager = nil;

@interface MSSmartUDPManager ()<AsyncUdpSocketDelegate> {
    const char *_sid;
    
    const char *_pwd;
    
    const char *_key;
}

@property (nonatomic, assign) uint32_t ip;

@property (nullable, nonatomic, strong) NSTimer *udpTimer;

@property (nullable, nonatomic, strong) AsyncUdpSocket *udpSocket;

@end

@implementation MSSmartUDPManager

+(instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MSSmartUDPManager alloc] init];
    });
    
    return manager;
}

-(void)smartConfig {
    
    [[MSConnectManager sharedInstance] tcpDisconnect];
    
    [self udpSocket];
    
    // 开启广播路由信息
    [self udpTimer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MSConnectManager sharedInstance] udpBroadcast];
    });
}

-(AsyncUdpSocket *)udpSocket {
    
    if (!_udpSocket || !_udpSocket.localPort) {
        
        if (!_udpSocket) {
            
            _udpSocket = [[AsyncUdpSocket alloc]
                          initWithDelegate:self];
        }

        NSError *error = nil;
        
        if (!_udpSocket.localPort) {
            
            [_udpSocket bindToPort:UDP_PORT_G
                             error:&error];
        }
        
        [_udpSocket enableBroadcast:YES
                              error:&error];
        
        [_udpSocket joinMulticastGroup:UDP_HOST_C
                                 error:&error];
        
        [_udpSocket receiveWithTimeout:-1
                                   tag:0];
    }
    
    return _udpSocket;
}

-(NSTimer *)udpTimer {
    
    if (!_udpTimer) {
        
        _udpTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                     target:self
                                                   selector:@selector(startCooee)
                                                   userInfo:nil
                                                    repeats:YES];
        
        [_udpTimer fire];
    }
    
    return _udpTimer;
}

-(void)startCooee{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"AsyncUdpSocket smartconfig......");
        
        _sid = [[[NSUserDefaults standardUserDefaults] objectForKey:CRT_WIFI_SSID] UTF8String];
        
        _pwd  = [[[NSUserDefaults standardUserDefaults] objectForKey:CRT_WIFI_PSWD] UTF8String];
        
        _key  = [@"" UTF8String];
        
        struct in_addr addr;
        
        inet_aton([[CommonUtil deviceIPAdress:IPType_addr] UTF8String], &addr);
        
        self.ip = CFSwapInt32BigToHost(ntohl(addr.s_addr));
        
        send_cooee(_sid, (int)strlen(_sid),
                   _pwd, (int)strlen(_pwd),
                   _key, 0,
                   self.ip);
    });
}

-(void)stopUdpTimer {
    
    if ([_udpTimer isValid])
    {
        [_udpTimer invalidate];
        _udpTimer = nil;
    }
    
    if ([_udpSocket isClosed] == YES)
    {
        [_udpSocket close];
        _udpSocket = nil;
    }
}




#if 0
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString *Wifi_Config_Success = @"lapsule:success";
    //  NSString *Wifi_Config_Fail = @"lapsule:fail";
    
    NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if([info containsString:Wifi_Config_Success]){
        
        NSString *alertStr = [NSString stringWithFormat:@"info: %@\nhost: %@\nport: %d", info, host, port];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取信息" message:alertStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    NSLog(@"on udp did receive data...");
    
    
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
#endif

@end
