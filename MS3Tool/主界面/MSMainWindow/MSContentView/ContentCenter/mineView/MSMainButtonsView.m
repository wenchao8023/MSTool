
//
//  MSMainButtonsView.m
//  MS3Tool
//
//  Created by chao on 2016/12/15.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMainButtonsView.h"






@interface MSMainButtonsView ()

@end


@implementation MSMainButtonsView

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MSMainButtonsView" owner:self options:nil] firstObject];
        
        self.frame = frame;
        
        self.backgroundColor = WCRed;
    }
    
    return self;
}





- (IBAction)myLoveClick:(id)sender {
    NSLog(@"我喜欢");

    self.buttonsClickBlock(myLoveClickTag);
}

- (IBAction)latestClick:(id)sender {
    
    NSLog(@"最近播放");

    self.buttonsClickBlock(latestClickTag);
}


- (IBAction)smartHomeClick:(id)sender {
    
    NSLog(@"音箱");

    self.buttonsClickBlock(smarthomeClickTag);
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
