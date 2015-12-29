//
//  TuijianquanziCell.m
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 1510Cloud. All rights reserved.
//

#import "TuijianquanziCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation TuijianquanziCell
@synthesize mainImageView,titleLabel,symbolButton,synopsisLabel;
@synthesize numLabel;
@synthesize tishiImageView;
- (void)dealloc
{
    [numLabel release];
    [mainImageView release];
    [titleLabel release];
    [synopsisLabel release];
    [symbolButton release];
    [tishiImageView release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];

        UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-(Screen_Width-10))/2, 1, Screen_Width-10, 53)];
        backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"002_17" ofType:@"png"]];
        backImageView.userInteractionEnabled=YES;
        [self.contentView addSubview:backImageView];
        [backImageView release];
        
        self.mainImageView=[[[AsyncImageView alloc]initWithFrame:CGRectMake(7, (53-40)/2, 40, 40)] autorelease];
        self.mainImageView.layer.cornerRadius=5;
        [self.mainImageView.layer setMasksToBounds:YES];
        [backImageView addSubview:self.mainImageView];
        self.titleLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(53, 8, Screen_Width-160, 20)] autorelease];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        self.titleLabel.m_Font=[UIFont systemFontOfSize:16];
        [backImageView addSubview:self.titleLabel];
        self.numLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.frame.size.width+self.titleLabel.frame.origin.x+20, 8, Screen_Width-self.titleLabel.frame.size.width-self.titleLabel.frame.origin.x-35, 13)] autorelease];
        self.numLabel.backgroundColor=[UIColor clearColor];
        self.numLabel.alpha=0.8;
        self.numLabel.font=[UIFont systemFontOfSize:10];
        [backImageView addSubview:self.numLabel];
        self.synopsisLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(53, 33, Screen_Width-130, 10)] autorelease];
        self.synopsisLabel.backgroundColor=[UIColor clearColor];
        self.synopsisLabel.m_Font=[UIFont systemFontOfSize:10];
        [backImageView addSubview:self.synopsisLabel];
        self.symbolButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.symbolButton.frame=CGRectMake(backImageView.frame.size.width-30, 25, 30, 26.5);
        [backImageView addSubview:self.symbolButton];
        self.tishiImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(self.titleLabel.frame.size.width+self.titleLabel.frame.origin.x+2, self.titleLabel.frame.origin.y, 16, 16)] autorelease];
        self.tishiImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"03引导" ofType:@"png"]];
        [backImageView addSubview:self.tishiImageView];
        self.tishiImageView.hidden=YES;
        if (ISIPAD) {
            backImageView.frame=CGRectMake(backImageView.frame.origin.x*1.4, backImageView.frame.origin.y*1.4, Screen_Width-backImageView.frame.origin.x*1.4*2, backImageView.frame.size.height*1.4);
            self.mainImageView.frame=CGRectMake(self.mainImageView.frame.origin.x*1.4, self.mainImageView.frame.origin.y*1.4, self.mainImageView.frame.size.width*1.4, self.mainImageView.frame.size.height*1.4);

            self.titleLabel.frame=CGRectMake(self.titleLabel.frame.origin.x*1.4, self.titleLabel.frame.origin.y*1.4, Screen_Width-160*1.4, self.titleLabel.frame.size.height*1.4);
            self.tishiImageView.frame=CGRectMake(self.titleLabel.frame.size.width+self.titleLabel.frame.origin.x+2, 10, self.tishiImageView.frame.size.width, self.tishiImageView.frame.size.height);
            
            self.titleLabel.m_Font=[UIFont systemFontOfSize:16*1.25];
            self.numLabel.frame=CGRectMake(self.titleLabel.frame.size.width+self.titleLabel.frame.origin.x+20, 10, 110, 13*1.4);
            self.numLabel.font=[UIFont systemFontOfSize:10*1.4];

            self.symbolButton.frame=CGRectMake(backImageView.frame.size.width-30*1.4, 25*1.4, 30*1.4, 26.5*1.4);

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
