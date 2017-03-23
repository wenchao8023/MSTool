//
//  MSFooterManager.m
//  MS3Tool
//
//  Created by chao on 2016/12/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//
/*****************************************
 ******                             ******
 ******  创建一个单例来管理window视图   ******
 ******                             ******
 *****************************************/


#import "MSFooterManager.h"

#import "MusicFooterView.h"

#import "MSMusicAlbumView.h"

//#import "GCDAsyncSocketManager.h"


typedef enum : NSInteger {
    
    albumTypeDarkInPlayVC = 10,
    
    albumTypeLightInMainVC
    
}AlbumStyle;



typedef enum : NSInteger {
    
    headView_tag = 101,
    
    scrollView_tag
    
}ViewsTag;





@interface MSFooterManager ()

@property (nonatomic, strong) UIWindow *footerWindow;

@property (nonatomic, strong) MusicFooterView *footerView;

@property (nonatomic, strong) MSMusicAlbumView *albumView;

// 记录是在哪个界面推出的 歌单
@property (nonatomic, assign) AlbumStyle albumStyle;

@end

static MSFooterManager *manager = nil;

@implementation MSFooterManager

#pragma mark - init

+ (instancetype) shareManager {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
        
    });
    
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        
        [self createFooterWindow];
        
    }
    
    return self;
}

#pragma mark - setViews

- (void) createFooterWindow {
    
    self.footerWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, HEIGHT - kFooterViewHeight, WIDTH, HEIGHT)];
    
    self.footerWindow.windowLevel = UIWindowLevelAlert + 1;
    
    self.footerWindow.backgroundColor = WCBgGray;
    
    [self createFooterView];
    
    [self createAlbumView];
}

- (void) createFooterView {
    
    MusicFooterView *headView = [[MusicFooterView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kFooterViewHeight)];
    
    [self.footerWindow addSubview:headView];
    
    _footerView = headView;
    
    __weak typeof(&*self) sself = self;
    
    _footerView.goMusicVC = ^() {
        
        NSLog(@"去播放器界面");

//        if ([GCDAsyncSocketManager sharedInstance].connectStatus == 1)
//            sself.goMusicVC();
//        else
//            [CommonUtil showAlertToUnConnected];
        
    };
    
    _footerView.goAlbumView = ^() {
        
        NSLog(@"打开歌单");
        [sself openAlbumViewInMainVC];
    };
    
    
}


- (UIScrollView *) createScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 100, kFooterViewHeight)];
    
    scrollView.contentSize = CGSizeMake((WIDTH - 100) * 3, kFooterViewHeight);
    
    scrollView.contentOffset = CGPointMake(WIDTH - 100, 0);
    
    scrollView.tag = scrollView_tag;
    
    return scrollView;
}

- (void) createAlbumView {
    
    MSMusicAlbumView *albumV = [[MSMusicAlbumView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    albumV.hidden = YES;
    
    [_footerWindow addSubview:albumV];
    
    _albumView = albumV;
    
    __weak typeof (&*self) sself = self;
    
    // 关闭歌单
    albumV.closeAlbum = ^() {
        
        if (sself.albumStyle == albumTypeDarkInPlayVC) {
            
            [sself closeAlbumViewFromPlayVC];
            
        } else {
            
            [sself closeAlbumViewFromMainVC];
        }
    };
}

- (void) addEffectView {

    self.footerWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
}

- (void) removeEffectView {
    
    self.footerWindow.backgroundColor = WCBgGray;
}

- (UIWindow *) getFooterWindow {
    
    return manager.footerWindow;
}

- (void) layOutFooterWindow {
    
    for (UIView *obj in _footerWindow.subviews) {
        
        if ([obj isKindOfClass:[UIView class]]) {
            
            obj.backgroundColor = [UIColor redColor];
        }
    }
}

#pragma mark - getWindow

- (UIWindow *) getWindow {
    
    return self.footerWindow;
}

- (BOOL) getHiddenState {
    
    return self.footerWindow.isHidden;
}

- (NSInteger)getHeightOfFooter {
    
    return kFooterViewHeight;
}

#pragma mark - setConfigs

- (void) setWindowVisible {
    
    [self.footerWindow makeKeyAndVisible];
}

- (void) setWindowHidden {
    
    self.footerWindow.hidden = YES;
}

- (void) setWindowUnHidden {
    
    self.footerWindow.hidden = NO;
}

- (void) setWindowFrame:(CGFloat)offsetX {
    
    CGRect frame = self.footerWindow.frame;
    
    frame.origin.x = offsetX;
    
    self.footerWindow.frame = frame;
}

#pragma mark - actions
- (void) tapOne {
    
    NSLog(@"tapOne");
    
}



#pragma mark - managerAlbum
#pragma mark -- openAlbumView -> PlayVC
- (void) openAlbumViewInPlayVC {
    
    self.albumStyle = albumTypeDarkInPlayVC;
    
    [self setWindowUnHidden];
    
    _footerView.hidden = YES;
    
    [_albumView setBgColorTypeDark];
    
    _albumView.hidden = NO;
    
    CGRect frame = self.footerWindow.frame;
    
    frame.origin.y = 0;
 
    [UIView animateWithDuration:0.5 animations:^{

        self.footerWindow.frame = frame;

    }];
    
    [self performSelector:@selector(addEffectView) withObject:nil afterDelay:0.5];
}

#pragma mark -- closeAlbumView -> PlayVC
- (void) closeAlbumViewFromPlayVC {

//    [self removeEffectView];
    
    CGRect frame = self.footerWindow.frame;
    
    frame.origin.y = HEIGHT - kFooterViewHeight;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.footerWindow.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            _footerView.hidden = NO;
            
            _albumView.hidden = YES;
            
            [self setWindowHidden];
        }
    }];
    
    [self performSelector:@selector(removeEffectView) withObject:nil afterDelay:0.5];
}

#pragma mark -- openAlbumView -> MainVC
- (void) openAlbumViewInMainVC {
    
    self.albumStyle = albumTypeLightInMainVC;

    CGRect Vframe = self.footerView.frame;
    
    Vframe.origin.y = kFooterViewHeight;
    
    [self addEffectView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.footerView.frame = Vframe;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.footerView.hidden = YES;
            
            _albumView.hidden = NO;
            
//            [_albumView setBgColorTypeLight];
            [_albumView setBgColorTypeDark];
            
            CGRect frame = self.footerWindow.frame;
            
            frame.origin.y = 0;
            
            [UIView animateWithDuration:0.4 animations:^{
                
                self.footerWindow.frame = frame;
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    
                    [self addEffectView];
                }
            }];
        }
    }];
}

#pragma mark -- closeAlbumView -> MainVC
- (void) closeAlbumViewFromMainVC {
    
    [self removeEffectView];
    
    CGRect frame = self.footerWindow.frame;
    
    frame.origin.y = HEIGHT - kFooterViewHeight;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.footerWindow.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            _footerView.hidden = NO;
            
            _albumView.hidden = YES;
            
            CGRect Vframe = self.footerView.frame;
            
            Vframe.origin.y = 0;
            
            [UIView animateWithDuration:0.3 animations:^{
               
                self.footerView.frame = Vframe;
            }];
        }
    }];
}




#pragma mark - resignWindow
- (void) resignWindow {
    
    [self.footerWindow resignKeyWindow];
    
    self.footerWindow = nil;
}


@end
