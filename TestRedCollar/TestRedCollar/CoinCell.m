//
//  CoinCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoinCell.h"

@implementation CoinCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_50.png"]];
        imageView.frame = CGRectMake(0, 0, 320, 120);
        imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageView];
        
        for (int i = 0; i < 4; i++)
        {
            UILabel *myLabel = [[UILabel alloc] init];
            myLabel.frame = CGRectMake(15, 10+i*25, 90, 28);
            if (i == 0)
            {
                myLabel.text = @"收益酷特币:";
            }
            else if (i == 1)
            {
                myLabel.text = @"消费酷特币:";
            }
            else if (i == 2)
            {
                myLabel.text = @"酷特币类型:";
            }
            else
            {
                myLabel.text = @"酷特币详情:";
            }
            myLabel.textColor = WORDGRAYCOLOR;
            myLabel.font = [UIFont systemFontOfSize:16];
            myLabel.backgroundColor = [UIColor clearColor];
            [imageView addSubview:myLabel];
        }
        int ipointX = 105;
        int iWidth = 190;
        int iHeight = 28;
        _getCoin = [[UILabel alloc] init];
        _getCoin.frame = CGRectMake(ipointX, 10, iWidth, iHeight);
        _getCoin.textColor = WORDGRAYCOLOR;
        _getCoin.font = [UIFont systemFontOfSize:16];
        _getCoin.backgroundColor = [UIColor clearColor];
        [imageView addSubview:_getCoin];
        
        _loseCoin = [[UILabel alloc] init];
        _loseCoin.frame = CGRectMake(ipointX, 35, iWidth, iHeight);
        _loseCoin.textColor = WORDGRAYCOLOR;
        _loseCoin.font = [UIFont systemFontOfSize:16];
        _loseCoin.backgroundColor = [UIColor clearColor];
        [imageView addSubview:_loseCoin];
        
        _coinType = [[UILabel alloc] init];
        _coinType.frame = CGRectMake(ipointX, 60, iWidth, iHeight);
        _coinType.textColor = WORDGRAYCOLOR;
        _coinType.font = [UIFont systemFontOfSize:16];
        _coinType.backgroundColor = [UIColor clearColor];
        [imageView addSubview:_coinType];
        
        _coinDetail = [[UILabel alloc] init];
        _coinDetail.frame = CGRectMake(ipointX, 85, iWidth, iHeight);
        _coinDetail.textColor = WORDGRAYCOLOR;
        _coinDetail.font = [UIFont systemFontOfSize:16];
        _coinDetail.backgroundColor = [UIColor clearColor];
        [imageView addSubview:_coinDetail];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
