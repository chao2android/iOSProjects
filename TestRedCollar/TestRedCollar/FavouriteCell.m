//
//  FavouriteCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FavouriteCell.h"

@implementation FavouriteCell

@synthesize backgroundView = _backgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 110)];
        backgroundImage.userInteractionEnabled = YES;
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"3_14"];
        [self.contentView addSubview:backgroundImage];
        
        for (int i = 0; i < 2; i++)
        {
            UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 109*i, self.frame.size.width, 1)];
            lineImage.backgroundColor = [UIColor clearColor];
            lineImage.image = [UIImage imageNamed:@"51"];
            [backgroundImage addSubview:lineImage];
        }
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(245, 45, 65, 30);
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"mn1_03(2).png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_cancelBtn];
        
        _fImageView = [[NetImageView alloc] init];
        _fImageView.frame = CGRectMake(15, 15, 60, 80);
        //_fImageView.image = [UIImage imageNamed:@"my_17.png"];
        _fImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_fImageView];
        
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.frame = CGRectMake(110, 0, backgroundImage.frame.size.width-110, backgroundImage.frame.size.height);
        _backgroundView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_backgroundView];
        
        _fTitle = [[UILabel alloc] init];
        _fTitle.frame = CGRectMake(0, 14, _backgroundView.frame.size.width, 20);
        //_fTitle.text = @"意大利休闲男装秋季款";
        _fTitle.backgroundColor = [UIColor clearColor];
        _fTitle.font = [UIFont systemFontOfSize:16];
        [_backgroundView addSubview:_fTitle];
        
        _fPrice = [[UILabel alloc] init];
        _fPrice.frame = CGRectMake(0, 36, _backgroundView.frame.size.width, 20);
        //_fPrice.text = @"￥2343";
        _fPrice.font = [UIFont systemFontOfSize:20];
        _fPrice.textColor = [UIColor colorWithRed:188.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0];
        _fPrice.backgroundColor = [UIColor clearColor];
        [_backgroundView addSubview:_fPrice];
        
        _fTime = [[UILabel alloc] init];
        _fTime.frame = CGRectMake(0, 58, _backgroundView.frame.size.width, 20);
        //_fTime.text = @"时间：2013-06-09";
        _fTime.backgroundColor = [UIColor clearColor];
        _fTime.font = [UIFont systemFontOfSize:15];
        [_backgroundView addSubview:_fTime];
        
        _fFavourite = [[UILabel alloc] init];
        _fFavourite.frame = CGRectMake(0, 78, _backgroundView.frame.size.width, 20);
        //_fFavourite.text = @"收藏人气 1393284";
        _fFavourite.font = [UIFont systemFontOfSize:13];
        _fFavourite.textColor = [UIColor lightGrayColor];
        _fFavourite.backgroundColor = [UIColor clearColor];
        [_backgroundView addSubview:_fFavourite];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
