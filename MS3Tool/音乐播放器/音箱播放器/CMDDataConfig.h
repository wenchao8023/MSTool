//
//  CMDDataConfig.h
//  MS3Tool
//
//  Created by chao on 2017/2/16.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMDDataConfig : NSObject

@property (nonatomic, assign) int getCMD;

//  判断播放列表是否正在请求，因为获取播放列表需要不停的获取，知道获取到完整的播放列表
@property (nonatomic, assign) BOOL isAlbumChanging;

@property (nonatomic, assign) int playIndex;

// 列表信息用数组保存，对应的状态码回来了还是保存在字典里面，进行判断
@property (nonatomic, strong, nullable) NSMutableArray *playAlbum;

@property (nonatomic, strong, nullable) NSMutableArray *collectAlbum;

@property (nonatomic, strong, nullable) NSMutableDictionary *cmdDic;


+(CMDDataConfig  * _Nonnull)shareInstance ;


/**
 根据音箱返回的数据进行刷新保存的数据
 
 @param cmd 返回的对应的命令码
 @param rec 命令码对应的返回数据，BOOL型的，没有数据返回的，int型的，返回value，dic型的，返回信息
 */
- (void)setDicWithCMD:(int)cmd andBool:(BOOL)rec ;

//int型的，返回value
- (void)setDicWithCMD:(int)cmd andValue:(int)value ;

//dic型的，返回信息
- (void)setDicWithCMD:(int)cmd andDic:(nullable NSDictionary *)dic ;

// 列表保存
- (void)setAlbumWithCMD:(int)cmd errNo:(int)errNo dic:(nullable NSDictionary *)tempDic;

// 清空播放列表
- (void)setAlbumEmpty ;


@end
