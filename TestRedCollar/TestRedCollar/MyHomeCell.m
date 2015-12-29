//
//  MyHomeCell.m
//  TestRedCollar
//
//  Created by miracle on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MyHomeCell.h"

@implementation MyHomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 46)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"f_whiteback"];
        [self.contentView addSubview:backgroundImage];
        
        _myImage = [[UIImageView alloc] init];
        _myImage.frame = CGRectMake(20, 12, 20, 20);
        [backgroundImage addSubview:_myImage];
        
        _myLabel = [[UILabel alloc] init];
        _myLabel.frame = CGRectMake(50, 11, 100, 22);
        _myLabel.font = [UIFont systemFontOfSize:18];
        _myLabel.backgroundColor = [UIColor clearColor];
        
        [backgroundImage addSubview:_myLabel];
        
        UIImageView *nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 6, 11)];
        nextImage.backgroundColor = [UIColor clearColor];
        nextImage.image = [UIImage imageNamed:@"my_08"];
        [backgroundImage addSubview:nextImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
