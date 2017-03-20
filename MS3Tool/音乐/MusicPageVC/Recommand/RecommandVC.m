//
//  RecommandVC.m
//  sdkTest
//
//  Created by chao on 2016/11/4.
//  Copyright © 2016年 nali. All rights reserved.
//

#import "RecommandVC.h"
#import "XMDataManager.h"
#import "XMSDK.h"

@interface RecommandVC ()

@property (nonatomic, strong) XMDataManager *dataManager;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RecommandVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Recommand"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData];
    });
    
    [self createUI];
}
- (void)loadData {
    
}

- (void)createUI {
    [self createHeadView];
}
- (void)createHeadView {
    
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
