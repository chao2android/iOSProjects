//
//  PinglunCell.m
//  好妈妈
//
//  Created by iHope on 13-10-30.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "PinglunCell.h"
#import "ImageTextLabel.h"
#import "AsyncImageView.h"
@implementation PinglunCell
@synthesize touxiangImageView,timeLabel,titleLabel;
@synthesize contentLabel,typeLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.backImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 2.5, Screen_Width, 65)] autorelease];
        self.backImageView.userInteractionEnabled=YES;
        [self.contentView addSubview:self.backImageView];
        
        self.touxiangImageView=[[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)] autorelease];
        [self.backImageView addSubview:self.touxiangImageView];
        
        
        self.titleLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.touxiangImageView.frame.origin.x+self.touxiangImageView.frame.size.width+10, 10, 100, 20)] autorelease];
        self.titleLabel.font=[UIFont systemFontOfSize:18];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.typeLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width, 11.5, 100, 15)] autorelease];
        self.typeLabel.backgroundColor=[UIColor clearColor];
        self.typeLabel.font=[UIFont systemFontOfSize:13.5];
        [self.contentView addSubview:self.typeLabel];
        
        self.contentLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, 255, 20)] autorelease];
        self.contentLabel.textColor=[UIColor blackColor];
        self.contentLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.touxiangImageView.frame.origin.x+self.touxiangImageView.frame.size.width+10, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+40, 100, 15)] autorelease];
        
        self.timeLabel.backgroundColor=[UIColor clearColor];
        self.timeLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.timeLabel];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
