//
//  WenChaoDEFINE.h
//  WeiChat
//
//  Created by 郭文超 on 16/2/27.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#warning mainScreen
#pragma mark - define mainScreen
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#warning notifyID
#pragma mark - define notifyID
/**
 *  设置通知
 */
//#define NOTIFY_PLAYSTATUS       @"notifyPlaystatus"             //播放状态
//#define NOTIFY_SETTRACKARRAY    @"notifySetTrackArray"          //播放列表
//#define NOTIFY_PROGRESS          @"notifyProgress"              //播放进度
#define NOTIFY_BUTTONINDEX      @"buttonIndexChange"            //pageViewController控制页面
#define NOTIFY_CONTROLLERCOUNT  @"naviViewsControllerCount"     //返回到了根导航
#define NOTIFY_CMDDATARETURN    @"notifyCMDDataReturn"          //音箱返回数据

#define NOTIFY_PUSH_CATELIST @"pushkwcatelistViewController"    //推出酷我列表详情
#define NOTIFY_PUSH_VOICE    @"pushVoiceSetterViewController"   //推出音箱中的视图
#define NOTIFY_PUSH_ALBUMDETAIL @"pushAlbumDetailViewController"//推出我的歌单详情

#define NOTIRY_CONNECTSTATUS @"notifyConnectStatus"             // tcp连接状态





#warning userdefaultID
#pragma mark - userdefaultID
#define LAST_PLAYTRACKARRAY @"LASTPLAYTRACKARRAY"   //上一次播放的列表
#define LAST_PLAYTRACK      @"LASTPLAYTRACK"        //上一次播放的track(MSModel)
#define LAST_PLAYINDEX      @"LASTPLAYINDEX"        //上一次播放的下标
#define LAST_PLAYTYPE       @"LASTPLAYTYPE"         //上一次的循环模式

#define WIFI_ARRAY          @"WIFIARRAY"            //上一次进来的WiFi
#define CRT_WIFI_SSID       @"currentWIFISSIDName"  //当前连接WiFi账号
#define CRT_WIFI_PSWD       @"currentWIFIPWSDName"  //当前连接WiFi密码


#warning rotateTime
#pragma mark - define rotateTime
/**
 *  设置图片旋转时的时间参数
 */
#define RotateTimerInterval 0.05
#define RotateViewInterval 0.1
#define RotateAnglePerMinute 200    //  RotateAnglePerMinute * RotateViewInterval 转半圈需要的秒数

#warning color
#pragma mark - define color
/**
 *  定义各种颜色
 */
#define WCBlack [UIColor blackColor]            //黑色
#define WCDarkGray [UIColor darkGrayColor]      //深灰
#define WCLightGray [UIColor lightGrayColor]    //浅灰
#define WCWhite [UIColor whiteColor]            //白色
#define WCGray [UIColor grayColor]              //灰色
#define WCRed [UIColor redColor]                //红色
#define WCGreen [UIColor greenColor]            //绿色
#define WCBlue [UIColor blueColor]              //蓝色
#define WCCyan [UIColor cyanColor]              //天蓝色
#define WCYellow [UIColor yellowColor]          //黄色
#define WCMagenta [UIColor magentaColor]        //洋红色
#define WCOrange [UIColor orangeColor]          //橘色
#define WCPurple [UIColor purpleColor]          //紫色
#define WCBrown [UIColor brownColor]            //棕色
#define WCClear [UIColor clearColor]            //透明色

//#define WCDarkBlue [UIColor colorWithRed:0.04 green:0.59 blue:1 alpha:1]
//#define WCSearchColor [UIColor colorWithRed:0.05 green:0.51 blue:0.94 alpha:1] // 搜索栏的背景色
#define WCDarkBlue [UIColor colorWithRed:6 / 255.0 green:71 / 255.0 blue:69 / 255.0 alpha:1] // 深蓝色 - 导航栏颜色
#define WCSearchColor [UIColor colorWithRed:9 / 255.0 green:106.5 / 255.0 blue:103.5 / 255.0 alpha:1] // 搜索栏的背景色
#define WCBgGray [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1] // 背景灰 - 视图背景色

// 视图背景颜色
//#define VIEW_BACKGROUNDCOLOR [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1]

//自定义颜色，直接填入整数
#define WCColor(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]

//随机颜色
#define WCRandomColor WCColor(arc4random() % 256, arc4random() % 256, arc4random() % 256, 1)

#warning height
#pragma mark -- define height
//导航栏+状态栏 和标签栏高度
#define NAVIGATIONBAR_HEIGHT 64.f
#define TABBAR_HEIGHT 49.f

#define CONTENTVIEW_FRAME CGRectMake(0, 0, WIDTH, HEIGHT - NAVIGATIONBAR_HEIGHT - kFooterViewHeight)

#define CONTENTVIEW_FRAME_NoNavi CGRectMake(0, 0, WIDTH, HEIGHT - kFooterViewHeight)


#define headViewBackColor WCBlack
#define headViewHeight 50
#define headViewWidth [UIScreen mainScreen].bounds.size.width
#define titleScroViewHeight 0.f
//底部视图高度
#define HEIGHT_FOOTERVIEW 56


#warning others
#pragma mark -- define others
//账号规则
#define  DTAETIME (long)[[NSDate date]timeIntervalSince1970]-1404218190

//个人中心编码解码
#define CODE(str)\
[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]\

#define UNCODE(str)\
[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]\

//资源下载路径
#define LIBPATH [NSString stringWithFormat:@"%@/",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]]





#ifndef WenChaoDEFINE_h
#define WenChaoDEFINE_h


#endif /* WenChaoDEFINE_h */
