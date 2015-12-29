//
//  OrderListCell.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)theButtonClick:(id)sender {
    if (_delegate && _onButtonClick) {
        
        [_delegate performSelector:_onButtonClick];
    }
}

@end
