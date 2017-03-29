//
//  CMDDataConfig.m
//  MS3Tool
//
//  Created by chao on 2017/2/16.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "CMDDataConfig.h"

#import "packet.h"


static CMDDataConfig *manager = nil;

@implementation CMDDataConfig

+ (CMDDataConfig *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CMDDataConfig alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.isAlbumChanging = NO;
        
        [self cmdDic];
        
        [self playAlbum];
        
        [self collectAlbum];
        
        [self loadDic];
    }
    
    return self;
}

-(NSMutableDictionary *)cmdDic {
    
    if (!_cmdDic) {
        
        _cmdDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return _cmdDic;
}

// 播放列表
-(NSMutableArray *)playAlbum {
    
    if (!_playAlbum) {
        
        _playAlbum = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _playAlbum;
}
// 收藏列表
-(NSMutableArray *)collectAlbum {
    
    if (!_collectAlbum) {
        
        _collectAlbum = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _collectAlbum;
}

- (void)loadDic {

    // 返回命令码
    [self setDicWithCMD:CMD_SET_VOLUME_R andBool:NO];
    
    [self setDicWithCMD:CMD_SET_PLAYCONTROLE_R andBool:NO];
    
    [self setDicWithCMD:CMD_SET_playUrl_R andBool:NO];
    
    [self setDicWithCMD:CMD_SET_playProgress_R andBool:NO];
    
    [self setDicWithCMD:CMD_SET_collect_R andBool:NO];
    
    [self setDicWithCMD:CMD_SET_play_album_R andBool:NO];
    
    [self setDicWithCMD:CMD_SET_currentPlayStyle_R andBool:NO];
    
    [self setDicWithCMD:CMD_SET_cancelCollect_R andBool:NO];
    
    
    // 返回带value
    [self setDicWithCMD:CMD_GET_VOLUME_R andValue:-1];
    
    [self setDicWithCMD:CMD_GET_PLAYSTATE_R andValue:-1];
    
    [self setDicWithCMD:CMD_GET_playProgress_R andValue:-1];
    
    [self setDicWithCMD:CMD_GET_currentPlayStyle_R andValue:-1];
    
    [self setDicWithCMD:CMD_GET_currentDuration_R andValue:-1];
    
    [self setDicWithCMD:CMD_SET_APPCollectMusic_R andValue:-1];
    
    [self setDicWithCMD:CMD_SET_currentPlayAlbum_R andValue:-1];
    
    /* 播放列表和收藏列表 
        default : -1
        播放列表  : 0
        收藏列表  : 1
     */
    [self setDicWithCMD:CMD_GET_playAlbum_R andValue:-1];
    
    [self setDicWithCMD:CMD_NOT_volume andValue:-1];            // notify
    
    [self setDicWithCMD:CMD_NOT_controlPlay andValue:-1];       // notify
    
    [self setDicWithCMD:CMD_NOT_controlStatus andValue:-1];     // notify
    
    
    // 返回带dic
    [self setDicWithCMD:CMD_GET_current_musicInfo_R andDic:[NSDictionary dictionary]];
    
    [self setDicWithCMD:CMD_GET_record_musicInfo_R andDic:[NSDictionary dictionary]];
    
    [self setDicWithCMD:CMD_GET_voiceboxInfo_R andDic:[NSDictionary dictionary]];
    
    [self setDicWithCMD:CMD_NOT_collect andDic:[NSDictionary dictionary]];  // notify
    
    
}

/**
 根据音箱返回的数据进行刷新保存的数据
 
 @param cmd 返回的对应的命令码
 @param rec 命令码对应的返回数据，BOOL型的，没有数据返回的，int型的，返回value，dic型的，返回信息
 */
- (void)setDicWithCMD:(int)cmd andBool:(BOOL)rec {
    
    [self.cmdDic setObject:@(rec) forKey:[self getKeyFromCMD:cmd]];
}

//int型的，返回value
- (void)setDicWithCMD:(int)cmd andValue:(int)value {
    
    [self.cmdDic setObject:@(value) forKey:[self getKeyFromCMD:cmd]];
}

//dic型的，返回信息
- (void)setDicWithCMD:(int)cmd andDic:(NSDictionary *)dic {
    
    if (dic) {
        
        [self.cmdDic setObject:dic forKey:[self getKeyFromCMD:cmd]];
    }
}

//arr型的，列表信息
- (void)setDicWithCMD:(int)cmd andArr:(NSArray *)arr {
    
    if (arr) {
        
        [self.cmdDic setObject:arr forKey:[self getKeyFromCMD:cmd]];
    }
}


/**
 更新播放列表
 
 @param tempDic 音箱返回的音乐信息，
 
 如果这首歌不在列表里面就需要添加进列表
 
 还是保存完了再排序
 */
- (void)setAlbumWithCMD:(int)cmd errNo:(int)errNo dic:(NSDictionary *)tempDic {
    
    if (tempDic) {
        if ([[tempDic objectForKey:@"flag"] intValue] == 0) {   // 播放列表
            
            [self setAlbumWithCMD:cmd errNo:errNo dic:tempDic album:self.playAlbum];
            
        } else {    // 收藏列表
            
            [self setAlbumWithCMD:cmd errNo:errNo dic:tempDic album:self.collectAlbum];
        }
    }
}

- (void)setAlbumWithCMD:(int)cmd errNo:(int)errNo dic:(NSDictionary *)tempDic album:(NSMutableArray *)dataArr {
    
    [self setIsAlbumChanging:YES];
    
    if (![self isExistInAlbum:dataArr dic:tempDic]) {
        
        [dataArr addObject:tempDic];
        
        if (errNo == 11) {
            
            [self sortAlbum:dataArr];
            
            [self setDicWithCMD:cmd andValue:[[tempDic objectForKey:@"flag"] intValue]];
            
            [[VoicePlayer shareInstace] XVPGetPlayAlbum_stop:[[tempDic objectForKey:@"flag"] intValue]];
        }
    }
}

- (void)sortAlbum:(NSMutableArray *)dataArr {
    
    for (int i = 0; i < dataArr.count; i++) {
        
        for (int j = i + 1; j < dataArr.count; j++) {
            
            NSDictionary *dicI = dataArr[i];
            
            NSDictionary *dicJ = dataArr[j];
            
            if ([[dicI objectForKey:@"index"] intValue] >= [[dicJ objectForKey:@"index"] intValue]) {
                
                [dataArr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}


// 清空播放列表
- (void)setAlbumEmpty {
    
    [self.playAlbum removeAllObjects];
    
    [self setDicWithCMD:CMD_GET_playAlbum_R andArr:[NSArray array]];
}

- (BOOL)isExistInAlbum:(NSArray *)dataArr dic:(NSDictionary *)musicDic {
    
    for (NSDictionary *tempDic in self.playAlbum) {
        
        if ([musicDic isEqual:tempDic]) {
            
            return YES;
        }
    }
    
    return NO;
}



#pragma mark - private
#pragma mark -- 根据 CMD 返回NSString
- (NSString *)getKeyFromCMD:(int)cmd {
    
    return [NSString stringWithFormat:@"%d", cmd];
}




@end
