//
//  TJFoundViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFoundViewController.h"
#import "TJFoundSeachViewController.h"

@interface TJFoundViewController ()
{
    UILabel *timeLabel;
    UILabel *todayLimit;
    UILabel *tomorrowLimit;
    
    UILabel *wLabel1;
    UILabel *wLabel2;
    UILabel *wLabel3;
}
@end

@implementation TJFoundViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"发现"];
    [self.naviController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor colorWithRed:240/250.f green:240/250.f blue:240/250.f alpha:1];
    //[self AddNaviView];
    
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 210)];
    topView.contentMode = UIViewContentModeScaleToFill;
    topView.image = [UIImage imageNamed:@"11_03"];
    [self.view addSubview:topView];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-85, 20)];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:18];
    timeLabel.textColor = [UIColor whiteColor];
    [topView addSubview:timeLabel];
    
    wLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-85, 20)];
    wLabel1.textAlignment = NSTextAlignmentLeft;
    wLabel1.font = [UIFont systemFontOfSize:18];
    wLabel1.textColor = [UIColor whiteColor];
    [topView addSubview:wLabel1];
    
    todayLimit = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, SCREEN_WIDTH-85, 50)];
    todayLimit.textAlignment = NSTextAlignmentRight;
    todayLimit.font = [UIFont systemFontOfSize:48];
    todayLimit.textColor = [UIColor whiteColor];
    [topView addSubview:todayLimit];
    
    wLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH-85, 50)];
    wLabel2.textAlignment = NSTextAlignmentLeft;
    wLabel2.font = [UIFont systemFontOfSize:48];
    wLabel2.textColor = [UIColor whiteColor];
    [topView addSubview:wLabel2];
    
    tomorrowLimit = [[UILabel alloc]initWithFrame:CGRectMake(80, 130, SCREEN_WIDTH-85, 20)];
    tomorrowLimit.textAlignment = NSTextAlignmentRight;
    tomorrowLimit.font = [UIFont systemFontOfSize:18];
    tomorrowLimit.textColor = [UIColor whiteColor];
    [topView addSubview:tomorrowLimit];
    
    wLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 130, SCREEN_WIDTH-85, 20)];
    wLabel3.textAlignment = NSTextAlignmentLeft;
    wLabel3.font = [UIFont systemFontOfSize:18];
    wLabel3.textColor = [UIColor whiteColor];
    [topView addSubview:wLabel3];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSLog(@"---->%ld---->%ld---->%ld",[comps weekday],[comps month],[comps day]);
    NSInteger weekDay = [comps weekday];
    NSString *week= @"";
    if (weekDay==1) {
        week = @"日";
    }else if(weekDay==2){
        week = @"一";
    }else if(weekDay==3){
        week = @"二";
    }else if(weekDay==4){
        week = @"三";
    }else if(weekDay==5){
        week = @"四";
    }else if(weekDay==6){
        week = @"五";
    }else if(weekDay==7){
        week = @"六";
    }
    timeLabel.text = [NSString stringWithFormat:@"%d-%d 星期%@ 今日限行",(int)[comps month],(int)[comps day],week];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = CGRectMake(0, 284, SCREEN_WIDTH, 43);
    [btn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    for (int i = 0; i<2; i++) {
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, i*42.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [btn addSubview:lineView];
    }
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10.25, 22.5, 22.5)];
    icon.image = [UIImage imageNamed:@"fonud_3_"];
    [btn addSubview:icon];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(52.5, 0, 100, 43)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"违章查询";
    [btn addSubview:label];
    
    [self requestRegionsInfo];
    [self GetWeather];
}

- (void)GetWeather{
    //weather
    
    NSString *urlStr = @"http://api.map.baidu.com/telematics/v3/weather?location=%E5%A4%A9%E6%B4%A5&output=json&ak=f9Bi39Z1z0dL58rUG5zuLWwk";
    [[HttpClient getRequestWithPath:urlStr] subscribeNext:^(NSDictionary *info) {
        NSLog(@"weather---->%@",info);
        
        NSString *str1 = info[@"results"][0][@"weather_data"][0][@"weather"];
        wLabel1.text = str1;
        
        NSString *str2 = info[@"results"][0][@"weather_data"][0][@"temperature"];
        wLabel2.text= str2;
        
        NSString *str3 = info[@"results"][0][@"pm25"];
        wLabel3.text= [NSString stringWithFormat:@"pm2.5:%@",str3];
        
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
    }];
}

- (void)BtnClick{
    NSLog(@"----");
    TJFoundSeachViewController *ctrl = [[TJFoundSeachViewController alloc]init];
    [self.naviController pushViewController:ctrl animated:YES];
}

- (void)requestRegionsInfo {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/CarLimit"];
    
    [[HttpClient getRequestWithPath:urlStr] subscribeNext:^(NSDictionary *info) {
        NSLog(@"---->%@",info);
        todayLimit.text = [NSString stringWithFormat:@"%@",info[@"data"][0]];
        tomorrowLimit.text = [NSString stringWithFormat:@"明日限行 %@",info[@"data"][1]];
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
    }];
}
- (void)AddNaviView{
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:19];
    mLabel.textAlignment = NSTextAlignmentCenter;
    mLabel.textColor  =[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1];
    mLabel.text = @"发现";
    [self.view addSubview:mLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
