//
//  CategoryDetailVC1.h
//  MS3Tool
//
//  Created by chao on 2016/11/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryDetailVC1 : UIViewController

@property (nonatomic, assign) NSInteger categoryID;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, strong) XMTag *xmTag;


@end
