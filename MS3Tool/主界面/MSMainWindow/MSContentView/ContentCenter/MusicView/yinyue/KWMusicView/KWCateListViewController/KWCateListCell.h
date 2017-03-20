//
//  KWCateListCell.h
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KWFenleiModel.h"

#import "KWFenleiDetailModel.h"

@interface KWCateListCell : UITableViewCell

-(void)config:(NSDictionary *)dic ;

-(void)configGeShou:(NSDictionary *)dic ;

-(void)config:(NSDictionary *)dic localPic:(NSString *)picStr ; 

-(void)configFenlei:(KWFenleiModel *)model ;

-(void)configFenleiDetail:(KWFenleiModel *)model ;

@end
