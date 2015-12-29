//
//  CarCell.m
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "CarCell.h"

@implementation CarCell
{
    UILabel *nameLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 70)];
        mView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:mView];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 28, 28)];
        icon.image = [UIImage imageNamed:@"fonud_8_"];
        [mView addSubview:icon];
        
        icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-35, 20, 28, 28)];
        icon.image = [UIImage imageNamed:@"my_shezhi_"];
        [mView addSubview:icon];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 13, 200, 20)];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:18];
        nameLabel.backgroundColor = [UIColor clearColor];
        [mView addSubview:nameLabel];
        
        UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 43, 200, 20)];
        mLabel.textColor = [UIColor blackColor];
        mLabel.font = [UIFont systemFontOfSize:18];
        mLabel.text = @"未处理违章次数0次";
        [mView addSubview:mLabel];
        
        mLabel = [[UILabel alloc]initWithFrame:CGRectMake(mView.bounds.size.width-100, 0, 50, 70)];
        mLabel.backgroundColor = [UIColor clearColor];
        mLabel.textColor = [UIColor blackColor];
        mLabel.font = [UIFont systemFontOfSize:30];
        mLabel.text = @"0";
        mLabel.textAlignment = NSTextAlignmentRight;
        [mView addSubview:mLabel];
        
        
    }
    return self;
}
- (void)LoadContent:(NSString *)carId{
    nameLabel.text =  [NSString stringWithFormat:@"津：%@",carId];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
