//
//  CategoryDataManager.h
//  MS3Tool
//
//  Created by chao on 2016/11/10.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^DataBlock)(NSDictionary *dataDic);

typedef void(^DataArrayBlock)(NSArray *titleArray, NSArray *dataArray, NSArray *totalCountArray);

@interface CategoryDataManager : NSObject


@property (nonatomic, copy) DataBlock dataBlock;
@property (nonatomic, copy) DataArrayBlock dataArrayBlock;

+(instancetype)shareInstance;
-(void)loadSoundsAlbumData:(NSInteger)categoryID;
-(void)loadZhuanjiAlbumData:(NSInteger)categoryID;
-(void)loadDetailAlbumData:(NSInteger)categoryID andArray:(NSArray *)tempDataArr;
-(void)loadMusicWithAlbum:(XMAlbum *)album;
@end
