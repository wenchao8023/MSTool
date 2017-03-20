//
//  VoiceCommandsVC.m
//  MS3Tool
//
//  Created by chao on 2016/11/1.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "VoiceCommandsVC.h"

#define SELF_HEIGHT (SCREENH - NAVIGATIONBAR_HEIGHT)



@interface VoiceCommandsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation VoiceCommandsVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"语音指令大全";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = VIEW_BACKGROUNDCOLOR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = @[@"1、音箱操控", @"2、点播音乐", @"3、点播网络电视节目", @"4、点播新闻", @"5、点播FM广播", @"6、查询天气", @"7、综合查询", @"8、翻译服务", @"9、生活服务", @"10、百科知识"];
    
    [self createUI];
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
        return _dataArray.count;
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *userCellId = @"VOICECOMMANDSCELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCellId];
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.textLabel.textColor = WCWhite;
        cell.backgroundColor = WCClear;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return cell;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH / 2)];
//        bgView.userInteractionEnabled = YES;
//        bgView.backgroundColor = [UIColor cyanColor];
//        
////        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////        backBtn.frame = CGRectMake(10, 20, 40, 40);
////        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
////        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [backBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
////        [bgView addSubview:backBtn];
//        
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, SCREENW - 120, 50)];
//        titleLabel.text = @"语音指令大全";
//        titleLabel.textAlignment = 1;
//        titleLabel.font = [UIFont systemFontOfSize:16];
//        titleLabel.textColor = [UIColor blackColor];
//        [bgView addSubview:titleLabel];
//        
//        return bgView;
//    }
//    
//    return nil;
//}

-(void)clickBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 80;
//    }
    
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == _dataArray.count - 1) {
//        return 150;
//    }
    
    return 0.1;
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
