//
//  latestCell.m
//  MS3Tool
//
//  Created by chao on 2017/2/10.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "latestCell.h"

@interface latestCell()

@property (weak, nonatomic) IBOutlet UILabel *wifiLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation latestCell

- (void)config:(NSString *)wifiStr {
    
    self.wifiLabel.text = wifiStr;
}


- (IBAction)selectClick:(id)sender {
    
    self.selectBlock(self.wifiLabel.text);
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
