//
//  MSVoicecommandViewController.m
//  MS3Tool
//
//  Created by chao on 2017/3/10.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "MSVoicecommandViewController.h"

@interface MSVoicecommandViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong, nonnull) UITableView *tableView;

@property (nonatomic, strong, nonnull) NSArray *dataArray;

@property (nonatomic, copy, nonnull) NSString *descString;


@end

@implementation MSVoicecommandViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCBgGray;
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"语音指令大全";
    
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
        
        _dataArray = @[@"音箱操控", @"点播音乐", @"点播网络电台", @"点播新闻", @"点播FM广播", @"查询天气", @"查询股价", @"综合查询", @"翻译服务", @"生活服务", @"百科知识"];
    }
    
    return _dataArray;
}

-(NSString *)descString {
    
    if (!_descString) {
        
        _descString = @"按下音箱顶部的“声音键”， 听到提示音后，接着再说出语音指令";
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
    
    self.tableView.backgroundColor = WCClear;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellid = @"VoicecommandTableViewCellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellid];
    
    
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellid];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@", indexPath.row + 1, self.dataArray[indexPath.row]];
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [WenChaoControl viewWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    
    headView.backgroundColor = WCClear;
    
    
    UILabel *descLabel = [WenChaoControl createLabelWithFrame:CGRectMake(10, 10, WIDTH - 20, 60) Font:16 Text:self.descString textAlignment:0];
    
    descLabel.numberOfLines = 0;
    
    descLabel.backgroundColor = WCClear;
    
    
    [headView addSubview:descLabel];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 80.f;
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
