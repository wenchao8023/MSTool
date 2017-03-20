//
//  UserFooterview.m
//  MS3Tool
//
//  Created by chao on 2016/11/1.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "UserFooterview.h"

@implementation UserFooterview

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UserFooterview" owner:self options:nil] firstObject];
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (IBAction)registClick:(id)sender {
    NSLog(@"退出当前账号");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
