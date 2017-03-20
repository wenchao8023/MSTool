//
//  MusicFooterView.h
//  MS3Tool
//
//  Created by chao on 2016/11/21.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef void(^GoMusicVC)();

typedef void(^GoAlbumView)();

@interface MusicFooterView : UIView


@property (nonatomic, copy) GoMusicVC goMusicVC;

@property (nonatomic, copy) GoAlbumView goAlbumView;

-(void)resetSubviews;

-(void)pauseRotate;

@end
