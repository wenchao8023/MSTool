//
//  MSConnectManager.m
//  MS3Tool
//
//  Created by chao on 2017/3/23.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "MSConnectManager.h"

#import "MSSmartUDPManager.h"

#import "MSUDPManager.h"

#import "MSTCPManager.h"


static MSConnectManager *manager = nil;

@interface MSConnectManager ()

@property (nonatomic, strong) MSSmartUDPManager *smartManager;

@property (nonatomic, strong) MSUDPManager *udpManager;

@property (nonatomic, strong) MSTCPManager *tcpManager;

@property (nonatomic, strong) CMDDataConfig *cmdConfig;

@property (nonatomic, strong, nullable) NSMutableData *albumData;



@end

@implementation MSConnectManager

#pragma mark - init containers
+ (nonnull MSConnectManager *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MSConnectManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init {
    
    if (self = [super init]) {
        
        self.smartManager = [MSSmartUDPManager shareInstance];
        
        self.udpManager = [MSUDPManager sharedInstance];
        
        self.tcpManager = [MSTCPManager sharedInstance];
        
        self.dataManager = [GCDAysncSocketDataManager shareInstance];
        
        self.cmdConfig = [CMDDataConfig shareInstance];
    }
    
    return self;
}

#pragma mark - manager TCP
-(void)tcpConnectWithHost:(NSString *)host andPort:(uint16_t)port {
    
    [self.tcpManager tcpSocketwithHost:host andPort:port];
    
    __weak typeof(&*self) sself = self;
    self.tcpManager.tcpDataBlock = ^(NSData *data) {
        [sself analysisData:data];
    };
}

- (BOOL)tcpConnectStatus {
    
    return [self.tcpManager TcpConnectStatus] == 1 ? YES : NO;
}

- (void)tcpWriteDataWithData:(nonnull NSData *)requestData andTag:(long)tag {
    
    [self.tcpManager tcpWriteData:requestData andTag:tag];
}

- (void)tcpDisconnect {
    
    [self.tcpManager tcpDisconnectSocket];
}


#pragma mark - manager UDP
/**
 *  开始广播
 */
-(void)udpBroadcast {
    
    [self.udpManager UDPSocketWriteData];
    
    __weak typeof(&*self) sself = self;
    
    self.udpManager.udpDataBlock = ^(NSData *data) {
        
        [sself analysisData:data];
    };
}

/**
 *  停止广播
 */
-(void)udpStopBroadcast {
    
    [self.udpManager stopBroadCast];
}


#pragma mark - manager smart config
-(void)smartConfig {
    
    [self.smartManager smartConfig];
}

-(void)smartStopConfig {
    [self.smartManager stopUdpTimer];
}


#pragma mark - analyse data
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

    } else if (cmd == CMD_NOT_album_change) {   // 通知 - 播放列表变化
        
                    NSLog(@"播放列表变化了");
                    [[VoicePlayer shareInstace] VPGetPlayAlbum_begin:0];
    }
    
    self.cmdConfig.getCMD = cmd;
    
    [self postNotify];
}

#pragma mark -- commandBack
- (void)handShakeBack {
    
    NSLog(@"握手成功, 开始具体业务请求");
    
    [self.smartManager stopUdpTimer];
    
    [self.udpManager stopBroadCast];
    
    [[VoicePlayer shareInstace] VPGetPlayAlbum_begin:0];
}

- (void)udpBack:(NSData *)data {
    
    NSDictionary *tempDic = [self.dataManager getUDPServerReturnWithData:data];
    
    for (id obj in tempDic) {
        
        NSLog(@"routerInfo = \n[key: %@, value: %@]", (NSString *)obj, tempDic[obj]);
    }

    [self tcpConnectWithHost:[tempDic objectForKey:@"IP"]
                     andPort:[[tempDic objectForKey:@"PORT"] integerValue]];
}

#pragma mark -- add notify
- (void)postNotify {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CMDDATARETURN object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CMDDATARETURN object:nil];
}


@end
