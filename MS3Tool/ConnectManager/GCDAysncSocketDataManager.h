//
//  GCDAysncSocketDataManager.h
//  MS3Tool
//
//  Created by chao on 2016/10/26.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDAysncSocketDataManager : NSObject

+(instancetype)shareInstance;

#pragma mark - -- 编译，转成二进制数据流
/**
 *  握手连接
 */
-(NSData *)getHandShakeData;

/**
 *  发送路由器信息
 */
-(NSData *)getRouterInfoDataWithSSID:(NSString *)ssid andPassword:(NSString *)password;

/**
 *  发送命令码报文
 */
-(NSData *)getGetReturnHeadDataWithCMD:(int)cmd;

/**
 *  发送数据报文
 */
-(NSData *)getSetReturnHeadAndValueDataWithCMD:(int)cmd andValue:(int)value;


/**
 *  歌曲 url 
 */
- (NSData *) getGetReturnCurrentUrlDataWithCMD:(int)cmd andURLLength:(int)urlLength andURL:(NSString *)url ;


/**
 *  播放列表中的歌曲
 */
- (NSData *) getAlbumUrlDataWithFlag:(int)flag index:(NSInteger)index ;

/**
 *  app收藏的歌曲
 */
- (NSData *) getReturnAPPCollectMusicWithCMD:(int)cmd dataDic:(NSDictionary *)dic ;

- (NSData *) getReturnAPPCollectMusicWithCMD:(int)cmd dataDic:(NSDictionary *)dic errNo:(int)errNo ;

#pragma mark - -- 解析，转成二进制数据流
/**
 解析返回报文中的cmd
 */
-(int)getDataCMD:(NSData *)data ;
/**
 解析返回报文中的errNo
 */
-(int)getErrorNo:(NSData *)data ;
/**
 获取数据报文中的Value
 */
-(int)getValueWithData:(NSData *)data ;

/**
 获取udp返回的数据
 */
-(NSDictionary *)getUDPServerReturnWithData:(NSData *)data ;

/**
 获取播放列表报文的数据
 */
-(NSDictionary *)getPlayAlbum:(NSData *)data ;
//-(NSDictionary *)getPlayAlbum:(NSData *)data beginIndex:(NSUInteger)beginIndex ;

/**
 获取音乐信息报文数据
 */
-(NSDictionary *)getMusicInfo:(NSData *)data ;

/** 
 App 收藏歌曲信息
 */
-(NSDictionary *)getAPPMusicInfo:(NSData *)data ;

/**
 获取音箱信息报文中的数据
 */
-(NSDictionary *)getVoiceBoxInfo:(NSData *)data ;
@end
