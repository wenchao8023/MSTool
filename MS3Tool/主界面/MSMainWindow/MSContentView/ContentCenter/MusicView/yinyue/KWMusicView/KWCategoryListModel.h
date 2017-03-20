//
//  KWCategoryListModel.h
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWCategoryListModel : NSObject

@property (nonatomic, copy, nullable) NSString *name;

@property (nonatomic, strong, nullable) NSArray *children;

@property (nonatomic, assign) NSInteger catId;

@property (nonatomic, copy, nullable) NSString *catePic;



@property (nonatomic, copy, nullable) NSString *bangId;

@property (nonatomic, copy, nullable) NSString *bangPic;


@end
