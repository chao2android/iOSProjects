//
//  ShoppingCarCell.m
//  TestRedCollar
//
//  Created by MC on 14-7-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShoppingCarCell.h"

@implementation ShoppingCarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 5, 60, 80)];
    imgView.backgroundColor = [UIColor redColor];
    [self addSubview:imgView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
