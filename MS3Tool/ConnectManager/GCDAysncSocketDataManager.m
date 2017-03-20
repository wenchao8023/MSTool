//
//  GCDAysncSocketDataManager.m
//  MS3Tool
//
//  Created by chao on 2016/10/26.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "GCDAysncSocketDataManager.h"
#import "packet.h"

static GCDAysncSocketDataManager *dataManager = nil;
@implementation GCDAysncSocketDataManager

+(instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataManager = [[GCDAysncSocketDataManager alloc] init];
    });
    
    return dataManager;
}

#pragma mark - 发送数据的NSData
-(NSData *)getHandShakeData {
    
    int length = (int)sizeof(handshake);
    
    handshake hand_Shake;
    
    hand_Shake.head = [self getPackHeadwithHeadSize:length andCMD:CMD_HANDSHAKE];
    
    char tempAuth[kCHAR16] = AUTHCODE;
    
    memcpy(hand_Shake.authCode, tempAuth, sizeof(hand_Shake.authCode));
    
    return [[NSData alloc] initWithBytes:&hand_Shake length:length];
}

-(NSData *)getRouterInfoDataWithSSID:(NSString *)ssid andPassword:(NSString *)password {
    
    int length = sizeof(set_routerInfo);
    
    set_routerInfo setRouterInfo;
    
    setRouterInfo.head = [self getPackHeadwithHeadSize:length andCMD:CMD_SET_ROUTERINFO];
    
    memcpy(setRouterInfo.ssid, [ssid cStringUsingEncoding:NSUTF8StringEncoding], sizeof(setRouterInfo.ssid));
    
    memcpy(setRouterInfo.password, [password cStringUsingEncoding:NSUTF8StringEncoding], sizeof(setRouterInfo.password));
    
    return [[NSData alloc] initWithBytes:&setRouterInfo length:length];
}

-(NSData *)getGetReturnHeadDataWithCMD:(int)cmd {
    
    int length = (int)sizeof(get_return_head);
    
    get_return_head getReturnHead;
    
    getReturnHead.head = [self getPackHeadwithHeadSize:length andCMD:cmd];
    
    return [[NSData alloc] initWithBytes:&getReturnHead length:length];
}

-(NSData *)getSetReturnHeadAndValueDataWithCMD:(int)cmd andValue:(int)value {
    
    int length = (int)sizeof(set_return_headAndValue);
    
    set_return_headAndValue setReturnHeadAndValue;
    
    setReturnHeadAndValue.head = [self getPackHeadwithHeadSize:length andCMD:cmd];
    
    setReturnHeadAndValue.value = htonl(value);
    
    return [[NSData alloc] initWithBytes:&setReturnHeadAndValue length:length];
}


- (NSData *) getGetReturnCurrentUrlDataWithCMD:(int)cmd andURLLength:(int)urlLength andURL:(NSString *)url {
    
    int length = (int)sizeof(get_return_currentUrl);
    
    get_return_currentUrl getReturnCurrentUrl;
    
    getReturnCurrentUrl.head = [self getPackHeadwithHeadSize:length andCMD:cmd];
    
    getReturnCurrentUrl.value = htonl(kMAXLEN_url);
    
    memcpy(getReturnCurrentUrl.urls, [url cStringUsingEncoding:NSUTF8StringEncoding], urlLength);
    
    return [[NSData alloc] initWithBytes:&getReturnCurrentUrl length:length];
}


/**
 编码 播放列表中的歌曲

 @param flag 标识，0 当前播放列表；1收藏列表
 @param index 歌曲在列表中的下标
 @return 播放列表中的歌曲二进制数据
 */
- (NSData *) getAlbumUrlDataWithFlag:(int)flag index:(NSInteger)index {
    
    int length = (int)sizeof(get_album_url);
    
    get_album_url getAlbumUrl;
    
    getAlbumUrl.head = [self getPackHeadwithHeadSize:length andCMD:CMD_SET_play_album];
    
    getAlbumUrl.flag = htonl(flag);
    
    getAlbumUrl.index = htonl(index);
    
    return [[NSData alloc] initWithBytes:&getAlbumUrl length:length];
}

- (NSData *) getReturnAPPCollectMusicWithCMD:(int)cmd dataDic:(NSDictionary *)dic {
    
    int length = (int)sizeof(get_return_APPCollectMusic);
    
    get_return_APPCollectMusic getAppCollect;
    
    getAppCollect.head = [self getPackHeadwithHeadSize:length andCMD:cmd];
    
    memcpy(getAppCollect.musicName, [[dic objectForKey:@"musicName"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.musicName));
    
    memcpy(getAppCollect.musicUrl, [[dic objectForKey:@"musicUrl"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.musicUrl));
    
    memcpy(getAppCollect.musicImgUrl, [[dic objectForKey:@"musicImgUrl"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.musicImgUrl));
    
    memcpy(getAppCollect.albumsName, [[dic objectForKey:@"albumsName"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.albumsName));
    
    memcpy(getAppCollect.artistsName, [[dic objectForKey:@"artistsName"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.artistsName));
    
    return [[NSData alloc] initWithBytes:&getAppCollect length:length];
}

- (NSData *) getReturnAPPCollectMusicWithCMD:(int)cmd dataDic:(NSDictionary *)dic errNo:(int)errNo {
    
    int length = (int)sizeof(get_return_APPCollectMusic);
    
    get_return_APPCollectMusic getAppCollect;
    
    getAppCollect.head = [self getPackHeadwithHeadSize:length andCMD:cmd errNo:errNo];
    
    memcpy(getAppCollect.musicName, [[dic objectForKey:@"musicName"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.musicName));
    
    memcpy(getAppCollect.musicUrl, [[dic objectForKey:@"musicUrl"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.musicUrl));
    
    memcpy(getAppCollect.musicImgUrl, [[dic objectForKey:@"musicImgUrl"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.musicImgUrl));
    
    memcpy(getAppCollect.albumsName, [[dic objectForKey:@"albumsName"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.albumsName));
    
    memcpy(getAppCollect.artistsName, [[dic objectForKey:@"artistsName"] cStringUsingEncoding:NSUTF8StringEncoding], sizeof(getAppCollect.artistsName));
    
    return [[NSData alloc] initWithBytes:&getAppCollect length:length];
}


#pragma mark - 解析音箱返回报文
#pragma mark -- 解析报文头，获取命令码
-(int)getDataCMD:(NSData *)data {
    
    if (data != nil) {
        
        pack_head packHead;
        
        [data getBytes:&packHead length:sizeof(packHead)];
        
        NSLog(@"cmd == 0x000000%x", ntohl(packHead.cmd));
        
        return ntohl(packHead.cmd);
    }
    else {
        
        return 0;
    }
}

-(int)getErrorNo:(NSData *)data {
 
    if (data != nil) {
        
        pack_head packHead;
        
        [data getBytes:&packHead length:sizeof(packHead)];
        
        NSLog(@"errNo == %x", ntohl(packHead.errNo));
        
        return ntohl(packHead.errNo);
    }
    else {
        
        return -1;
    }
}


#pragma mark -- 获取数据报文中的数据
-(int)getValueWithData:(NSData *)data {
    
    NSInteger length = sizeof(set_return_headAndValue);
    
    set_return_headAndValue setReturnHeadAndValue;
    
    [data getBytes:&setReturnHeadAndValue length:length];
    
    return ntohl(setReturnHeadAndValue.value);
}


#pragma mark -- 获取播放列表报文的dic
/** 播放列表获取返回 *
 *  命令码: 0x00000038  回复播放列表
 *  返回多次，直到收到 errNo=11 的报文表示结束
 */
//-(NSDictionary *)getPlayAlbum:(NSData *)data beginIndex:(NSUInteger)beginIndex {
//    
//    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
//    
//    get_return_playAlbum getReturnPlayAlbum;
//    
//    NSInteger length = sizeof(get_return_playAlbum);
//    
//    [data getBytes:&getReturnPlayAlbum range:NSMakeRange(beginIndex, length)];
//    
//    [mutDic setObject:@(ntohl(getReturnPlayAlbum.index)) forKey:@"index"];
//    
//    [mutDic setObject:@(ntohl(getReturnPlayAlbum.flag)) forKey:@"flag"];
//    
//    
//    char *songNameP = (char *)malloc(kMAXLEN_name);
//    
//    char *artisticP = (char *)malloc(kMAXLEN_name);
//    
//    
//    memcpy(songNameP, getReturnPlayAlbum.songName, kMAXLEN_name);
//    
//    memcpy(artisticP, getReturnPlayAlbum.artistic, kMAXLEN_name);
//    
//    
//    NSString *songNameStr = [NSString stringWithCString:songNameP encoding:NSUTF8StringEncoding];
//    
//    NSString *artisticStr = [NSString stringWithCString:artisticP encoding:NSUTF8StringEncoding];
//    
//    
//    [self setNonullObject:songNameStr key:@"songName" inDic:mutDic];
//    
//    [self setNonullObject:artisticStr key:@"artistic" inDic:mutDic];
//    
//    
//    return mutDic;
//}

-(NSDictionary *)getPlayAlbum:(NSData *)data {
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
    NSInteger length = sizeof(get_return_playAlbum);
    
    get_return_playAlbum getReturnPlayAlbum;
    
    [data getBytes:&getReturnPlayAlbum length:length];
    
    [mutDic setObject:@(ntohl(getReturnPlayAlbum.index)) forKey:@"index"];
    
    [mutDic setObject:@(ntohl(getReturnPlayAlbum.flag)) forKey:@"flag"];
    
    
    char *songNameP = (char *)malloc(kMAXLEN_name);
    
    char *artisticP = (char *)malloc(kMAXLEN_name);
    
    
    memcpy(songNameP, getReturnPlayAlbum.songName, kMAXLEN_name);
    
    memcpy(artisticP, getReturnPlayAlbum.artistic, kMAXLEN_name);
    
    
    NSString *songNameStr = [NSString stringWithCString:songNameP encoding:NSUTF8StringEncoding];
    
    NSString *artisticStr = [NSString stringWithCString:artisticP encoding:NSUTF8StringEncoding];
    
    
    [self setNonullObject:songNameStr key:@"songName" inDic:mutDic];
    
    [self setNonullObject:artisticStr key:@"artistic" inDic:mutDic];
    
    
    return mutDic;
}
//
//-(NSDictionary *)getMusicInfoInAlbumData:(NSData *)data {
//    
//    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
//    
//    NSInteger length = sizeof(get_return_playAlbum);
//    
//    get_return_playAlbum getReturnPlayAlbum;
//    
//    [data getBytes:&getReturnPlayAlbum length:length];
//    
//    [mutDic setObject:@(ntohl(getReturnPlayAlbum.index)) forKey:@"index"];
//    
//    [mutDic setObject:@(ntohl(getReturnPlayAlbum.flag)) forKey:@"flag"];
//    
//    
//    char *songNameP = (char *)malloc(kMAXLEN_name);
//    
//    char *artisticP = (char *)malloc(kMAXLEN_name);
//    
//    
//    memcpy(songNameP, getReturnPlayAlbum.songName, kMAXLEN_name);
//    
//    memcpy(artisticP, getReturnPlayAlbum.artistic, kMAXLEN_name);
//    
//    
//    NSString *songNameStr = [NSString stringWithCString:songNameP encoding:NSUTF8StringEncoding];
//    
//    NSString *artisticStr = [NSString stringWithCString:artisticP encoding:NSUTF8StringEncoding];
//    
//    
//    [self setNonullObject:songNameStr key:@"songName" inDic:mutDic];
//    
//    [self setNonullObject:artisticStr key:@"artistic" inDic:mutDic];
//    
//    
//    return mutDic;
//}
//
//- (BOOL)isExistInAlbum:(NSArray *)dataArr dic:(NSDictionary *)musicDic {
//    
//    for (NSDictionary *tempDic in dataArr) {
//        
//        if ([musicDic isEqual:tempDic]) {
//            
//            return YES;
//        }
//    }
//    
//    return NO;
//}
//
//- (void)sortAlbum:(NSMutableArray *)dataArr {
//    
//    for (int i = 0; i < dataArr.count; i++) {
//        
//        for (int j = i + 1; j < dataArr.count; j++) {
//            
//            NSDictionary *dicI = dataArr[i];
//            
//            NSDictionary *dicJ = dataArr[j];
//            
//            if ([[dicI objectForKey:@"index"] intValue] >= [[dicJ objectForKey:@"index"] intValue]) {
//                
//                [dataArr exchangeObjectAtIndex:i withObjectAtIndex:j];
//            }
//        }
//    }
//}


#pragma mark -- 获取音乐信息报文dic
/** 当前播放音乐信息获取返回 *
 *  命令码: 0x00000040  回复当前播放音乐信息
 *
 *  命令码: 0x00000042  回复当前播放音乐信息
 *
 *  命令码: 0x00000058  音箱收藏歌曲
 */
-(NSDictionary *)getMusicInfo:(NSData *)data {
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
    NSInteger length = sizeof(get_return_currentPlayUrl);
    
    get_return_currentPlayUrl getReturnCurrentPlayUrl;
    
    [data getBytes:&getReturnCurrentPlayUrl length:length];
    
    
    [mutDic setObject:@(ntohl(getReturnCurrentPlayUrl.index)) forKey:@"index"];
    
   
    char *musicNameP = (char *)malloc(kMAXLEN_name);
    
    char *musicUrlP = (char *)malloc(kMAXLEN_url);
    
    char *musicImgUrlP = (char *)malloc(kMAXLEN_url);

    char *albumsNameP = (char *)malloc(kMAXLEN_name);
    
    char *artistsNameP = (char *)malloc(kMAXLEN_name);
    
    
    memcpy(musicNameP, getReturnCurrentPlayUrl.musicName, kMAXLEN_name);
    
    memcpy(musicUrlP, getReturnCurrentPlayUrl.musicUrl, kMAXLEN_url);
    
    memcpy(musicImgUrlP, getReturnCurrentPlayUrl.musicImgUrl, kMAXLEN_url);
    
    memcpy(albumsNameP, getReturnCurrentPlayUrl.albumsName, kMAXLEN_name);
    
    memcpy(artistsNameP, getReturnCurrentPlayUrl.artistsName, kMAXLEN_name);
    
    
    NSString *musicNameStr = [NSString stringWithCString:musicNameP encoding:NSUTF8StringEncoding];
    
    NSString *musicUrlStr = [NSString stringWithCString:musicUrlP encoding:NSUTF8StringEncoding];
    
    NSString *musicImgUrlStr = [NSString stringWithCString:musicImgUrlP encoding:NSUTF8StringEncoding];
    
    NSString *albumsNmaeStr = [NSString stringWithCString:albumsNameP encoding:NSUTF8StringEncoding];
    
    NSString *artistsNameStr = [NSString stringWithCString:artistsNameP encoding:NSUTF8StringEncoding];
    
    
    [self setNonullObject:musicNameStr key:@"musicName" inDic:mutDic];
    
    [self setNonullObject:musicUrlStr key:@"musicUrl" inDic:mutDic];
    
    [self setNonullObject:musicImgUrlStr key:@"musicImgUrl" inDic:mutDic];
    
    [self setNonullObject:albumsNmaeStr key:@"albumsName" inDic:mutDic];
    
    [self setNonullObject:artistsNameStr key:@"artistsName" inDic:mutDic];
    
    return mutDic;
}

/** App 收藏某歌曲 *
 *  命令码: 0x00000054  App收藏某歌曲
 *
 *  命令码: 0x00000056  App发送临时列表到音箱
 */
-(NSDictionary *)getAPPMusicInfo:(NSData *)data {
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
    NSInteger length = sizeof(get_return_APPCollectMusic);
    
    get_return_APPCollectMusic APPCollectMusic;
    
    [data getBytes:&APPCollectMusic length:length];
    
    
    char *musicNameP = (char *)malloc(kMAXLEN_name);
    
    char *musicUrlP = (char *)malloc(kMAXLEN_url);
    
    char *musicImgUrlP = (char *)malloc(kMAXLEN_url);
    
    char *albumsNameP = (char *)malloc(kMAXLEN_name);
    
    char *artistsNameP = (char *)malloc(kMAXLEN_name);
    
    
    memcpy(musicNameP, APPCollectMusic.musicName, kMAXLEN_name);
    
    memcpy(musicUrlP, APPCollectMusic.musicUrl, kMAXLEN_url);
    
    memcpy(musicImgUrlP, APPCollectMusic.musicImgUrl, kMAXLEN_url);
    
    memcpy(albumsNameP, APPCollectMusic.albumsName, kMAXLEN_name);
    
    memcpy(artistsNameP, APPCollectMusic.artistsName, kMAXLEN_name);
    
    
    NSString *musicNameStr = [NSString stringWithCString:musicNameP encoding:NSUTF8StringEncoding];
    
    NSString *musicUrlStr = [NSString stringWithCString:musicUrlP encoding:NSUTF8StringEncoding];
    
    NSString *musicImgUrlStr = [NSString stringWithCString:musicImgUrlP encoding:NSUTF8StringEncoding];
    
    NSString *albumsNmaeStr = [NSString stringWithCString:albumsNameP encoding:NSUTF8StringEncoding];
    
    NSString *artistsNameStr = [NSString stringWithCString:artistsNameP encoding:NSUTF8StringEncoding];
    
    
    [self setNonullObject:musicNameStr key:@"musicName" inDic:mutDic];
    
    [self setNonullObject:musicUrlStr key:@"musicUrl" inDic:mutDic];
    
    [self setNonullObject:musicImgUrlStr key:@"musicImgUrl" inDic:mutDic];
    
    [self setNonullObject:albumsNmaeStr key:@"albumsName" inDic:mutDic];
    
    [self setNonullObject:artistsNameStr key:@"artistsName" inDic:mutDic];
    
    return mutDic;
}

#pragma mark -- 获取UDP返回报文中的数据
-(NSDictionary *)getUDPServerReturnWithData:(NSData *)data {
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
    get_server_r getServerR;
    
    [data getBytes:&getServerR length:sizeof(get_server_r)];
    
    
    [mutDic setObject:@(ntohl(getServerR.port)) forKey:@"PORT"];
    
    
    char *ipP = (char *)malloc(kCHAR32);
    
    memcpy(ipP, getServerR.ip, kCHAR32);
    
    NSString *ipStr = [NSString stringWithCString:ipP encoding:NSUTF8StringEncoding];
    
    [self setNonullObject:ipStr key:@"IP" inDic:mutDic];
    
    
    return mutDic;
}


#pragma mark -- 获取音箱信息报文中的数据
-(NSDictionary *)getVoiceBoxInfo:(NSData *)data {
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
    get_return_voiceBox_info getVoiceboxInfo;
    
    [data getBytes:&getVoiceboxInfo length:sizeof(get_return_voiceBox_info)];
    
    
    char *versionsP = (char *)malloc(kCHAR32);
    
    memcpy(versionsP, getVoiceboxInfo.versions, kCHAR32);
    
    NSString *versionsStr = [NSString stringWithCString:versionsP encoding:NSUTF8StringEncoding];
    
    [self setNonullObject:versionsStr key:@"versions" inDic:mutDic];
    
    
    char *serialsP = (char *)malloc(kCHAR128);
    
    memcpy(serialsP, getVoiceboxInfo.serials, kCHAR128);
    
    NSString *serialsStr = [NSString stringWithCString:serialsP encoding:NSUTF8StringEncoding];
    
    [self setNonullObject:serialsStr key:@"serials" inDic:mutDic];
    
    
    return mutDic;
}



#pragma mark - private actions
/**
 设置报文头
 @param headSize 整个报文大小
 @param cmd      命令码
 @return 报文头
 */
-(pack_head)getPackHeadwithHeadSize:(int)headSize andCMD:(int)cmd {
    
    pack_head packHead;
    
    packHead.headSize = htonl(headSize);
    
    packHead.cmd      = htonl(cmd);
    
    packHead.errNo    = 0;
    
    packHead.serialNo = 0;
    
    return packHead;
}

-(pack_head)getPackHeadwithHeadSize:(int)headSize andCMD:(int)cmd errNo:(int)errNo {
    
    pack_head packHead;
    
    packHead.headSize = htonl(headSize);
    
    packHead.cmd      = htonl(cmd);
    
    packHead.errNo    = htonl(errNo);
    
    packHead.serialNo = 0;
    
    return packHead;
}

/**
 将字符串转成字符数组

 @param urlStr 字符串
 @param charArr 字符数组
 @param kLength 字符数组的最大长度
 */
- (void)getCharArrayFromStr: (NSString *)urlStr ToCharArray: (char *)charArr length: (NSInteger)kLength {
    
    int length = (int)urlStr.length;
    
    for (int i = 0; i < kLength; i++) {
        
        if (i < length) {
            
            charArr[i] = [urlStr characterAtIndex:i];
            
        } else {
            
            charArr[i] = '\0';
        }
    }
}


/**
 将char数组转成字符串

 @return 解析的字符串
 */

//- (NSString *)getString:(char *)charname length:(NSInteger)length {
//    
//    char *p = (char *)malloc(length);
//    
//    memcpy(p, charname, length);
//    
//    return [NSString stringWithCString:p encoding:NSUTF8StringEncoding];
//}

-(void)setNonullObject:(NSString *)objStr key:(NSString *)keyStr inDic:(NSMutableDictionary *)dic {
    
    objStr ? [dic setObject:objStr forKey:keyStr] : [dic setObject:@"" forKey:keyStr];
}

//- (NSString *)getString:(char *)charArray {
//    
//    NSString *str = [NSString stringWithCString:charArray encoding:NSUTF8StringEncoding];
//    
//    if (str == nil) {
//        
//        return @"";
//    }
//    
//    return str;
//}

@end
