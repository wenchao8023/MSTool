//
//  XMDataManager.h
//  MS3Tool
//
//  Created by chao on 2016/11/2.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMReqMgr.h"

typedef void(^DataBlock)(NSDictionary *dic);

@interface XMDataManager : NSObject

@property (nonatomic, copy) DataBlock dataBlock;

+ (instancetype)shareInstance;

-(void)loadDataWithDic:(NSDictionary *)dic andXMReqType:(XMReqType)XMReqType;

@end
