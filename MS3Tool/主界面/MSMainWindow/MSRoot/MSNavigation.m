//
//  MSNavigation.m
//  MS3Tool
//
//  Created by chao on 2016/12/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSNavigation.h"

#import "MSMainVC.h"




@interface MSNavigation ()

@end

@implementation MSNavigation

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = NO;
    
    self.navigationBar.barTintColor = WCDarkBlue;
    
    [self.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       
       NSForegroundColorAttributeName:WCWhite}];
    
    
    UIButton *backBtn = [WenChaoControl createButtonWithFrame:CGRectMake(0, 0, 40, 40) ImageName:@"naviBack" Target:self Action:@selector(backClick) Title:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    
}

-(void)backClick {
    
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
