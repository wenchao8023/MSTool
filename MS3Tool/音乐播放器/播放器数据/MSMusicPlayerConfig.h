//
//  MSMusicPlayerConfig.h
//  MS3Tool
//
//  Created by chao on 2016/11/14.
//  Copyright © 2016年 ibuild. All rights reserved.
//

/*************************************************************************
 ************         对音乐信息的存储全部放在这里面           ****************
 ** 1.酷狗搜歌获取的音乐资源，转成 MSMusicModel 存储在 musicConfig 中
 ** 2.喜马拉雅获取的音乐资源，转成 MSMusicModel 存储在 musicConfig 中
 ** 3.保存 当前播放列表、当前播放音乐信息、播放状态、播放模式、播放总时长、播放当前时长
 ** 4.添加 音箱收藏列表 - 用于保存音箱中收藏的歌曲
 ** 5.添加 最近播放列表 - 本地保存用户最近播放过的歌曲
 ** 6.添加 手机本地歌曲 - 保存用户通过 iTunes 上传到手机的歌曲
 ** 7.酷我外链获取的音乐资源，转成 MSMusicModel 存储在 musicConfig 中
 *************************************************************************/

#import <Foundation/Foundation.h>


@interface MSMusicPlayerConfig : NSObject

/**
 播放列表
 */
@property (nonatomic, strong) NSMutableArray *playAlbum;


/**
 正在播放的model对象
 */
@property (nonatomic, strong) MSMusicModel *playModel;

/**
 *
 *
 */

/**
  正在播放的 列表中的 model对象 下标 (model = -1 的时候，表示播放列表没有元素)
 */
@property (nonatomic, assign) NSInteger playIndex;

/** 判断音乐播放状态
 *  -1: 准备播放
 *   0: 暂停
 *   1: 正在播放
 */
@property (nonatomic, assign) NSInteger playStatus;

/** 判断音乐播放模式
 *  -1: 随机播放
 *   0: 顺序播放
 *   1: 单曲循环
 */
@property (nonatomic, assign) NSInteger playType;



+(MSMusicPlayerConfig *)sharedInstance;


/**************************
 **     播放状态控制       **
 **************************/
// 正在播放
-(void)setStatusToIsPlaying;
// 暂停
-(void)setStatusToPause;
// 播放
-(void)setStatusToPlay;

/**************************
 **     循环模式控制       **
 **************************/
// 选择下一个循环模式
-(void)setPlayTypeToNext;
// 获取循环模式
-(NSInteger)getPlayType;


/**************************
 **     播放下标控制       **
 **************************/
/**
 *  播放上一首时控制设置下标
 */
-(void)setIndexWhenPlayLast;
/**
 *  播放下一首时控制设置下标
 */
-(void)setIndexWhenPlayNextWithClick:(BOOL)isClick;


/**************************
 **     播放列表控制       **
 **************************/
-(NSArray *)getPlayAlbumArray ;

-(void)updateMusicArray:(NSArray *)array;

-(void)addModelToMusicArray:(MSMusicModel *)MSModel;

-(void)addAlbumToMusicArray:(NSArray *)array;

-(void)delModelFromMusicArrayWithIndex:(NSInteger)trackIndex;

-(void)delModelFromMusicArrayWithTrack:(MSMusicModel *)MSModel;

-(void)clearMusicArray;

@end
