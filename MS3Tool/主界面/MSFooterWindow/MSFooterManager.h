//
//  MSFooterManager.h
//  MS3Tool
//
//  Created by chao on 2016/12/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^GoMusicVC)();

typedef void(^OpenAlbumView)();

static const float kFooterViewHeight = 56.0f;

@interface MSFooterManager : NSObject


/**
 *  去音乐播放界面
 */
@property (nonatomic, copy) GoMusicVC goMusicVC;

/**
 *  打开歌单
 */
@property (nonatomic, copy) OpenAlbumView openAlbumView;

/**
 *  打开歌单
 */
- (void) openAlbumViewInPlayVC ;

/**
 *  关闭歌单
 */
- (void) closeAlbumViewFromPlayVC ;



/**
 *  创建 manager 单例
 */
+ (instancetype) shareManager ;


/**
 *  返回 window 对象
 */
- (UIWindow *) getWindow ;


/**
 *  返回 window 是否隐藏
 */
- (BOOL) getHiddenState ;

/**
 *  返回 window 底部视图高度
 */
- (NSInteger) getHeightOfFooter ;


/**
 *  设置 window 显示在视图上
 */
- (void) setWindowVisible ;


/**
 *  设置 window 隐藏
 */
- (void) setWindowHidden ;


/**
 *  设置 window 不隐藏
 */
- (void) setWindowUnHidden ;



/**
 设置 window 的 frame

 @param offsetX 手指在屏幕移动的间距
 */
- (void) setWindowFrame:(CGFloat)offsetX ;


/**
 *  注销 window
 */
- (void) resignWindow ;


@end
