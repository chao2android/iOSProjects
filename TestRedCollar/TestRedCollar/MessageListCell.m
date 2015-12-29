//
//  MessageListCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-20.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 66)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"3_14"];
        [self.contentView addSubview:backgroundImage];
        
        UIImageView *sepImage = [[UIImageView alloc] init];
        sepImage.frame = CGRectMake(0, 65, 320, 1);
        sepImage.image = [UIImage imageNamed:@"my_32.png"];
        sepImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:sepImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
        //_titleLabel.text = @"欢迎加入RCTAILOR西装定制";
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 40, 80, 20)];
        //_timeLabel.text = @"2014-03-03";
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = WORDGRAYCOLOR;
        [self.contentView addSubview:_timeLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
