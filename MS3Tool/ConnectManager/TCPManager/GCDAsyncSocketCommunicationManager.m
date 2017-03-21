//
//  GCDAsyncSocketCommunicationManager.m
//  MS3Tool
//
//  Created by 郭文超 on 2016/10/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "GCDAsyncSocketCommunicationManager.h"

#import "GCDAsyncSocket.h"

#import "GCDAsyncSocketManager.h"

#import "AFNetworkReachabilityManager.h"

#import <UIKit/UIKit.h>

#import "UDPAsyncSocketManager.h"





typedef enum _SOCKET_TAG {
    
    GET_HANDSHAKE_TAG = 100,
    
    SEND_ROUTE_TAG
    
}SOCKET_TAG;

@interface GCDAsyncSocketCommunicationManager ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocketManager *socketManager;

@property (nonatomic, strong) UDPAsyncSocketManager *udpManager;

@property (nonatomic, strong) CMDDataConfig *cmdConfig;

@property (nonatomic, copy, nullable) NSString *routerSSID;

@property (nonatomic, copy, nullable) NSString *routerPassword;

@property (nonatomic, strong, nullable) NSMutableData *albumData;

@property (nonatomic, assign) BOOL isReset; // 判断是否是直连恢复出厂设置


@end


static GCDAsyncSocketCommunicationManager *manager = nil;

@implementation GCDAsyncSocketCommunicationManager

#pragma mark - init
+ (GCDAsyncSocketCommunicationManager *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.socketManager = [GCDAsyncSocketManager sharedInstance];
        
        self.dataManager = [GCDAysncSocketDataManager shareInstance];
        
        self.udpManager = [UDPAsyncSocketManager sharedInstance];
        
        self.cmdConfig = [CMDDataConfig shareInstance];
        
        self.albumData = [NSMutableData data];
        
        self.isReset = NO;
        
        [self readDataInRunloop];
    }
    
    return self;
}

- (void)rememberWifi:(NSString *)ssid pswd:(NSString *)pswd {
    
    self.routerSSID = ssid;
    
    self.routerPassword = pswd;
}

#pragma mark - socket actions
- (void)createSocketWithDelegate:(nonnull id)delegate andHost:(nonnull NSString *)host andPort:(uint16_t)port {
    
    [self.socketManager connectSocketWithDelegate:self
                                         withHost:host
                                          andPort:port];
    
    [GCDConnectConfig sharedInstance].connectProgress = CProgressShouldToConnect;
}

-(void)createSocketToReset {
    
    self.isReset = YES;
    
    [self createSocketWithDelegate:self
                           andHost:TCP_HOST
                           andPort:TCP_PORT];
}

//  断开连接
- (void)disconnectSocket {
    
    [self.socketManager disconnectSocket];
}

//  给服务器写数据
- (void)socketWriteDataWithData:(NSData *)requestData andTag:(long)tag {
    
    [self.socketManager socketWriteData:requestData
                                 andTag:tag];
}

#pragma mark -- 还原所有连接设置，重新连接
- (void)resetToConnect {
    
    [self.socketManager disconnectSocket];
    
    [GCDConnectConfig sharedInstance].connectProgress = CProgressShouldToConnect;
}

#pragma mark - GCDAsycnSocketDelegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    self.socketManager.connectStatus = 1;
    
    GCDConnectConfig *config = [GCDConnectConfig sharedInstance];
    
    if (config.connectProgress == CProgressShouldToConnect) {
        
        NSLog(@"tcp 第一次连接成功，发送握手");
        
        config.connectProgress = CProgressDidConnect;
        
        [self handShake];
        
    } else if (config.connectProgress == CProgressDidReceiveBroadcastData ||
               config.connectProgress == CProgressShouldReConnect){
        
        NSLog(@"tcp 第二次连接成功，发送握手");
        
        config.connectProgress = CProgressDidReConnect;
        
        [self handShake];
    }
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    NSLog(@"socket disconnect ------ ");
    
    self.socketManager.connectStatus = -1;
    
    
//    [self.socketManager socketDidDisconnectBeginSendReconnect];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    [self analysisData:data];
}



#pragma mark - 数据解析
-(void)analysisData:(NSData *)data {

    int cmd = [self.dataManager getDataCMD:data];
    
    if (cmd == CMD_HANDSHAKE_R) {   // 握手返回
    
        [self handShakeBack];
        
    } else if (cmd == CMD_GET_SERVER_R) {   //  udp返回
        
        [self udpBack:data];
        
    } else if (cmd == CMD_GET_VOLUME_R ||               // value返回
               cmd == CMD_GET_PLAYSTATE_R ||
               cmd == CMD_GET_playProgress_R ||
               cmd == CMD_GET_currentPlayStyle_R ||
               cmd == CMD_GET_currentDuration_R ||
               cmd == CMD_SET_APPCollectMusic_R ||
               cmd == CMD_SET_currentPlayAlbum_R ||
               cmd == CMD_NOT_volume ||
               cmd == CMD_NOT_controlPlay ||
               cmd == CMD_NOT_controlStatus) {
        
        /* 设置播放列表成功之后需要重新获取播放列表 */
        if (cmd == CMD_SET_currentPlayAlbum_R) {
            
            [[VoicePlayer shareInstace] VPGetPlayAlbum_begin:0];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cmdConfig setDicWithCMD:cmd
                                 andValue:[self.dataManager getValueWithData:data]];
        });
        
        
    } else if (cmd == CMD_SET_VOLUME_R ||               // 命令码返回
               cmd == CMD_SET_PLAYCONTROLE_R ||
               cmd == CMD_SET_playUrl_R ||
               cmd == CMD_SET_playProgress_R ||
               cmd == CMD_SET_collect_R ||
               cmd == CMD_SET_play_album_R ||
               cmd == CMD_SET_currentPlayStyle_R ||
               cmd == CMD_SET_cancelCollect_R) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cmdConfig setDicWithCMD:cmd andBool:YES];
        });
        
    } else if (cmd == CMD_GET_playAlbum_R ||
               cmd == CMD_GET_current_musicInfo_R ||
               cmd == CMD_GET_record_musicInfo_R ||
               cmd == CMD_GET_voiceboxInfo_R ||
               cmd == CMD_NOT_collect) {                               // 字典返回
        
       dispatch_async(dispatch_get_main_queue(), ^{
           
           NSDictionary *getDataDic;
           
           if (cmd == CMD_GET_playAlbum_R) {   // 播放列表 或收藏列表
               
               NSInteger length = sizeof(get_return_playAlbum);
               
               for (int i = 0; (i + 1) * length <= data.length; i++) {
                   
                   NSData *tempData = [data subdataWithRange:NSMakeRange(i * length, length)];
                   
                   /* 播放列表中的歌曲信息 */
                   NSDictionary *tempDic = [self.dataManager getPlayAlbum:tempData];
                   
                   int errNo = [self.dataManager getErrorNo:tempData];
                   
                   [self.cmdConfig setAlbumWithCMD:cmd
                                             errNo:errNo
                                               dic:tempDic];
               }
               
           } else if (cmd == CMD_GET_voiceboxInfo_R) {   // 音箱信息
               
               getDataDic = [self.dataManager getVoiceBoxInfo:data];
               
           } else {    // 音乐信息
               
               getDataDic = [self.dataManager getMusicInfo:data];
               
               [self.cmdConfig setPlayIndex:[[getDataDic objectForKey:@"index"] intValue]];
           }
           
           [self.cmdConfig setDicWithCMD:cmd
                                  andDic:getDataDic];
       });
    }
    
    self.cmdConfig.getCMD = cmd;
    
    [self addNotify];
}

#pragma mark - send data
//  请求握手授权
-(void)handShake {
    
    [self socketWriteDataWithData:[self.dataManager getHandShakeData]
                           andTag:GET_HANDSHAKE_TAG];
}

//  发送路由信息
-(void)sendRouteDataWithSSID:(NSString *)ssid andPassword:(NSString *)password {
    
    NSData *requestData = [self.dataManager getRouterInfoDataWithSSID:ssid
                                                          andPassword:password];
    
    [self socketWriteDataWithData:requestData
                           andTag:SEND_ROUTE_TAG];
}

//  开始广播
-(void)udpBroadcast {
    
    [self.udpManager UDPSocketWriteData];

    __weak typeof(&*self) sself = self;

    self.udpManager.udpDataBlock = ^(NSData *data) {
        
        [sself analysisData:data];
    };
}

- (void)udpStopBroadcast {
    
    [self.udpManager stopBroadCast];
}





#pragma mark - read data in runloop
- (void)readDataInRunloop {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1                     // 给个0.1s 的间隔，不然CPU消耗太大
                                                 target:self.socketManager
                                               selector:@selector(socketReadData)
                                               userInfo:nil repeats:YES];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        NSLog(@"read socket data currentRunLoop = %@", [runLoop description]);
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        CFRunLoopRun();
    });
}

#pragma mark - connectBack
- (void)handShakeBack {
    
    if ([GCDConnectConfig sharedInstance].connectProgress == CProgressDidConnect) {
        
        if (self.isReset) {     // 恢复出厂设置连接
            
            NSData *data = [self.dataManager getGetReturnHeadDataWithCMD:CMD_SET_resetFactory];
            
            [self socketWriteDataWithData:data andTag:0];
            
        } else {    // WiFi连接
            
            NSLog(@"握手成功，发送路由");
            
            [GCDConnectConfig sharedInstance].connectProgress = CProgressShouldSendRoute;
            
            [self sendRouteDataWithSSID:self.routerSSID
                            andPassword:self.routerPassword];
            
            [GCDConnectConfig sharedInstance].connectProgress = CProgressDidSendRoute;

        }
    }
    
    if ([GCDConnectConfig sharedInstance].connectProgress == CProgressDidReConnect) {
        
        NSLog(@"握手成功, 开始具体业务请求");
        
        [GCDConnectConfig sharedInstance].connectProgress = CProgressShouldConnectSuccess;
        
//        [[VoicePlayer shareInstace] VPGetPlayAlbum_begin:0];
    }
}
- (void)udpBack:(NSData *)data {
    
    GCDConnectConfig *config = [GCDConnectConfig sharedInstance];
    
    if (config.connectProgress == CProgressDidReceiveBroadcastData) {
        
        config.connectProgress = CProgressShouldReConnect;
        
        [self tcpReConnect:data];
    }
}

//  解析广播数据，重新连接音箱
-(void)tcpReConnect:(NSData *)data {
    
    NSDictionary *tempDic = [self.dataManager getUDPServerReturnWithData:data];
    
    for (id obj in tempDic) {
        
        NSLog(@"routerInfo = \n[key: %@, value: %@]", (NSString *)obj, tempDic[obj]);
    }
    
    //  发起二次连接
    NSLog(@"发起二次连接");
    
    [GCDConnectConfig sharedInstance].connectProgress = CProgressShouldReConnect;
    
    [self.socketManager connectSocketWithDelegate:self
                                         withHost:[tempDic objectForKey:@"IP"]
                                          andPort:[[tempDic objectForKey:@"PORT"] integerValue]];
}



#pragma mark - 网络判断
/**
 *  开始检测网络状况
 *  测试版：没有给网络限制
 *  正式版：只在WiFi环境中使用
 */
- (void)startMonitoringNetwork {
    AFNetworkReachabilityManager *networkManger = [AFNetworkReachabilityManager sharedManager];
    
    [networkManger startMonitoring];
    
    __weak typeof(&*self) weakSelf = self;
    
    [networkManger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:
                
                if (weakSelf.socketManager.connectStatus != -1) {
                    
                    [self disconnectSocket];
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                if (weakSelf.socketManager.connectStatus == -1) {
                    
                    
                }
                break;
                
            default:
                break;
        }
    }];
}




#pragma mark - add notify
- (void)addNotify {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CMDDATARETURN object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CMDDATARETURN object:nil];
}
@end
