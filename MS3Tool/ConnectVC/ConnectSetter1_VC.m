//
//  ConnectSetter1_VC.m
//  MS3Tool
//
//  Created by chao on 2016/10/27.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "ConnectSetter1_VC.h"

#import "ConnectSet2.h"




@implementation ConnectSetter1_VC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"配置网络";
    
    self.view.backgroundColor = WCDarkBlue;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       
       NSForegroundColorAttributeName:WCWhite}];
    
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

#pragma mark - 创建UI
-(void)createUI {
    
    NSString *str = @"前往 iPhone 的 WiFi设置\n选择 SmartAudio - ****** 并连接\n密码是 - 后面的字符串\n然后返回 MS3 音箱App";
    
    UILabel *tipLabel = [WenChaoControl createLabelWithFrame:CGRectMake(20, 200, WIDTH - 40, 100) Font:16 Text:str textAlignment:1];
    
    tipLabel.backgroundColor = WCClear;
    
    tipLabel.textColor = WCWhite;
    
    [self.view addSubview:tipLabel];
    
    
    UIButton *goBtn = [WenChaoControl createButtonWithFrame:CGRectMake(60, SCREENH - 250, SCREENW - 120, 40) ImageName:nil Target:self Action:@selector(clickToWifiTable) Title:@"去连接"];
    
    goBtn.titleLabel.textColor = [UIColor whiteColor];
    
    goBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    goBtn.layer.borderWidth = 0.8;
    
    goBtn.layer.cornerRadius = 20;
    
    [self.view addSubview:goBtn];
    
    
    UIButton *nextBtn = [WenChaoControl createButtonWithFrame:CGRectMake(60, SCREENH - 200, SCREENW - 120, 40) ImageName:nil Target:self Action:@selector(btnClick) Title:@"下一步"];
    
    nextBtn.titleLabel.textColor = [UIColor whiteColor];
    
    nextBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    nextBtn.layer.borderWidth = 0.8;
    
    nextBtn.layer.cornerRadius = 20;
    
    [self.view addSubview:nextBtn];
}



#pragma mark - actions
-(void)btnClick {
    
    [self.navigationController pushViewController:[[ConnectSet2 alloc] init] animated:YES];
}
//  跳转到WiFi列表设置WiFi
-(void)clickToWifiTable {
    
    [CommonUtil switchToWifiTable];
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
