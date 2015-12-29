//
//  UserAddressListCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserAddressListCell.h"

@implementation UserAddressListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 59)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"f_whiteback"];
        [self.contentView addSubview:backgroundImage];
        
        _checkImage = [[UIImageView alloc] init];
        _checkImage.frame = CGRectMake(15, 19, 20, 20);
        _checkImage.backgroundColor = [UIColor clearColor];
        _checkImage.image = [UIImage imageNamed:@"check_red.png"];
        _checkImage.hidden = YES;
        [self.contentView addSubview:_checkImage];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(320-50, 7, 44, 44);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        UIImageView *infoImage = [[UIImageView alloc] init];
        infoImage.frame = btn.bounds;
        infoImage.image = [UIImage imageNamed:@"button_info.png"];
        [btn addSubview:infoImage];
        
        _userName = [[UILabel alloc] init];
        _userName.frame = CGRectMake(50, 4, 120, 30);
        _userName.font = [UIFont systemFontOfSize:18];
        _userName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userName];
        
        _userAddress = [[UILabel alloc] init];
        _userAddress.frame = CGRectMake(50, 33, 220, 20);
        _userAddress.font = [UIFont systemFontOfSize:15];
        _userAddress.textColor = WORDGRAYCOLOR;
        _userAddress.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userAddress];
        
    }
    return self;
}

- (void)btnClick:(UIButton *)sender
{
    if (_delegate && _onButtonClick) {
        SafePerformSelector([_delegate performSelector:_onButtonClick withObject:[NSNumber numberWithInt:sender.tag]]);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
