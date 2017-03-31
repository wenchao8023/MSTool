//
//  MusicFooterView.m
//  MS3Tool
//
//  Created by chao on 2016/11/21.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MusicFooterView.h"

#import "FooterViewModel.h"

#import "MSMusicModel.h"




@interface MusicFooterView ()<UIScrollViewDelegate>{
    double pausedTime;
}


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *lircLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIButton *listButton;

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (nonatomic, assign) CGAffineTransform originTransform;


@property (nonatomic, assign) int playStatu;

@end

@implementation MusicFooterView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MusicFooterView" owner:self options:nil] firstObject];
        
        self.frame = frame;
        
        [self initDataContainer];
        
        [self createUI];
    }
    
    return self;
}

-(void)createUI {
    
    self.iconImageView.layer.cornerRadius = (HEIGHT_FOOTERVIEW - 10) / 2;
    
    self.iconImageView.layer.masksToBounds = YES;
    
    [self setImgToPlayBtn];
    
    [self rotateIconImage];
}

// 初始化数据容器
-(void)initDataContainer {
    
    [self addNotifycation];
}


#pragma mark - 核心动画实现图片旋转
// 给iconImage添加动画
-(void)rotateIconImage {
    
    self.iconImageView.transform = self.originTransform;
    
    [self.iconImageView imageDrawRect];
    
    [self.iconImageView.layer addAnimation:[self rotate360DegreeImage] forKey:@"ROTATEICONIMAGE"];
}

// 暂停动画
-(void)pauseRotate {
    
    // 获取当前暂停时间
    pausedTime = [self.iconImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 层的速度为0，停止动画
    self.iconImageView.layer.speed = 0;
    
    // 保存暂停时间，便于恢复
    self.iconImageView.layer.timeOffset = pausedTime;
}

// 恢复动画
-(void)resumRotate {
    
    // 设置速度
    self.iconImageView.layer.speed = 1.0;
    
    // 清楚开始时间
    self.iconImageView.layer.beginTime = 0.0;
    
    // 计算开始时间
    CFTimeInterval beginTime = [self.iconImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    
    // 重设开始时间
    self.iconImageView.layer.beginTime = beginTime;
}

// 创建动画
-(CABasicAnimation *)rotate360DegreeImage {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    [animation rotate360DegreeWithDuration:5];
    
    return animation;
}


#pragma mark - click actions
// xib中隐藏的那个滑动视图的图标点击事件
- (IBAction)iconImageViewClick:(id)sender {
    
    self.goMusicVC();
}

- (IBAction)playButtonClick:(id)sender {
    NSLog(@"点击播放按钮");
    
    [self setPlayStatuToNext];
    
    if (self.playStatu == 2 ||
        self.playStatu == 4)
        [[VoicePlayer shareInstace] VPause];
    else
        [[VoicePlayer shareInstace] VPlay];
    
    [self setImgToPlayBtn];
}

- (IBAction)listButtonClick:(id)sender {
    NSLog(@"点击歌单按钮");
    
    self.goAlbumView();
}

#pragma mark - 设置播放按钮
-(void)setPlayStatuToNext {
    
    self.playStatu = self.playStatu == 3 ? 4 : 3;
}

- (void)setImgToPlayBtn {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (self.playStatu == 2 ||
            self.playStatu == 4) {  // 播放
            
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"bottompause"] forState:UIControlStateNormal];
            
             [self resumRotate];
            
            [[VoicePlayer shareInstace] VPGetCurrentProgressIsLastFiveSeconds:YES];
            
        } else {    // 暂停
            
            [self.playButton setBackgroundImage:[UIImage imageNamed:@"bottomplay"] forState:UIControlStateNormal];
            
//            [self pauseRotate];
            [self resumRotate];
            
            [[VoicePlayer shareInstace] VPGetCurrentProgress_Stop];
        }
    });
}

#pragma mark - addNotifycation
-(void)addNotifycation {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCMDData) name:NOTIFY_CMDDATARETURN object:nil];
}

- (void)getCMDData {
    
    int cmd = [CMDDataConfig shareInstance].getCMD;
    
    if (cmd == CMD_GET_current_musicInfo_R) {
        [self configViews];
        
    } else if (cmd == CMD_GET_PLAYSTATE_R ||
               cmd == CMD_NOT_controlStatus) {
        self.playStatu = [[CMDDataConfig shareInstance] getValueWithCMD:cmd];
        
        [self setImgToPlayBtn];
    }
}
-(void)configViews {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *infoDic = [[CMDDataConfig shareInstance] getObjDicWithCMD:CMD_GET_current_musicInfo_R];
        
        self.titleLabel.text = [infoDic objectForKey:@"musicName"];
        
        if ([[infoDic objectForKey:@"albumsName"] length])
            self.lircLabel.text = [NSString stringWithFormat:@"%@ - %@", [infoDic objectForKey:@"artistsName"], [infoDic objectForKey:@"albumsName"]];
        else
            self.lircLabel.text = [infoDic objectForKey:@"artistsName"];
        
        if ([[infoDic objectForKey:@"musicImgUrl"] length]) {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"musicImgUrl"]]
                                  placeholderImage:[UIImage imageNamed:@"playDefualtImg"]];
        } else {
            self.iconImageView.image = [UIImage imageNamed:@"playDefualtImg"];
        }
        
    });
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CMDDATARETURN object:nil];
}


#if 0
- (void)createUI {
    /**
     *  hide subViews from xib
     */
    self.iconImageView.hidden = YES;
    
    self.titleLabel.hidden = YES;
    
    self.lircLabel.hidden = YES;
    
    self.lineLabel.backgroundColor = WCDarkBlue;
    
    CGFloat scWidth = self.frame.size.width - 90;
    
    CGFloat scHeight = self.frame.size.height;
    
    self.bgScrollView.contentOffset = CGPointMake(scWidth, 0);
    
    self.bgScrollView.contentSize = CGSizeMake(scWidth * 3, scHeight);
    
    self.bgScrollView.pagingEnabled = YES;
    
    self.bgScrollView.bounces = NO;
    
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    
    self.bgScrollView.directionalLockEnabled = YES;
    
    self.bgScrollView.backgroundColor = WCClear;
    
    self.bgScrollView.delegate = self;
    
    for (UIView *subView in self.bgScrollView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconIVClick:)];
    
    [self.bgScrollView addGestureRecognizer:gesture];
    
    for (int i = 0; i < 3; i++) {
        
        UIImageView *iconIV = [WenChaoControl createImageViewWithFrame:CGRectMake(10 + scWidth * i, 5, scHeight - 10, scHeight - 10) ImageName:nil];
        
        iconIV.tag = 345 + i;
        
        iconIV.layer.cornerRadius = (scHeight - 10) / 2;
        
        iconIV.layer.masksToBounds = YES;
        
        iconIV.userInteractionEnabled = YES;
        
        iconIV.backgroundColor = WCClear;
        
        if (i == 1) {
            
            self.iconImage = iconIV;
            
            [self.bgScrollView addSubview:self.iconImage];
            
            self.originTransform = iconIV.transform;
            
        } else {
            
            [self.bgScrollView addSubview:iconIV];
        }
        
        
        CGFloat xInSc = 10 + iconIV.frame.size.width + 10;
        
        UILabel *titleLabel = [WenChaoControl createLabelWithFrame:CGRectMake(xInSc + scWidth * i, 5, scWidth - xInSc, 20) Font:15 Text:nil textAlignment:0];
        
        titleLabel.textColor = WCWhite;
        
        titleLabel.tag = 355 + i;
        
        titleLabel.backgroundColor = WCClear;
        
        [self.bgScrollView addSubview:titleLabel];
        
        UILabel *lircLabel = [WenChaoControl createLabelWithFrame:CGRectMake(xInSc + scWidth * i, CGRectGetMaxY(titleLabel.frame) + 5, scWidth - xInSc, 15) Font:13 Text:nil textAlignment:0];
        
        lircLabel.textColor = WCWhite;
        
        lircLabel.tag = 365 + i;
        
        lircLabel.backgroundColor = WCClear;
        
        [self.bgScrollView addSubview:lircLabel];
    }
    
    [self resetSubviews];
    
    [self setPlayButtonImage];
    
    [self rotateIconImage];
    
    [self setRotate];
}

-(void)resetSubviews {
    
    MSMusicPlayerConfig *config = [MSMusicPlayerConfig sharedInstance];
    
    if (config.playAlbum.count != 0) {
        for (int i = -1; i < 2; i++) {
            
            MSMusicModel *model;
            
            if (config.playIndex == 0 && i == -1) {
                
                model = [config.playAlbum lastObject];
                
            } else if (config.playIndex == config.playAlbum.count - 1 && i == 1){
                
                model = [config.playAlbum firstObject];
                
            } else {
                
                model = config.playAlbum[i + config.playIndex];
            }
            
            if (i == 0) {
                
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImgSmall] placeholderImage:[UIImage imageNamed:@"playDefualtImg"]];
                
            } else {
                
                UIImageView *iconV = (UIImageView *)[self viewWithTag:(345 + i + 1)];
                
                [iconV sd_setImageWithURL:[NSURL URLWithString:model.coverImgSmall]];
            }
            
            UILabel *titleLabel = [self viewWithTag:(355 + i + 1)];
            
            titleLabel.text = model.songName;
            
            UILabel *lircLabel = [self viewWithTag:(365 + i + 1)];
            
            lircLabel.text = model.singerName;
        }
    }
}

-(void)setPlayButtonImage {
    
    if ([MSMusicPlayerConfig sharedInstance].playStatus == 1) {
        
        [self.playButton setImage:[UIImage imageNamed:@"playPause39"] forState:UIControlStateNormal];
        
    } else if ([MSMusicPlayerConfig sharedInstance].playStatus == 0) {
        
        [self.playButton setImage:[UIImage imageNamed:@"play_music"] forState:UIControlStateNormal];
    }
}

// 设置动画
-(void)setRotate {
    MSMusicPlayerConfig *config = [MSMusicPlayerConfig sharedInstance];
    
    if (config.playStatus == 1) {
        
        [self resumRotate];
        
    } else {
        
        [self pauseRotate];
    }
}

- (void)iconIVClick:(UITapGestureRecognizer *)gesture {
    
    NSLog(@"点击专辑图标");
    
    UIView *iV = gesture.view;
    
    NSLog(@"tag of iconImageView: %ld", (long)iV.tag);
    
    self.goMusicVC();
}
#endif
@end




