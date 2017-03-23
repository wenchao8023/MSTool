//
//  MSVoiceSettingViewController.m
//  MS3Tool
//
//  Created by chao on 2017/3/10.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "MSVoiceSettingViewController.h"

#import "VoiceSettingCell.h"




@interface MSVoiceSettingViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong, nonnull) UITableView *tableView;

@property (nonatomic, strong, nonnull) NSArray *dataArray;

@property (nonatomic, copy, nonnull) NSString *descString;

//@property (nonatomic, copy, nonnull) GCDAsyncSocketCommunicationManager *comManager;

@end

@implementation MSVoiceSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCBgGray;
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"音箱设置";
    
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
-(NSArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = @[@"昵称", @"网络连接", @"音箱版本", @"序列号"];
    }
    
    return _dataArray;
}

-(NSString *)descString {
    
    if (!_descString) {
        
        _descString = @"还原所有设置，音箱将恢复出厂状态，抹掉所有账户内容及网络设置，不可找回，请慎用！！！";
    }
    
    return _descString;
}
#pragma mark - 创建界面
-(void)createUI {
    
    CGRect frame = self.view.frame;
    
    frame.size.height -= NAVIGATIONBAR_HEIGHT;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT -  NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundColor = WCClear;
    
    [self.view addSubview:self.tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VoiceSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoiceSettingCellID"];
    
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoiceSettingCell" owner:self options:nil] firstObject];
    }
    
    [cell config:self.dataArray[indexPath.row] subTitle:@""];
    
    
    return cell;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [WenChaoControl viewWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    
    footerView.backgroundColor = WCClear;
    
    
    UIButton *resetBtn = [WenChaoControl createButtonWithFrame:CGRectMake(0, 20, WIDTH, 40) ImageName:nil Target:self Action:@selector(resetClick) Title:@"还原出厂设置"];
    
    resetBtn.backgroundColor = WCWhite;
    
    [footerView addSubview:resetBtn];
    
    
    UILabel *descLabel = [WenChaoControl createLabelWithFrame:CGRectMake(20, 70, WIDTH - 40, 50) Font:14 Text:self.descString textAlignment:0];
    
    descLabel.numberOfLines = 0;
    
    descLabel.backgroundColor = WCClear;
    
    descLabel.textColor = WCDarkGray;
    
    [footerView addSubview:descLabel];
    
    
    return footerView;
}

-(void)resetClick {
    
    NSData *data = [[MSConnectManager sharedInstance].dataManager getGetReturnHeadDataWithCMD:CMD_SET_resetFactory];
    
    [[MSConnectManager sharedInstance] tcpWriteDataWithData:data andTag:0];
    
    NSLog(@"还原出厂设置");
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 120.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
