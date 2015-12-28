//
//  ZTListVIew.m
//  TJLike
//
//  Created by MC on 15/4/9.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "ZTListVIew.h"
#import "UIImageView+WebCache.h"

@implementation ZTListVIew{
    UIImageView *mlbImageView;
    UILabel *mlbTitleLabel;
    UILabel *mlbContent;
    UILabel *mlbComment;
    UILabel *mlbCategory;
}

@synthesize mDelegate,onClick;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 83.5, SCREEN_WIDTH-20, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
        mlbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11.5, 75, 60)];
        [self addSubview:mlbImageView];
        
        mlbTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(92.5, 11.5, SCREEN_WIDTH-105, 16)];
        mlbTitleLabel.backgroundColor = [UIColor clearColor];
        mlbTitleLabel.textAlignment = NSTextAlignmentLeft;
        mlbTitleLabel.font = [UIFont systemFontOfSize:15.5];
        mlbTitleLabel.textColor = [UIColor blackColor];
        [self addSubview:mlbTitleLabel];
        
        mlbContent = [[UILabel alloc]initWithFrame:CGRectMake(92.5, 27, SCREEN_WIDTH-104, 35)];
        mlbContent.numberOfLines = 2;
        mlbContent.backgroundColor = [UIColor clearColor];
        mlbContent.textAlignment = NSTextAlignmentLeft;
        mlbContent.font = [UIFont systemFontOfSize:11.5];
        mlbContent.textColor = [UIColor grayColor];
        [self addSubview:mlbContent];
        
        mlbComment = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-138, 59, 100, 13)];
        mlbComment.backgroundColor = [UIColor clearColor];
        mlbComment.textAlignment = NSTextAlignmentRight;
        mlbComment.font = [UIFont systemFontOfSize:13];
        mlbComment.textColor = [UIColor grayColor];
        [self addSubview:mlbComment];
        
        mlbCategory = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, 59, 100, 13)];
        mlbCategory.backgroundColor = [UIColor clearColor];
        mlbCategory.textAlignment = NSTextAlignmentRight;
        mlbCategory.font = [UIFont systemFontOfSize:10];
        mlbCategory.textColor = [UIColor grayColor];
        [self addSubview:mlbCategory];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)LoadContent:(NewsListInfo *)info{
    self.info = info;
    [mlbImageView sd_setImageWithURL:[NSURL URLWithString:info.pic]];
    mlbTitleLabel.text = info.title;
    mlbContent.text = info.brief;
    mlbComment.text = [NSString stringWithFormat:@"%d评",info.comment];
    mlbCategory.text = info.property;
}
- (void)BtnClick{
    SafePerformSelector([mDelegate performSelector:onClick withObject:self.info]);
}

- (void)dealloc{
    self.info = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
