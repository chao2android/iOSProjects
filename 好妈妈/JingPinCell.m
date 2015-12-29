//
//  JingPinCell.m
//  好妈妈
//
//  Created by iHope on 14-1-15.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "JingPinCell.h"

@implementation JingPinCell
@synthesize iconImageView1,iconImageView2,iconImageView3;
@synthesize titleLabel1,titleLabel2,titleLabel3;
- (void)dealloc
{
    self.iconImageView1=nil;
    self.iconImageView2=nil;
    self.iconImageView3=nil;
    self.titleLabel1=nil;
    self.titleLabel2=nil;
    self.titleLabel3=nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];

        self.iconImageView1=[[[AsyncImageView alloc]initWithFrame:CGRectMake(20, 2, 80, 80)] autorelease];
        [self.contentView addSubview:self.iconImageView1];
        self.titleLabel1=[[[UILabel alloc]initWithFrame:CGRectMake(20, 82, 80, 20)] autorelease];
        self.titleLabel1.backgroundColor=[UIColor clearColor];
        self.titleLabel1.textColor=[UIColor blackColor];
        self.titleLabel1.textAlignment=UITextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel1];
        
        self.iconImageView2=[[[AsyncImageView alloc] initWithFrame:CGRectMake(120, 2, 80, 80)] autorelease];
        [self.contentView addSubview:self.iconImageView2];
        
        self.titleLabel2=[[[UILabel alloc] initWithFrame:CGRectMake(120, 82, 80, 20)] autorelease];
        self.titleLabel2.backgroundColor=[UIColor clearColor];
        self.titleLabel2.textColor=[UIColor blackColor];
        self.titleLabel2.textAlignment=UITextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel2];
        self.iconImageView3=[[[AsyncImageView alloc] initWithFrame:CGRectMake(220, 2, 80, 80)] autorelease];
        [self.contentView addSubview:self.iconImageView3];
        
        self.titleLabel3=[[[UILabel alloc] initWithFrame:CGRectMake(220, 82, 80, 20)] autorelease];
        self.titleLabel3.backgroundColor=[UIColor clearColor];
        self.titleLabel3.textColor=[UIColor blackColor];
        self.titleLabel3.textAlignment=UITextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel3];
        if (ISIPAD) {
            self.iconImageView1.frame=CGRectMake(self.iconImageView1.frame.origin.x*1.4, self.iconImageView1.frame.origin.y*1.4, self.iconImageView1.frame.size.width*1.4, self.iconImageView1.frame.size.height*1.4);
            self.iconImageView2.frame=CGRectMake(self.iconImageView2.frame.origin.x*1.4, self.iconImageView2.frame.origin.y*1.4, self.iconImageView2.frame.size.width*1.4, self.iconImageView2.frame.size.height*1.4);
            self.iconImageView3.frame=CGRectMake(self.iconImageView3.frame.origin.x*1.4, self.iconImageView3.frame.origin.y*1.4, self.iconImageView3.frame.size.width*1.4, self.iconImageView3.frame.size.height*1.4);

            
            self.titleLabel1.frame=CGRectMake(self.titleLabel1.frame.origin.x*1.4, self.titleLabel1.frame.origin.y*1.4, self.titleLabel1.frame.size.width*1.4, self.titleLabel1.frame.size.height*1.4);

            self.titleLabel2.frame=CGRectMake(self.titleLabel2.frame.origin.x*1.4, self.titleLabel2.frame.origin.y*1.4, self.titleLabel2.frame.size.width*1.4, self.titleLabel2.frame.size.height*1.4);

            self.titleLabel3.frame=CGRectMake(self.titleLabel3.frame.origin.x*1.4, self.titleLabel3.frame.origin.y*1.4, self.titleLabel3.frame.size.width*1.4, self.titleLabel3.frame.size.height*1.4);

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
