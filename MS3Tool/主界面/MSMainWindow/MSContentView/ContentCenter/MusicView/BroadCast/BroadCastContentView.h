//
//  BroadCastContentView.h
//  MS3Tool
//
//  Created by chao on 2016/11/8.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PresentClickBlock)(NSInteger clickTag);
@interface BroadCastContentView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) PresentClickBlock presentClickBlock;

@end
