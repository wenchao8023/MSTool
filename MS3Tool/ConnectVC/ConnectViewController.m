//
//  ConnectViewController.m
//  MS3Tool
//
//  Created by chao on 2016/10/27.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "ConnectViewController.h"

#import "VoiceBoxType.h"

//#import "ConnectSetter1_VC.h"

#import "ConnectSet2.h"





typedef enum _NAVI_BUTTON_TAG {
    TAG_LEFT_BUTTON = 120,
    TAG_RIGHT_BUTTON
}NAVI_BUTTON_TAG;

@implementation ConnectViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCDarkBlue;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"准备联网";
    
    [[MSFooterManager shareManager] setWindowHidden];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
}
-(void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void)createUI {
    
    NSString *str = @"长按 play 键\n听到提示音后点击【下一步】";
    
    UILabel *tipLabel = [WenChaoControl createLabelWithFrame:CGRectMake(20, 200, WIDTH - 40, 100) Font:16 Text:str textAlignment:1];
    
    tipLabel.backgroundColor = WCClear;
    
    tipLabel.textColor = WCWhite;
    
    [self.view addSubview:tipLabel];
    
    
    UIButton *nextBtn = [WenChaoControl createButtonWithFrame:CGRectMake(60, SCREENH - 200, SCREENW - 120, 40) ImageName:nil Target:self Action:@selector(nextClick) Title:@"下一步"];
    
    nextBtn.titleLabel.textColor = [UIColor whiteColor];
    
    nextBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    nextBtn.layer.borderWidth = 0.8;
    
    nextBtn.layer.cornerRadius = 20;
    
    [self.view addSubview:nextBtn];
    
}

#pragma mark - actions
- (void) nextClick {
    
    [self.navigationController pushViewController:[[ConnectSet2 alloc] init] animated:YES];
}

-(void)btnClick:(UIButton *)btn {
    switch (btn.tag) {
        case TAG_LEFT_BUTTON:
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil]; 
        }
            break;
        case TAG_RIGHT_BUTTON:
        {
            NSLog(@"二维码扫描");
        }
            break;
            
        default:
            break;
    }
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
