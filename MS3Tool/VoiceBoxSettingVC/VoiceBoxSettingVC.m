//
//  VoiceBoxSettingVC.m
//  MS3Tool
//
//  Created by chao on 2016/11/1.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "VoiceBoxSettingVC.h"


#define SELF_HEIGHT (SCREENH - NAVIGATIONBAR_HEIGHT)


@interface VoiceBoxSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation VoiceBoxSettingVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = VIEW_BACKGROUNDCOLOR;
    self.navigationItem.title = @"音箱设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    [self createUI];
}
-(void)loadData {
    
    _dataArray = @[@"昵称",@"网络连接", @"音箱版本", @"音箱序列号"];
}
-(void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SELF_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = WCClear;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray) {
        return [_dataArray count];
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *userCellId = @"VOICEBOXSETTING";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCellId];
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.textLabel.textColor = WCWhite;
        cell.backgroundColor = WCClear;
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SELF_HEIGHT / 2)];
        
        bgView.userInteractionEnabled = YES;
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lt.jpg"]];
        imageV.frame = CGRectMake(0, 0, SCREENW, SELF_HEIGHT / 2);
        imageV.alpha = 1;
        imageV.userInteractionEnabled = YES;
        [bgView addSubview:imageV];
        
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        backBtn.frame = CGRectMake(10, 20, 50, 50);
//        backBtn.tag = 150;
//        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bgView addSubview:backBtn];
        
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, SCREENW - 120, 50)];
//        titleLabel.text = @"音箱设置";
//        titleLabel.textAlignment = 1;
//        titleLabel.font = [UIFont systemFontOfSize:16];
//        titleLabel.textColor = [UIColor blackColor];
//        [bgView addSubview:titleLabel];
    
        
        return bgView;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 120)];
        
        bgView.userInteractionEnabled = YES;
        
        UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        resetBtn.frame = CGRectMake(0, 20, SCREENW, 50);
        [resetBtn setTitle:@"还原所有设置" forState:UIControlStateNormal];
        resetBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
        resetBtn.tag = 155;
        [resetBtn setTitleColor:WCWhite forState:UIControlStateNormal];
        [resetBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:resetBtn];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(resetBtn.frame) + 10, SCREENW - 40, 40)];
        descLabel.text = @"还原出厂设置，音箱将恢复出厂状态，抹掉所有账户内容及网络设置，不可找回，请慎用！";
        descLabel.numberOfLines = 2;
        descLabel.textColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.8];
        descLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:descLabel];
        
        return bgView;
    }
   
    return nil;
}
-(void)clickBtn:(UIButton *)btn {
    switch (btn.tag) {
        case 150:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 155:
        {
            NSLog(@"还原出厂设置");
        }
            break;
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SELF_HEIGHT / 2;
    }
    
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 120;
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
