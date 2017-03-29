//
//  MSMusicAlbumView.h
//  MS3Tool
//
//  Created by chao on 2016/11/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

/*************************************************************************
 ****************       显示在MSFooterWindow中          *******************
 *************************************************************************/

#import <UIKit/UIKit.h>


typedef void(^CloseAlbum)();

@interface MSMusicAlbumView : UIView


@property (nonatomic, copy) CloseAlbum closeAlbum;

- (void)loadData ;

//- (void) setBgColorTypeDark ;
//
//- (void) setBgColorTypeLight ;


@end
