//
//  TishiView.m
//  好妈妈
//
//  Created by iHope on 13-10-11.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "TishiView.h"
#import <QuartzCore/QuartzCore.h>
static TishiView * tishiView=nil;
@implementation TishiView

+(TishiView *)tishiViewMenth
{
    
    if (tishiView==nil) {
        if (ISIPAD) {
            tishiView=[[TishiView alloc]initWithFrame:CGRectMake((Screen_Width-80*1.4)/2, (Screen_Height+10)*1.4, 80*1.4, 80*1.4)];

        }
        else
        {
            tishiView=[[TishiView alloc]initWithFrame:CGRectMake((Screen_Width-80)/2, Screen_Height+10, 80, 80)];

        }
    }
    tishiView.titlelabel.text=@"加载中...";
    return tishiView;
}

@synthesize activity;
@synthesize titlelabel;

- (void)dealloc
{
    [titlelabel release];
    [activity release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
       self.activity = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width-25)/2, (frame.size.height-25)/2-10, 25, 25)] autorelease];//指定进度轮的大小
        [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
        [self addSubview:self.activity];
        self.titlelabel=[[[UILabel alloc]initWithFrame:CGRectMake(5, frame.size.height-25, frame.size.width-10, 18)] autorelease];
        self.titlelabel.backgroundColor=[UIColor clearColor];
        self.titlelabel.text=@"加载中...";
        self.titlelabel.font=[UIFont systemFontOfSize:16];
        self.titlelabel.textAlignment=NSTextAlignmentCenter;
        self.titlelabel.textColor=[UIColor whiteColor];
        [self addSubview:self.titlelabel];
        if (ISIPAD) {
            self.activity.frame=CGRectMake((frame.size.width-25*1.4)/2, (frame.size.height-25*1.4)/2-10*1.4, 25*1.4, 25*1.4);
            self.titlelabel.frame=CGRectMake(5*1.4, frame.size.height-25*1.4, frame.size.width-10*1.4, 18*1.4);
            self.titlelabel.font=[UIFont systemFontOfSize:16*1.4];
        }
    }
    return self;
}
- (void)StartMenth{
    
    self.frame=CGRectMake((Screen_Width-80)/2, (Screen_Height-10-80)/2, 80, 80);
    if (ISIPAD) {
        self.frame=CGRectMake((Screen_Width-80*1.4)/2, (Screen_Height-10*1.4-80*1.4)/2, 80*1.4, 80*1.4);
    }
    [self.activity startAnimating];
}
- (void)StopMenth
{
    self.frame=CGRectMake((Screen_Width-80)/2, Screen_Height+10, 80, 80);
    if (ISIPAD) {
        self.frame=CGRectMake((Screen_Width-80*1.4)/2, Screen_Height+10*1.4, 80*1.4, 80*1.4);
    }
    [self.activity stopAnimating];
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
