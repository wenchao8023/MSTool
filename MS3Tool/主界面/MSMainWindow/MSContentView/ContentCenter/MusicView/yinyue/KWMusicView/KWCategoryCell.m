//
//  KWCategoryCell.m
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWCategoryCell.h"

@interface KWCategoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation KWCategoryCell

-(void)config:(KWCategoryListModel *)model {
    
    self.titleLabel.text = model.name;
    
    self.bgImgView.image = [UIImage imageNamed:model.catePic];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
