//
//  KWMusicNet.m
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWMusicNet.h"


/* 酷我api */
static NSString *kCategoryList = @"http://www.kuwo.cn/bd/category/list?bdfrom=xiaomi&c=sm10ncurzssf";

static NSString *kCategoryPlaylist = @"http://www.kuwo.cn/bd/category/getPlayListByCateId?id=%d&pn=%d&rn=%d&bdfrom=xiaomi&c=sm10ncurzssf";

static NSString *kCategoryDetail = @"http://www.kuwo.cn/bd/playlist/getPlaylistById?pid=%d&pn=%d&rn=%d&bdfrom=xiaomi&c=sm10ncurzssf";


static NSString *kBangList = @"http://www.kuwo.cn/bd/bang/list?bdfrom=xiaomi&c=sm10ncurzssf";

static NSString *kBangDetail = @"http://www.kuwo.cn/bd/bang/detail?id=%d&bdfrom=xiaomi&c=sm10ncurzssf";

//cateory = 0~9
static NSString *kArtistList = @"http://www.kuwo.cn/bd/artist/list?category=%d&pn=%d&rn=%d&bdfrom=xiaomi&c=sm10ncurzssf";

static NSString *kArtistMusiclist = @"http://www.kuwo.cn/bd/artist/getMusicsByAristId?artistId=%@&pn=%d&rn=%d&bdfrom=xiaomi&c=sm10ncurzssf";


static NSString *kMusicUrl = @"http://antiserver.kuwo.cn/anti.s?format=acc|mp3&rid=MUSIC_ %@&response=url&type=convert_url";

static NSString *kLrcUrl = @"http://m.kuwo.cm/newh5/singles/songinfoandlrc?musicId=%@";

static NSString *kSearchUrl = @"http://www.kuwo.cn/bd/search/musicSearch?key=%@&pn=%d&rn=%d&bdfrom=xiaomi&c=sm10ncurzssf";

@interface KWMusicNet ()<NSURLSessionDelegate>


@end

@implementation KWMusicNet

#pragma mark - 分类
#pragma mark -- 分类标题
-(void)loadKWCategory {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
    
    NSString *getUrl = [kCategoryList stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"1" forKey:@"isOk"];
        
        [dic setObject:responseObject forKey:@"data"];
        
        self.categoryListBlock(dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        NSLog(@"请求数据失败,失败原因:\n%@", error);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"0" forKey:@"isOk"];
        
        [dic setObject:error forKey:@"error"];
        
        self.categoryListBlock(dic);
    }];
}

#pragma mark -- 分类列表
-(void)loadKWCategoryPlaylistDataWithCate:(int)category pn:(int)pn rn:(int)rn {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
    
    NSString *getUrl = [[NSString stringWithFormat:kCategoryPlaylist, category, pn, rn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"1" forKey:@"isOk"];
        
        [dic setObject:responseObject forKey:@"data"];
        
        self.categoryPlaylistBlock(dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        NSLog(@"请求数据失败,失败原因:\n%@", error);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"0" forKey:@"isOk"];
        
        [dic setObject:error forKey:@"error"];
        
        self.categoryPlaylistBlock(dic);
    }];
}

#pragma mark -- 分类详情
-(void)loadKWCategoryDetailDataWithPID:(int)pid pn:(int)pn rn:(int)rn {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
    
    NSString *getUrl = [[NSString stringWithFormat:kCategoryDetail, pid, pn, rn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"1" forKey:@"isOk"];
        
        [dic setObject:responseObject forKey:@"data"];
        
        self.categoryDetailBlock(dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        NSLog(@"请求数据失败,失败原因:\n%@", error);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"0" forKey:@"isOk"];
        
        [dic setObject:error forKey:@"error"];
        
        self.categoryDetailBlock(dic);
    }];
}

#pragma mark - 榜单
#pragma mark -- 榜单列表
-(void)loadKWBang {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
    
    NSString *getUrl = [kBangList stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"1" forKey:@"isOk"];
        
        [dic setObject:responseObject forKey:@"data"];
        
        self.bangListBlock(dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        NSLog(@"请求数据失败,失败原因:\n%@", error);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"0" forKey:@"isOk"];
        
        [dic setObject:error forKey:@"error"];
        
        self.bangListBlock(dic);
    }];
}

#pragma mark -- 详情
-(void)loadKWBangDetailDataWithID:(int)bangId {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
    
    NSString *getUrl = [[NSString stringWithFormat:kBangDetail,bangId] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"1" forKey:@"isOk"];
        
        [dic setObject:responseObject forKey:@"data"];
        
        self.bangDetailBlock(dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"0" forKey:@"isOk"];
        
        [dic setObject:error forKey:@"error"];
        
        self.bangDetailBlock(dic);
    }];
}

#pragma mark - 歌手
#pragma mark -- 歌手列表
-(void)loadKWArtistListDataWithCate:(int)category pn:(int)pn rn:(int)rn {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
    
    NSString *getUrl = [[NSString stringWithFormat:kArtistList, category, pn, rn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"1" forKey:@"isOk"];
        
        [dic setObject:responseObject forKey:@"data"];
        
        self.artistListBlock(dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        NSLog(@"请求数据失败,失败原因:\n%@", error);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"0" forKey:@"isOk"];
        
        [dic setObject:error forKey:@"error"];
        
        self.artistListBlock(dic);
    }];
}

#pragma mark -- 歌手歌曲
-(void)loadKWArtistListDataWithArtistID:(NSString *)artistid pn:(int)pn rn:(int)rn {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
    
    NSString *getUrl = [[NSString stringWithFormat:kArtistMusiclist, artistid, pn, rn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"1" forKey:@"isOk"];
        
        [dic setObject:responseObject forKey:@"data"];
        
        self.artistMusiclistBlock(dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"0" forKey:@"isOk"];
        
        [dic setObject:error forKey:@"error"];
        
        self.artistMusiclistBlock(dic);
    }];
}

#pragma mark - 音乐
#pragma mark -- 音乐地址
- (void)loadKWMusicDataWithSongid:(NSString *)songid {
    
    NSString *getUrl = [[NSString stringWithFormat:kMusicUrl, songid] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *sessoin = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *task = [sessoin dataTaskWithURL:[NSURL URLWithString:getUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        [dic setObject:songid forKey:@"songid"];
        
        [dic setObject:str forKey:@"urlStr"];

        self.musicUrlBlock(dic);
        
    }];
    
    [task resume];
}

//-(void)loadKWMusicDataWithSongid:(NSString *)songid {
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
//    
//    NSString *getUrl = [[NSString stringWithFormat:kMusicUrl, songid] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
//    
//    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //成功的回调
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        
//        [dic setObject:@"1" forKey:@"isOk"];
//        
//        [dic setObject:responseObject forKey:@"data"];
//        
//        self.musicUrlBlock(dic);
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //失败的回调
//        NSLog(@"请求数据失败,失败原因:\n%@", error);
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        
//        [dic setObject:@"0" forKey:@"isOk"];
//        
//        [dic setObject:error forKey:@"error"];
//        
//        self.musicUrlBlock(dic);
//    }];
//}

#pragma mark -- 音乐歌词
-(void)loadKWLrcDataSongid:(NSString *)songid {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
    
    NSString *getUrl = [[NSString stringWithFormat:kLrcUrl, songid] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"1" forKey:@"isOk"];
        
        [dic setObject:responseObject forKey:@"data"];
        
        self.lrcUrlBlock(dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        NSLog(@"请求数据失败,失败原因:\n%@", error);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"0" forKey:@"isOk"];
        
        [dic setObject:error forKey:@"error"];
        
        self.lrcUrlBlock(dic);
    }];
}

#pragma mark -- 音乐搜索
-(void)loadKWSearchData:(NSString *)keyword pn:(int)pn rn:(int)rn {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"application/json",  nil]];
    
    NSString *getUrl = [[NSString stringWithFormat:kSearchUrl, keyword, pn, rn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:getUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功的回调
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"1" forKey:@"isOk"];
        
        [dic setObject:responseObject forKey:@"data"];
        
        self.searchUrlBlock(dic);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败的回调
        NSLog(@"请求数据失败,失败原因:\n%@", error);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"0" forKey:@"isOk"];
        
        [dic setObject:error forKey:@"error"];
        
        self.searchUrlBlock(dic);
    }];
}


@end
