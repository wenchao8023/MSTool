//
//  CDCollectionCell.m
//  MS3Tool
//
//  Created by chao on 2016/11/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "CDCollectionCell.h"


@interface CDCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;

@end

@implementation CDCollectionCell

- (void)config:(XMAlbum *)album {
    
   
//    self.titleLabel.attributedText = [self getTitleLabelStr:album.albumTitle];
    self.titleLabel.attributedText = [CommonUtil getTitleLabelStr:album.albumTitle];
    
    self.playCountLabel.attributedText = [self getCountStr:album.playCount];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:album.coverUrlMiddle]];
}

- (NSMutableAttributedString *)getTitleLabelStr:(NSString *)str {
    
    NSRange range = NSMakeRange(0, str.length);
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowBlurRadius = 5;    //模糊度
    
    shadow.shadowColor = WCBlack;
    
    shadow.shadowOffset = CGSizeMake(1, 3);
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                           NSForegroundColorAttributeName : WCWhite,
                           NSShadowAttributeName : shadow};
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attText setAttributes:dict range:range];
    
    return attText;
}

- (NSMutableAttributedString *)getCountStr:(NSInteger)count {
    
    NSString *str;
    
    if (count < 10000) {
        
        str = [NSString stringWithFormat:@"%ld", (long)count];
        
    } else {
        
        str = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    }
    
    NSRange range = NSMakeRange(0, str.length);
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowBlurRadius = 5;    //模糊度
    
    shadow.shadowColor = WCBlack;
    
    shadow.shadowOffset = CGSizeMake(1, 2);
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                           NSForegroundColorAttributeName : WCWhite,
                           NSShadowAttributeName : shadow};
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attText setAttributes:dict range:range];
    
    return attText;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
