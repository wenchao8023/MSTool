//
//  MSMusicPlayVC1.m
//  MS3Tool
//
//  Created by chao on 2017/3/1.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "MSMusicPlayVC1.h"

#import "MSMusicPlayViewController.h"


static NSInteger kBgimageVWidth;

@interface MSMusicPlayVC1 ()


@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIButton *lastButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UILabel *songLabel;

@property (weak, nonatomic) IBOutlet UILabel *lircLabel;



@end

@implementation MSMusicPlayVC1

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[MSFooterManager shareManager] setWindowHidden];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    kBgimageVWidth = WIDTH - 44;
    
    [self resetView];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:swipe];
}

- (void)leftSwipe {
    
    MSMusicPlayViewController *vc = [[MSMusicPlayViewController alloc] init];
    
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)resetView {
    
    [self addLayerToView:self.backButton];
    [self addLayerToView:self.rightButton];
    [self addLayerToView:self.playButton];
    [self addLayerToView:self.lastButton];
    [self addLayerToView:self.nextButton];
    [self addLayerToView:self.bgImageV];
    [self addLayerToView:self.infoView];
    [self addLayerToView:self.songLabel];
    [self addLayerToView:self.lircLabel];
    
    self.bgImageV.layer.cornerRadius = kBgimageVWidth / 2;
    
}

- (void)addLayerToView:(UIView *)originView {
    
    originView.layer.borderWidth = 1.0;
    
    originView.layer.borderColor = WCLightGray.CGColor;
    
    originView.layer.masksToBounds = YES;
}



- (IBAction)backClick:(id)sender {
    
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rightClick:(id)sender {
    
    NSLog(@"有按钮");
}

- (IBAction)playClick:(id)sender {
    
    NSLog(@"播放、暂停");
}

- (IBAction)lastClick:(id)sender {
    
    NSLog(@"上一首");
}

- (IBAction)nextClick:(id)sender {
    
    NSLog(@"下一首");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
