//
//  QuanZi_Cell.m
//  好妈妈
//
//  Created by liuguozhu on 18/9/13.
//  Copyright (c) 2013 1510Cloud. All rights reserved.
//

#import "QuanZi_Cell.h"

@implementation QuanZi_Cell
@synthesize headerImage=_headerImage,titleLabel4=_titleLabel4,label2=_label2;
@synthesize titleLabel;
@synthesize subImage1=_subImage1,subImage2=_subImage2,subImage3=_subImage3,subImage4=_subImage4,subImage5=_subImage5;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(4.5, 3, Screen_Width-9, 89.5)];
        backImageView.userInteractionEnabled=YES;
        backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"002_3" ofType:@"png"]];
        [self.contentView addSubview:backImageView];
        [backImageView release];
        // Initialization code
      _headerImage = [[[AsyncImageView alloc]initWithFrame:CGRectMake(12, (89.5-75)/2+3, 75, 75)] autorelease];
     _headerImage.image=[UIImage imageNamed:@"75.png"];
      _headerImage.userInteractionEnabled = YES;
      [self.contentView addSubview:_headerImage];
        
      _titleLabel4 = [[[UILabel alloc]initWithFrame:CGRectMake(93, 13, self.frame.size.width-110, 20)] autorelease];
        _titleLabel4.font=[UIFont systemFontOfSize:16];
        
        _titleLabel4.backgroundColor=[UIColor clearColor];
      [self.contentView addSubview:_titleLabel4];
        self.titleLabel=[[[ImageTextLabel alloc]initWithFrame:CGRectMake(93, 36.5, self.frame.size.width-110, 13)] autorelease];
        self.titleLabel.m_Font=[UIFont systemFontOfSize:12];
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        self.subImage1=[[[AsyncImageView alloc]initWithFrame:CGRectMake(93, 53, 30, 30)] autorelease];
        [self.contentView addSubview:self.subImage1];
        self.subImage2=[[[AsyncImageView alloc]initWithFrame:CGRectMake(93+38, 53, 30, 30)] autorelease];
        [self.contentView addSubview:self.subImage2];
        self.subImage3=[[[AsyncImageView alloc]initWithFrame:CGRectMake(93+38*2, 53, 30, 30)] autorelease];
        [self.contentView addSubview:self.subImage3];
        self.subImage4=[[[AsyncImageView alloc]initWithFrame:CGRectMake(93+38*3, 53, 30, 30)] autorelease];
        [self.contentView addSubview:self.subImage4];
        self.subImage5=[[[AsyncImageView alloc]initWithFrame:CGRectMake(93+38*4, 53, 30, 30)] autorelease];
        [self.contentView addSubview:self.subImage5];
      

        if (ISIPAD) {
            self.subImage1.frame=CGRectMake(self.subImage1.frame.origin.x*1.4, self.subImage1.frame.origin.y*1.4, self.subImage1.frame.size.width*1.4, self.subImage1.frame.size.height*1.4);
            self.subImage1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"圈子默认.png"]];
            self.subImage2.frame=CGRectMake(self.subImage2.frame.origin.x*1.4, self.subImage2.frame.origin.y*1.4, self.subImage2.frame.size.width*1.4, self.subImage2.frame.size.height*1.4);
            self.subImage2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"圈子默认.png"]];
            self.subImage3.frame=CGRectMake(self.subImage3.frame.origin.x*1.4, self.subImage3.frame.origin.y*1.4, self.subImage3.frame.size.width*1.4, self.subImage3.frame.size.height*1.4);
            self.subImage3.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"圈子默认.png"]];
            self.subImage4.frame=CGRectMake(self.subImage4.frame.origin.x*1.4, self.subImage4.frame.origin.y*1.4, self.subImage4.frame.size.width*1.4, self.subImage4.frame.size.height*1.4);
            self.subImage4.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"圈子默认.png"]];
            self.subImage5.frame=CGRectMake(self.subImage5.frame.origin.x*1.4, self.subImage5.frame.origin.y*1.4, self.subImage5.frame.size.width*1.4, self.subImage5.frame.size.height*1.4);
            self.subImage5.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"圈子默认.png"]];
        }
        else
        {
            self.subImage1.layer.cornerRadius = 5;//设置那个圆角的有多圆
            self.subImage1.layer.masksToBounds = YES;
            self.subImage1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"30_30.png"]];
            self.subImage2.layer.cornerRadius = 5;//设置那个圆角的有多圆
            self.subImage2.layer.masksToBounds = YES;
            self.subImage2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"30_30.png"]];
            self.subImage3.layer.cornerRadius = 5;//设置那个圆角的有多圆
            self.subImage3.layer.masksToBounds = YES;
            self.subImage3.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"30_30.png"]];
            self.subImage4.layer.cornerRadius = 5;//设置那个圆角的有多圆
            self.subImage4.layer.masksToBounds = YES;
            self.subImage4.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"30_30.png"]];
            self.subImage5.layer.cornerRadius = 5;//设置那个圆角的有多圆
            self.subImage5.layer.masksToBounds = YES;
            self.subImage5.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"30_30.png"]];
        }

        if (ISIPAD) {
            backImageView.frame=CGRectMake(4.5*1.4, 3*1.4, Screen_Width-4.5*1.4*2, 89.5*1.4);
            _headerImage.frame=CGRectMake(12*1.4, _headerImage.frame.origin.y*1.4, _headerImage.frame.size.width*1.4, _headerImage.frame.size.height*1.4);
            _titleLabel4.frame=CGRectMake(_titleLabel4.frame.origin.x*1.4, _titleLabel4.frame.origin.y*1.4, _titleLabel4.frame.size.width*1.4, _titleLabel4.frame.size.height*1.4);
            _titleLabel4.font=[UIFont systemFontOfSize:16*1.4];
            self.titleLabel.frame=CGRectMake(self.titleLabel.frame.origin.x*1.4, self.titleLabel.frame.origin.y*1.4, self.titleLabel.frame.size.width*1.4, self.titleLabel.frame.size.height*1.4);
        }
        
        
    }
    return self;
}
- (void)abcd
{
    
}

- (void)dealloc
{

  [_label2 release]; _label2 = nil;
  [_titleLabel4 release]; _titleLabel4 = nil;
  [_headerImage release]; _headerImage = nil;
  [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
