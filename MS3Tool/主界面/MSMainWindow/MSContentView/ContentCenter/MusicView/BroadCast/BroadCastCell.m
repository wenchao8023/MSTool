//
//  BroadCastCell.m
//  MS3Tool
//
//  Created by chao on 2016/11/8.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "BroadCastCell.h"


@interface BroadCastCell ()

@property (weak, nonatomic) IBOutlet UILabel *sortNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation BroadCastCell

//-(void)config:(XMRadio *)radio andIndex:(NSInteger)row {
//    self.sortNumLabel.text = [NSString stringWithFormat:@"%ld", row];
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:radio.coverUrlSmall]];
//    self.titleLabel.text = radio.radioName;
//    self.subTitleLabel.text = radio.programName;
//}
-(void)config:(id)obj andIndex:(NSInteger)row {
    
    //  返回数据XMRadio
    if ([obj isKindOfClass:[XMRadio class]]) {
        XMRadio *radio = obj;
        self.sortNumLabel.text = [NSString stringWithFormat:@"%ld", (long)row];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:radio.coverUrlSmall]];
        self.titleLabel.text = radio.radioName;
        self.subTitleLabel.text = radio.programName;
    }
    
//    if ([obj isKindOfClass:[XMRadio class]]) {
//        XMRadio *radio = obj;
//        self.sortNumLabel.text = [NSString stringWithFormat:@"%ld", row];
//        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:radio.coverUrlSmall]];
//        self.titleLabel.text = radio.radioName;
//        self.subTitleLabel.text = radio.programName;
//    }
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
