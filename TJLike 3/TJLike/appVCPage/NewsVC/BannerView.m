//
//  BannerView.m
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "BannerView.h"
#import "UIImageView+WebCache.h"
@implementation BannerView
{
    UIImageView *netView;
    UILabel *mlbTitle;
}
@synthesize delegate,OnClick;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        netView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        netView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:netView];
        
        mlbTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-25, SCREEN_WIDTH, 15.5)];
        mlbTitle.backgroundColor = [UIColor clearColor];
        mlbTitle.textAlignment = NSTextAlignmentCenter;
        mlbTitle.font = [UIFont systemFontOfSize:15.5];
        mlbTitle.textColor = [UIColor whiteColor];
        [self addSubview:mlbTitle];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = netView.bounds;
        but.backgroundColor = [UIColor clearColor];
        [but addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
    }
    return self;
}
- (void)Click{
    NSLog(@"Click");
    if (delegate && OnClick) {
        SafePerformSelector([delegate performSelector:OnClick withObject:self]);
    }
}
- (void)LoadContent:(NewsBannerInfo *)info{
    self.mInfo = info;
    mlbTitle.text = info.title;
    [netView sd_setImageWithURL:[NSURL URLWithString:info.focusimg]];
}
- (void)dealloc{
    self.mInfo = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
