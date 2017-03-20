//
//  MSMainNetWork.m
//  MS3Tool
//
//  Created by chao on 2016/12/16.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMainNetWork.h"

#import "XMDataManager.h"

#import "MSMainGuessLikeModel.h"


@interface MSMainNetWork ()

@property (nonatomic, strong) XMDataManager *dataManager;

@end


static MSMainNetWork *netWork = nil;
@implementation MSMainNetWork

+ (instancetype) shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        netWork = [[MSMainNetWork alloc] init];
    });
    
    return netWork;
}

- (instancetype) init {
    
    if (self = [super init]) {
        
        _dataManager = [XMDataManager shareInstance];
    }
    
    return self;
}

#pragma mark - MSMainContentViewData
#pragma mark -- 热门下的推荐 - 共20条
- (void) loadData1 {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:@0 forKey:@"category_id"];
    
    [requestDic setObject:@3 forKey:@"display_count"];
 
    
    _dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        [netWork analysDic:dataDic];
    };
    
    [_dataManager loadDataWithDic:nil andXMReqType:XMReqType_DiscoveryRecommendAlbums];
}

#pragma mark -- 猜你喜欢 - 推荐模块分组 - XMAlbumGuessLike
- (void) loadData2 {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:@3 forKey:@"like_count"];
    
    _dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        [netWork analysDic:dataDic];
    };
    
    [_dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_AlbumsGuessLike];
}

#pragma mark -- 热门 - 焦点图
- (void) loadData3 {

    
    _dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        [netWork analysDic:dataDic];
        
    };
    
    [_dataManager loadDataWithDic:nil andXMReqType:XMReqType_DiscoveryBanner];
}


#pragma mark - categoryData
#pragma mark -- 音乐分类数据
- (void) loadCategoryData {
    
    _dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        [netWork analysDic:dataDic];
    };
    
    [_dataManager loadDataWithDic:nil andXMReqType:XMReqType_CategoriesList];
}


#pragma mark -- 分析返回的 数据字典
- (void) analysDic : (NSDictionary *)dataDic {

    if ([[dataDic objectForKey:@"isOk"] isEqualToString:@"1"]) {
        
        NSArray *tempArray = [dataDic objectForKey:@"data"];
        
        // 焦点图数据
        if (tempArray.count) {
            
            if (tempArray.count == 3) { // 猜你喜欢 - data2

                NSMutableArray *tempMArr = [NSMutableArray arrayWithCapacity:0];
                
                for (NSDictionary *dic in tempArray) {
                    
                    MSMainGuessLikeModel *model = [[MSMainGuessLikeModel alloc] initWithDictionary:dic];
                    
                    [tempMArr addObject:model];
                }
                
                self.msmainData2Block(tempMArr);
                
                
                
            } else if (tempArray.count == 20) { // 热门音乐 - data1
                
                
                for (NSDictionary *dic in tempArray) {
                    
                    if ([[dic objectForKey:@"category_id"] integerValue] == 2) {
                        
                        NSArray *albumsArr = [dic objectForKey:@"albums"];
                        
                        NSMutableArray *tempMArr = [NSMutableArray arrayWithCapacity:0];
                        
                        for (NSDictionary *objDic in albumsArr) {
                            
                            MSMainGuessLikeModel *model = [[MSMainGuessLikeModel alloc] initWithDictionary:objDic];
                            
                            [tempMArr addObject:model];
                        }
                        
                        self.msmainData1Block(tempMArr);
                    }
                }
                
                
            } else {    // 是 banner 字典
                
                NSDictionary *objDic = [tempArray firstObject];
                
                if ([objDic objectForKey:@"banner_title"]) {
                    
                    NSMutableArray *tempMArr = [NSMutableArray arrayWithCapacity:0];
                    
                    for (NSDictionary *dic in tempArray) {
                        
                        XMBanner *xmBanner = [[XMBanner alloc] initWithDictionary:dic];
                        
                        [tempMArr addObject:xmBanner];
                    }
                    
                    self.msmainData3Block(tempMArr);
                    
                }
            }
        }
        
    } else {
        
        NSLog(@"请求数据失败");
    }
}

@end
