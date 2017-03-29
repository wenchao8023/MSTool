//
//  MSMusicPlayViewController.m
//  ContentModel
//
//  Created by chao on 2016/10/18.
//  Copyright © 2016年 wc. All rights reserved.
//

#import "MSMusicPlayViewController.h"

#import "MSFooterManager.h"






static const CGFloat kVolumeViewHeight = 160.f;


@interface MSMusicPlayViewController ()
/**
 * UIButton
 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;         //返回按钮

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;         //功能菜单按钮

@property (weak, nonatomic) IBOutlet UIButton *cycleTypeBtn;    //循环模式按钮

@property (weak, nonatomic) IBOutlet UIButton *playLastBtn;     //播放上一首按钮

@property (weak, nonatomic) IBOutlet UIButton *playBtn;         //播放按钮

@property (weak, nonatomic) IBOutlet UIButton *playNextBtn;     //播放下一首按钮

@property (weak, nonatomic) IBOutlet UIButton *playMenuBtn;     //播放列表按钮

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;      //收藏按钮

@property (weak, nonatomic) IBOutlet UIButton *addAblumBtn;     //添加歌曲到歌单按钮

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;        //分享按钮

@property (weak, nonatomic) IBOutlet UIButton *volumeBtn;       //音量按钮


/**
 * UILable
 */
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *playingTimeLabel;  //播放当前时长

@property (weak, nonatomic) IBOutlet UILabel *playTotalTime;     //总时长

@property (weak, nonatomic) IBOutlet UIImageView *middleImageV;  //中间的小图


/**
 * UISlider
 */
@property (weak, nonatomic) IBOutlet UISlider *playSlider;      // 播放进度

@property (nonatomic, strong) UISlider *volumeSlider;           // 音量大小


@property (nonatomic, strong) UIImageView *bgImageView;          //背景图

@property (nonatomic, strong) UIView *albumBgView;               //歌单视图

@property (nonatomic, strong) UIView *volumeView;                 //音量视图

@property (nonatomic, strong, nonnull) CMDDataConfig *cmdConfig;

@property (nonatomic, strong, nonnull) VoicePlayer *vPlayer;

@property (nonatomic, strong, nonnull) MSConnectManager *comConfig;


@property (nonatomic, strong, nullable) NSTimer *sliderTimer;    // 播放进度定时器

@property (nonatomic, strong, nonnull) NSArray *argusArray;

/**
 * 播放数据
 */
@property (nonatomic, assign) int playVolume;

@property (nonatomic, assign) int playStatu;

@property (nonatomic, assign) int playType;     // 0-顺序, 1-单曲, 2-随机

@property (nonatomic, assign) int playProgress;

@property (nonatomic, assign) int playDuration;

@property (nonatomic, strong, nullable) NSDictionary *playInfo;

@property (nonatomic, strong, nullable) NSMutableArray *playAlbum;


/**
 *  default data
 */
@property (nonatomic, strong, nonnull) UIImage *defaultImage;


@end

@implementation MSMusicPlayViewController


#pragma mark -  View 的生命周期
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 将状态栏改成白色
    [CommonUtil changeStateBarWhite];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [[MSFooterManager shareManager] setWindowHidden];
    }];
    

}
-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initContainer];
    
    [self setUI];
    
    [self setImagesWithUrlStr:@""];
    
//    [self loadLocalData];
    
    
    [self loadMusicInfoInView];
    
    [self addObservers];
}

- (void)addObservers {

    for (NSString *aruStr in self.argusArray) {
        
        [self addObserver:self forKeyPath:aruStr
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
}

-(NSMutableArray *)playAlbum {
    
    if (!_playAlbum) {
        
        _playAlbum = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _playAlbum;
}

-(NSArray *)argusArray {
    
    if (!_argusArray) {
        
        _argusArray = @[@"playVolume",
                        @"playStatu",
                        @"playType",
                        @"playProgress",
                        @"playDuration",
                        @"playInfo"
                        ];
    }
    
    return _argusArray;
}

- (void)initContainer {
    
    self.cmdConfig = [CMDDataConfig shareInstance];
    
    self.vPlayer = [VoicePlayer shareInstace];
    
    self.comConfig = [MSConnectManager sharedInstance];
    
    self.defaultImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                          pathForResource:@"cm2_default_play_bg@3x"
                                                          ofType:@"jpg"]];
}

#pragma mark - 进入界面的时候导入播放音乐的信息
/**
 * 循环模式
 * 播放状态
 * 歌曲信息：歌曲名、歌曲作家、专辑图片 -- 显示，歌曲url -- 存储
 * 声音
 * 总时长
 * 进度
 * 是否收藏
 * 播放列表
 */
- (void)loadMusicInfoInView {
    
    // 进来的时候就先获取一次进度
//    [self.vPlayer VPGetCurrentProgress];
    // 循环获取进度
//    [self.vPlayer VPGetCurrentProgressIsLastFiveSeconds:NO];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *selArr = @[@"VPGetPlayMusicInfo",
                            @"VPGetPlayStatu",
                            @"VPGetPlayType",
                            @"VPGetVolume",
                            ];
        
        for (int i = 0; i < selArr.count; i++) {
            
            if (!i) {
                
            }
            
            [NSThread sleepForTimeInterval:0.1];
            
            [self.vPlayer performSelectorInBackground:NSSelectorFromString(selArr[i])
                                           withObject:nil];
        }
    });

 
//    [self.sliderTimer fire];
}

- (void)loadLocalData {

    NSDictionary *tempDic = self.cmdConfig.cmdDic;
    
    if ([self getValueDic:tempDic CMD:CMD_GET_VOLUME_R] != -1) {
        self.playVolume = [self getValueDic:tempDic CMD:CMD_GET_VOLUME_R];
    }
    
    if ([self getValueDic:tempDic CMD:CMD_GET_PLAYSTATE_R] != -1) {
        self.playStatu = [self getValueDic:tempDic CMD:CMD_GET_PLAYSTATE_R];
    }
    
    if ([self getValueDic:tempDic CMD:CMD_NOT_controlStatus] != -1) {
        self.playStatu = [self getValueDic:tempDic CMD:CMD_NOT_controlStatus];
    }
    
    if ([self getValueDic:tempDic CMD:CMD_GET_playProgress_R] != -1) {
        self.playProgress = [self getValueDic:tempDic CMD:CMD_GET_playProgress_R];
    }
    
    if ([self getValueDic:tempDic CMD:CMD_GET_currentPlayStyle_R] != -1) {
        self.playType = [self getValueDic:tempDic CMD:CMD_GET_currentPlayStyle_R];
    }
    
    if ([self getValueDic:tempDic CMD:CMD_GET_currentDuration_R] != -1) {
        self.playDuration = [self getValueDic:tempDic CMD:CMD_GET_currentDuration_R];
    }
}




#pragma mark - 设置UI界面中的控件详细参数
-(void)setUI {
    // 设置中间的图片
    [self setMiddldImageLayer];
    
    // 设置进度条
    [self setSliderUI];
    
    /**
     * 创建背景视图
     */
    [self.view addSubview:self.bgImageView];
    
    [self.view sendSubviewToBack:self.bgImageView];
    
    /**
     * 创建音量视图
     */
    [self.view addSubview:self.volumeView];
    
    /**
     * 添加通知
     */
    [self addNotifycation];
    
    /**
     *  给button赋值，程序上一次记录的
     */
    [self setImgToCycleTypeBtn];
}

- (void)setMiddldImageLayer {
    
    self.middleImageV.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:0.4].CGColor;
    
    self.middleImageV.layer.borderWidth = 8.f;
    
    self.middleImageV.layer.masksToBounds = YES;
}

- (void)setSliderUI {
    
    [self.playSlider addTarget:self
                        action:@selector(progressValueChanged:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.playSlider addTarget:self
                        action:@selector(sliderProgress:)
              forControlEvents:UIControlEventValueChanged | UIControlEventTouchDown];
    
    self.playSlider.minimumTrackTintColor = WCWhite;
    
    [self.playSlider setThumbImage:[UIImage imageNamed:@"sliderthumb"] forState:UIControlStateNormal];
}


-(UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        
        // 毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        effectView.frame = _bgImageView.frame;
        
        effectView.alpha = 0.9;
        
        [_bgImageView addSubview:effectView];
    }
    
    return _bgImageView;
}

-(UIView *)volumeView {
    
    if (!_volumeView) {
        
        _volumeView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - kVolumeViewHeight, WIDTH, kVolumeViewHeight)];
        
        _volumeView.backgroundColor = WCWhite;
        
        _volumeView.hidden = YES;
        
        
        UIButton *cancelBtn = [WenChaoControl createButtonWithFrame:CGRectMake((WIDTH - 40) / 2, 0, 40, 40)
                                                          ImageName:nil
                                                             Target:self
                                                             Action:@selector(cancelVolumeView)
                                                              Title:nil];
        
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"backDownBlue"] forState:UIControlStateNormal];
        
        [_volumeView addSubview:cancelBtn];
        
        
        self.volumeSlider.frame =  CGRectMake(40, kVolumeViewHeight / 2 - 10, WIDTH - 80, 20);
        
        [_volumeView addSubview:self.volumeSlider];
    }
    
    return _volumeView;
}


-(UISlider *)volumeSlider {
    
    if (!_volumeSlider) {
        
        _volumeSlider = [[UISlider alloc] init];
        
        _volumeSlider.minimumValue = 0;
        
        _volumeSlider.maximumValue = 100;
        
        [_volumeSlider addTarget:self
                          action:@selector(setVolumeData)
                forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _volumeSlider;
}

-(NSTimer *)sliderTimer {
    
    if (!_sliderTimer) {
        
//        _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addPlaySlider) userInfo:nil repeats:YES];
    }
    
    return _sliderTimer;
}

#pragma mark - 管理播放进度
-(void)addPlaySlider {
    
//    [self configPlaySlider:0 isAdd:YES];
}

-(void)configPlaySlider:(float)value isAdd:(BOOL)isAdd {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        if (isAdd) {
            
            self.playProgress++;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.playSlider.value = self.playProgress;
            
            self.playingTimeLabel.text = [self getDuration:(int)self.playSlider.value];
        });
    });
}

// 暂停进度推进
-(void)stopPlaySlider {
    
//    if (self.sliderTimer && [self.sliderTimer isValid]) {
//        
//        [self.sliderTimer invalidate];
//        
//        self.sliderTimer = nil;
//    }
}
// 恢复进度推进
-(void)resumePlaySlider {
    
//    [self.sliderTimer fire];
}

// 手指松开
- (void)progressValueChanged:(UISlider *)slider {
    
//    [self resumePlaySlider];
//    
    [self.vPlayer VPGetCurrentProgressIsLastFiveSeconds:YES];
//
    [self.vPlayer VPSetProgress:(int)slider.value];
}

// 手指按下
- (void)sliderProgress:(UISlider *)slider {
    
//    [self stopPlaySlider];
//
    [self.vPlayer VPGetCurrentProgress_Stop];
//
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playingTimeLabel.text = [self getDuration:(int)slider.value];
    });
}

#pragma mark - 给控件赋值
// 设置音量
- (void)setVolumeData {
    
    [self.vPlayer VPSetVolume:(int)(self.volumeSlider.value)];
}

- (void)setMusicInfoInView {
    
    [self setImagesWithUrlStr:[self.playInfo objectForKey:@"musicImgUrl"]];
    
    self.songNameLabel.attributedText = [CommonUtil getTitleLabelStr:[self.playInfo objectForKey:@"musicName"] font:18];
    
    self.albumNameLabel.attributedText = [CommonUtil getTitleLabelStr:[self.playInfo objectForKey:@"artistsName"] font:14];
}

// 设置背景、专辑图片
-(void)setImagesWithUrlStr:(NSString *)urlStr {
    
    if (urlStr.length) {
        
        [self.middleImageV sd_setImageWithURL:[NSURL URLWithString:urlStr]
                             placeholderImage:self.defaultImage];
        
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:self.defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           
            self.bgImageView.image = [CommonUtil coreBlurImage:image
                                                withBlurNumber:0.5];
        }];
        
    } else {
        
        self.middleImageV.image = self.defaultImage;
        
        self.bgImageView.image = [CommonUtil coreBlurImage:self.defaultImage
                                            withBlurNumber:0.5];
    }
}

// 设置循环模式按钮图片
- (void)setImgToCycleTypeBtn {
   
    switch (self.playType) {
        case 0:
            [self.cycleTypeBtn setBackgroundImage:[UIImage imageNamed:@"cycleTypeOrder39"] forState:UIControlStateNormal];
            break;
        case 1:
            [self.cycleTypeBtn setBackgroundImage:[UIImage imageNamed:@"cycleTypeSingle39"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.cycleTypeBtn setBackgroundImage:[UIImage imageNamed:@"cycleTypeDisorder39"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

/* 设置播放按钮图片 
 * 3 - 暂停
 * 4 - 播放
 */
- (void)setImgToPlayBtn {
    
    if (self.playStatu == 2 ||
        self.playStatu == 4) {  // 播放
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"playPause39"] forState:UIControlStateNormal];
//        [self resumePlaySlider];
        [self.vPlayer VPGetCurrentProgressIsLastFiveSeconds:YES];
    } else {    // 暂停
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"playPlay39"] forState:UIControlStateNormal];
//            [self stopPlaySlider];
        [self.vPlayer VPGetCurrentProgress_Stop];
    }
}

-(void)setPlayTypeToNext {
    
    self.playType = self.playType == 0 ? 1 : (self.playType == 1 ? 2 : 0);
}
-(void)setPlayStatuToNext {
    
    self.playStatu = self.playStatu == 3 ? 4 : 3;
}


#pragma mark - Actions

- (IBAction)clickToBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickToMenu:(id)sender {
    
    NSLog(@"打开菜单");
}

- (IBAction)clickToCycleType:(id)sender {
    NSLog(@"更换循环模式");
    
    [self setPlayTypeToNext];
    
    [self.vPlayer VPSetPlayType:self.playType];
    
    [self setImgToCycleTypeBtn];
}

- (IBAction)clickToLastSong:(id)sender {
    NSLog(@"上一首");

    [self.vPlayer VPlayLastSong];
}

- (IBAction)clickToPlayOrPause:(id)sender {
    NSLog(@"播放、暂停");

    [self setPlayStatuToNext];
    
    if (self.playStatu == 2 ||
        self.playStatu == 4)
        [self.vPlayer VPause];
    else
        [self.vPlayer VPlay];
    
    [self setImgToPlayBtn];
}

- (IBAction)clickToNextSong:(id)sender {
    NSLog(@"下一首");

    [self.vPlayer VPlayNextSong];
}

- (IBAction)clickToAddMenu:(id)sender {
    NSLog(@"歌单");

    // 打开歌单
    [[MSFooterManager shareManager] openAlbumViewInPlayVC];
}

- (IBAction)clickToCollect:(id)sender {
    
    NSLog(@"收藏");
    
    [self.vPlayer VPSetCollectMusic];
}

- (IBAction)clickToAddAlbum:(id)sender {
    
    NSLog(@"添加歌曲进歌单");
}

- (IBAction)clickToShare:(id)sender {
    
    NSLog(@"分享");
}

- (IBAction)clickToVolume:(id)sender {
    
    NSLog(@"音量");
    
    if (self.volumeView.isHidden) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.volumeView.hidden = NO;
            
            self.volumeSlider.value = (float)self.playVolume;
        }];
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.volumeView.hidden = YES;
        }];
    }
}

-(void)cancelVolumeView {
    
    self.volumeView.hidden = YES;
}



#pragma mark - addNotifycation
-(void)addNotifycation {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCMDData) name:NOTIFY_CMDDATARETURN object:nil];
}

- (void)getCMDData {
    
    int cmd = self.cmdConfig.getCMD;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self setMusicInfoWithCMD:cmd];
    });
}

// 音箱返回的数据
- (void)setMusicInfoWithCMD:(int)cmd {
    
    NSDictionary *tempDic = self.cmdConfig.cmdDic;

    switch (cmd) {
        case CMD_GET_VOLUME_R:  // 音量
        {
            
            self.playVolume = [self getValueDic:tempDic CMD:cmd];
            
            NSLog(@"获取音量大小 : %d", self.playVolume);
        }
        case CMD_NOT_volume:  // 音量
        {
            
            self.playVolume = [self getValueDic:tempDic CMD:cmd];
            
            NSLog(@"通知 -- 音量大小 : %d", self.playVolume);
        }
            break;
        case CMD_GET_PLAYSTATE_R:   //  播放状态
        {
            self.playStatu = [self getValueDic:tempDic CMD:cmd];
            
            NSLog(@"获取播放状态 : %d", self.playVolume);
        }
            break;
        case CMD_NOT_controlStatus:   //  播放状态
        {
            self.playStatu = [self getValueDic:tempDic CMD:cmd];
            
            NSLog(@"通知 -- 获取播放状态 : %d", self.playStatu);
        }
            break;
        case CMD_GET_playProgress_R:    // 播放进度
        {
            self.playProgress = [self getValueDic:tempDic CMD:cmd];
            
            if (self.playDuration <= 0) {
                
                [self.vPlayer VPGetDuration];
            }
        }
            break;
        case CMD_GET_currentPlayStyle_R:    // 播放模式
        {
            self.playType = [self getValueDic:tempDic CMD:cmd];
            
            NSLog(@"获取播放模式 : %d", self.playType);
        }
            break;
        case CMD_GET_currentDuration_R:     // 播放总时长
        {

            self.playDuration = [self getValueDic:tempDic CMD:cmd];
            
            NSLog(@"获取播放总时长 : %d", self.playDuration);
        }
            break;
        case CMD_GET_current_musicInfo_R:   // 音乐信息
        {
            self.playInfo = (NSDictionary *)[self getObjDic:tempDic CMD:cmd];
            
            NSLog(@"获取音乐信息 : %@", self.playInfo);
            
        }
            break;
        case CMD_NOT_controlPlay:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:0.1];
                [self.vPlayer VPGetPlayMusicInfo];
            });
            NSLog(@"通知 -- 歌曲下标 : %d", [self getValueDic:tempDic CMD:cmd]);
        }
            break;
        case CMD_GET_playAlbum_R:
        {
            NSLog(@"播放列表RRRR");
            
            [self.playAlbum removeAllObjects];
            
            [self.playAlbum addObjectsFromArray:self.cmdConfig.playAlbum];
        }
            break;
            
            
        default:
            break;
    }
}

- (int)getValueDic:(NSDictionary *)dic CMD:(int)cmd {
    
    return [[dic objectForKey:[NSString stringWithFormat:@"%d", cmd]] intValue];
}

- (id)getObjDic:(NSDictionary *)dic CMD:(int)cmd {
    
    return [dic objectForKey:[NSString stringWithFormat:@"%d", cmd]];
}

- (NSString *)getDuration:(int)duration {
    
    return [NSString stringWithFormat:@"%02d:%02d", (int)(duration / 60), (int)(duration % 60)];
}


-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context {
//_argusArray = @[@"playVolume", @"playStatu", @"playType", @"playProgress", @"playDuration", @"playInfo"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger index = [self.argusArray indexOfObject:keyPath];
        
        switch (index) {
            case 0:
            {
                self.volumeSlider.value = (float)self.playVolume;
            }
                break;
            case 1:
            {
                [self setImgToPlayBtn];
            }
                break;
            case 2:
            {
                [self setImgToCycleTypeBtn];
            }
                break;
            case 3:
            {
                [self configPlaySlider:self.playProgress isAdd:NO];
            }
                break;
            case 4:
            {
                self.playSlider.maximumValue = (float)self.playDuration;
                
                self.playTotalTime.text = [self getDuration:self.playDuration];
            }
                break;
            case 5:
            {
                [self setMusicInfoInView];
            }
                break;
//            case 6:
//            {
//                NSLog(@"播放列表返回 - 通知");
//            }
//                break;
//                
            default:
                break;
        }
    });
    
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CMDDATARETURN object:nil];
    
    for (NSString *aruStr in self.argusArray) {
        
        [self removeObserver:self forKeyPath:aruStr];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
