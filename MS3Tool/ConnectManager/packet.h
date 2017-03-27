#ifndef PACKET_H_
#define PACKET_H_

#define AUTHCODE {0x0b,0x1b,0x8d,0x58,0x6d,0x46,0x43,0x73,0xab, 0x36,0x69,0xd8,0x58,0xa8,0x94,0xfd}

static const NSInteger kCHAR16 = 16;
static const NSInteger kCHAR32 = 32;
static const NSInteger kCHAR64 = 64;
static const NSInteger kCHAR128 = 128;

static const NSInteger kMAXLEN_url = 500;   // 歌曲地址、图片地址
static const NSInteger kMAXLEN_name = 80;   // 歌曲名称、专辑名称、艺术家名称




typedef char int8;
typedef short int16;
typedef int	int32;
typedef unsigned char U8;
typedef unsigned short U16;
typedef unsigned int U32;

#pragma mark - 连接 -- TCP协议
#pragma mark -- 报文头
typedef struct {
	int32 headSize; //报文大小
    
	int32 cmd;      //命令码
    
	int32 errNo;    //0
    
	int32 serialNo; //0
    
}pack_head;




#pragma mark -- 授权请求
//  命令码: 0x00000010
typedef struct {
	pack_head head;
    
	U8 authCode[kCHAR16];
    
}handshake;



#pragma mark -- 发送路由器的SSID和密码
//  命令码: 0x00000012  此报文无回复
typedef struct{
	pack_head head;
    
	U8	password[kCHAR64];   //不能直接将整个数组丢过去赋值，要一一对应的赋值
    
	U8	ssid[kCHAR128];
    
}set_routerInfo;




#pragma mark - 报文回复
/** 获取报文 *
 *  命令码: 0x00000013  UDP协议获取音箱IP和端口
 *
 *  命令码: 0x00000019  获取当前音量
 *
 *  命令码: 0x00000021  获取当前播放状态
 *
 *  命令码: 0x00000023  获取电池电量
 *
 *  命令码: 0x00000025  获取当前播放url
 *
 *  命令码: 0x00000027  获取当前播放进度
 *
 *
 ** 报文回复 *
 *  命令码: 0x00000011  授权返回
 *
 *  命令码: 0x00000016  发送音量返回
 *
 *  命令码: 0x00000018  发送播放控制返回
 *
 *  命令码: 0x00000030  发送手机播放url是否成功返回
 *
 *  命令码: 0x00000032  发送手机播放进度是否成功返回
 *
 *
 ** 收藏功能 *
 *  命令码: 0x00000033  收藏播放歌曲url
 *
 *  命令码: 0x00000034  收藏播放歌曲url是否成功返回
 *
 ** 播放功能 *
 *  命令码: 0x00000036  播放列表中的歌曲是否成功
 *
 *  命令码: 0x00000039  获取当前播放音乐信息
 *
 *  命令码: 0x00000046  获取当前播放模式
 *
 *  命令码: 0x00000049  设置播放模式返回
 *
 *  命令码: 0x00000050  获取当前歌曲总时长
 *
 *  命令码: 0x00000053  取消收藏某歌曲返回
 *
 *  命令码: 0x00000063  收藏当前列表的某首歌曲返回
 *
 *  命令码: 0x00000065  音箱播放列表变化通知
 *
 *
 ** 音箱相关 *
 *  命令码: 0x00000043  获取音箱信息
 *
 *  命令码: 0x00000045  恢复出厂设置（没回复报文）
 */
typedef struct {
    
    pack_head head;
    
}get_return_head;




/** 发送数据报文 *
 *  命令码: 0x00000015  发送音量大小
 *
 *  命令码: 0x00000017  发送播放控制
 *
 *  命令码: 0x00000031  发送手机播放进度
 *
 *
 ** 报文回复 *
 *  命令码: 0x00000020  获取音量返回
 *
 *  命令码: 0x00000022  获取当前播放状态返回
 *
 *  命令码: 0x00000024  获取当前电池电量返回
 *
 *  命令码: 0x00000028  获取当前播放进度返回
 *
 *
 ** 播放功能 *
 *  命令码: 0x00000037  获取播放列表
 *
 *  命令码: 0x00000041  获取播放列表中的某条音乐信息（value不超过20）
 *
 *  命令码: 0x00000047  返回获取播放模式
 *
 *  命令码: 0x00000048  设置播放模式
 *
 *  命令码: 0x00000051  返回当前歌曲总时长
 *
 *  命令码: 0x00000052  取消收藏某歌曲
 *
 *  命令码: 0x00000055  返回App 收藏某歌曲，下标表示此歌曲在收藏列表中的下标
 *
 *  命令码: 0x00000057  返回发送临时列表数据，下标表示完成几条条目
 *
 *  命令码: 0x00000059  音箱状态改变
 *
 *  命令码: 0x00000060  音箱歌曲变化
 *
 *  命令码: 0x00000061  音箱音量变化
 *
 *  命令码: 0x00000062  收藏当前列表的某首歌曲
 *
 *  命令码: 0x00000064  发送播放列表的结束报文
 *
 */
// 发送一些数据报文: 音量大小、播放状态
// 获取音量返回、获取当前播放状态返回、获取当前电池电量返回
typedef struct {
    
    pack_head head;
    
    int32 value;
    
}set_return_headAndValue;

#pragma mark - url 相关
/** url 和 列表 *
 *  命令码: 0x00000026  返回当前播放url（废弃）
 *
 *  命令码: 0x00000029  发送手机播放url
 *
 */
typedef struct {

    pack_head head;
    
    int32 value;
    
    U8 urls[kMAXLEN_url];
    
}get_return_currentUrl;


/** 2017-02-07 add */

/** 播放某个列表中的某首歌曲 *
 *  命令码: 0x00000035
 */
typedef struct {

    pack_head head;
    
    int32 flag;     // 0 当前播放列表；1收藏列表
    
    int32 index;    // 歌曲在列表中的下标
    
}get_album_url;

/** 播放列表获取返回 *
 *  命令码: 0x00000038  回复播放列表
 *  返回多次，直到收到 errNo=11 的报文表示结束
 */
typedef struct {
    
    pack_head head;
    
    int32 index;
    
    int32 flag;
    
    U8 songName[kMAXLEN_name];
    
    U8 artistic[kMAXLEN_name];
    
}get_return_playAlbum;

/** 当前播放音乐信息获取返回 *
 *  命令码: 0x00000040  回复当前播放音乐信息
 *
 *  命令码: 0x00000042  回复当前播放音乐信息
 *
 *  命令码: 0x00000058  音箱收藏歌曲
 */
typedef struct {
    
    pack_head head;
    
    int32 index;
    
    U8 musicName[kMAXLEN_name];
    
    U8 musicUrl[kMAXLEN_url];
    
    U8 musicImgUrl[kMAXLEN_url];
    
    U8 albumsName[kMAXLEN_name];
    
    U8 artistsName[kMAXLEN_name];
    
}get_return_currentPlayUrl;

/** App 收藏某歌曲 *
 *  命令码: 0x00000054  App收藏某歌曲
 *
 *  命令码: 0x00000056  App发送临时列表到音箱
 */
typedef struct {
    
    pack_head head;
    
    U8 musicName[kMAXLEN_name];
    
    U8 musicUrl[kMAXLEN_url];
    
    U8 musicImgUrl[kMAXLEN_url];
    
    U8 albumsName[kMAXLEN_name];
    
    U8 artistsName[kMAXLEN_name];
    
}get_return_APPCollectMusic;

/** 2017-02-07 add */


#pragma mark - UDP协议
#pragma mark -- 获取音箱服务IP和端口
//  回复报文
//  命令码: 0x00000014
typedef struct {
    
    pack_head head;
    
    U8 ip[kCHAR32];
    
    int32 port;
    
}get_server_r;


/** 2017-02-07 add */
#pragma mark - -- 音箱相关
/** 音箱信息获取返回 *
 *  命令码: 0x00000044  获取音箱信息返回
 */
typedef struct {
    
    pack_head head;
    
    U8 versions[kCHAR32];
    
    U8 serials[kCHAR128];
    
}get_return_voiceBox_info;
/** 2017-02-07 add */



#pragma mark - 枚举列出所有的命令码
/*
 * - ok - 表示测试通过
 * ! no - 表示没有实现
 * - T  - 表示需要测试
 */

typedef enum _PACK_CMD {
    
    CMD_HANDSHAKE = 0x00000010,         // - ok - 授权请求
    
    CMD_HANDSHAKE_R,                    // - ok - 授权返回
    
    CMD_SET_ROUTERINFO,                 // - ok - 发送路由 SSID 和 密码
    
    CMD_GET_SERVER,                     // - ok - 获取音箱服务 IP 和 端口 (UDP)
    
    CMD_GET_SERVER_R,                   // - ok - 返回音箱 IP 和 端口 (UDP)
    
    CMD_SET_VOLUME,                     // - ok - 发送音量大小
    
    CMD_SET_VOLUME_R,                   // - ok - 回复发送音量报文
    
    CMD_SET_PLAYCONTROL,                // - ok - 发送 1: 上一曲，2: 下一曲，3: 暂停，4: 播放
    
    CMD_SET_PLAYCONTROLE_R,             // - ok - 回复播放状态设置报文
    
    CMD_GET_VOLUME,                     // - ok - 获取当前音量
    
    CMD_GET_VOLUME_R = 0x00000020,      // - ok - 返回当前音量
    
    CMD_GET_PLAYSTATE,                  // - ok - 获取当前播放状态 (协议逻辑有问题，对歌曲的状态分类不明确)
    
    CMD_GET_PLAYSTATE_R,                // - ok - 返回当前播放状态 (0-停止，1-暂停，2-播放
    
    CMD_GET_VOLTAGE,                    // ! no - 获取当前电池电量 (返回错误号0，还没实现)
    
    CMD_GET_VOLTAGE_R,                  // ! no - 返回当前电池电量 (返回错误号0，还没实现)
    
    CMD_GET_currentUrl,                 // ! no - 获取当前播放url (废弃，请使用 CMD_GET_current_musicInfo 获取音乐信息)
    
    CMD_GET_currentUrl_R,               // ! no - 返回当前播放url (废弃，请使用 CMD_GET_record_musicInfo_R 获取音乐返回信息)
    
    CMD_GET_playProgress,               // - ok - 获取当前播放进度
    
    CMD_GET_playProgress_R,             // - ok - 返回当前播放进度
    
    CMD_SET_playUrl,                    // - T  - 发送手机播放url
    
    CMD_SET_playUrl_R = 0x00000030,     // - T  - 返回手机播放url是否发送成功
    
    CMD_SET_playProgress,               // - ok - 发送手机播放进度 31
    
    CMD_SET_playProgress_R,             // - ok - 返回手机播放进度是否发送成功 32
    
    
    /** 协议3.1 更改内容 2017-02-06*/
    
    CMD_SET_collect,                    // - T  - 收藏当前播放歌曲url(手机只对音箱发一个命令码) 33
    
    CMD_SET_collect_R,                  // - T  - 回复收藏url是否成功 34
    
    CMD_SET_play_album,                 // - T  - 播放某首歌曲（当前列表或收藏列表，根据列表和下标来确定要播放的歌曲） 35
    
    CMD_SET_play_album_R,               // - T  - 回复报文 36
    
    /** 协议3.1 更改内容 */
    
    
    /**
     *  2017-01-16 add
     */
    
    CMD_GET_playAlbum,                     // - T  - 获取播放列表 37
    
    CMD_GET_playAlbum_R,                   // - T  - 返回播放列表 38
    
    CMD_GET_current_musicInfo,             // - T  - 获取当前播放音乐信息 39
    
    CMD_GET_current_musicInfo_R = 0x00000040, // - T  - 返回当前播放音乐信息
    
    CMD_GET_record_musicInfo,             // - T  - 获取播放列表某条记录音乐信息（根据下标去获取播放列表中的音乐）
    
    CMD_GET_record_musicInfo_R,           // - T  - 返回列表某条记录音乐信息
    
    CMD_GET_voiceboxInfo,                 // - T  - 获取音箱信息
    
    CMD_GET_voiceboxInfo_R,               // - T  - 返回音箱信息
    
    /**
     *  2017-01-17 add
     */
    
    CMD_SET_resetFactory,                 // - T  - 恢复出厂设置（没回复报文，需要找一个设置变化来判断）
    
    CMD_GET_currentPlayStyle,             // - T  - 获取当前播放模式
    
    CMD_GET_currentPlayStyle_R,           // - T  - 返回当前播放模式(0-顺序，1-单曲，2-随机)
    
    CMD_SET_currentPlayStyle,             // - T  - 设置当前播放模式
    
    CMD_SET_currentPlayStyle_R,           // - T  - 返回设置当前播放模式设置是否成功
    
    CMD_GET_currentDuration = 0x00000050, // - T  - 获取当前歌曲总时长
    
    CMD_GET_currentDuration_R,            // - T  - 返回当前歌曲总时长
    
    CMD_SET_cancelCollect,                // - T  - 取消收藏某歌曲
    
    CMD_SET_cancelCollect_R,              // - T  - 返回取消收藏歌曲是否成功
    
    CMD_SET_APPCollectMusic,              // - T  - APP收藏某歌曲
    
    CMD_SET_APPCollectMusic_R,            // - T  - 返回APP收藏歌曲是否成功
    
    CMD_SET_currentPlayAlbum,             // - T  - 设置当前播放列表
    
    CMD_SET_currentPlayAlbum_R,           // - T  - 返回设置播放列表是否成功（发送errNo=11的报文）（使用CMD_SET_send_end_album 协议表示结束）
    
    
    /**
     *  NOT : notify, 表示音箱自己的操作，然后需要通知给手机
     */
    CMD_NOT_collect,                      // - T  - 通知监听音箱收藏歌曲
    
    CMD_NOT_controlStatus,                // - T  - 通知监听音箱播放、暂停
    
    CMD_NOT_controlPlay = 0x00000060,     // - T  - 通知监听音箱中歌曲变化，返回给手机歌曲在列表中的下标
    
    CMD_NOT_volume,                       // - T  - 通知监听音箱音量变化
    
    /**
     *  2017-02-18 add
     */
 
    CMD_SET_collect_in_current_album,     // - T  - 收藏当前播放列表中的某首歌曲
    
    CMD_SET_collect_in_current_album_R,   // - T  - 收藏当前播放列表中的某首歌曲返回
    
    CMD_SET_send_end_album,               // - T  - 发送列表到音箱的结束报文
    
    CMD_NOT_album_change,                 // - T  - 通知播放列表变化
    
} PACK_CMD;


#endif






