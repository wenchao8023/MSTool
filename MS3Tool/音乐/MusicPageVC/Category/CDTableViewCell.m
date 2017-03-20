//
//  CDTableViewCell.m
//  MS3Tool
//
//  Created by chao on 2016/11/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "CDTableViewCell.h"


@interface CDTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftLineLabel;

@end

@implementation CDTableViewCell

- (void)config:(NSString *)titleStr andisClick:(BOOL)isClick {
    
    self.titleLabel.text = titleStr;
    
    self.titleLabel.textColor = WCGray;
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.leftLineLabel.backgroundColor = WCGray;
    
    self.rightLineLabel.backgroundColor = WCGray;
    
    if (isClick) {
        
        self.titleLabel.textColor = WCBlack;
        
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.leftLineLabel.backgroundColor = WCBlack;
        
        self.rightLineLabel.backgroundColor = WCBlack;
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
