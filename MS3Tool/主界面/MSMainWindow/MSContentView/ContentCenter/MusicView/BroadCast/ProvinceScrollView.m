//
//  ProvinceScrollView.m
//  MS3Tool
//
//  Created by chao on 2016/11/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "ProvinceScrollView.h"


#define intervalWidth (WIDTH - 60) / 5

static NSInteger const kFirstButtonTag = 300;


@implementation ProvinceScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        
        self.backgroundColor = WCClear;
        
        self.selectedIndex = 0;
        
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW - 60, 40)];
    
    self.scrollView.backgroundColor = WCBgGray;
    
    [self addSubview:self.scrollView];

    [self addButtonsToScrollView];

    UILabel *lineLabel = [WenChaoControl createLabelWithFrame:CGRectMake(0, 39, SCREENW, 1) Font:0 Text:nil textAlignment:0];
    
    lineLabel.backgroundColor = WCLightGray;
    
    [self addSubview:lineLabel];

    self.selectedButton = [WenChaoControl createButtonWithFrame:CGRectMake(SCREENW - 60, 0, 40, 40) ImageName:nil Target:self Action:@selector(btnClick) Title:nil];
    
    [self.selectedButton setBackgroundImage:[UIImage imageNamed:@"backDownBlue"] forState:UIControlStateNormal];
    
    [self addSubview:self.selectedButton];
}

- (void)addButtonsToScrollView {
    
    
    // 设置按钮固定的宽度
    self.scrollView.contentSize = CGSizeMake(intervalWidth * self.buttonsArray.count, 40);
    
    for (int i = 0; i < self.buttonsArray.count; i++) {
        
        XMProvince *province = self.buttonsArray[i];
        
        UIButton *btn = [WenChaoControl createButtonWithFrame:CGRectMake(5 + intervalWidth * i, 5, intervalWidth - 10, 30) ImageName:nil Target:self Action:@selector(selectedClick:) Title:province.provinceName];
        
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        btn.layer.cornerRadius = 15;
        
        btn.tag = kFirstButtonTag + i;
        
        [btn setTitleColorWithColor:WCGray andText:btn.titleLabel.text];
        
        [btn setBackgroundColor:WCClear];
        
        [self.scrollView addSubview:btn];
    }
    
    [self setButtonsState];
}

- (NSDictionary *)getButtonWidthDic {
    
    CGFloat totalWidth = 0;
    
    NSMutableDictionary *widthDic = [NSMutableDictionary dictionary];
    
    NSMutableArray *originXArr = [NSMutableArray arrayWithCapacity:0];
    
    for (XMProvince *province in self.buttonsArray) {
        
        NSString *buttonTitle = province.provinceName;
        
        CGFloat width = buttonTitle.length * 30.0;
        
        [widthDic setObject:@(width) forKey:buttonTitle];
        
        [originXArr addObject:@(totalWidth)];
        
        totalWidth += width;
    }
    
    [widthDic setObject:@(totalWidth) forKey:@"totalWidth"];
    
    [widthDic setObject:originXArr forKey:@"originXArr"];
    
    return (NSDictionary *)widthDic;
}

- (void)btnClick {
    
    NSLog(@"开放吧，骚年");
    
    self.hidSelfBlock();
}

- (void)selectedClick:(UIButton *)btn {
    NSLog(@"动起来吧，骚年%ld号", (long)btn.tag);
    
    self.selectedIndex = btn.tag - kFirstButtonTag;
    
    self.selectedIndexBlock(self.selectedIndex);
    
    [self setButtonsState];
}

- (void)setButtonsState {
    
    for (int i = 0; i < self.buttonsArray.count; i++) {
        
        UIButton *btn = [self.scrollView viewWithTag:300 + i];
        
        [btn setTitleColorWithColor:WCGray andText:btn.titleLabel.text];
        
        [btn setBackgroundColor:WCClear];
        
        if (i == self.selectedIndex) {
            
            [btn setTitleColorWithColor:WCWhite andText:btn.titleLabel.text];
            
            [btn setBackgroundColor:headViewBackColor];
        }
    }
    
    CGPoint offset = CGPointZero;
    
    if (self.selectedIndex >= 0 && self.selectedIndex < 2) {
        
        offset = CGPointMake(0, 0);
        
    } else if (self.selectedIndex <= self.buttonsArray.count - 1) {
        
        offset = CGPointMake(intervalWidth * (self.selectedIndex - 2), 0);
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.scrollView.contentOffset = offset;
        
    }];
}



@end
