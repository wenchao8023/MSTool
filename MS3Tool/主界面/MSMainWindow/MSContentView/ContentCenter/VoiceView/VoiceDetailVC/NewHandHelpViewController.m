
//
//  NewHandHelpViewController.m
//  MS3Tool
//
//  Created by chao on 2017/3/13.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "NewHandHelpViewController.h"

@interface NewHandHelpViewController ()

@end

@implementation NewHandHelpViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WCBgGray;
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"我是新手，还没有提供帮助T_T";
    
    self.navigationItem.leftBarButtonItem = [WenChaoControl createNaviBackButtonTarget:self Action:@selector(clickBack)];
    
}
-(void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
