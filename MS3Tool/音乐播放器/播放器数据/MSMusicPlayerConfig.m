//
//  MSMusicPlayerConfig.m
//  MS3Tool
//
//  Created by chao on 2016/11/14.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMusicPlayerConfig.h"

#import "MSMusicModel.h"
  


static MSMusicPlayerConfig *manager = nil;




@interface MSMusicPlayerConfig ()


@property (nonatomic, assign) BOOL isShouldResetPlayer;

@end



@implementation MSMusicPlayerConfig


/**
 *  创建config单例
 */
+ (instancetype) sharedInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
    });
    
    return manager;
}

/**
 *  初始化，用于创建config单例
 */
- (instancetype) init{
    
    if (self = [super init]) {
        
        self.playAlbum = [NSMutableArray arrayWithCapacity:0];
        
        self.playType = 0;
        
        self.isShouldResetPlayer = NO;
    }
    
    return self;
}





#pragma mark - 播放状态控制
// 准备播放
- (void) setStatusToIsPlaying {
    
    manager.playStatus = -1;
}
// 暂停
- (void) setStatusToPause {
    
    manager.playStatus = 0;
}
// 播放
- (void) setStatusToPlay {
    
    manager.playStatus = 1;
}



#pragma mark - 循环模式控制
-(void)setPlayTypeToNext {
    
    switch (manager.playType) {
            
        case -1:
        {
            manager.playType = 0;
        }
            break;
        case 0:
        {
            manager.playType = 1;
        }
            break;
        case 1:
        {
            manager.playType = -1;
        }
            break;
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(manager.playType) forKey:LAST_PLAYTYPE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)getPlayType {
    
    return manager.playType;
}



#pragma mark - 播放下标控制
// 上一首播放
-(void)setIndexWhenPlayLast {
    
    if (manager.playIndex == 0) {
        
        manager.playIndex = manager.playAlbum.count - 1;
        
    } else {
        
        manager.playIndex--;

    }
    
    manager.playModel = manager.playAlbum[manager.playIndex];
}

// 下一首播放
-(void)setIndexWhenPlayNextWithClick:(BOOL)isClick {
    
    switch (manager.playType) {
        case -1:
        {
            while (1) {
                
                NSInteger tempIndex = (NSInteger)arc4random() % manager.playAlbum.count;
                
                if (tempIndex != manager.playIndex) {
                    
                    manager.playIndex = tempIndex;
                    
                    break;
                }
                
            }
        }
            break;
        case 0:
        {
            if (manager.playIndex == manager.playAlbum.count - 1) {
                
                manager.playIndex = 0;
                
            } else {
                manager.playIndex++;
            }
        }
            break;
        case 1:
        {
            if (isClick) {
                
                if (manager.playIndex == manager.playAlbum.count - 1) {
                    
                    manager.playIndex = 0;
                    
                } else {
                    
                    manager.playIndex++;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    manager.playModel = manager.playAlbum[manager.playIndex];
}


#pragma mark - 播放列表控制

#pragma makr -- 获取歌单
-(NSArray *)getPlayAlbumArray {
    
    return manager.playAlbum;
}

#pragma mark -- 更新歌单
-(void)updateMusicArray:(NSArray *)array {
    
    [manager.playAlbum removeAllObjects];
    
    [manager.playAlbum addObjectsFromArray:array];
    
    [manager postNotifycationWithStatus:1];
}

#pragma mark -- 添加歌曲
// 添加单首歌曲进入播放列表
-(void)addModelToMusicArray:(MSMusicModel *)MSModel {
    
    [manager.playAlbum addObject:MSModel];
    
    [manager postNotifycationWithStatus:1];
}

// 添加某个歌单中的歌曲进入播放列表
-(void)addAlbumToMusicArray:(NSArray *)array {
    
    [manager.playAlbum addObjectsFromArray:array];
    
    [manager postNotifycationWithStatus:1];
}

#pragma mark -- 删除歌曲
// 根据track下标 删除歌单中的歌曲
-(void)delModelFromMusicArrayWithIndex:(NSInteger)index {
    
    [manager setPlayModelIndexWithDelIndex:index];

    [manager.playAlbum removeObjectAtIndex:index];
    

    
    [self  saveToUserDefaults];

    [manager postNotifycationWithStatus:1];
}

- (void) setPlayModelIndexWithDelIndex:(NSInteger) index {
    
    manager.isShouldResetPlayer = NO;
    
    if (index < manager.playIndex) {  // 删除当前的前一个，playIndex 前移一位
        
        manager.playIndex -= 1;
        
    } else if (index == manager.playIndex) {   // 删除当前播放歌曲时 需要处理播放器
        
        if (manager.playIndex == manager.playAlbum.count - 1) {   // playIndex 在最后一位被删除的时候，跳到第一首
            
            manager.playIndex = 0;
        }

        manager.isShouldResetPlayer = YES;
        
    }   // 删除 playIndex 后面的不变; 删除 playIndex 当前的时候如果后面还有数据，也不变，指向下一个，自动播放下一曲
    
    manager.playModel = manager.playAlbum[manager.playIndex];
}


// 根据model 删除歌单中的歌曲
-(void)delModelFromMusicArrayWithTrack:(MSMusicModel *)MSModel {
    
    [manager.playAlbum removeObject:MSModel];
    
    [manager postNotifycationWithStatus:1];
}

#pragma mark -- 清空播放列表
-(void)clearMusicArray {
    
    manager.playModel = nil;
    
    manager.playIndex = -1;
    
    [manager.playAlbum removeAllObjects];
    
    [self  saveToUserDefaults];
    
    [manager postNotifycationWithStatus:0];
}

/**
 *  将信息保存到本地
 */
- (void) saveToUserDefaults {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    MSMusicPlayerConfig *config = [MSMusicPlayerConfig sharedInstance];
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    
    for (MSMusicModel *model in config.playAlbum) {
        
        NSDictionary *tempDic = [model toDictionary];
        
        [tempArr addObject:tempDic];
    }
    
    NSDictionary *modelDic = [NSDictionary dictionaryWithDictionary:[config.playModel toDictionary]];
    
    [defaults setObject:[NSArray arrayWithArray:tempArr] forKey:LAST_PLAYTRACKARRAY];
    
    [defaults setObject:modelDic forKey:LAST_PLAYTRACK];
    
    [defaults setObject:@(config.playIndex) forKey:LAST_PLAYINDEX];
    
    [defaults synchronize];
}

#pragma mark - postNotifycation
/**
 *  status
 *       0 := 清空
 *       1 := 修改 - 增、删、更新
 */
-(void)postNotifycationWithStatus:(NSInteger)status {
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_SETTRACKARRAY object:@(status)];
}

-(void)dealloc {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:manager name:NOTIFY_SETTRACKARRAY object:nil];
}

@end
