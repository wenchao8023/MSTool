//
//  VoicePlayer.h
//  MS3Tool
//
//  Created by chao on 2017/2/13.
//  Copyright © 2017年 ibuild. All rights reserved.
//



#import <Foundation/Foundation.h>



@interface VoicePlayer : NSObject


+(nonnull instancetype)shareInstace;



#pragma mark - album control
#pragma mark -- playAlbum control
/**
 更新播放列表
 
 @param musicData 音箱返回的音乐信息，如果收到 errNo=11 的报文就表示结束了
 
 如果这首歌不在列表里面就需要添加进列表
 
 每次收到数据之后都需要根据歌曲下标进行排序
 
 */
-(void)updateAlbum:(nonnull NSData *)musicData ;

-(void)updateAlbum:(nonnull NSArray *)array index:(NSInteger)index ;

-(void)addModelToAlbum:(nonnull MSMusicModel *)MSModel ;

-(void)addAlbumToAlbum:(nonnull NSArray *)array ;

-(void)delModelFromAlbumWithIndex:(NSInteger)index ;

- (void)setPlayModelIndexWithDelIndex:(NSInteger)index ;

-(void)clearAlbum ;



#pragma mark - set info
#pragma mark -- play control
/**
 *  上一曲
 */
-(void)VPlayLastSong ;

/**
 *  下一曲
 *  单曲循环的时候点击下一曲，顺序播放下一首歌曲，然后再单曲循环播放正在播放的歌曲
 */
-(void)VPlayNextSong ;

/**
 *  播放
 */
- (void)VPlay ;

/**
 *  暂停
 */
- (void)VPause ;



/**
 设置音量 0-100
 
 @param value 将数据在获取的时候设置好
 */
-(void)VPSetVolume:(int)value ;

/**
 设置进度
 
 @param value 传过来的数值是根据进度条和总时长设置好的
 */
-(void)VPSetProgress:(int)value ;

/**
 设置播放模式
 
 @param value 播放模式 0-顺序 1-单曲 2-随机
 */
-(void)VPSetPlayType:(int)value ;

/**
 设置收藏音乐
 */
-(void)VPSetCollectMusic ;

/**
 设置播放 某个列表(0-当前列表 1-收藏列表) 中的 某首歌曲
 */
-(void)VPSetPlayMusicInAlbum:(int)albumType index:(int)index ;

/**
 设置取消收藏音乐
 */
-(void)VPSetCancelCollectMusicIndex:(int)index ;

/**
 设置APP收藏音乐
 */
-(void)VPSetAPPCollectMusicWithMSModel:(nonnull MSMusicModel *)model ;

/**
 设置播放列表 并播放 第index首 歌曲
 */
- (void)VPSetPlayAlbum:(nonnull NSArray *)modelArr index:(int)index ;


#pragma mark - get info
/**
 获取音箱音量
 */
-(void)VPGetVolume ;

/**
 获取播放状态
 */
-(void)VPGetPlayStatu ;

/**
 获取播放进度
 */
-(void)VPGetCurrentProgress ;

/**
 获取播放总时长
 */
-(void)VPGetDuration ;

/**
 获取播放模式
 */
-(void)VPGetPlayType ;

/**
 获取播放列表 (0-播放列表，1-收藏列表)
 
 启动音箱之后，如果有歌曲播放的时候获取一次
 
 每次更换列表歌曲之后重新获取，数据保存在模型中，然后只需要从本地获取
 */

-(void)VPGetPlayAlbum_begin:(int)type ;

/**
 暂停获取播放列表
 */
-(void)XVPGetPlayAlbum_stop:(int)type ;

/**
 获取当前播放音乐信息
 */
-(void)VPGetPlayMusicInfo ;

/**
 获取当前播放中的某条音乐信息
 */
-(void)VPGetPlayMusicInAlbum:(int)index ;


@end
