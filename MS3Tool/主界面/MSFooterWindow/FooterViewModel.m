//
//  FooterViewModel.m
//  MS3Tool
//
//  Created by chao on 2016/11/22.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "FooterViewModel.h"

@implementation FooterViewModel

- (void)config:(MSMusicModel *)model {
    
    _coverUrlSmall = _track.coverUrlSmall;
    
    _trackTitle = _track.trackTitle;
    
    _nickname = _track.announcer.nickname;
}

@end
