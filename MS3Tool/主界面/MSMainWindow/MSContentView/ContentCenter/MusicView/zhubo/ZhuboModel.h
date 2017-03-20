//
//  ZhuboModel.h
//  MS3Tool
//
//  Created by chao on 2017/1/3.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhuboModel : NSObject

//"announcer_position" = "\U9999\U6e2f\U8d44\U6df1\U65f6\U4e8b\U8bc4\U8bba\U5458\Uff0c\U8457\U540d\U4e13\U680f\U4f5c\U5bb6";
//"avatar_url" = "http://fdfs.xmcdn.com/group19/M06/21/71/wKgJK1eF5r3RGnJRAAPm0E7HvBM058_web_large.jpg";
//"follower_count" = 15486;
//"following_count" = 2;
//id = 53649032;
//"is_verified" = 1;
//kind = announcer;
//nickname = "\U6768\U9526\U9e9f";
//"released_album_count" = 5;
//"released_track_count" = 164;
//"vcategory_id" = 8;
//vdesc = "";
//vsignature = "\U51e4\U51f0\U536b\U89c6\U524d\U540d\U5634\Uff0c\U8457\U540d\U4e3b\U6301\U4eba\Uff0c\U65f6\U4e8b\U8bc4\U8bba\U5458\Uff0c\U4e13\U680f\U4f5c\U5bb6"

@property (nonatomic, copy) NSString *announcer_position;

@property (nonatomic, copy) NSString *avatar_url;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *vdesc;

@property (nonatomic, copy) NSString *vsignature;

@property (nonatomic, copy) XMAnnouncer *kind;


@property (nonatomic, assign) BOOL is_verified;

@property (nonatomic, assign) long follower_count;

@property (nonatomic, assign) long following_count;

@property (nonatomic, assign) long id;

@property (nonatomic, assign) long released_album_count;

@property (nonatomic, assign) long released_track_count;

@property (nonatomic, assign) long vcategory_id;



@end
