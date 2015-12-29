//
//  UserInfoCell.m
//  TestRedCollar
//
//  Created by miracle on 14-8-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

@synthesize nextImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
                
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 46)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"f_whiteback"];
        [self.contentView addSubview:backgroundImage];
        
        nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 6, 11)];
        nextImage.backgroundColor = [UIColor clearColor];
        nextImage.image = [UIImage imageNamed:@"my_08"];
        [backgroundImage addSubview:nextImage];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tag:(NSInteger)firstTag
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (firstTag == 0){
            UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,80)];
            backgroundImage.backgroundColor = [UIColor clearColor];
            backgroundImage.image = [UIImage imageNamed:@"3_14"];
            [self.contentView addSubview:backgroundImage];
            
            UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
            lineImage.backgroundColor = [UIColor clearColor];
            lineImage.image = [UIImage imageNamed:@"51"];
            [self.contentView addSubview:lineImage];
            
            nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 35, 6, 11)];
            nextImage.backgroundColor = [UIColor clearColor];
            nextImage.image = [UIImage imageNamed:@"my_08"];
            [backgroundImage addSubview:nextImage];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
