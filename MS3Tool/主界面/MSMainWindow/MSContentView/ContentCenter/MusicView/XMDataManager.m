//
//  XMDataManager.m
//  MS3Tool
//
//  Created by chao on 2016/11/2.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "XMDataManager.h"


#define XMLYKEY @"c10a433e397f1fb884f4b65300d697a7"
#define XMLYSECRET @"647f931d346c307a75b5aa7731e47d42"

@interface XMDataManager ()<XMReqDelegate>


@end

static XMDataManager *manager = nil;
@implementation XMDataManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMDataManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
#if DEBUG
        [[XMReqMgr sharedInstance] registerXMReqInfoWithKey:XMLYKEY appSecret:XMLYSECRET] ;
        
#else
        [[XMReqMgr sharedInstance] registerXMReqInfoWithKey:XMLYKEY appSecret:XMLYSECRET] ;
#endif
        [XMReqMgr sharedInstance].delegate = self;
    }
    
    return self;
}
-(void)didXMInitReqOK:(BOOL)result {
    NSLog(@"XMLY init success");
}
-(void)didXMInitReqFail:(XMErrorModel *)respModel {
    NSLog(@"MXLY init failed");
}

-(void)loadDataWithDic:(NSDictionary *)dic andXMReqType:(XMReqType)XMReqType {
    
    __weak __typeof(&*self) sself = self;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [[XMReqMgr sharedInstance] requestXMData:XMReqType params:dic withCompletionHander:^(id result, XMErrorModel *error) {
        if(!error) {
            
            [tempDic setObject:@"1" forKey:@"isOk"];
            [tempDic setObject:result forKey:@"data"];
            sself.dataBlock(tempDic);
        }
        else {
            NSLog(@"Error: error_no:%ld, error_code:%@, error_desc:%@",(long)error.error_no, error.error_code, error.error_desc);
            [tempDic setObject:@"0" forKey:@"isOk"];
            [tempDic setObject:error forKey:@"error"];
            sself.dataBlock(tempDic);
        }
    }];
}






































@end
















