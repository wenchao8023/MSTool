//
//  KMRecordCell.m
//  MS3Tool
//
//  Created by chao on 2016/12/9.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "KMRecordCell.h"



@interface KMRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;


@end

@implementation KMRecordCell


- (void)config:(NSString *)recordStr {
    self.recordLabel.text = recordStr;
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
