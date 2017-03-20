//
//  FooterViewModel.h
//  MS3Tool
//
//  Created by chao on 2016/11/22.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FooterViewModel : NSObject

@property (nonatomic, strong) XMTrack *track;

@property (nonatomic, copy) NSString *coverUrlSmall;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *trackTitle;

-(void)config:(XMTrack *)track;

@end
