//
//  MSPanScroll.m
//  MS3Tool
//
//  Created by chao on 2017/2/23.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "MSPanScroll.h"



@implementation MSPanScroll

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.pagingEnabled = YES;
        
        self.bounces = NO;
        
        self.directionalLockEnabled = YES;
        
        self.backgroundColor = WCWhite;
        
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
