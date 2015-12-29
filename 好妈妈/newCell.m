//
//  newCell.m
//  好妈妈
//
//  Created by iHope on 13-10-23.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "newCell.h"
#import "ImageTextLabel.h"
@implementation newCell
@synthesize  timeLabel,titleLabel;
@synthesize mainImageView,upTimeLabel,areaLabel,withPlacardLabel;
@synthesize backgroundView;
@synthesize tupianImageView;
- (void)dealloc
{
    [tupianImageView release];
    [backgroundView release];
    [titleLabel release];
    [timeLabel release];
    [mainImageView release];
    [upTimeLabel release];
    [areaLabel release];
    [withPlacardLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.backImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(5, 2, (Screen_Width-10), 50)] autorelease];
        self.backImageView.userInteractionEnabled=YES;
        self.backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"002_17" ofType:@"png"]];
        [self.contentView addSubview:self.backImageView];
        self.mainImageView=[[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)] autorelease];
        self.mainImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"圈子默认" ofType:@"png"]]];
        self.mainImageView.layer.cornerRadius = 8;//设置那个圆角的有多圆
        self.mainImageView.layer.masksToBounds = YES;
        [self.backImageView addSubview:self.mainImageView];
        
        self.titleLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(53, 8, 100, 20)] autorelease];
        self.titleLabel.hangshu=YES;
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        [self.backImageView addSubview:self.titleLabel];
        self.titleLabel.m_RowHeigh=20;

        self.tupianImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(self.titleLabel.frame.size.width+self.titleLabel.frame.origin.x+5, self.titleLabel.frame.origin.y, 17.5, 13)] autorelease];
        [self.backImageView addSubview:self.tupianImageView];
        self.tupianImageView.hidden=YES;
        
        self.areaLabel=[[[UILabel alloc]initWithFrame:CGRectMake(53, 30, 65, 13)] autorelease];
        self.areaLabel.backgroundColor=[UIColor clearColor];
        self.areaLabel.font=[UIFont systemFontOfSize:12.5];
        [self.backImageView addSubview:self.areaLabel];
        self.timeLabel=[[[UILabel alloc]initWithFrame:CGRectMake(120, 33, 90, 10)] autorelease];
        self.timeLabel.backgroundColor=[UIColor clearColor];
        self.timeLabel.font=[UIFont systemFontOfSize:10];
        [self.backImageView addSubview:self.timeLabel];
        self.upTimeLabel=[[[UILabel alloc]initWithFrame:CGRectMake(212, 33, 50, 10)] autorelease];
        self.upTimeLabel.textAlignment=NSTextAlignmentRight;
        self.upTimeLabel.backgroundColor=[UIColor clearColor];
        self.upTimeLabel.font=[UIFont systemFontOfSize:10];
        [self.backImageView addSubview:self.upTimeLabel];
        UIImageView *  gentieImageView=[[UIImageView alloc]initWithFrame:CGRectMake(265, 33, 12, 10)];
        gentieImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_20" ofType:@"png"]];
        [self.backImageView addSubview:gentieImageView];
        [gentieImageView release];
        self.withPlacardLabel=[[[UILabel alloc]initWithFrame:CGRectMake(280, 33, 25, 10)] autorelease];
        self.withPlacardLabel.backgroundColor=[UIColor clearColor];
        self.withPlacardLabel.font=[UIFont systemFontOfSize:10];
        [self.backImageView addSubview:self.withPlacardLabel];
        if (ISIPAD) {
            self.backImageView.frame=CGRectMake(5*1.4, 2*1.4, (Screen_Width-10*1.4), 50*1.4);
            self.mainImageView.frame=CGRectMake(self.mainImageView.frame.origin.x*1.4, self.mainImageView.frame.origin.y*1.4, self.mainImageView.frame.size.width*1.4, self.mainImageView.frame.size.height*1.4);
            self.mainImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认" ofType:@"png"]]];

            self.titleLabel.frame=CGRectMake(self.titleLabel.frame.origin.x*1.4+30, self.titleLabel.frame.origin.y*1.4, self.titleLabel.frame.size.width*1.4, self.titleLabel.frame.size.height*1.4);
            self.tupianImageView.frame=CGRectMake(self.tupianImageView.frame.origin.x*1.4, self.tupianImageView.frame.origin.y*1.4, self.tupianImageView.frame.size.width*1.4, self.tupianImageView.frame.size.height*1.4);
            self.areaLabel.frame=CGRectMake(self.areaLabel.frame.origin.x*1.4, self.areaLabel.frame.origin.y*1.4, self.areaLabel.frame.size.width*1.4, self.areaLabel.frame.size.height*1.4);
            self.timeLabel.frame=CGRectMake(self.timeLabel.frame.origin.x*1.4, self.timeLabel.frame.origin.y*1.4, self.timeLabel.frame.size.width*1.4, self.timeLabel.frame.size.height*1.4);
            self.upTimeLabel.frame=CGRectMake(self.upTimeLabel.frame.origin.x*1.4, self.upTimeLabel.frame.origin.y*1.4, self.upTimeLabel.frame.size.width*1.4, self.upTimeLabel.frame.size.height*1.4);
            self.withPlacardLabel.frame=CGRectMake(self.withPlacardLabel.frame.origin.x*1.4, self.withPlacardLabel.frame.origin.y*1.4, self.withPlacardLabel.frame.size.width*1.4, self.withPlacardLabel.frame.size.height*1.4);

            gentieImageView.frame=CGRectMake(gentieImageView.frame.origin.x*1.4, gentieImageView.frame.origin.y*1.4, gentieImageView.frame.size.width*1.4, gentieImageView.frame.size.height*1.4);
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
