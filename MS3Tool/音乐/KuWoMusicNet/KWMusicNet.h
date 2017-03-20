//
//  KWMusicNet.h
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^CategoryListBlock)(NSDictionary * _Nonnull dataDic);

typedef void(^CategoryPlaylistBlock)(NSDictionary * _Nonnull dataDic);

typedef void(^CategoryDetailBlock)(NSDictionary * _Nonnull dataDic);

typedef void(^BangListBlock)(NSDictionary * _Nonnull dataDic);

typedef void(^BangDetailBlock)(NSDictionary * _Nonnull dataDic);

typedef void(^ArtistListBlock)(NSDictionary * _Nonnull dataDic);

typedef void(^ArtistMusiclistBlock)(NSDictionary * _Nonnull dataDic);

typedef void(^MusicUrlBlock)(NSDictionary * _Nonnull dataDic);

typedef void(^LrcUrlBlock)(NSDictionary * _Nonnull dataDic);

typedef void(^SearchUrlBlock)(NSDictionary * _Nonnull dataDic);



@interface KWMusicNet : NSObject



@property (nonatomic, copy, nullable) CategoryListBlock categoryListBlock;

@property (nonatomic, copy, nullable) CategoryPlaylistBlock categoryPlaylistBlock;

@property (nonatomic, copy, nullable) CategoryDetailBlock categoryDetailBlock;

@property (nonatomic, copy, nullable) BangListBlock bangListBlock;

@property (nonatomic, copy, nullable) BangDetailBlock bangDetailBlock;

@property (nonatomic, copy, nullable) ArtistListBlock artistListBlock;

@property (nonatomic, copy, nullable) ArtistMusiclistBlock artistMusiclistBlock;

@property (nonatomic, copy, nullable) MusicUrlBlock musicUrlBlock;

@property (nonatomic, copy, nullable) LrcUrlBlock lrcUrlBlock;

@property (nonatomic, copy, nullable) SearchUrlBlock searchUrlBlock;



#pragma mark - 分类
#pragma mark -- 分类标题
-(void)loadKWCategory ;

#pragma mark -- 分类列表
-(void)loadKWCategoryPlaylistDataWithCate:(int)category pn:(int)pn rn:(int)rn ;

#pragma mark -- 分类详情
-(void)loadKWCategoryDetailDataWithPID:(int)pid pn:(int)pn rn:(int)rn ;

#pragma mark - 榜单
#pragma mark -- 榜单列表
-(void)loadKWBang ;

#pragma mark -- 详情
-(void)loadKWBangDetailDataWithID:(int)bangId ;

#pragma mark - 歌手
#pragma mark -- 歌手列表
-(void)loadKWArtistListDataWithCate:(int)category pn:(int)pn rn:(int)rn ;

#pragma mark -- 歌手歌曲
-(void)loadKWArtistListDataWithArtistID:(NSString * _Nonnull)artistid pn:(int)pn rn:(int)rn ;

#pragma mark - 音乐
#pragma mark -- 音乐地址
-(void)loadKWMusicDataWithSongid:(NSString * _Nonnull)songid ;

#pragma mark -- 音乐歌词
-(void)loadKWLrcDataSongid:(NSString * _Nonnull)songid  ;

#pragma mark -- 音乐搜索
-(void)loadKWSearchData:(NSString * _Nonnull)keyword pn:(int)pn rn:(int)rn ;

@end
