//
//  CategoryCell.m
//  MS3Tool
//
//  Created by chao on 2016/11/10.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "CategoryCell.h"

@interface CategoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end

@implementation CategoryCell

- (void)config:(XMCategory *)category {
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:category.coverUrlSmall]];
    
    self.titleLabel.text = category.categoryName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
