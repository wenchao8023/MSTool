//
//  UIButton+UnderlineNone.m
//  wxwh_ios
//
//  Created by 郭文超 on 16/4/7.
//  Copyright © 2016年 li. All rights reserved.
//

#import "UIButton+UnderlineNone.h"

@implementation UIButton (UnderlineNone)

-(void)cancelUndenlineWithText:(NSString *)text
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, text.length)];
    [self setAttributedTitle:str forState:UIControlStateNormal];
}
-(void)setTitleColorWithColor:(UIColor *)color andText:(NSString *)text {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length)];
    [self setAttributedTitle:str forState:UIControlStateNormal];
}
@end
