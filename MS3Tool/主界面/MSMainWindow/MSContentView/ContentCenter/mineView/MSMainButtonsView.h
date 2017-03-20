//
//  MSMainButtonsView.h
//  MS3Tool
//
//  Created by chao on 2016/12/15.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    myLoveClickTag,
    
    latestClickTag,

    smarthomeClickTag

}ButtonsClickTag;

typedef void(^ButtonsClickBlock)(ButtonsClickTag clickTag);

@interface MSMainButtonsView : UIView

@property (nonatomic, copy) ButtonsClickBlock buttonsClickBlock;

@end
