//
//  WenChaoControl.h
//  WeiChat
//
//  Created by 郭文超 on 16/2/27.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#pragma mark -- setHeadView
#define headViewBackColor WCBlack
#define headViewHeight 50
#define headViewWidth [UIScreen mainScreen].bounds.size.width
#define titleScroViewHeight 0.f



@interface WenChaoControl : NSObject



#pragma mark --判断设备型号
//+(NSString *)platformString;
+(NSString *)deviceIdForIDFA;

#pragma mark - UIKit
#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text textAlignment:(int)textAlignment;
#pragma mark --创建View
+(UIView*)viewWithFrame:(CGRect)frame;
#pragma mark --创建imageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
#pragma mark --创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;
#pragma makr --创建导航栏返回按钮
+(UIBarButtonItem *)createNaviBackButtonTarget:(id)target Action:(SEL)action;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;
#pragma mark -- 创建UITableView
+(UITableView *)createTableViewWithFrame:(CGRect)frame delegate:(id)delegate style:(UITableViewStyle)style;
#pragma mark --创建界面的HeadView
+(UIView *)createHeadViewWithTitle:(NSString *)title Target:(id)target Action:(SEL)action leftTag:(NSInteger)leftTag leftImage:(NSString *)leftImage rightTag:(NSInteger)rigthTag rightImage:(NSString *)rightImage;

//适配器的方法  扩展性方法
//现有方法，已经在工程里面存在，如果修改工程内所有方法，工作量巨大，就需要使用适配器的方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;
#pragma mark 创建UIScrollView
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size;
#pragma mark 创建UIPageControl
+(UIPageControl*)makePageControlWithFrame:(CGRect)frame;
#pragma mark 创建UISlider
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image;
#pragma mark - --创建时间转换字符串
+(NSString *)stringFromDateWithcomplete:(NSDate *)date;         //完整的时间
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date;    //只有小时和分
#pragma mark --判断导航的高度64or44
+(float)isIOS7;

#pragma mark 内涵图需要的方法
//startTime的时间格式@"yyyy-MM-dd HH:mm:ss"
+(NSString *)timeIntervalWithStartTime:(NSString *)startTime;
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval;

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize;

+ (NSString *)addOneByIntegerString:(NSString *)integerString;

// 将纯颜色转换成图片
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
