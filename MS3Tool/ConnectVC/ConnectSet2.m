//
//  ConnectSet2.m
//  MS3Tool
//
//  Created by chao on 2017/2/9.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "ConnectSet2.h"

#import "latestCell.h"

#import "SmartUDPManager.h"



@interface ConnectSet2 () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentWifiLabel;

@property (weak, nonatomic) IBOutlet UITextField *ssidLabel;

@property (weak, nonatomic) IBOutlet UITextField *pswdLabel;

@property (weak, nonatomic) IBOutlet UIButton *showPswdBtn;

@property (weak, nonatomic) IBOutlet UIImageView *remberPswdImg;

@property (weak, nonatomic) IBOutlet UITableView *latestWifi;

@property (weak, nonatomic) IBOutlet UIButton *connectBtn;


@property (nonnull, nonatomic, copy) NSString *currentWifiStr;

@property (nonnull, nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) BOOL isRememberPswd;

@property (nonnull, nonatomic, strong) GCDAsyncSocketCommunicationManager *comManager;

@property (nonatomic, nonnull, strong) GCDConnectConfig *configManager;

@property (nonatomic, nullable, strong) SmartUDPManager *SmartUDP;

@end

@implementation ConnectSet2

#pragma mark - -- 生命周期函数
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCDarkBlue;
    
    [self setShowOrHidden];

    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
}
-(void)clickBack {
 
    if ([KVNProgress isVisible] == YES) {
        
        [KVNProgress dismiss];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadLocalData];
    
    [self resetView];

    self.comManager = [GCDAsyncSocketCommunicationManager sharedInstance];
    
    self.comManager = [GCDAsyncSocketCommunicationManager sharedInstance];
    
    self.configManager = [GCDConnectConfig sharedInstance];
    
    [self.configManager addObserver:self forKeyPath:@"connectProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"connectProgress"]) {
        
        if (self.configManager.connectProgress == CProgressShouldConnectSuccess) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self clickBack];
//                NSLog(@"连接成功，关闭提示框");
            });
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - -- 导入本地数据
- (void)loadLocalData {
    
    self.isRememberPswd = YES;
    
    [self setShowOrHidden];
}

#pragma mark - -- 重新设置 View
- (void)resetView {
    
    self.latestWifi.backgroundColor = WCClear;
    
    self.latestWifi.delegate = self;
    
    self.latestWifi.dataSource = self;
    
    self.latestWifi.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.latestWifi.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)setShowOrHidden {
    
    self.currentWifiStr = [CommonUtil getCurrentWIFISSID];
    
    self.dataArray = [CommonUtil getWifiTableInUserDefualt];
    
    if (self.currentWifiStr) {
        
        self.currentWifiLabel.hidden = NO;
        
        self.currentWifiLabel.text = [NSString stringWithFormat:@"当前连接WiFi: %@", self.currentWifiStr];
        
    } else {
        
        self.currentWifiLabel.hidden = YES;
    }
    
    
    if (self.dataArray.count) {
        
        self.latestWifi.hidden = NO;
        
    } else {
        
        self.latestWifi.hidden = YES;
    }
}


#pragma mark - -- 按钮点击事件
// 显示 或隐藏密码
- (IBAction)showPswdClick:(id)sender {
    
}

// 记住 或不记住密码
- (IBAction)remberPswdClick:(id)sender {
    
}

// 清空 WiFi列表
- (IBAction)delectClick:(id)sender {
    
    [CommonUtil deleteAllWifi];
    
    [self setShowOrHidden];
    
    [self.latestWifi reloadData];
}

// 连接
- (IBAction)connectClick:(id)sender {
    
    if (self.isRememberPswd) {
        
        [CommonUtil addWifiToWifiTableWithSSID:self.ssidLabel.text andPassword:self.pswdLabel.text];
    }
    
    [self setShowOrHidden];
    
    [self.latestWifi reloadData];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.ssidLabel.text forKey:@"wifiname"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[SmartUDPManager shareInstance] sendRouteInfoSSID:self.ssidLabel.text pswd:self.pswdLabel.text];
    
//    [CommonUtil addKVNToConnectOnView:self.view];
    [self addKVNToConnect];
    
    [KVNProgress showWithStatus:@"正在连接网络" onView:self.view];
}

-(void)addKVNToConnect {
    
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    configuration.statusColor = [UIColor whiteColor];
    
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    
    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    
    configuration.backgroundTintColor = [UIColor colorWithRed:6 / 255.0 green:71 / 255.0 blue:69 / 255.0 alpha:1];
    
    configuration.successColor = [UIColor whiteColor];
    
    configuration.errorColor = [UIColor redColor];
    
    configuration.stopColor = [UIColor whiteColor];
    
    configuration.circleSize = 100.0f;
    
    configuration.lineWidth = 1.0f;
    
    configuration.fullScreen = YES;
    
    configuration.showStop = YES;
    
    configuration.stopRelativeHeight = 0.4f;
    
    [KVNProgress setConfiguration:configuration];
}



#pragma mark - -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    latestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latestCellID"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"latestCell" owner:self options:nil] firstObject];
        
        __weak typeof(&*self) sself = self;
        
        cell.selectBlock = ^(NSString *wifiStr) {
            
            [sself selectClick:wifiStr];
        };
    }
    
    if (self.dataArray) {
        
        NSDictionary *dic = self.dataArray[indexPath.row];
        
        [cell config:[[dic allKeys] firstObject]];
    }
    
    return cell;
}


- (void)selectClick:(NSString *)wifiStr {
    
    for (NSDictionary *dic in self.dataArray) {
        
        if ([[[dic allKeys] firstObject] isEqualToString:wifiStr]) {
            
            self.ssidLabel.text = [[dic allKeys] firstObject];
            
            self.pswdLabel.text = [dic objectForKey:self.ssidLabel.text];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.SmartUDP stopUdpTimer];
}

@end
