//
//  HowGetMoneyCell.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "HowGetMoneyCell.h"

@implementation HowGetMoneyCell

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
    _theLeftLabel.text=aDict[@"one"];
    _theRightLabel.text=aDict[@"two"];
}

@end
