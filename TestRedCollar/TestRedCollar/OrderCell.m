//
//  OrderCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

@synthesize backgroundView = _backgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 110)];
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
        
        _image = [[NetImageView alloc] init];
        _image.frame = CGRectMake(15, 15, 60, 80);
        //_image.frame = CGRectZero;
        //_image.image = [UIImage imageNamed:@"my_17.png"];
        _image.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_image];
        
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.frame = CGRectMake(110, 0, backgroundImage.frame.size.width-110, backgroundImage.frame.size.height);
        _backgroundView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_backgroundView];
        
        _consignee = [[UILabel alloc] init];
        _consignee.frame = CGRectMake(0, 14, _backgroundView.frame.size.width, 20);
        //_consignee.text = @"收货人：李红卫";
        _consignee.backgroundColor = [UIColor clearColor];
        _consignee.font = [UIFont systemFontOfSize:16];
        [_backgroundView addSubview:_consignee];
        
//        _money = [[UILabel alloc] init];
//        _money.frame = CGRectMake(260, 14, 68, 20);
//        //_money.text = @"￥3280";
//        _money.font = [UIFont systemFontOfSize:14.5];
//        [self.contentView addSubview:_money];
        
        _orderMoney = [[UILabel alloc] init];
        _orderMoney.frame = CGRectMake(0, 36, _backgroundView.frame.size.width, 20);
        //_orderMoney.text = @"订单金额：￥2343（在线支付）";
        _orderMoney.backgroundColor = [UIColor clearColor];
        _orderMoney.font = [UIFont systemFontOfSize:14];
        [_backgroundView addSubview:_orderMoney];
        
        _time = [[UILabel alloc] init];
        _time.frame = CGRectMake(0, 58, _backgroundView.frame.size.width, 20);
        //_time.text = @"时间：2013-06-09";
        _time.font = [UIFont systemFontOfSize:14.5];
        _time.backgroundColor = [UIColor clearColor];
        [_backgroundView addSubview:_time];
        
        _status = [[UILabel alloc] init];
        _status.frame = CGRectMake(0, 78, _backgroundView.frame.size.width, 20);
        //_status.text = @"状态：完成";
        _status.backgroundColor = [UIColor clearColor];
        _status.font = [UIFont systemFontOfSize:14.5];
        [_backgroundView addSubview:_status];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
