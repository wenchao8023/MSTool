//
//  MSMainVC.m
//  MS3Tool
//
//  Created by chao on 2016/12/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMainVC.h"

/* main views */
#import "MSSliderView.h"

#import "MSMainLeftView.h"


/* viewControllers */
#import "ConnectViewController.h"

#import "CategoryDetailVC1.h"

#import "MSMusicPlayViewController.h"

#import "BroadCastDetailVC.h"

#import "SmartHomeVC.h"

#import "MSMusicPlayVC1.h"

#import "KWCateListViewController.h"

#import "KugouMusicSearchVC.h"

#import "AlbumDetailViewController.h"


//#import "UDPAsyncSocketManager.h"


typedef enum :NSInteger {
    
    kCameraMoveDirectionNone = 10,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown
    
} CameraMoveDirection;



static const CGFloat kRightWidth = 60.0f;

static const CGFloat kGestureMinimumTranslation = 20.0;


@interface MSMainVC () {
    CameraMoveDirection direction;
}

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) MSSliderView *contentView;

@property (nonatomic, strong) MSFooterManager *footerManager;

@property (nonatomic, strong) UIWindow *progressWindow;

@property (nonatomic, strong) NSArray *VoiceVCArray;

@end


@implementation MSMainVC

#pragma mark - lifeCycle of view

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = WCBgGray;

    [_footerManager setWindowUnHidden];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initContainer];
    
    [self createUI];
    
    [self createFooterWindow];
    
    [self addNotify];
}

-(NSArray *)VoiceVCArray {
    
    if (!_VoiceVCArray) {
        
        _VoiceVCArray = @[@"MSVoicecommandViewController", @"NewHandHelpViewController", @"MSVoiceSettingViewController", @"SmartHomeVC", @"ConnectViewController"];
    }
    
    return _VoiceVCArray;
}

#pragma mark - init
- (void) initContainer {
    
    //  初始化喜马拉雅sdk
    [XMDataManager shareInstance];
    
    _footerManager = [MSFooterManager shareManager];
}

#pragma mark - createUI

- (void)createUI {    
    
    [self createLeftView];
    
    [self createMainView];
    
    [self createWindowProgress];
}

- (void)createLeftView {
    
    MSMainLeftView *leftV = [[MSMainLeftView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - kRightWidth, HEIGHT)];
    
    [self.view addSubview:leftV];
    
    _leftView = leftV;
    
}

- (void)createMainView {
    
    _contentView = [[MSSliderView  alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_contentView];
    
    _mainView = _contentView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.contentView addGestureRecognizer:pan];
    
    
    __weak typeof(&*self) sself = self;
    
    // 顶部按钮点击事件
    _contentView.clickBlock = ^(NSInteger clickTag) {
        
        if (clickTag == leftButtonTag) {
            
            [sself showLeftView];
            
        } else if (clickTag == rightButtonTag) {
            
            ConnectViewController *vc = [[ConnectViewController alloc] init];
            
            [sself.navigationController pushViewController:vc animated:YES];
        }
    };
    
    // 点击分类标题
    _contentView.categoryBlock = ^(XMCategory *category) {
      
        CategoryDetailVC1 *vc = [[CategoryDetailVC1 alloc] init];
        
        vc.categoryID = category.categoryId;
        
        vc.categoryName = category.categoryName;
        
        [sself.navigationController pushViewController:vc animated:YES];
    };
    
    
    // 点击搜索栏进行搜歌
    _contentView.kugouSearchVC = ^() {

        NSLog(@"搜索");
        [sself.navigationController pushViewController:[[KugouMusicSearchVC alloc] init] animated:YES];
    };
    
    // 选择广播 clickTag: 220 ~ 224
    NSArray *broadTitleArr = @[@"本地台", @"国家台", @"省市台", @"网络台", @"广播排行榜"];
    
    _contentView.broadClick = ^(NSInteger clickTag) {
        
        BroadCastDetailVC *bcVC = [[BroadCastDetailVC alloc] init];
        
        bcVC.clickTag = clickTag;
        
        bcVC.titleName = broadTitleArr[clickTag - 220];
        
        [sself.navigationController pushViewController:bcVC animated:YES];
    };
    
    
    _contentView.buttonsViewClickBlock = ^(ButtonsClickTag clickTag) {
      
        switch (clickTag) {
//            case latestClickTag:
//            {
//                NSLog(@"--> 音箱");
//                
//                [sself.navigationController pushViewController:[[CMDTestViewController alloc] init] animated:YES];
//            }
//                break;
            case myLoveClickTag:
            {
                NSLog(@"--> 我喜欢");
                
                
            }
                break;
            case latestClickTag:
            {
                NSLog(@"--> 最近播放");
//                [UDPAsyncSocketManager sharedInstance];
            }
                break;
            case smarthomeClickTag:
            {
                NSLog(@"--> 智能家居");
                
                [sself.navigationController pushViewController:[[SmartHomeVC alloc] init] animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
}


- (void) createFooterWindow {
    
    [_footerManager setWindowVisible];
    
    __weak typeof (&*self) sself = self;
    
    _footerManager.goMusicVC = ^() {
        
        [sself presentViewController:[MSMusicPlayViewController new] animated:YES completion:nil];
    };
}


- (void) createWindowProgress {
    
    _progressWindow = [[UIWindow alloc] initWithFrame:self.view.bounds];
    
    _progressWindow.windowLevel = UIWindowLevelAlert + 2;
    
    [_progressWindow makeKeyAndVisible];
    
    _progressWindow.backgroundColor = WCDarkBlue;
    
    _progressWindow.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTap)];
    
    [_progressWindow addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resetPan:)];
    
    [_progressWindow addGestureRecognizer:pan];
}


#pragma mark - actions
- (void) resetPan: (UIPanGestureRecognizer *)gesture {
    
    [self tapTap];
}

- (void) tapTap {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.mainView.frame = self.view.bounds;     // 还原 mainView 的位置
        
        [self setWindowXWithMainX];
        
        [self setProgressWindowWithMainX];
    }];
}



- (void) pan:(UIPanGestureRecognizer *)gesture {
    
    CGPoint translation = [gesture  translationInView:self.mainView];
    
    // 判断滑动方向
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        direction = kCameraMoveDirectionNone;
        
    } else if (gesture.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone) {
        
        direction = [self determineCameraDirectionIfNeeded:translation];
        
    }
    
    if (direction == kCameraMoveDirectionRight) {   // 向右滑  start moving right
   
        if (gesture.state == UIGestureRecognizerStateChanged) {
            
            if (self.mainView.x < 0) {  // moving boundary left
            
                self.mainView.x = 0;
                
            } else if (self.mainView.x > WIDTH - kRightWidth) { // moving boundary right
                
                self.mainView.x = WIDTH - kRightWidth;
            }
            
        }
        
        [self setLeftFrameWithOffsetX:translation.x];

        if (gesture.state == UIGestureRecognizerStateEnded) {
            
            // 滑动结束给判断
            if (self.mainView.frame.origin.x > WIDTH * 0.3 ) {
                
                [self showLeftView];
                
            } else {
                
                [self tapTap];
            }
            
        }
        
    } else if (direction == kCameraMoveDirectionLeft) {    // 向左滑
        
        NSLog(@"start moving left");
        
    } else if (direction == kCameraMoveDirectionDown) {
        
        NSLog(@"start moving down");
        
    } else if (direction == kCameraMoveDirectionUp) {
        
        NSLog(@"start moving up");
        
    }
    
    [gesture setTranslation:CGPointZero inView:self.mainView];
}

#pragma mark --根据偏移量计算MainV的frame
// 显示左侧view - 点击
- (void) showLeftView {
    
    CGFloat target = (WIDTH - kRightWidth);
    
    CGFloat offset = target - self.mainView.frame.origin.x;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.mainView.frame =  [self frameWithOffsetX:offset];
        
        [self setWindowXWithMainX];
        
        [self setProgressWindowWithMainX];
    }];
}
// 显示左侧view - 滑动
- (void) setLeftFrameWithOffsetX : (CGFloat)offsetX {
    
    self.mainView.frame = [self frameWithOffsetX:offsetX];
    
    [self setWindowXWithMainX];
    
    [self setProgressWindowWithMainX];
}

- (CGRect) frameWithOffsetX:(CGFloat)offsetX {

    CGRect frame = self.mainView.frame;
    
    frame.origin.x += offsetX;
    
    return frame;
}

- (void) setWindowXWithMainX {
    
    [_footerManager setWindowFrame:self.mainView.frame.origin.x];
}

- (void) setProgressWindowWithMainX {
    
    CGFloat mainX = self.mainView.frame.origin.x;
    
    CGRect frame = self.progressWindow.frame;
    
    frame.origin.x = mainX;
    
    _progressWindow.frame = frame;
    
    _progressWindow.alpha = 0.6 * (mainX / (WIDTH - 80));
}


#pragma mark - private func
- (CameraMoveDirection) determineCameraDirectionIfNeeded:(CGPoint)translation {
    if (direction != kCameraMoveDirectionNone)
        
        return direction;
    
    // determine if horizontal swipe only if you meet some minimum velocity
    if (fabs(translation.x) > kGestureMinimumTranslation) {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y == 0.0)
            
            gestureHorizontal = YES;
        
        else
            
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0);
        
        if (gestureHorizontal) {
            
            if (translation.x > 0.0)
                
                return kCameraMoveDirectionRight;
            
            else
                
                return kCameraMoveDirectionLeft;
            
        } else if(fabs(translation.y) > kGestureMinimumTranslation)
            
        {
            
            BOOL gestureVertical = NO;
            
            if(translation.x == 0.0)
                
                gestureVertical = YES;
            
            else
                
                gestureVertical = (fabs(translation.y / translation.x) > 5.0);
            
            if(gestureVertical)
                
            {
                
                if(translation.y > 0.0)
                    
                    return kCameraMoveDirectionDown;
                
                else
                    
                    return kCameraMoveDirectionUp;
                
            }
        }
    }

    return direction;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];
    
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    NSLog(@"MSMainVC -- velocity.x:%f----location.x:%d",velocity.x,(int)location.x%(int)[UIScreen mainScreen].bounds.size.width);
    
    if (velocity.x > 0.0f&&(int)location.x%(int)[UIScreen mainScreen].bounds.size.width<60) {
        
        return NO;
    }
    return YES;
}

#pragma mark - 通知
-(void)addNotify {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewC:) name:NOTIFY_PUSH_CATELIST object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewC:) name:NOTIFY_PUSH_VOICE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewC:) name:NOTIFY_PUSH_ALBUMDETAIL object:nil];
}

-(void)pushViewC:(NSNotification *)notify {
    
    if ([notify.name isEqualToString:NOTIFY_PUSH_CATELIST]) {
        
        KWCategoryListModel *model = notify.object;
        
        KWCateListViewController *vc = [[KWCateListViewController alloc] init];
        
        vc.cateModel = model;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([notify.name isEqualToString:NOTIFY_PUSH_VOICE]) {
        
        NSIndexPath *indexPath = notify.object;
        
        Class myclas = NSClassFromString(self.VoiceVCArray[indexPath.row]);
        
        UIViewController *vc = [myclas new];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([notify.name isEqualToString:NOTIFY_PUSH_ALBUMDETAIL]) {
        
        AlbumDetailViewController *vc = [[AlbumDetailViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PUSH_CATELIST object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PUSH_VOICE object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PUSH_ALBUMDETAIL object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
