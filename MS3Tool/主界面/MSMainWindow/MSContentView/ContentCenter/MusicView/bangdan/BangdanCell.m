//
//  BangdanCell.m
//  MS3Tool
//
//  Created by chao on 2017/1/3.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "BangdanCell.h"




@interface BangdanCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel1;

@property (weak, nonatomic) IBOutlet UILabel *descLabel2;
@end

@implementation BangdanCell

- (void)configRankList:(XMRankSectionList *)rankList {
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:rankList.coverUrl] placeholderImage:nil];
    
    self.titleLabel.text = rankList.rankTitle;
    
    NSArray *itemsArr = rankList.indexRankItems;
    
    if (itemsArr.count == 1) {
        
        XMIndexRankItem *item = [itemsArr firstObject];
        
        self.descLabel1.text = item.title;
        
        self.descLabel2.hidden = YES;
        
    } else {
        
        XMIndexRankItem *item1 = itemsArr[0];
        
        self.descLabel1.text = item1.title;
        
        XMIndexRankItem *item2 = itemsArr[1];
        
        self.descLabel2.text = item2.title;
    }
     
}

- (void)configRadio:(XMRadio *)radio {
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:radio.coverUrlSmall] placeholderImage:nil];
    
    self.titleLabel.text = radio.radioName;
    
    if (radio.programName.length) {
        
        self.descLabel1.text = radio.programName;
        
    } else {
        
        self.descLabel1.hidden = YES;
    }
    
    self.descLabel2.hidden = YES;
    
}








- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
