//
//  CommonUtil.m
//  JBLTool
//
//  Created by 郭文超 on 2016/10/9.
//  Copyright © 2016年 郭文超. All rights reserved.
//

#import "CommonUtil.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>


@implementation CommonUtil

#pragma mark - 是否是第一次进入这个版本
+(BOOL)isFirstBuildVesion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //是
    if ([defaults objectForKey:@"Vesion"])
    {
        //取出系统当前的版本
        NSString *systemVesion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        //用当前版本和上一次记录的版本作比较
        BOOL isFirstVesion = [systemVesion isEqualToString:[defaults objectForKey:@"Vesion"]];
        //将当前版本写入本地
        [defaults setObject:systemVesion forKey:@"Vesion"];
        [defaults synchronize];
        
        
        //比较当前版本号和上一次的版本号是否相等
        //相等    进入tabBar页面
        //不相等  进入滚动视图 表示第一次进入这个新版本
        if (isFirstVesion)
        {
            return NO;
        }
        
        return YES;
    }
    //否 就将这个版本号保存起来
    NSString *systemVesion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    [defaults setObject:systemVesion forKey:@"Vesion"];
    [defaults synchronize];
    
    return YES;
}

#pragma mark - 更改状态栏颜色
//白
+(void)changeStateBarWhite
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"statuBarColor"];
    [defaults synchronize];
}
//黑
+(void)changeStateBarBlack
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"statuBarColor"];
    [defaults synchronize];
}

#pragma mark - WiFi Control
//  获取手机当前连接的WiFi名
+(NSString *)getCurrentWIFISSID {
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    
    if (!myArray) {
        
        return nil;
    }
    
    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    
    NSLog(@"Connected at: %@", myDict);
    
    NSDictionary *myDictionary = (__bridge_transfer NSDictionary *)myDict;
    
    [self addWifiToWifiTableWithSSID:[myDictionary objectForKey:@"SSID"]];
    
    return [myDictionary objectForKey:@"SSID"];
}

+ (NSString *)deviceIPAdress:(IPType)ipType {
    
    NSString *address = @"an error occurred when obtaining ip address";
    
    struct ifaddrs *interfaces = NULL;
    
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        
        while (temp_addr != NULL) {
            
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {

                    switch (ipType) {
                        case IPType_netmast:
                            address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                            break;
                        case IPType_desaddr:
                            address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                            break;
                        case IPType_addr:
                            address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return address;
}

//跳转到WiFi列表
+(void)switchToWifiTable {
    
    NSURL*url=[NSURL URLWithString:@"Prefs:root=WIFI&path=LOCATION"];
    
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    
    [[LSApplicationWorkspace performSelector:@selector(defaultWorkspace)] performSelector:@selector(openSensitiveURL:withOptions:)
                                                                               withObject:url
                                                                               withObject:nil];
}

#pragma mark - NSUserDefault Control
#pragma mark -- privite
// 设置用户连接过的WiFi列表
+(void)setWifiTableToUserDefualt:(NSArray *)wifiArray {
    
   [[NSUserDefaults standardUserDefaults] setObject:wifiArray
                                             forKey:WIFI_ARRAY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取WiFi列表
+(NSMutableArray *)getWifiTableInUserDefualt {
    
    return [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:WIFI_ARRAY]];
}

// 判断是否保存过该WiFi
+(BOOL)isAddedWifiToWifiTableWithSSID:(NSString *)ssid inDic:(NSDictionary *)wifiDic {
    
    return [[[wifiDic allKeys] firstObject] isEqualToString:ssid] ? YES : NO;
}

#pragma mark -- 保存WiFi
+(void)addWifiToWifiTableWithSSID:(NSString *)ssid {
    
    if (!ssid) {
        
        return ;
    }
    
    NSMutableArray *wifiArr = [self getWifiTableInUserDefualt];
    
    if (wifiArr.count) {
        
        for (int i = 0; i < wifiArr.count; i++) {
            
            if ([self isAddedWifiToWifiTableWithSSID:ssid
                                               inDic:wifiArr[i]]) {
                
                break ;
                
            } else if (i == wifiArr.count - 1) {
                
                [wifiArr insertObject:@{ssid : @""}
                              atIndex:0];
                
                break ;
            }
        }
        
    } else {
        
        [wifiArr addObject:@{ssid : @""}];
    }
    
    [self setWifiTableToUserDefualt:wifiArr];
}

#pragma mark -- 保存WiFi密码
+(void)addWifiToWifiTableWithSSID:(NSString *)ssid andPassword:(NSString *)password {
    
    if (ssid.length == 0 || password.length == 0) {
        
        return ;
    }
    
    NSMutableArray *wifiArr = [self getWifiTableInUserDefualt];

    if (wifiArr.count) {
        
        for (int i = 0; i < wifiArr.count; i++) {
            
            if ([self isAddedWifiToWifiTableWithSSID:ssid inDic:wifiArr[i]]) {
                
                [wifiArr replaceObjectAtIndex:i withObject:@{ssid : password}];
                
                break;
                
            } else if (i == wifiArr.count - 1) {
                
                [wifiArr insertObject:@{ssid : password} atIndex:0];
                
                break;
            }
        }

    } else {
        
        [wifiArr addObject:@{ssid : password}];
    }

    [self setWifiTableToUserDefualt:wifiArr];
}

#pragma mark -- 删除单个WiFi
+(void)deleteWifiFromWifiTableWithSSID:(NSString *)ssid {
    
    NSMutableArray *wifiArr = [self getWifiTableInUserDefualt];
    
    for (NSDictionary *wifiDic in wifiArr) {
        
        if ([self isAddedWifiToWifiTableWithSSID:ssid inDic:wifiDic]) {
            
            [wifiArr removeObject:wifiDic];
        }
    }
    
    [self setWifiTableToUserDefualt:wifiArr];
}

#pragma mark -- 删除所有WiFi
+(void)deleteAllWifi {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WIFI_ARRAY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark -- 通过WiFiSSID获取WiFi密码
+(NSString *)getPasswordFromWifiTableWithSSID:(NSString *)ssid {
    
    NSMutableArray *wifiArr = [self getWifiTableInUserDefualt];
    
    for (NSDictionary *dic in wifiArr) {
        
        if ([[[dic allKeys] firstObject] isEqualToString:ssid]) {
            
            return [dic objectForKey:ssid];
        }
    }
    
    return @"";
}

#pragma mark - 配置KVNProgress

+(void)addKVNFullScreen:(BOOL)isFullScreen status:(NSString *)status onView:(UIView *)superView{
    
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    configuration.statusColor = [UIColor whiteColor];
    
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    
    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    
    configuration.backgroundTintColor = [UIColor colorWithRed:6 / 255.0 green:71 / 255.0 blue:69 / 255.0 alpha:0.6];
    
    configuration.successColor = [UIColor whiteColor];
    
    configuration.errorColor = [UIColor redColor];
    
    configuration.stopColor = [UIColor whiteColor];
    
    configuration.circleSize = 100.0f;
    
    configuration.lineWidth = 1.0f;
    
    configuration.fullScreen = isFullScreen;
    
    configuration.showStop = YES;
    
    configuration.stopRelativeHeight = 0.4f;
    
    [KVNProgress setConfiguration:configuration];
    
    [KVNProgress showWithStatus:status onView:superView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([KVNProgress isVisible]) {
            
            [KVNProgress dismiss];
        }
    });
}

+(void)addKVNToConnectOnView:(UIView *)superView {
    
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    configuration.statusColor = [UIColor whiteColor];
    
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    
    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    
    configuration.backgroundTintColor = [UIColor colorWithRed:6 / 255.0 green:71 / 255.0 blue:69 / 255.0 alpha:1];
    
    configuration.successColor = [UIColor whiteColor];
    
    configuration.errorColor = [UIColor redColor];
    
    configuration.stopColor = [UIColor whiteColor];
    
    configuration.circleSize = 100.0f;
    
    configuration.lineWidth = 1.0f;
    
    configuration.fullScreen = YES;
    
    configuration.showStop = YES;
    
    configuration.stopRelativeHeight = 0.4f;
    
    [KVNProgress setConfiguration:configuration];
    
    [KVNProgress showWithStatus:@"正在连接网络" onView:superView];
}

+(void)addKVNToMainView:(UIView *)superView {
    
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    configuration.statusColor = [UIColor whiteColor];
    
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    
    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    
    configuration.backgroundTintColor = [UIColor colorWithRed:6 / 255.0 green:71 / 255.0 blue:69 / 255.0 alpha:1];
    
    configuration.successColor = [UIColor whiteColor];
    
    configuration.errorColor = [UIColor redColor];
    
    configuration.stopColor = [UIColor whiteColor];
    
    configuration.circleSize = 100.0f;
    
    configuration.lineWidth = 1.0f;
    
    configuration.fullScreen = YES;
    
    configuration.showStop = YES;
    
    configuration.stopRelativeHeight = 0.4f;
    
    [KVNProgress setConfiguration:configuration];
    
    [KVNProgress showWithStatus:nil onView:superView];
}


+(void)showAlertToUnConnected {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"音箱还没有连接网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}


// 高斯模糊
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}
// 文字模糊背景
+(NSMutableAttributedString *)getTitleLabelStr:(NSString *)str {
    
    NSRange range = NSMakeRange(0, str.length);
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowBlurRadius = 5;    //模糊度
    
    shadow.shadowColor = WCBlack;
    
    shadow.shadowOffset = CGSizeMake(1, 3);
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                           NSForegroundColorAttributeName : WCWhite,
                           NSShadowAttributeName : shadow};
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attText setAttributes:dict range:range];
    
    return attText;
}

+(NSMutableAttributedString *)getTitleLabelStr:(NSString *)str font:(CGFloat)fontSize {
    
    NSRange range = NSMakeRange(0, str.length);
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowBlurRadius = 5;    //模糊度
    
    shadow.shadowColor = WCBlack;
    
    shadow.shadowOffset = CGSizeMake(0, 0);
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                           NSForegroundColorAttributeName : WCWhite,
                           NSShadowAttributeName : shadow};
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attText setAttributes:dict range:range];
    
    return attText;
}
@end





