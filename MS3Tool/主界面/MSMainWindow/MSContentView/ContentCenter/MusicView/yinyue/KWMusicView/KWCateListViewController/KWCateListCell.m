//
//  KWCateListCell.m
//  MS3Tool
//
//  Created by chao on 2017/3/6.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "KWCateListCell.h"


@interface KWCateListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;


@property (weak, nonatomic) IBOutlet UILabel *fenleiTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *fenleiSubTitleLabel;

@end


@implementation KWCateListCell

-(void)config:(NSDictionary *)dic localPic:(NSString *)picStr {
    
    self.titleLable.text = [dic objectForKey:@"name"];
    
    self.iconImgView.image = [UIImage imageNamed:picStr];
}

-(void)configGeShou:(NSDictionary *)dic {
    
    self.titleLable.text = [dic objectForKey:@"name"];
    
    self.iconImgView.image = [UIImage imageNamed:@"changjing"];
}

-(void)config:(NSDictionary *)dic {
    
    self.titleLable.text = [dic objectForKey:@"name"];
    
    if ([dic objectForKey:@"pic"]) {
        
        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic"]]];
    }
}

-(void)configFenlei:(KWFenleiModel *)model {
    
    self.titleLable.text = model.name;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
}

-(void)configFenleiDetail:(KWFenleiDetailModel *)model {
    
//    self.titleLable.text = model.name;
//    
//    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    
    self.titleLable.hidden = YES;
    
    self.fenleiTitleLabel.hidden = NO;
    
    self.fenleiSubTitleLabel.hidden = NO;

    self.fenleiTitleLabel.text = model.songName;
    
    self.fenleiSubTitleLabel.text = model.artist;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.pic100]];
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
