//
//  CommonUtil.h
//  JBLTool
//
//  Created by 郭文超 on 2016/10/9.
//  Copyright © 2016年 郭文超. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONNECTED_WIFI_SSID_TABLE @"CONNECTEDWIFISSIDTABLE"


typedef enum : NSInteger{
    
    IPType_netmast, //子网掩码
    
    IPType_addr,    //本地IP
    
    IPType_desaddr  //广播地址
    
}IPType;

@interface CommonUtil : NSObject

/**
 *  判断是不是第一次进入这个版本
 */
+(BOOL)isFirstBuildVesion;

/**
 *  改变状态栏的颜色为白色
 */
+(void)changeStateBarWhite;

/**
 *  改变状态栏的颜色为黑色
 */
+(void)changeStateBarBlack;


+(BOOL)isConnectedToVoiceboxWifi;
/**
 *  获取手机当前连接的WiFiSSID
 */
+(NSString *)getCurrentWIFISSID;

/**
 *  获取ip地址
 */
+(NSString *)deviceIPAdress:(IPType)ipType;

/**
 *  跳转到WiFi列表
 */
#pragma mark - NSUserDefault Control
+(void)switchToWifiTable;

/**
 获取本地保存的WiFi列表
 */
+(NSMutableArray *)getWifiTableInUserDefualt ;

+(void)setWifiTableToUserDefualt:(NSArray *)wifiArray ;

+(void)addWifiToWifiTableWithSSID:(NSString *)ssid ;

+(void)addWifiToWifiTableWithSSID:(NSString *)ssid andPassword:(NSString *)password ;

+(void)deleteWifiFromWifiTableWithSSID:(NSString *)ssid ;

+(void)deleteAllWifi ;

+(NSString *)getPasswordFromWifiTableWithSSID:(NSString *)ssid ;


/**
 配置KVNProgress
 */
+(void)addKVNFullScreen:(BOOL)isFullScreen status:(NSString *)status onView:(UIView *)superView;

+(void)addKVNToConnectOnView:(UIView *)superView;

+(void)addKVNToMainView:(UIView *)superView;



/**
 提示音箱还没有连接网络
 */
+(void)showAlertToUnConnected;
@end
