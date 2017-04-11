//
//  VoicePlayer.m
//  MS3Tool
//
//  Created by chao on 2017/2/13.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "VoicePlayer.h"



static VoicePlayer *manager = nil;

@interface VoicePlayer ()

@property (nonatomic, strong, nonnull) MSConnectManager *conManager;

@property (nonatomic, strong, nullable) NSTimer *getAlbumTimer;     // 控制播放列表获取

@property (nonatomic, strong, nullable) NSTimer *getCollectTimer;   // 控制收藏列表获取

@property (nonatomic, strong, nullable) NSTimer *progressTimer_inv5;     // 控制进度获取,每5s获取一次

@property (nonatomic, strong, nullable) NSTimer *progressTimer_inv1;     // 控制进度获取,每1s获取一次


@end

@implementation VoicePlayer
+(instancetype)shareInstace {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[VoicePlayer alloc] init];
    });
    
    return manager;
}


- (instancetype)init {
    
    if (self = [super init]) {
        
        self.conManager = [MSConnectManager sharedInstance];
        
    }
    
    return self;
}

#pragma mark - set info
#pragma mark -- set message only head
- (void)setDataWithCMD:(int)cmd {
    
    NSData *data = [self.conManager.dataManager getGetReturnHeadDataWithCMD:cmd];
    
    [self.conManager tcpWriteDataWithData:data andTag:0];
}

// 设置播放 某个列表(0-当前列表 1-收藏列表) 中的 某首歌曲
- (void)setDataWithAlbumType:(int)albumType index:(int)index {
    
    NSData *data = [self.conManager.dataManager getAlbumUrlDataWithFlag:albumType index:index];
    
    [self.conManager tcpWriteDataWithData:data andTag:0];
}

// 设置APP收藏音乐
- (void)setDataWithCMD:(int)cmd musicInfo:(NSDictionary *)musicInfo {
    
    NSData *data = [self.conManager.dataManager getReturnAPPCollectMusicWithCMD:cmd dataDic:musicInfo];
    
    [self.conManager tcpWriteDataWithData:data andTag:0];
}




#pragma mark -- message with value
-(void)setArgumentWithCMD:(int)cmd value:(int)value {
    
    NSData *data = [self.conManager.dataManager getSetReturnHeadAndValueDataWithCMD:cmd andValue:value];
    
    [self.conManager tcpWriteDataWithData:data andTag:0];
}

#pragma mark -- play control
/**
 *  上一曲
 */
-(void)VPlayLastSong {
    
    [self setArgumentWithCMD:CMD_SET_PLAYCONTROL value:1];
}

/**
 *  下一曲
 *  单曲循环的时候点击下一曲，顺序播放下一首歌曲，然后再单曲循环播放正在播放的歌曲
 */
-(void)VPlayNextSong {
    
    [self setArgumentWithCMD:CMD_SET_PLAYCONTROL value:2];
}

/**
 *  播放
 */
- (void)VPlay {
    
    [self setArgumentWithCMD:CMD_SET_PLAYCONTROL value:3];
}

/**
 *  暂停
 */
- (void)VPause {
    
    [self setArgumentWithCMD:CMD_SET_PLAYCONTROL value:4];
}


/**
 设置音量 0-100
 
 @param value 将数据在获取的时候设置好
 */
-(void)VPSetVolume:(int)value {
    
    [self setArgumentWithCMD:CMD_SET_VOLUME value:value];
}

/**
 设置进度
 
 @param value 传过来的数值是根据进度条和总时长设置好的
 */
-(void)VPSetProgress:(int)value {
    
    [self setArgumentWithCMD:CMD_SET_playProgress value:value];
}

/**
 设置播放模式
 
 @param value 播放模式 0-顺序 1-单曲 2-随机
 */
-(void)VPSetPlayType:(int)value {
    
    [self setArgumentWithCMD:CMD_SET_currentPlayStyle value:value];
}

/**
 设置收藏音乐
 */
-(void)VPSetCollectMusic {
    
    [self setDataWithCMD:CMD_SET_collect];
}

/**
 *  设置播放 某个列表(0-当前列表 1-收藏列表) 中的 某首歌曲
 *
 *  重新设置播放列表的时候需要清空之前的播放列表中的所有歌曲
 */
-(void)VPSetPlayMusicInAlbum:(int)albumType index:(int)index {
    
    [self setDataWithAlbumType:albumType index:index];
}

/**
 设置取消收藏音乐
 */
-(void)VPSetCancelCollectMusicIndex:(int)index {
    
    [self setDataWithAlbumType:CMD_SET_cancelCollect index:index];
}

/**
 设置APP收藏音乐
 */
-(void)VPSetAPPCollectMusicWithMSModel:(MSMusicModel *)model {
    
    [self setDataWithCMD:CMD_SET_APPCollectMusic musicInfo:[self musicInfo:model]];
}

/**
 发送播放列表和要播放的歌曲下标给音箱
 */
- (void)VPSetPlayAlbum:(NSArray *)modelArr index:(int)index {
    
    [[CMDDataConfig shareInstance] setAlbumEmpty];
    
    [self writeAlbumWithMSMusicModelArray:modelArr andIndex:index];
}


#pragma mark - get info
-(void)getArgumentWithCMD:(int)cmd {
    
    NSData *data = [self.conManager.dataManager getGetReturnHeadDataWithCMD:cmd];
    
    [self.conManager tcpWriteDataWithData:data andTag:0];
}

/**
 获取音箱音量
 */
-(void)VPGetVolume {
    
    [self getArgumentWithCMD:CMD_GET_VOLUME];
}

/**
 获取播放状态
 */
-(void)VPGetPlayStatu {
    
    [self getArgumentWithCMD:CMD_GET_PLAYSTATE];
}

/**
 获取播放进度
 */
-(void)VPGetCurrentProgress {

    [self VPGetCurrentProgressInRunLoop];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        [self VPGetCurrentProgressInRunLoop];
//        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            NSTimer *timer = [NSTimer timerWithTimeInterval:5.0
//                                                     target:self
//                                                   selector:@selector(VPGetCurrentProgressInRunLoop)
//                                                   userInfo:nil repeats:YES];
//            
//            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//            
//            CFRunLoopRun();
//        });
//    });
}

-(void)VPGetCurrentProgressIsLastFiveSeconds:(BOOL)isLastFiveSeconds {
    
    if (isLastFiveSeconds) {
        
        if (_progressTimer_inv5 && [_progressTimer_inv5 isValid]) {
            
            [_progressTimer_inv5 invalidate];
            _progressTimer_inv5 = nil;
        }
        
        [self progressTimer_inv1];
    } else {
        
        if (_progressTimer_inv1 && [_progressTimer_inv1 isValid]) {
            
            [_progressTimer_inv1 invalidate];
            _progressTimer_inv1 = nil;
        }
        
        [self progressTimer_inv5];
    }
}

-(void)VPGetCurrentProgress_Stop {
    
    if (_progressTimer_inv5 && [_progressTimer_inv5 isValid]) {
        
        [_progressTimer_inv5 invalidate];
        _progressTimer_inv5 = nil;
    }
    
    if (_progressTimer_inv1 && [_progressTimer_inv1 isValid]) {
        
        [_progressTimer_inv1 invalidate];
        _progressTimer_inv1 = nil;
    }
}

-(NSTimer *)progressTimer_inv5 {
    
    if (!_progressTimer_inv5) {
        [self VPGetCurrentProgressInRunLoop];
        _progressTimer_inv5 = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(VPGetCurrentProgressInRunLoop) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_progressTimer_inv5 forMode:NSDefaultRunLoopMode];
        
        CFRunLoopRun();
        
        [self.progressTimer_inv5 fire];
    }
    
    return _progressTimer_inv5;
}

-(NSTimer *)progressTimer_inv1 {
    
    if (!_progressTimer_inv1) {
        [self VPGetCurrentProgressInRunLoop];
        _progressTimer_inv1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(VPGetCurrentProgressInRunLoop) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_progressTimer_inv1 forMode:NSRunLoopCommonModes];
        
        [self.progressTimer_inv1 fire];
    }
    
    return _progressTimer_inv1;
}

-(void)VPGetCurrentProgressInRunLoop {
    
    [self getArgumentWithCMD:CMD_GET_playProgress];
}
/**
 获取播放总时长
 */
-(void)VPGetDuration {
    
    [self getArgumentWithCMD:CMD_GET_currentDuration];
}

/**
 获取播放模式
 */
-(void)VPGetPlayType {
    
    [self getArgumentWithCMD:CMD_GET_currentPlayStyle];
}

/**
 * 获取播放列表 (0-播放列表，1-收藏列表)
 *
 *  获取列表的时候，因为数据报文是一条一条发送过来的，不是每次都能获取到最后一条数据的
 *  所以这里也需要使用定时器多次获取，直到获取到最后一条数据报文就停止发送请求报文
 *
 */
-(void)getPlayAlbum:(NSTimer *)timer {
    
    [self setArgumentWithCMD:CMD_GET_playAlbum value:[(NSNumber *)[timer userInfo] intValue]];
}

-(NSTimer *)getAlbumTimerWithType:(int)type {
    
    if (type == 0) {
        
        if (!_getAlbumTimer) {
            
            _getAlbumTimer = [NSTimer timerWithTimeInterval:1.0                     // 每1s广播一次
                                                     target:self
                                                   selector:@selector(getPlayAlbum:)
                                                   userInfo:@(type) repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_getAlbumTimer forMode:NSDefaultRunLoopMode];
            
            CFRunLoopRun();
        }
        
        return _getAlbumTimer;
        
    } else {
        
        if (!_getCollectTimer) {
            
            _getCollectTimer = [NSTimer timerWithTimeInterval:1.0                     // 每1s广播一次
                                                     target:self
                                                   selector:@selector(getPlayAlbum:)
                                                   userInfo:@(type) repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_getCollectTimer forMode:NSDefaultRunLoopMode];
            
            CFRunLoopRun();
        }
        
        return _getCollectTimer;
    }
}

// 开始获取播放列表
-(void)VPGetPlayAlbum_begin:(int)type {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self getAlbumTimerWithType:type];
    });
    
    if (type == 0) {

        [self.getAlbumTimer setFireDate:[NSDate distantPast]];
        
    } else {

        [self.getCollectTimer setFireDate:[NSDate distantPast]];
    }

}

// 暂停获取播放列表
-(void)XVPGetPlayAlbum_stop:(int)type {
    
    if (type == 0)
        [self.getAlbumTimer setFireDate:[NSDate distantFuture]];
    else
        [self.getCollectTimer setFireDate:[NSDate distantFuture]];
}


/**
 获取当前播放音乐信息
 */
-(void)VPGetPlayMusicInfo {
    
    [self getArgumentWithCMD:CMD_GET_current_musicInfo];
}

/**
 获取当前播放中的某条音乐信息
 */
-(void)VPGetPlayMusicInAlbum:(int)index {

    [self setArgumentWithCMD:CMD_GET_record_musicInfo value:index];
}

#pragma mark -- playAlbum get
/**
 获取播放列表
 
 @param musicData 音箱返回的音乐信息，如果收到 errNo=11 的报文就表示结束了
 
 如果这首歌不在列表里面就需要添加进列表
 
 每次收到数据之后都需要根据歌曲下标进行排序
 */
//- (void)getAlbum:(NSData *)musicData {
//    
//    int errNo = [self.comManager.dataManager getErrorNo:musicData];
//    
//    NSDictionary *tempDic = [self.comManager.dataManager getPlayAlbum:musicData];
//    
//    NSLog(@"返回的音乐信息是 : %@", tempDic);
//    
//    if (![self isExistInAlbum:tempDic]) {
//        
//        if (errNo == 11) {
//            
//            NSLog(@"收到错误码，最后一条数据了");
//            
//            [[CMDDataConfig shareInstance].cmdDic setObject:self.playAlbum forKey:@"56"];
//        }
//        
//        [self.playAlbum addObject:tempDic];
//    }
//}
//
//
//- (BOOL)isExistInAlbum:(NSDictionary *)musicDic {
//    
//    for (NSDictionary *tempDic in self.playAlbum) {
//        
//        if ([musicDic isEqual:tempDic]) {
//            
//            NSLog(@"这首歌存在列表中...");
//            
//            return YES;
//        }
//    }
//    
//    NSLog(@"这首歌不在列表中...");
//    
//    return NO;
//}


#pragma mark - 协议数据封装
//播放列表下标对应的歌曲
- (void)writeDataWithValue:(int)value flag:(int)flag {
    
    NSData *data = [self.conManager.dataManager getAlbumUrlDataWithFlag:flag index:value];
    
    [self.conManager tcpWriteDataWithData:data andTag:0];
}

//播放列表下标对应的歌曲
- (void)writeAlbumWithMSMusicModelArray:(NSArray *)modelArray andIndex:(NSInteger)index {
    
    for (int i = 0; i < modelArray.count; i++) {
        
        NSDictionary *dataDic = [self musicInfo:modelArray[i]];
        
        NSData *data = [self.conManager.dataManager getReturnAPPCollectMusicWithCMD:CMD_SET_currentPlayAlbum dataDic:dataDic];
        
        [self.conManager tcpWriteDataWithData:data andTag:0];
        
        if (i == modelArray.count - 1) {
            
            NSData *lastData = [self.conManager.dataManager getSetReturnHeadAndValueDataWithCMD:CMD_SET_send_end_album andValue:(int)index];
            
            [self.conManager tcpWriteDataWithData:lastData andTag:0];
        }
    }
}

/**
 将 MSMusicModel 转换成 字典 用于发送数据
 */
- (NSDictionary *)musicInfo:(MSMusicModel *)model {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  
    [self setNonnullObj:model.songName key:@"musicName" inDic:dic];
    
    [self setNonnullObj:model.playUrl key:@"musicUrl" inDic:dic];
    
    [self setNonnullObj:model.coverImgLarge key:@"musicImgUrl" inDic:dic];
    
    [self setNonnullObj:model.albumName key:@"albumsName" inDic:dic];
    
    [self setNonnullObj:model.singerName key:@"artistsName" inDic:dic];
    
    return (NSDictionary *)dic;
}

- (void)setNonnullObj:(NSString *)obj key:(NSString *)key inDic:(NSMutableDictionary *)dic {
    
    if (obj) {
        [dic setObject:obj forKey:key];
        
    } else {
        [dic setObject:@"" forKey:key];
    }
}

//#pragma mark - playAlbum control in app
//#pragma mark -- 更新歌单
//-(void)updateAlbum:(NSArray *)array index:(NSInteger)index {
//    
//    [manager.playAlbum removeAllObjects];
//    
//    [manager.playAlbum addObjectsFromArray:array];
//    
//    manager.playIndex = index;
//}
//
//#pragma mark -- 添加歌曲
//// 添加单首歌曲进入播放列表
//-(void)addModelToAlbum:(MSMusicModel *)MSModel {
//    
//    [manager.playAlbum addObject:MSModel];
//}
//
//// 添加某个歌单中的歌曲进入播放列表
//-(void)addAlbumToAlbum:(NSArray *)array {
//    
//    [manager.playAlbum addObjectsFromArray:array];
//}
//
//#pragma mark -- 删除歌曲
//// 根据track下标 删除歌单中的歌曲
//-(void)delModelFromAlbumWithIndex:(NSInteger)index {
//
//    [manager.playAlbum removeObjectAtIndex:index];
//
//    
//}
//
//- (void) setPlayModelIndexWithDelIndex:(NSInteger) index {
//    
//    if (index < manager.playIndex) {  // 删除当前的前一个，playIndex 前移一位
//        
//        manager.playIndex -= 1;
//        
//    } else if (index == manager.playIndex) {   // 删除当前播放歌曲时 需要处理播放器
//        
//        if (manager.playIndex == manager.playAlbum.count - 1) {   // playIndex 在最后一位被删除的时候，跳到第一首
//            
//            manager.playIndex = 0;
//        }
//        
//        
//    }   // 删除 playIndex 后面的不变; 删除 playIndex 当前的时候如果后面还有数据，也不变，指向下一个，自动播放下一曲
//    
//    manager.playModel = manager.playAlbum[manager.playIndex];
//}
//
//
//// 根据model 删除歌单中的歌曲
//-(void)delModelFromAlbumWithMSModel:(MSMusicModel *)MSModel {
//    
//    [manager.playAlbum removeObject:MSModel];
//    
// 
//}
//
//#pragma mark -- 清空播放列表
//-(void)clearAlbum {
//    
//    manager.playModel = nil;
//    
//    manager.playIndex = -1;
//    
//    [manager.playAlbum removeAllObjects];
//}



@end
