//
//  OvulationViewController.m
//  好妈妈
//
//  Created by Hepburn Alex on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "OvulationViewController.h"

@interface OvulationViewController ()

@end

@implementation OvulationViewController

@synthesize mDate, miOffset;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.mDate = nil;
    [super dealloc];
}

- (void)GoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.98 blue:0.91 alpha:1.0];
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    topView.backgroundColor = [UIColor blackColor];
    topView.userInteractionEnabled = YES;
    topView.image = [UIImage imageNamed:@"nav_background.png"];
    [self.view addSubview:topView];
    [topView release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 6, 45, 30.5);
    [backBtn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"001_4.png"] forState:UIControlStateNormal];
    [topView addSubview:backBtn];
    
    UIButton *monthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    monthBtn.frame = CGRectMake(topView.frame.size.width-50, 6, 45, 30.5);
    [monthBtn addTarget:self action:@selector(ShowLocalMonth) forControlEvents:UIControlEventTouchUpInside];
    [monthBtn setBackgroundImage:[UIImage imageNamed:@"004_钮.png"] forState:UIControlStateNormal];
    [monthBtn setTitle:@"本月" forState:UIControlStateNormal];
    [monthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    monthBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:monthBtn];
    
    mlbTitle = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, topView.frame.size.width-200, topView.frame.size.height)];
    mlbTitle.backgroundColor = [UIColor clearColor];
    mlbTitle.textAlignment = UITextAlignmentCenter;
    mlbTitle.textColor = [UIColor whiteColor];
    mlbTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [topView addSubview:mlbTitle];
    [mlbTitle release];
    
    int iLeft = (self.view.frame.size.width-320)/2;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(65+iLeft, 2, 42, 42);
    [leftBtn addTarget:self action:@selector(OnLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [topView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(topView.frame.size.width-107-iLeft, 2, 42, 42);
    [rightBtn addTarget:self action:@selector(OnRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [topView addSubview:rightBtn];
    
    int iOffset = 1;
    if (ISIPAD) {
        iOffset = 2;
    }

    int iTop = 70;
    mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24, iTop, self.view.frame.size.width-48, 238*iOffset)];
    mImageView.image = [UIImage imageNamed:@"dateback.png"];
    [self.view addSubview:mImageView];
    [mImageView release];
    
    iTop += (mImageView.frame.size.height+20);
    
    NSArray *array = [NSArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
    int iWidth = (mImageView.frame.size.width-2)/7;
    for (int i = 0; i < 7; i ++) {
        UILabel *lbText = [[UILabel alloc]initWithFrame:CGRectMake(3+i*iWidth, 12*iOffset, iWidth, 14*iOffset)];
        lbText.backgroundColor = [UIColor clearColor];
        lbText.text = [array objectAtIndex:i];
        lbText.textAlignment = UITextAlignmentCenter;
        lbText.textColor = [UIColor blackColor];
        lbText.font = [UIFont systemFontOfSize:12];
        [mImageView addSubview:lbText];
        [lbText release];
    }
    
    iWidth = (self.view.frame.size.width-20)/3;
    for (int i = 0; i < 3; i ++) {
        UIView *flagView = [[UIView alloc] initWithFrame:CGRectMake(iWidth*i+20, iTop, 25, 25)];
        [self.view addSubview:flagView];
        [flagView release];
        
        UILabel *lbText = [[UILabel alloc]initWithFrame:CGRectMake(iWidth*i+50, iTop, iWidth-50, 25)];
        lbText.backgroundColor = [UIColor clearColor];
        lbText.text = [array objectAtIndex:i];
        lbText.textColor = [UIColor blackColor];
        lbText.font = [UIFont boldSystemFontOfSize:16];
        [self.view addSubview:lbText];
        [lbText release];
        
        if (i == 0) {
            flagView.backgroundColor = [UIColor colorWithRed:219/255.0 green:245/255.0 blue:221/255.0 alpha:1.0];
//            flagView.backgroundColor = [UIColor colorWithRed:0.13 green:0.55 blue:0.02 alpha:1.0];
            lbText.text = @"安全期";
        }
        else if (i == 1) {
            flagView.backgroundColor = [UIColor colorWithRed:255/255.0 green:179/255.0 blue:206/255.0 alpha:1.0];

//            flagView.backgroundColor = [UIColor colorWithRed:0.92 green:0.09 blue:0.39 alpha:1.0];
            lbText.text = @"月经期";
        }
        else if (i == 2) {
            flagView.backgroundColor = [UIColor colorWithRed:206/255.0 green:231/255.0 blue:251/255.0 alpha:1.0];

            lbText.text = @"排卵期";
        }
    }
    
    [self GetDateComponent:[NSDate date] :&miYear :&miMonth];
    mlbTitle.text = [NSString stringWithFormat:@"%04d-%02d", miYear, miMonth];
    NSLog(@"CurWeek%d", [self GetWeekOfDay:miYear :miMonth :20]);
    [self ShowDateView];
}

- (void)OnLeftBtnClick {
    miMonth--;
    if (miMonth <= 0) {
        miMonth = 12;
        miYear--;
    }
    [self ShowDateView];
}

- (void)OnRightBtnClick {
    miMonth++;
    if (miMonth > 12) {
        miMonth = 1;
        miYear++;
    }
    [self ShowDateView];
}

- (void)ShowLocalMonth {
    [self GetDateComponent:[NSDate date] :&miYear :&miMonth];
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
    NSLog(@"week:%d weekday:%d", [comps week], [comps weekday]);
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
    mlbTitle.text = [NSString stringWithFormat:@"%04d-%02d", miYear, miMonth];
    int iWeek = [self GetWeekOfDay:miYear :miMonth :1];
    int iDays = [self DaysOfMonth:miYear :miMonth];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (UIView *view in mImageView.subviews) {
        if (view.tag>=5000) {
            [view removeFromSuperview];
        }
    }
    [pool release];
    float fWidth = (mImageView.frame.size.width-2)/7;
    float fHeight = 35.2;
    int iTop = 25;
    if (ISIPAD) {
        fHeight = 70.8;
        iTop = 50;
    }
    for (int i = 0; i < iDays; i ++) {
        int iXPos = (iWeek+i)%7;
        int iYPos = (iWeek+i)/7;
        int iType = [self GetDayType:miYear :miMonth :i+1];
        UILabel *lbText = [[UILabel alloc]initWithFrame:CGRectMake(iXPos*fWidth+1, iTop+fHeight*iYPos+1, fWidth-2, fHeight-2)];
        lbText.backgroundColor=[UIColor blueColor];
        NSLog(@"w == %f h == %f",fWidth-2,fHeight-2);
        lbText.text = [NSString stringWithFormat:@"%d", i+1];
        lbText.textAlignment = UITextAlignmentCenter;
        lbText.font = [UIFont systemFontOfSize:18];
        lbText.textColor = [UIColor colorWithRed:79/255.0f green:0 blue:28/255.0f alpha:1];
        lbText.tag = 5000+i;
        [mImageView addSubview:lbText];
        [lbText release];
        if (iType == 0) {
            lbText.backgroundColor = [UIColor colorWithRed:255/255.0 green:179/255.0 blue:206/255.0 alpha:1.0];

        }
        else if (iType == 1) {
       lbText.backgroundColor = [UIColor colorWithRed:206/255.0 green:231/255.0 blue:251/255.0 alpha:1.0];
        }
        else if (iType == 2) {
       lbText.backgroundColor =  [UIColor colorWithRed:219/255.0 green:245/255.0 blue:221/255.0 alpha:1.0];
        }
        
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString * daStr = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *yStr = [daStr substringWithRange:NSMakeRange(0, 4)];
        NSString *mStr = [daStr substringWithRange:NSMakeRange(5, 2)];
        NSString *dStr = [daStr substringWithRange:NSMakeRange(8, 2)];
        
        
        NSLog(@"%@ %@ %@",yStr,mStr,dStr);
        int y = [yStr intValue];
        int m = [mStr intValue];
        int d = [dStr intValue];
//        bg = [[UIImageView alloc]initWithFrame:CGRectMake(iXPos*fWidth+1, iTop+fHeight*iYPos+1, fWidth-2, fHeight-2)];
//        bg.image = [UIImage imageNamed:@"排卵期2_1.png"];
//        [mImageView addSubview:bg];
//        [bg release];
        

        NSLog(@"%d    %d ",d , i);
        if (m == miMonth && y == miYear &&d == i+1) {
            UIImageView *lbImageView=[[UIImageView alloc]initWithFrame:lbText.bounds];
            lbImageView.backgroundColor=[UIColor clearColor];
            if (ISIPAD) {
                lbImageView.image=[UIImage imageNamed:@"排卵期2_2.png"];
                
//                lbText.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"排卵期2_2.png"]];

            }else{
                lbImageView.image=[UIImage imageNamed:@"排卵期2_1.png"];

//                lbText.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"排卵期2_1.png"]];

            }
            [lbText addSubview:lbImageView];
            [lbImageView release];

        }else{
                        
                        
//            if (bg) {
//                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//                [bg removeFromSuperview];
//                
//                bg = nil;
//                [pool release];
//            }
            
        }
        
        
    }
}

- (int)GetDayType:(int)iYear :(int)iMonth :(int)iDay {
    NSString *startstr = [NSString stringWithFormat:@"%d-%02d-%02d", iYear, iMonth, iDay];
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *startdate = [formatter dateFromString:startstr];
    NSTimeInterval interval = [startdate timeIntervalSinceDate:self.mDate];
    int iOffset = interval/(3600*24);
    if (iOffset>0) {
        iOffset = iOffset%miOffset;
    }
    else if (iOffset < 0) {
        while (iOffset < 0) {
            iOffset += miOffset;
        }
    }
    NSLog(@"%02d, %d, %.1f", iDay, iOffset, interval);
    if (iOffset<=4 || iOffset == miOffset) {
        return 0;
    }
    else if (iOffset > miOffset-20 && iOffset <= miOffset - 10) {
        return 1;
    }
    return 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
