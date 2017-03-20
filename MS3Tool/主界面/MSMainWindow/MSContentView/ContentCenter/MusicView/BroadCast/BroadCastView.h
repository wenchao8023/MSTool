//
//  BroadCastView.h
//  MS3Tool
//
//  Created by chao on 2016/11/8.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ClickBlock)(NSInteger clickTag);

@interface BroadCastView : UIView

@property (nonatomic, copy) ClickBlock clickBlock;

@end
