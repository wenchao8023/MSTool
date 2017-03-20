//
//  BroadCastView.m
//  MS3Tool
//
//  Created by chao on 2016/11/8.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "BroadCastView.h"


@implementation BroadCastView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"BroadCastView" owner:self options:nil] firstObject];
        
        self.frame = frame;
    }
    
    return self;
}

- (IBAction)benDiTaiClick:(id)sender {
    NSLog(@"本地台");
    self.clickBlock(220);
}

- (IBAction)guoJiaTaiClick:(id)sender {
    NSLog(@"国家台");
    self.clickBlock(221);
}

- (IBAction)shengShiTaiClick:(id)sender {
    NSLog(@"省市台");
    self.clickBlock(222);
}

- (IBAction)wangLuoTaiClick:(id)sender {
    NSLog(@"网络台");
    self.clickBlock(223);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
