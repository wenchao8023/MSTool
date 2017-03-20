//
//  MusicFooterView.m
//  MS3Tool
//
//  Created by chao on 2016/11/21.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MusicFooterView.h"

#import "MSMusicPlayerConfig.h"

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


@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, assign) CGAffineTransform originTransform;




/**
 *  如果没有歌单传过来，那么数组里面是空的
 *  如果有歌单的时候，数组中至少要有三个元素
 *  歌单 == 一首歌，数组中三个相同元素
 *  歌单 == 两首歌，数组首尾元素相同，中间是正在播放的那首
 *  歌单 == 三首歌，按顺序添加，并循环
 *  歌单  > 三首歌，按模式循环
 */
@property (nonatomic, strong) NSMutableArray *musicArray;

/**
 *  显示当前播放的音乐在数组中的下标
 *  数组为空的时候，musicIndex = 0
 *  数组不为空的时，musicIndex 初始值为 1
 */
@property (nonatomic, assign) NSInteger musicIndex;

/**
 *  为1  下一曲
 *  为-1 上一曲
 */
@property (nonatomic, assign) NSInteger swipeType;

@end

@implementation MusicFooterView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MusicFooterView" owner:self options:nil] firstObject];
        
        self.frame = frame;
        
//        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        
        [self initDataContainer];
        
        [self createUI];
    }
    
    return self;
}

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

// 初始化数据容器
-(void)initDataContainer {
    
    self.musicArray = [NSMutableArray arrayWithCapacity:0];
    
    self.musicIndex = 1;
    
    self.swipeType = 1;
    
    
    [self addNotifycation];
}


#pragma mark - 核心动画实现图片旋转
// 给iconImage添加动画
-(void)rotateIconImage {
    
    self.iconImage.transform = self.originTransform;
    
    [self.iconImage imageDrawRect];
    
    [self.iconImage.layer addAnimation:[self rotate360DegreeImage] forKey:@"ROTATEICONIMAGE"];
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

// 暂停动画
-(void)pauseRotate {
    
    // 获取当前暂停时间
    pausedTime = [self.iconImage.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 层的速度为0，停止动画
    self.iconImage.layer.speed = 0;
    
    // 保存暂停时间，便于恢复
    self.iconImage.layer.timeOffset = pausedTime;
}

// 恢复动画
-(void)resumRotate {
    
    // 设置速度
    self.iconImage.layer.speed = 1.0;
    
    // 清楚开始时间
    self.iconImage.layer.beginTime = 0.0;
    
    // 计算开始时间
    CFTimeInterval beginTime = [self.iconImage.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    
    // 重设开始时间
    self.iconImage.layer.beginTime = beginTime;
}

// 创建动画
-(CABasicAnimation *)rotate360DegreeImage {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    [animation rotate360DegreeWithDuration:5];
    
    return animation;
}

#pragma mark - 给视图导入数据
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
                
                [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.coverImgSmall] placeholderImage:[UIImage imageNamed:@"playDefualtImg"]];
                
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
        
        [self.playButton setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
        
    } else if ([MSMusicPlayerConfig sharedInstance].playStatus == 0) {
        
        [self.playButton setImage:[UIImage imageNamed:@"play_music"] forState:UIControlStateNormal];
    }
}

#pragma mark - click actions
- (void)iconIVClick:(UITapGestureRecognizer *)gesture {
    
    NSLog(@"点击专辑图标");
    
    UIView *iV = gesture.view;
    
    NSLog(@"tag of iconImageView: %ld", (long)iV.tag);
    
    self.goMusicVC();
}
// xib中隐藏的那个滑动视图的图标点击事件
- (IBAction)iconImageViewClick:(id)sender {
    
}

- (IBAction)playButtonClick:(id)sender {
    NSLog(@"点击播放按钮");
    
}

- (IBAction)listButtonClick:(id)sender {
    NSLog(@"点击歌单按钮");
    
    self.goAlbumView();
}


#pragma mark - addNotifycation
-(void)addNotifycation {
    
    NSOperationQueue *obq = [NSOperationQueue currentQueue];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_PLAYSTATUS object:nil queue:obq usingBlock:^(NSNotification * _Nonnull note) {
   
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setPlayButtonImage];
            
            [self setRotate];
            
            [self resetSubviews];
        });
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PLAYSTATUS object:nil];
    }];
}

#pragma mark - UIScrollViewDelegate
// 处理滑动切歌时的逻辑
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

//    CGFloat scWidth = self.frame.size.width - 90;
//    
//    // 表示已经滑动完成 -- 换页了
//    if (scrollView.contentOffset.x != scWidth) {
//        //  表示向右滑 - 上一曲
//        if (scrollView.contentOffset.x == 0)
//        {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                
//                [self.musicPlayer playLastSong];
//            });
//        }
//        //  表示向左滑 - 下一曲
//        if (scrollView.contentOffset.x == 2 * scWidth)
//        {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                
//                [self.musicPlayer playNextSongWithClick:YES];
//            });
//        }
//    }
//    
//    [self.bgScrollView setContentOffset:CGPointMake(scWidth, 0)];
//    
//    [self setPlayButtonImage];
//}
@end




