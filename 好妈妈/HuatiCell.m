//
//  HuatiCell.m
//  好妈妈
//
//  Created by iHope on 13-9-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "HuatiCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageTextLabel.h"
@implementation HuatiCell
@synthesize titleLabel,timeLabel,contentLabel,mainImageView;
@synthesize xingImageView,xingLabel,pinglunImageView,pinglunLabel;
@synthesize backImageView;
@synthesize qzNameLabel;
- (void)dealloc
{
    [qzNameLabel release];
    [backImageView release];
    [titleLabel release];
    [timeLabel release];
    [contentLabel release];
    [mainImageView release];
    [xingImageView release];
    [xingLabel release];
    [pinglunImageView release];
    [pinglunLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];

       self.backImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(5, 2, Screen_Width-10, 50)] autorelease];
        self.backImageView.userInteractionEnabled=YES;
        self.backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"002_17" ofType:@"png"]];
        [self.contentView addSubview:self.backImageView];
        
        self.titleLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(5, 5, 250, 20)] autorelease];
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        [self.backImageView addSubview:self.titleLabel];
        
        self.timeLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.y, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y+8, 60, 12)] autorelease];
        self.timeLabel.alpha=0.8;
        self.timeLabel.textColor=[UIColor blackColor];
        self.timeLabel.backgroundColor=[UIColor clearColor];
        self.timeLabel.font=[UIFont systemFontOfSize:10];
        [backImageView addSubview:self.timeLabel];
        self.qzNameLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.timeLabel.frame.origin.x+self.timeLabel.frame.size.width+2, self.timeLabel.frame.origin.y-4, 100, 14)] autorelease];
        self.qzNameLabel.alpha=0.85;
        self.qzNameLabel.textColor=[UIColor blackColor];
        self.qzNameLabel.backgroundColor=[UIColor clearColor];
        self.qzNameLabel.font=[UIFont systemFontOfSize:13];
        [backImageView addSubview:self.qzNameLabel];

        self.contentLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.timeLabel.frame.size.width+self.timeLabel.frame.origin.x, self.timeLabel.frame.origin.y, 120, 12)] autorelease];
        self.contentLabel.alpha=0.8;
        self.contentLabel.textColor=[UIColor blackColor];
        self.contentLabel.backgroundColor=[UIColor clearColor];
        self.contentLabel.font=[UIFont systemFontOfSize:10];
        [backImageView addSubview:self.contentLabel];
        UIImage * xingImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_30" ofType:@"png"]];
        self.xingImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-150, self.contentLabel.frame.origin.y, xingImage.size.width/2, xingImage.size.height/2)] autorelease];
        self.xingImageView.image=xingImage;
        [xingImage release];
        [backImageView addSubview:self.xingImageView];
        
        self.xingLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.xingImageView.frame.size.width+self.xingImageView.frame.origin.x, self.xingImageView.frame.origin.y-(xingImageView.frame.size.height-12), 20, 12)] autorelease];
        self.xingLabel.alpha=0.8;
        self.xingLabel.textColor=[UIColor blackColor];
        self.xingLabel.backgroundColor=[UIColor clearColor];
        self.xingLabel.font=[UIFont systemFontOfSize:10];
        [backImageView addSubview:self.xingLabel];
        
        UIImage * pinglunImage=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_20" ofType:@"png"]];
        self.pinglunImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(self.xingLabel.frame.size.width+self.xingLabel.frame.origin.x, xingImageView.frame.origin.y+2, pinglunImage.size.width/2, pinglunImage.size.height/2)] autorelease];
        self.pinglunImageView.image=pinglunImage;
        [pinglunImage release];
        [backImageView addSubview:self.pinglunImageView];
        
        self.pinglunLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.pinglunImageView.frame.size.width+self.pinglunImageView.frame.origin.x+2, self.pinglunImageView.frame.origin.y-(pinglunImageView.frame.size.height-12)-4, 20, 12)] autorelease];
        self.pinglunLabel.alpha=0.8;
        self.pinglunLabel.textColor=[UIColor blackColor];
        self.pinglunLabel.backgroundColor=[UIColor clearColor];
        self.pinglunLabel.font=[UIFont systemFontOfSize:10];
        [backImageView addSubview:self.pinglunLabel];
        
        self.mainImageView=[[[AsyncImageView alloc]initWithFrame:CGRectMake(backImageView.frame.size.width-45, 5, 40, 40)] autorelease];
        self.mainImageView.image=[UIImage imageNamed:@"默认.png"];
        [backImageView addSubview:self.mainImageView];
        if (ISIPAD) {
            backImageView.frame=CGRectMake(5*1.4, 2*1.4, Screen_Width-5*1.4*2, 50*1.4);
            self.titleLabel.frame=CGRectMake(self.titleLabel.frame.origin.x*1.4, self.titleLabel.frame.origin.y*1.4, self.titleLabel.frame.size.width*1.4, self.titleLabel.frame.size.height*1.4);
            self.titleLabel.m_Font=[UIFont systemFontOfSize:20];
            self.timeLabel.frame=CGRectMake(self.timeLabel.frame.origin.x*1.4, self.timeLabel.frame.origin.y*1.4, self.timeLabel.frame.size.width*1.4, self.timeLabel.frame.size.height*1.4);
            self.timeLabel.font=[UIFont systemFontOfSize:10*1.4];
            
            self.qzNameLabel.frame=CGRectMake(self.qzNameLabel.frame.origin.x*1.4, self.qzNameLabel.frame.origin.y*1.4, self.qzNameLabel.frame.size.width*1.4, self.qzNameLabel.frame.size.height*1.4);
            self.qzNameLabel.font=[UIFont systemFontOfSize:13*1.4];

            self.contentLabel.frame=CGRectMake(self.contentLabel.frame.origin.x*1.4, self.contentLabel.frame.origin.y*1.4, self.contentLabel.frame.size.width*1.4, self.contentLabel.frame.size.height*1.4);
            self.contentLabel.font=[UIFont systemFontOfSize:10*1.4];

            self.xingImageView.frame=CGRectMake(Screen_Width-150*1.4, self.xingImageView.frame.origin.y*1.4, self.xingImageView.frame.size.width*1.4, self.xingImageView.frame.size.height*1.4);
            self.xingLabel.frame=CGRectMake(self.xingLabel.frame.origin.x-50, self.xingLabel.frame.origin.y*1.4, self.xingLabel.frame.size.width*1.4, self.xingLabel.frame.size.height*1.4);
            self.xingLabel.font=[UIFont systemFontOfSize:10*1.4];
            self.pinglunImageView.frame=CGRectMake(self.pinglunImageView.frame.origin.x-40, self.pinglunImageView.frame.origin.y*1.4, self.pinglunImageView.frame.size.width*1.4, self.pinglunImageView.frame.size.height*1.4);
            self.pinglunLabel.frame=CGRectMake(self.pinglunLabel.frame.origin.x-30, self.pinglunLabel.frame.origin.y*1.4, self.pinglunLabel.frame.size.width*1.4, self.pinglunLabel.frame.size.height*1.4);
            self.pinglunLabel.font=[UIFont systemFontOfSize:10*1.4];

            self.mainImageView.frame=CGRectMake(backImageView.frame.size.width-45*1.4, 5*1.4, 40*1.4, 40*1.4);




            
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
