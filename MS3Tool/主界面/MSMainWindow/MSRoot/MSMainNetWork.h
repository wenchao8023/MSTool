//
//  MSMainNetWork.h
//  MS3Tool
//
//  Created by chao on 2016/12/16.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^MSMainData1Block)(NSArray *dataArray);

typedef void(^MSMainData2Block)(NSArray *dataArray);

typedef void(^MSMainData3Block)(NSArray *dataArray);




@interface MSMainNetWork : NSObject

+ (instancetype) shareManager ;


/**
 *  热门音乐
 */
- (void) loadData1 ;
@property (nonatomic, copy) MSMainData1Block msmainData1Block;

/**
 *  猜你喜欢
 */
- (void) loadData2 ;
@property (nonatomic, copy) MSMainData2Block msmainData2Block;

/**
 *  头部焦点图
 */
- (void) loadData3 ;
@property (nonatomic, copy) MSMainData3Block msmainData3Block;


@end
