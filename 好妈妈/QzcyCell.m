//
//  QzcyCell.m
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "QzcyCell.h"

@implementation QzcyCell
@synthesize  mainImageView,titleLabel,subLabel;
@synthesize timeLabel,qzLabel,gzLabel,fsLabel,scLabel;
@synthesize cellButton;
@synthesize guanzhuButton;
@synthesize tiaojianLabel;
- (void)dealloc
{
    [tiaojianLabel release];
    [cellButton release];
    [mainImageView release];
    [timeLabel release];
    [titleLabel release];
    [subLabel release];
    [qzLabel release];
    [gzLabel release];
    [fsLabel release];
    [scLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];

        self.mainImageView=[[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 61, 61)] autorelease];
        self.mainImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认" ofType:@"png"]]];
        [self.contentView addSubview:self.mainImageView];
        
        self.titleLabel=[[[UILabel alloc]initWithFrame:CGRectMake(72.5, 6, 85, 20)] autorelease];
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        self.titleLabel.font=[UIFont systemFontOfSize:15.5];
        [self.contentView addSubview:self.titleLabel];
        
        self.tiaojianLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.frame.size.width+self.titleLabel.frame.origin.x+5, 10, 55, 16)] autorelease];
        self.tiaojianLabel.textColor=[UIColor blackColor];
        self.tiaojianLabel.backgroundColor=[UIColor clearColor];
        self.tiaojianLabel.font=[UIFont systemFontOfSize:11.5];
        [self.contentView addSubview:self.tiaojianLabel];
        
        self.timeLabel=[[[UILabel alloc] initWithFrame:CGRectMake(self.tiaojianLabel.frame.origin.x+self.tiaojianLabel.frame.size.width+1, self.titleLabel.frame.origin.y+5, 100, 13)] autorelease];
        self.timeLabel.textAlignment=UITextAlignmentCenter;
        self.timeLabel.textColor=[UIColor colorWithRed:214/255.0 green:40/255.0 blue:39/255.0 alpha:1];
        self.timeLabel.backgroundColor=[UIColor clearColor];
        self.timeLabel.font=[UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.timeLabel];
        
        self.subLabel=[[[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x+2, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y+5, Screen_Width-self.titleLabel.frame.origin.x-20, 17)] autorelease];
        self.subLabel.font=[UIFont systemFontOfSize:13];
        self.subLabel.alpha=0.6;
        self.subLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.subLabel];
        
        for (int i=0; i<4; i++) {
            UIImage * Image=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"002_%d",i+27] ofType:@"png"]];
            
            UIImageView * ImageView=[[UIImageView alloc]init];
            if (i==3) {
                ImageView.frame=CGRectMake(75.5+i*57, self.subLabel.frame.size.height+self.subLabel.frame.origin.y+3, Image.size.width/2, Image.size.height/2);
            }
            else
            {
               
                ImageView.frame=CGRectMake(75.5+i*57, self.subLabel.frame.size.height+self.subLabel.frame.origin.y+5, Image.size.width/2, Image.size.height/2);
            }
            if (ISIPAD) {
                ImageView.frame=CGRectMake(ImageView.frame.origin.x*1.4, ImageView.frame.origin.y*1.4, ImageView.frame.size.width*1.4, ImageView.frame.size.height*1.4);
            }
            ImageView.backgroundColor=[UIColor clearColor];
            ImageView.image=Image;
            [Image release];
            [self.contentView addSubview:ImageView];
            [ImageView release];
            if (i==0) {
                self.qzLabel=[[[UILabel alloc]initWithFrame:CGRectMake(ImageView.frame.origin.x+ImageView.frame.size.width+2, ImageView.frame.origin.y+(ImageView.frame.size.height-12)+1, 63.5-ImageView.frame.size.width-4, 12)] autorelease];
                self.qzLabel.font=[UIFont systemFontOfSize:10];
                if (ISIPAD) {
                    self.qzLabel.frame=CGRectMake(self.qzLabel.frame.origin.x, self.qzLabel.frame.origin.y, self.qzLabel.frame.size.width*1.4, self.qzLabel.frame.size.height*1.4);
                    self.qzLabel.font=[UIFont systemFontOfSize:10*1.4];

                }
                self.qzLabel.backgroundColor=[UIColor clearColor];
                [self.contentView addSubview:self.qzLabel];
            }
            else if (i==1)
            {
                self.gzLabel=[[[UILabel alloc]initWithFrame:CGRectMake(ImageView.frame.origin.x+ImageView.frame.size.width+2, ImageView.frame.origin.y+(ImageView.frame.size.height-12)+1, 57-ImageView.frame.size.width-4, 12)] autorelease];
                self.gzLabel.font=[UIFont systemFontOfSize:10];
                self.gzLabel.backgroundColor=[UIColor clearColor];
                [self.contentView addSubview:self.gzLabel];
                if (ISIPAD) {
                    self.gzLabel.frame=CGRectMake(self.gzLabel.frame.origin.x, self.gzLabel.frame.origin.y, self.gzLabel.frame.size.width*1.4, self.gzLabel.frame.size.height*1.4);
                    self.gzLabel.font=[UIFont systemFontOfSize:10*1.4];
                    
                }
            }
            else if (i==2)
            {
                self.fsLabel=[[[UILabel alloc]initWithFrame:CGRectMake(ImageView.frame.origin.x+ImageView.frame.size.width+2, ImageView.frame.origin.y+(ImageView.frame.size.height-12)+1, 57-ImageView.frame.size.width-4, 12)] autorelease];
                self.fsLabel.font=[UIFont systemFontOfSize:10];
                self.fsLabel.backgroundColor=[UIColor clearColor];
                [self.contentView addSubview:self.fsLabel];
                if (ISIPAD) {
                    self.fsLabel.frame=CGRectMake(self.fsLabel.frame.origin.x, self.fsLabel.frame.origin.y, self.fsLabel.frame.size.width*1.4, self.fsLabel.frame.size.height*1.4);
                    self.fsLabel.font=[UIFont systemFontOfSize:10*1.4];
                    
                }
            }
            else
            {
                self.scLabel=[[[UILabel alloc]initWithFrame:CGRectMake(ImageView.frame.origin.x+ImageView.frame.size.width+2, ImageView.frame.origin.y+(ImageView.frame.size.height-12)+2, 57-ImageView.frame.size.width-4, 12)] autorelease];
                self.scLabel.font=[UIFont systemFontOfSize:10];
                self.scLabel.backgroundColor=[UIColor clearColor];
                [self.contentView addSubview:self.scLabel];
                if (ISIPAD) {
                    self.scLabel.frame=CGRectMake(self.scLabel.frame.origin.x, self.scLabel.frame.origin.y, self.scLabel.frame.size.width*1.4, self.scLabel.frame.size.height*1.4);
                    self.scLabel.font=[UIFont systemFontOfSize:10*1.4];
                    
                }
            }
        }
        
        UIImageView * lineImageViwe=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70.5, Screen_Width, 1)];
        lineImageViwe.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"line" ofType:@"png"]];
        [self.contentView addSubview:lineImageViwe];
        [lineImageViwe release];
     
        self.cellButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.cellButton.frame=CGRectMake(0, 0, Screen_Width, 71.5);
       
        [self.contentView addSubview:self.cellButton];
        
        self.guanzhuButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.guanzhuButton.frame=CGRectMake(Screen_Width-55, 24, 40, 28);
        [self.contentView addSubview:self.guanzhuButton];
        if (ISIPAD) {
            self.mainImageView.frame=CGRectMake(self.mainImageView.frame.origin.x*1.4, self.mainImageView.frame.origin.y*1.4, self.mainImageView.frame.size.width*1.4, self.mainImageView.frame.size.height*1.4);
            self.mainImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认85" ofType:@"png"]]];

            lineImageViwe.frame=CGRectMake(0, 71.5*1.4-1, Screen_Width, 1);
            self.titleLabel.frame=CGRectMake(self.titleLabel.frame.origin.x*1.4, self.titleLabel.frame.origin.y*1.4, self.titleLabel.frame.size.width*1.4, self.titleLabel.frame.size.height*1.4);
            self.titleLabel.font=[UIFont systemFontOfSize:15.5*1.4];
            self.subLabel.frame=CGRectMake(self.subLabel.frame.origin.x*1.4, self.subLabel.frame.origin.y*1.4, self.subLabel.frame.size.width*1.4, self.subLabel.frame.size.height*1.4);
            self.subLabel.font=[UIFont systemFontOfSize:13*1.4];
            self.timeLabel.frame=CGRectMake(self.timeLabel.frame.origin.x*1.4, self.timeLabel.frame.origin.y*1.4, self.subLabel.frame.size.width*1.4, self.subLabel.frame.size.height*1.4);
            self.timeLabel.font=[UIFont systemFontOfSize:11*1.4];
            self.guanzhuButton.frame=CGRectMake(Screen_Width-55*1.4, 24*1.4, 40*1.4, 28*1.4);
            self.tiaojianLabel.frame=CGRectMake(self.tiaojianLabel.frame.origin.x*1.4, self.tiaojianLabel.frame.origin.y*1.4, self.tiaojianLabel.frame.size.width*1.4, self.tiaojianLabel.frame.size.height*1.4);
            self.tiaojianLabel.font=[UIFont systemFontOfSize:11.5*1.4];

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
