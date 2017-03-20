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

@interface SmartUDPManager()<AsyncUdpSocketDelegate>

@property (nullable, nonatomic, assign) const char *ssid;

@property (nullable, nonatomic, assign) const char *pwd;

@property (nullable, nonatomic, assign) const char *key;

@property (nonatomic, assign) U8 ip;

@property (nullable, nonatomic, strong) NSTimer *udpTimer;

@property (nullable, nonatomic, strong) AsyncUdpSocket *udpSocket;

@property (nonatomic, strong, nonnull) GCDAysncSocketDataManager *dataManager;

@property (nullable, nonatomic, strong) NSTimer *broadTimer;

@end

@implementation SmartUDPManager

+(instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SmartUDPManager alloc] init];
    });
    
    return manager;
}


-(instancetype)initWithSSID:(NSString *)ssid pswd:(NSString *)pswd {
    
    if (self = [super init]) {
        
        self.ssid = [ssid UTF8String];
        
        self.pwd  = [pswd UTF8String];
        
        self.key  = [@"" UTF8String];
        
        struct in_addr addr;
        
        inet_aton([[CommonUtil deviceIPAdress:IPType_addr] UTF8String], &addr);
        
        self.ip = CFSwapInt32BigToHost(ntohl(addr.s_addr));
        
        [self udpSocket];
        
        [self udpTimer];
    }
    
    return self;
}

-(AsyncUdpSocket *)udpSocket {
    
    if (!_udpSocket) {
        
        _udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
        
        NSError *error = nil;
        
        [_udpSocket bindToPort:UDP_PORT_C
                         error:&error];
        
        if(error)
            NSLog(@"AsyncUdpSocket bindToPort error:%@",error);
        
        [_udpSocket joinMulticastGroup:UDP_HOST_C
                                 error:&error];
        
        [_udpSocket enableBroadcast:YES
                              error:&error];
        
        [_udpSocket receiveWithTimeout:-1
                                   tag:0];
    }
    
    return _udpSocket;
}

-(GCDAysncSocketDataManager *)dataManager {
    
    if (!_dataManager) {
        
        _dataManager = [GCDAysncSocketDataManager shareInstance];
    }
    
    return _dataManager;
}

-(NSTimer *)broadTimer {
    
    if (!_broadTimer) {
        
        _broadTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(udpSocketBroad)
                                                     userInfo:nil
                                                      repeats:YES];
        
        [_broadTimer fire];
    }
    
    return _broadTimer;
}

-(void)udpSocketBroad {
    
    if (!self.dataManager) {
        
        _udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    
    NSData *serverData = [self.dataManager getGetReturnHeadDataWithCMD:CMD_GET_SERVER];
    
    NSString *wifiIPStr = [CommonUtil deviceIPAdress:IPType_desaddr];
    
    NSLog(@"broad IP = %@", wifiIPStr);
    
    sleep(TIMEOUT);
    
    // 开始广播
    [self.udpSocket
     
     sendData:serverData
     
     toHost:wifiIPStr
     
     port:UDP_PORT_S        // 协商好了的端口
     
     withTimeout:TIMEOUT    // 发送超时时长
     
     tag:0];
    
    [self.udpSocket receiveWithTimeout:TIMEOUT tag:0];
}

-(NSTimer *)udpTimer {
    
    if (!_udpTimer) {
        
        _udpTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                     target:self
                                                   selector:@selector(StartCooee)
                                                   userInfo:nil
                                                    repeats:YES];
        
        [_udpTimer fire];
    }
    
    return _udpTimer;
}

-(void)stopUdpTimer {
    
    if ([self.udpTimer isValid]) {
        
        [self.udpTimer invalidate];
        
        self.udpTimer = nil;
    }
}

-(void)stopBroadTimer {
    
    if ([self.broadTimer isValid]) {
        
        [self.broadTimer invalidate];
        self.broadTimer = nil;
    }
}

-(void)StartCooee{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"AsyncUdpSocket test smartconfig......");
        
        send_cooee(_ssid, (int)strlen(_ssid), _pwd, (int)strlen(_pwd), _key, 0, _ip);
    });
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
//    NSString *Wifi_Config_Success = @"lapsule:success";
//    //    NSString *Wifi_Config_Fail = @"lapsule:fail";
//    
//    NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    
//    if([info containsString:Wifi_Config_Success]){
//        
//        [self stopUdpTimer];
//        
//        NSString *alertStr = [NSString stringWithFormat:@"info: %@\nhost: %@\nport: %d", info, host, port];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取信息" message:alertStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        
//        [alert show];
//    }
    
    [self stopUdpTimer];
    
    [self broadTimer];
    
//    [[SmartTCPManager sharedInstance] connectSocketWithHost:host andPort:port];
    
    
    
    return YES;
}

-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    
    NSLog(@"close");
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"did not receive data");
}

//-(void)dealloc {
//    
//    if (self.udpSocket) {
//        
//        self.udpSocket = nil;
//    }
//}


@end
