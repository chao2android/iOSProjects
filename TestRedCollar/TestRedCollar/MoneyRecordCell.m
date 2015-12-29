//
//  MoneyRecordCell.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MoneyRecordCell.h"

@implementation MoneyRecordCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetInfoDict:(NSDictionary*)aDict{
    _theOneLabel.text=aDict[@"one"];
    _theTwoLabel.text=aDict[@"two"];
    _theThreeLabel.text=aDict[@"three"];
}

@end
