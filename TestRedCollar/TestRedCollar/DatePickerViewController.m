//
//  DatePickerViewController.m
//  TestRedCollar
//
//  Created by MC on 14-8-18.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()
{
    UIDatePicker *_datePicker;
}
@end

@implementation DatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择日期";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:_datePicker];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[[NSDate alloc] init]];
    
    [comps setHour:+24]; //+24表示获取下一天的date，-24表示获取前一天的date；
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *nowDate = [calendar dateByAddingComponents:comps toDate:date options:0];   //showDate表示某天的date，nowDate表示showDate的前一天或下一天的date
    _datePicker.minimumDate = nowDate;
    
    UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    OKBtn.frame = CGRectMake(15, self.view.bounds.size.height-200, 290, 44);
    [OKBtn setBackgroundImage:[UIImage imageNamed:@"OK_btn.png"] forState:UIControlStateNormal];
    [OKBtn addTarget:self action:@selector(OKBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKBtn];
}
- (void)OKBtnClick{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:_datePicker.date];
    NSLog(@"%@",dateStr);
    self.block(dateStr);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
