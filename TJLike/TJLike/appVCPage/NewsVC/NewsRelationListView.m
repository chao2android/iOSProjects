//
//  NewsRelationListView.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsRelationListView.h"

@implementation NewsRelationListView
{
    UILabel *nameLabel;
    UILabel *timeLabel;
    NewsRelationNewsList *mInfo;
}
@synthesize mDelegate,onClick;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-56, 35)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:16.5];
        [self addSubview:nameLabel];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, SCREEN_WIDTH-56, 12)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:timeLabel];
        
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        btn.backgroundColor = [ UIColor clearColor];
        [btn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)BtnClick{
    SafePerformSelector([mDelegate performSelector:onClick withObject:mInfo]);
}
- (void)LoadContent:(NewsRelationNewsList *)info{
    mInfo = info;
    nameLabel.text = info.source;
    timeLabel.text = info.pubtime;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
