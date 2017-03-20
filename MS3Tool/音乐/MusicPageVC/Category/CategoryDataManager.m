//
//  CategoryDataManager.m
//  MS3Tool
//
//  Created by chao on 2016/11/10.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "CategoryDataManager.h"
#import "XMDataManager.h"

static CategoryDataManager *manager = nil;
@interface CategoryDataManager ()

@property (nonatomic, strong) XMDataManager *dataManager;

@end

@implementation CategoryDataManager

+(instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CategoryDataManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init {
    if (self = [super init]) {
        self.dataManager = [XMDataManager shareInstance];
        
    }
    
    return self;
}

-(void)loadSoundsAlbumData:(NSInteger)categoryID {
    //  获取声音标签
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:@(categoryID) forKey:@"category_id"];
    [requestDic setObject:@1 forKey:@"type"];
    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_TagsList];
    
    __weak typeof(&*self) sself = self;
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        sself.dataBlock(dataDic);
    };
}

-(void)loadZhuanjiAlbumData:(NSInteger)categoryID {
    //  获取专辑标签
    NSMutableDictionary *requestDic1 = [NSMutableDictionary dictionary];
    [requestDic1 setObject:@(categoryID) forKey:@"category_id"];
    [requestDic1 setObject:@0 forKey:@"type"];
    [self.dataManager loadDataWithDic:requestDic1 andXMReqType:XMReqType_TagsList];
    
    __weak typeof(&*self) sself = self;
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        sself.dataBlock(dataDic);
    };
}


-(void)loadDetailAlbumData:(NSInteger)categoryID andArray:(NSArray *)tempDataArr {
    
    static int count = 0;
    
    for (int i = 0; i < tempDataArr.count; i++) {
        XMTag *tag = tempDataArr[i];
        
        NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
        [requestDic setObject:@(categoryID) forKey:@"category_id"];
        [requestDic setObject:tag.tagName forKey:@"tag_name"];
        [requestDic setObject:@1 forKey:@"calc_dimension"];
        [requestDic setObject:@1 forKey:@"page"];
        [requestDic setObject:@20 forKey:@"count"];
        //  获取专辑标签
        [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_AlbumsList];
        
        if (count) {
            count = 0;
        }
    }
    
    
    __weak typeof(&*self) sself = self;
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *dataArr = [NSMutableArray array];
    NSMutableArray *dataArr1 = [NSMutableArray array];
    NSMutableArray *totalCountArr = [NSMutableArray array];
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        
        count++;
        
        if ([dataDic objectForKey:@"isOk"]) {
            //            XMAlbum
            if ([[[dataDic objectForKey:@"data"] objectForKey:@"albums"] count] != 0 ) {
                

                NSArray *tempArr = [NSArray arrayWithArray:[[dataDic objectForKey:@"data"] objectForKey:@"albums"]];
                for (id obj in tempArr) {
                    XMAlbum *album = [[XMAlbum alloc] initWithDictionary:obj];
                    [dataArr1 addObject:album];
                }
                
                NSString *titleStr = [[dataDic objectForKey:@"data"] objectForKey:@"tag_name"];
                [titleArr addObject:titleStr];
                
                [totalCountArr addObject:[[dataDic objectForKey:@"data"] objectForKey:@"total_count"]];
                
                NSArray *dataArr2 = [NSArray arrayWithArray:dataArr1];
                [dataArr addObject:dataArr2];
                [dataArr1 removeAllObjects];
            }
            
            if (count == tempDataArr.count) {
                sself.dataArrayBlock(titleArr, dataArr, totalCountArr);
            }
            
        } else {
            NSLog(@"请求数据失败");
        }
    };
}

-(void)loadMusicWithAlbum:(XMAlbum *)album {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];

    [requestDic setObject:@(album.albumId) forKey:@"album_id"];
    [requestDic setObject:@1 forKey:@"page"];
    [requestDic setObject:@20 forKey:@"count"];
    
    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_AlbumsBrowse];
    
    __weak typeof(&*self) sself = self;
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        sself.dataBlock(dataDic);
    };
}









@end
