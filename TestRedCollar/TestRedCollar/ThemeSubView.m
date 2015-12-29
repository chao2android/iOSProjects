//
//  ThemeSubView.m
//  TestRedCollar
//
//  Created by MC on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ThemeSubView.h"
#import "NetImageView.h"
@implementation ThemeSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self loadUI];
    }
    return self;
}
- (void)loadUI
{
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-100)];
    [self addSubview:imgView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, imgView.frame.size.height+3, 153-16, 20)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:nameLabel];
    
    desLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, imgView.frame.size.height+3+20, 153-16, 45)];
    desLabel.numberOfLines = 3;
    desLabel.font = [UIFont systemFontOfSize:12];
    desLabel.textColor = [UIColor darkGrayColor];
    desLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:desLabel];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(5, desLabel.frame.origin.y+desLabel.frame.size.height+3, 143, 0.75)];
    line.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    [self addSubview:line];
    
    UIImageView *commentView = [[UIImageView alloc]initWithFrame:CGRectMake(10, line.frame.origin.y+line.frame.size.height+5, 17, 17)];
    commentView.image = [UIImage imageNamed:@"s8_11.png"];
    [self addSubview:commentView];
    
    UIImageView *favoriteView = [[UIImageView alloc]initWithFrame:CGRectMake(85, line.frame.origin.y+line.frame.size.height+5, 17, 17)];
    favoriteView.image = [UIImage imageNamed:@"s8_12.png"];
    [self addSubview:favoriteView];
    
    commentLabel =[[UILabel alloc]initWithFrame:CGRectMake(35, line.frame.origin.y+line.frame.size.height+3, 50, 18)];
    commentLabel.textColor = WORDGRAYCOLOR;
    commentLabel.font =[UIFont systemFontOfSize:15];
    commentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:commentLabel];
    
    favoriteLabel =[[UILabel alloc]initWithFrame:CGRectMake(110, line.frame.origin.y+line.frame.size.height+3, 46, 18)];
    favoriteLabel.textColor = WORDGRAYCOLOR;
    favoriteLabel.font =[UIFont systemFontOfSize:15];
    favoriteLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:favoriteLabel];
}

- (void)loadContent:(ThemeCateListModel *)model
{
    //[imgView setImageWithURL:[NSURL URLWithString: model.middle_img]];
    NetImageView *netImg = [[NetImageView alloc]initWithFrame:imgView.bounds];
    netImg.mImageType = TImageType_CutFill;
    [imgView addSubview:netImg];
    [netImg GetImageByStr:model.middle_img];
    
    nameLabel.text = model.title;
    desLabel.text = model.brief;
    commentLabel.text = [NSString stringWithFormat:@"%d",model.comment];
    favoriteLabel.text = [NSString stringWithFormat:@"%d",model.likes];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
