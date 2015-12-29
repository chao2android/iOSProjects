//
//  FavorableCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FavorableCell.h"

@implementation FavorableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Type:(NSInteger)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 7, 50, 23)];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = [UIFont systemFontOfSize:15];
        statusLabel.textColor = [UIColor lightGrayColor];
        
        if (type == 0)
        {
            UIImageView *staleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290-1, 150)];
            staleImage.image = [UIImage imageNamed:@"my_12.png"];
            [self.contentView addSubview:staleImage];
            statusLabel.text = @"未使用";
        }
        else if (type == 1)
        {
            UIImageView *staleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
            staleImage.image = [UIImage imageNamed:@"my_13.png"];
            [self.contentView addSubview:staleImage];
            statusLabel.text = @"已使用";
        }
        else
        {
            UIImageView *staleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
            staleImage.image = [UIImage imageNamed:@"my_13.png"];
            [self.contentView addSubview:staleImage];
            statusLabel.text = @"已过期";
        }
        
        [self.contentView addSubview:statusLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 225, 23)];
        //_titleLabel.text = @"RCTALOR 优惠券-NO.";
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 39, 287, 50)];
        //_priceLabel.text = @"￥";
        _priceLabel.font = [UIFont boldSystemFontOfSize:50];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_priceLabel];
        
        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 98, 250, 20)];
        desLabel.text = @"全场通用,消费满80元即可使用";
        desLabel.font = [UIFont systemFontOfSize:15];
        desLabel.backgroundColor = [UIColor clearColor];;
        [self.contentView addSubview:desLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 122, 250, 20)];
        //_timeLabel.text = @"有效期：";
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
