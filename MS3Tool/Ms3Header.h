//
//  Ms3Header.h
//  MS3Tool
//
//  Created by chao on 2016/10/26.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height


#define WS(weakSelf)                              __weak__ typeof(&*self) weakSelf = self;
#define SS(strongSelf)                            __strong__ typeof(&*weakSelf) strongSelf = weakSelf;

// 滑动视图上的按钮配置
#define buttonSelectedColor [UIColor whiteColor]

#define buttonUnselectedColor [UIColor grayColor]

#define buttonTagHeadScroll 567


// 焦点图高度
#define MSMainHeight_headScrollView (WIDTH * 300 / 640)





#ifdef __OBJC__

#import "WenChaoControl.h"

#import "UIButton+UnderlineNone.h"

#import "CommonUtil.h"

#import "WenChaoDEFINE.h"

#import "AFNetworking.h"

#import "MJRefresh.h"

#import "KVNProgress.h"



#import "XMSDK.h"

#import "XMSDKInfo.h"

#import "XMSDKPlayer.h"

#import "XMSingleTone.h"

#import "XMDataManager.h"


#import "Extension.h"

#import "MSMusicModel.h"

#import "CMDDataConfig.h"

#import "VoicePlayer.h"



#import "UIImageView+WebCache.h"

#import "UIButton+WebCache.h"


#import "MSFooterManager.h"

#import "GCDAsyncSocketCommunicationManager.h"



#endif /* Ms3Header_h */
