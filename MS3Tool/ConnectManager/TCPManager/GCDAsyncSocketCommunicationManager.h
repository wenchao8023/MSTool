//
//  GCDAsyncSocketCommunicationManager.h
//  MS3Tool



/*************************************************************************
 ****************                连接说明               *******************
 ** 1. 每次启动程序的时候就进行udp广播                                       
 **    如果广播的时候有数据返回，说明音箱已经连接WiFi，通过返回的数据进入STA模式连接 
 **    如果在限定的次数（时间）内没有收到数据返回,提示用户打开音箱WiFi进入AP模式配对 
 ** 2. 所有的连接方法都封装在了GCDAsyncSocketCommunicationManager里面        
 **    通过连接的进度来判断如何去做下一步操作
 ** 3. 类说明   
 **    packet.h 定义协议                                                 
 **    GCDConnectConfig.h 记录连接步骤                                    
 **    GCDAysncSocketDataManager 处理协议数据                             
 **    GCDAsyncSocketManager tcp连接协议                                 
 **    UDPAsyncSocketManager udp连接协议                                 
 **    GCDAsyncSocketCommunicationManager 调用接口
 *************************************************************************/

#import <Foundation/Foundation.h>

#import "packet.h"

#import "GCDHeaderFile.h"

#import "GCDConnectConfig.h"

#import "GCDAysncSocketDataManager.h"



@interface GCDAsyncSocketCommunicationManager : NSObject


@property (nonatomic, strong, nullable) GCDAysncSocketDataManager *dataManager;



+ (nonnull GCDAsyncSocketCommunicationManager *)sharedInstance;

/**
 *  记住 WiFi账号 和WiFi密码
 */
- (void)rememberWifi:(NSString * _Nonnull)ssid pswd:(NSString * _Nonnull)pswd;

/**
 *  连接tcpSocket
 */
- (void)createSocketWithDelegate:(nonnull id)delegate andHost:(nonnull NSString *)host andPort:(uint16_t)port;

/**
 *  连接tcpSocket -- 恢复出厂设置
 */
- (void)createSocketToReset;

/**
 *  写数据
 */
- (void)socketWriteDataWithData:(nonnull NSData *)requestData andTag:(long)tag;

/**
 *  还原所有连接设置，准备下次连接
 */
- (void)resetToConnect ;


/**
 *  开始广播
 */
-(void)udpBroadcast;

/**
 *  停止广播
 */
-(void)udpStopBroadcast;



/**
 *  主动断开连接
 */
- (void)disconnectSocket;




@end
