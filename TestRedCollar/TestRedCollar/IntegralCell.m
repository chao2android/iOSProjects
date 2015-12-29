//
//  IntegralCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "IntegralCell.h"

@implementation IntegralCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_50.png"]];
        imageView.frame = CGRectMake(0, 0, 320, 100);
        imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:imageView];
        
        for (int i = 0; i < 3; i++)
        {
            UILabel *myLabel = [[UILabel alloc] init];
            myLabel.frame = CGRectMake(15, 10+i*25, 75, 28);
            if (i == 0)
            {
                myLabel.text = @"获取积分:";
            }
            else if (i == 1)
            {
                myLabel.text = @"消费积分:";
            }
//            else if (i == 2)
//            {
//                myLabel.text = @"积分类型:";
//            }
            else
            {
                myLabel.text = @"积分详情:";
            }
            myLabel.textColor = WORDGRAYCOLOR;
            myLabel.font = [UIFont systemFontOfSize:16];
            myLabel.backgroundColor = [UIColor clearColor];
            [imageView addSubview:myLabel];
        }
        
        _getIntegral = [[UILabel alloc] init];
        _getIntegral.frame = CGRectMake(90, 10, 200, 28);
        _getIntegral.textColor = WORDGRAYCOLOR;
        _getIntegral.font = [UIFont systemFontOfSize:16];
        _getIntegral.backgroundColor = [UIColor clearColor];
        [imageView addSubview:_getIntegral];
        
        _loseIntegral = [[UILabel alloc] init];
        _loseIntegral.frame = CGRectMake(90, 35, 200, 28);
        _loseIntegral.textColor = WORDGRAYCOLOR;
        _loseIntegral.font = [UIFont systemFontOfSize:16];
        _loseIntegral.backgroundColor = [UIColor clearColor];
        [imageView addSubview:_loseIntegral];
        
//        _integralType = [[UILabel alloc] init];
//        _integralType.frame = CGRectMake(90, 60, 200, 28);
//        _integralType.textColor = WORDGRAYCOLOR;
//        _integralType.font = [UIFont systemFontOfSize:16];
//        _integralType.backgroundColor = [UIColor clearColor];
//        [imageView addSubview:_integralType];
        
        _integralDetail = [[UILabel alloc] init];
        _integralDetail.frame = CGRectMake(90, 60, 200, 28);
        _integralDetail.textColor = WORDGRAYCOLOR;
        _integralDetail.font = [UIFont systemFontOfSize:16];
        _integralDetail.backgroundColor = [UIColor clearColor];
        [imageView addSubview:_integralDetail];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
