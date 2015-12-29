//
//  FansListCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FansListCell.h"

@implementation FansListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"3_14"];
        [self.contentView addSubview:backgroundImage];
        
        _aImageView = [[NetImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _aImageView.mDefaultImage = [UIImage imageNamed:@"default_avatar"];
        //_aImageView.image = [UIImage imageNamed:@"my_22.png"];
        [self.contentView addSubview:_aImageView];
        
        UIImageView *sepImage = [[UIImageView alloc] init];
        sepImage.frame = CGRectMake(0, 59, 320, 1);
        sepImage.image = [UIImage imageNamed:@"my_32.png"];
        [self.contentView addSubview:sepImage];
        
        _aTextLabel = [[UILabel alloc] init];
        _aTextLabel.frame = CGRectMake(60, 10, self.frame.size.width-140, 20);
        _aTextLabel.backgroundColor = [UIColor clearColor];
        //_aTextLabel.text = @"郝先生";
        _aTextLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_aTextLabel];
        
        _aDetailLabel = [[UILabel alloc] init];
        _aDetailLabel.frame = CGRectMake(60, 30, self.frame.size.width-140, 20);
        _aDetailLabel.backgroundColor = [UIColor clearColor];
        //_aDetailLabel.text = @"相信自己";
        _aDetailLabel.font = [UIFont systemFontOfSize:14];
        _aDetailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_aDetailLabel];
        
        _cancelAttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelAttBtn.frame = CGRectMake(320-80, 18, 64, 30);
        _cancelAttBtn.backgroundColor = [UIColor clearColor];
//        [_cancelAttBtn setImage:[UIImage imageNamed:@"my_38.png"] forState:UIControlStateNormal];
        [_cancelAttBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelAttBtn];
        
    }
    return self;
}

- (void)btnClick:(UIButton *)sender
{
    if (_delegate && _onButtonClick){
        SafePerformSelector([_delegate performSelector:_onButtonClick withObject:[NSNumber numberWithInt:sender.tag]]);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
