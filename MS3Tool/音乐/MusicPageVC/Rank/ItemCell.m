//
//  ItemCell.m
//  sdkTest
//
//  Created by chao on 2016/11/4.
//  Copyright © 2016年 nali. All rights reserved.
//

#import "ItemCell.h"
#import "UIImageView+WebCache.h"


@interface ItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel2;


@end

@implementation ItemCell


//- (void)config:(XMRankSectionList *)sectionList {
//
//    self.iconImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sectionList.coverUrl]]];
//    self.titleLabel.text = sectionList.rankTitle;
//    self.subTitleLabel1.text = [NSString stringWithFormat:@"1  %@", sectionList.rankFirstItemTitle];
//    XMIndexRankItem *item1 = [sectionList.indexRankItems firstObject];
//    if (item1.id == sectionList.rankFirstItemId) {
//        XMIndexRankItem *item2 = [sectionList.indexRankItems objectAtIndex:1];
//        self.subTitleLabel2.text = [NSString stringWithFormat:@"2  %@", item2.title];
//    } else {
//        self.subTitleLabel2.text = [NSString stringWithFormat:@"2  %@", item1.title];
//    }
//}

- (void)config:(id)obj {
    
    if ([obj isKindOfClass:[XMRankSectionList class]]) {
        XMRankSectionList *sectionList = obj;
        
        self.iconImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sectionList.coverUrl]]];
        self.titleLabel.text = sectionList.rankTitle;
        self.subTitleLabel1.text = [NSString stringWithFormat:@"1  %@", sectionList.rankFirstItemTitle];
        XMIndexRankItem *item1 = [sectionList.indexRankItems firstObject];
        if (item1.id == sectionList.rankFirstItemId) {
            XMIndexRankItem *item2 = [sectionList.indexRankItems objectAtIndex:1];
            self.subTitleLabel2.text = [NSString stringWithFormat:@"2  %@", item2.title];
        } else {
            self.subTitleLabel2.text = [NSString stringWithFormat:@"2  %@", item1.title];
        }
    } else {
        XMRadio *radio = obj;
        
        self.iconImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:radio.coverUrlSmall]]];
        self.titleLabel.text = radio.programName;
        self.subTitleLabel1.text = radio.rate64AacUrl;
        self.subTitleLabel2.text = radio.rate64TsUrl;
    }
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
