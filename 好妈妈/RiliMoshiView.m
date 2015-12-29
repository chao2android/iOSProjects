//
//  RiliMoshiView.m
//  好妈妈
//
//  Created by iHope on 13-10-18.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "RiliMoshiView.h"
#import "ShangChuanViewController.h"
#import "AsyncImageView.h"
#import "RijiXiangqingViewController.h"
#import "TishiView.h"
#import "NetImageView.h"
@implementation RiliMoshiView
@synthesize riliImageView;
@synthesize timeLabel;
@synthesize temp;
- (void)dealloc
{
    if (analysis) {
    [analysis CancelMenthrequst];
    analysis=nil;
    }
    
    [timeLabel release];
    [riliImageView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame ID:(NSString *)idString
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        dataArray=[[NSMutableArray alloc]initWithCapacity:1];
                // Initialization code
        self.riliImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self.riliImageView.userInteractionEnabled=YES;
        self.riliImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_6" ofType:@"png"]];
        [self addSubview:self.riliImageView];
        self.timeLabel=[[[UILabel alloc]initWithFrame:CGRectMake((self.riliImageView.frame.size.width-80)/2, 10, 80, 20)] autorelease];
        self.timeLabel.backgroundColor=[UIColor whiteColor];
        self.timeLabel.textAlignment=UITextAlignmentCenter;
        self.timeLabel.textColor=[UIColor blackColor];
        [self.riliImageView addSubview:self.timeLabel];
        
        UIButton * leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame=CGRectMake((self.riliImageView.frame.size.width-80)/2-23, 10, 20, 20);
        [leftButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_3" ofType:@"png"]] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(OnLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.riliImageView addSubview:leftButton];
        UIButton * rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame=CGRectMake(self.timeLabel.frame.size.width+self.timeLabel.frame.origin.x+3, 10, 20, 20);
        [rightButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_2" ofType:@"png"]] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(OnRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.riliImageView addSubview:rightButton];
        
        NSArray * rqArray=[[NSArray alloc]initWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
        for (int i=0; i<rqArray.count; i++) {
            UILabel * rqLabel=[[UILabel alloc]initWithFrame:CGRectMake((Screen_Width/7)*i, 46, Screen_Width/7, 15)];
            if (ISIPAD) {
                rqLabel.frame=CGRectMake((Screen_Width/7)*i, 110, Screen_Width/7-2, 15);
            }
            rqLabel.textColor=[UIColor blackColor];
            rqLabel.backgroundColor=[UIColor clearColor];
            rqLabel.font=[UIFont systemFontOfSize:13];
            rqLabel.textAlignment=NSTextAlignmentCenter;
            rqLabel.text=[rqArray objectAtIndex:i];
            [self.riliImageView addSubview:rqLabel];
            [rqLabel release];
        }
        [rqArray release];
        [self GetDateComponent:[NSDate date] :&miYear :&miMonth];
        self.timeLabel.text = [NSString stringWithFormat:@"%04d-%02d", miYear, miMonth];
        idStr=idString;
        
        [self analyUrl];
    }
    return self;
}

- (void)analyUrl
{
    tishiView=[TishiView tishiViewMenth];
    [self addSubview:tishiView];
    [tishiView StartMenth];
    self.userInteractionEnabled=NO;
    [dataArray removeAllObjects];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",idStr,@"targetid",[NSString stringWithFormat:@"%d-%d",miYear,miMonth],@"month", nil];
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/topiclist2"];
    if (analysis) {
        [analysis CancelMenthrequst];
        analysis=nil;
    }
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"weiriji" delegate:self];
    [aUrl release];
    [analysis PostMenth:Dictionary];
    [Dictionary release];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    self.userInteractionEnabled=YES;

    [tishiView StopMenth];
    if ([[array valueForKey:asi.ControllerName] count]) {
        [dataArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
    }
        [self ShowDateView];
    
   
    [asi release];
    analysis=nil;
}

- (void)TapGestureMenth
{
    NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"发表文字",@"title", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LongPressGesture" object:asiDiction];
    [asiDiction release];
}
- (void)OnLeftBtnClick {
    miMonth--;
    if (miMonth <= 0) {
        miMonth = 12;
        miYear--;
    }
    [self analyUrl];
    [self ShowDateView];
}

- (void)OnRightBtnClick {
    miMonth++;
    if (miMonth > 12) {
        miMonth = 1;
        miYear++;
    }
    [self analyUrl];
    [self ShowDateView];
}

- (BOOL)isLeapYear:(int)iYear {
    return (iYear%4==0&&iYear%100!=0)||iYear%400==0;
}

- (int)DaysOfMonth:(int)iYear :(int)iMonth {
    int iDays = 30;
    switch (iMonth) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            iDays = 31;
            break;
        case 2:
            if ([self isLeapYear:iMonth]) {
                iDays = 29;
            }
            else {
                iDays = 28;
            }
            break;
        default:
            break;
    }
    return iDays;
}

- (void)GetDateComponent:(NSDate *)date :(int *)iYear :(int *)iMonth {
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    *iYear = [comps year];
    *iMonth = [comps month];
}
- (int)GetWeekOfDate:(NSDate *)date {
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    return [comps weekday]-1;
}
- (int)GetWeekOfDay:(int)iYear :(int)iMonth :(int)iDay {
    NSString *startstr = [NSString stringWithFormat:@"%d-%02d-%02d", iYear, iMonth, iDay];
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *startdate = [formatter dateFromString:startstr];
    return [self GetWeekOfDate:startdate];
}
- (void)ShowDateView {

    self.timeLabel.text = [NSString stringWithFormat:@"%04d-%02d", miYear, miMonth];
    int iWeek = [self GetWeekOfDay:miYear :miMonth :1];
    int iDays = [self DaysOfMonth:miYear :miMonth];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (UIView *view in self.riliImageView.subviews) {
        if (view.tag>=5000) {
            [view removeFromSuperview];
        }
    }
    [pool release];
    float fWidth = 46;
    float fHeight = 59.5;
    if (ISIPAD) {
       
        fWidth=Screen_Width*46/320;
        fHeight=132.5;
    }
    for (int i = 0; i < iDays; i ++) {
        int iXPos = (iWeek+i)%7;
        int iYPos = (iWeek+i)/7;
        int iType = [self GetDayType:miYear :miMonth :i+1];

        UIButton * btText=[UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
        
        if ([idStr intValue]==[[userDic valueForKey:@"uid"] intValue]) {
        [btText setImage:[UIImage imageNamed:@"12123123.png"] forState:UIControlStateHighlighted];
        }
        btText.frame=CGRectMake(iXPos*fWidth, 63.5+fHeight*iYPos, fWidth-2, fHeight-2);
        if (ISIPAD) {
            btText.frame=CGRectMake(iXPos*fWidth, 140+fHeight*iYPos, fWidth-2, fHeight-2);

        }
        [btText setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        [btText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btText.titleLabel.font=[UIFont systemFontOfSize:16];
        [btText addTarget:self action:@selector(PlayImageMenth:) forControlEvents:UIControlEventTouchUpInside];
        for (int j=0; j<dataArray.count; j++) {
            NetImageView * _bigImageView = [[NetImageView alloc]initWithFrame:CGRectMake(0, 0, btText.frame.size.width, btText.frame.size.height)];
            _bigImageView.mImageType = TImageType_CutFill;

            if ([[[[[dataArray objectAtIndex:j] valueForKey:@"time"] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]==miYear&&[[[[[dataArray objectAtIndex:j] valueForKey:@"time"] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]==miMonth&&[[[[[dataArray objectAtIndex:j] valueForKey:@"time"] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]==i+1) {
                if ([[[dataArray objectAtIndex:j] valueForKey:@"image"] length]) {
                    [_bigImageView GetImageByStr:[[dataArray objectAtIndex:j] valueForKey:@"image"]];

//                butImageView.urlString=[[dataArray objectAtIndex:j] valueForKey:@"image"];
                }else
                {
                    if ([[[dataArray objectAtIndex:j] valueForKey:@"text"] length]>6) {
                        [btText setTitle:[[[dataArray objectAtIndex:j] valueForKey:@"text"] substringToIndex:6] forState:UIControlStateNormal];

                    }
                    else
                    {
                [btText setTitle:[[dataArray objectAtIndex:j] valueForKey:@"text"] forState:UIControlStateNormal];
                    }
                }
                [btText addSubview:_bigImageView];
                [_bigImageView release];

                AsyncImageView *butImageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, btText.frame.size.width, btText.frame.size.height)];

                butImageView.tag=j;
                [butImageView addTarget:self action:@selector(AsyImageMenht:) forControlEvents:UIControlEventTouchUpInside];
                [_bigImageView addSubview:butImageView];
                [butImageView release];
                if ([[[dataArray objectAtIndex:j] valueForKey:@"flag"] intValue])
                {
                    UIImageView * suoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                    suoImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"锁" ofType:@"png"]];
                    [btText addSubview:suoImageView];
                    [suoImageView release];
                }
            }

        }
        
        btText.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        btText.tag = 5000+i;
        [self.riliImageView addSubview:btText];
        btText.userInteractionEnabled=YES;

        if (iType == 0) {
//            btText.backgroundColor = [UIColor colorWithRed:0.92 green:0.09 blue:0.39 alpha:1.0];
        }
        else if (iType == 1) {
            btText.backgroundColor = [UIColor colorWithRed:0.92 green:0.09 blue:0.39 alpha:1.0];;
        }
        else if (iType == 2) {
            btText.userInteractionEnabled=NO;
        }
    }
}
- (void)AsyImageMenht:(AsyncImageView *)sender
{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",idStr,@"targetid",[[dataArray objectAtIndex:sender.tag] valueForKey:@"time"],@"date", nil];
    [Dictionary setValue:@"http://apptest.mum360.com/web/home/index/topicinfo2" forKey:@"aUrl1"];
    RijiXiangqingViewController * rijixiangqing=[[RijiXiangqingViewController alloc]init];
    rijixiangqing.oldDictionary=Dictionary;
    [Dictionary release];
    [temp presentModalViewController:rijixiangqing animated:NO];
    [rijixiangqing release];
}
- (void)PlayImageMenth:(UIButton *)sender
{
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];

    if ([idStr intValue]==[[userDic valueForKey:@"uid"] intValue]) {
        
    
    NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"发表图片",@"title",[NSString stringWithFormat:@"%d-%d-%d",miYear,miMonth,sender.tag-5000+1],@"date", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LongPressGesture" object:asiDiction];
    [asiDiction release];
    }

}
- (int)GetDayType:(int)iYear :(int)iMonth :(int)iDay {
    NSString *startstr = [NSString stringWithFormat:@"%d-%02d-%02d", iYear, iMonth, iDay];
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *startdate = [formatter dateFromString:startstr];
   
    NSString *datestr1 = [formatter stringFromDate:[NSDate date]];
    NSTimeInterval interval = [startdate timeIntervalSinceDate:[formatter dateFromString:datestr1]];
    int iOffset = interval/(3600*24);
    if (iOffset<0) {
        return 0;
    }
    else if (iOffset==0)
    {
        return 1;
    }
    return 2;
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
