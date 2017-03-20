//
//  TuijianView.m
//  MS3Tool
//
//  Created by chao on 2016/12/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "TuijianView.h"

@implementation TuijianView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self loadData];
    }
    
    return self;
}

- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@200 forKey:@"count"];
    
    [params setObject:@1 forKey:@"page"];
    
    [params setObject:@1 forKey:@"calc_dimension"];
    
    [[XMReqMgr sharedInstance] requestXMData:XMReqType_AlbumsRecommendDownload params:params withCompletionHander:^(id result, XMErrorModel *error) {
        if(!error) {
            
        }
            
        else  {
            NSLog(@"%@",error.description);
        }
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
