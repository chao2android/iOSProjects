//
//  yumiaoViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "yumiaoViewController.h"
#import "TuiSongTongZhi.h"
@interface yumiaoViewController ()

@end

@implementation yumiaoViewController
-(void)dealloc{
    [super dealloc];
    //  [_timeArr release];
    //  [_ageArr release];
    //  [_zlArr release];
    //  [_smArr release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (ISIPAD) {
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.97 blue:0.89 alpha:1.0];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底.png"]];
    }
   

    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.backgroundColor=[UIColor blackColor];
    navigation.userInteractionEnabled=YES;
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    
    UIButton * backBut=[UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
    [backBut addTarget:self action:@selector(clicked_backBut) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
    [navigation addSubview:backBut];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(50, KUIOS_7(0), self.view.frame.size.width-100, 44)];
    titLab.text = @"疫苗提醒";
    titLab.textAlignment = 1;
    titLab.backgroundColor = [UIColor clearColor];
    titLab.textColor = [UIColor whiteColor];
    titLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [navigation addSubview:titLab];
    [titLab release];
    
    
    _uitable = [[UITableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height - 44-20) style:UITableViewStylePlain];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.backgroundColor = [UIColor clearColor];
    
    _uitable.contentInset = UIEdgeInsetsMake(180.0f, 0.0f, 0, 0.0f);
    
    _uitable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
    
    
    dataBgView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height, self.view.frame.size.width, 260)];
    dataBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wheel_shadow@2x.png"]];
    [self.view addSubview:dataBgView];
    [dataBgView release];
    
    UIButton *dBut = [UIButton buttonWithType:UIButtonTypeCustom];
    dBut .frame = CGRectMake(self.view.frame.size.width-50, 10, 30, 20);
    [dBut addTarget:self action:@selector(clicked_dBut) forControlEvents:UIControlEventTouchUpInside];
    [dBut setImage:[UIImage imageNamed:@"check_selected@2x.png"] forState:UIControlStateNormal];
    [dataBgView addSubview:dBut];
    
    
    UIDatePicker *dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, dataBgView.frame.size.width, 0)];
    dataPicker.backgroundColor = [UIColor whiteColor];
	dataPicker.datePickerMode = UIDatePickerModeDate;
	[dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
	[dataBgView addSubview:dataPicker];
	[dataPicker release];
    
    
    int iLeft = (self.view.frame.size.width-320)/2;
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15+iLeft, -170, 290, 40)];
    lab1.textAlignment =0;
    lab1.text = @"      宝宝的生日：";
    lab1.backgroundColor = [UIColor clearColor];
    lab1.textColor = [UIColor grayColor];
    [_uitable addSubview:lab1];
    [lab1 release];
    
    CALayer* l1=[lab1 layer];
    [l1 setMasksToBounds:YES];
    //  [l1 setCornerRadius:6];
    [l1 setBorderWidth:1];
    [l1 setBorderColor:[[UIColor grayColor]CGColor] ];
    
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @" yyyy-MM-dd";
	NSString * daStr = [dateFormatter stringFromDate:dataPicker.date];
    [dateFormatter release];
    dataLab = [[UILabel alloc]initWithFrame:CGRectMake(160+iLeft, -170, 140, 40 )];
    dataLab.backgroundColor = [UIColor clearColor];
    dataLab.textColor = [UIColor grayColor];
    dataLab.text = daStr;
    [_uitable addSubview:dataLab];
    [dataLab release];
    
    
    
  
    
    
    UIImage *image = [[UIImage imageNamed:@"004_钮.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:18];
    NSDictionary * userDic=[[NSUserDefaults standardUserDefaults]valueForKey:@"logindata"];

    UIButton *tuisuanBut=[UIButton buttonWithType:UIButtonTypeCustom];
    tuisuanBut.frame=CGRectMake((self.view.frame.size.width-130)/2, -100, 130, 40);
    if ([[userDic valueForKey:@"type"] intValue]==1) {

    tuisuanBut.frame=CGRectMake((self.view.frame.size.width-260)/2/2, -100, 130, 40);
    }
    [tuisuanBut addTarget:self action:@selector(clicked_tuisuanBut) forControlEvents:UIControlEventTouchUpInside];
    [tuisuanBut setBackgroundImage:image forState:UIControlStateNormal];
    [tuisuanBut setTitle:@"计算" forState:UIControlStateNormal];
    [tuisuanBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tuisuanBut.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_uitable addSubview:tuisuanBut];
    
    NSArray *arr = [NSArray arrayWithObjects:@"接种时间",@"年龄",@"疫苗种类",@"说明", nil];
    
    bgL = [[UIView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 40)];
    [_uitable addSubview:bgL];
    [bgL release];
    
    int iWidth = self.view.frame.size.width/4;
    for (int i = 0; i<4;i++) {
        
        
        UILabel *L = [[UILabel alloc]initWithFrame:CGRectMake(1+i*iWidth, 0, iWidth-1, 40)];
        L.backgroundColor = [UIColor colorWithRed:230/255.0f green:242/255.0f blue:247/255.0f alpha:1];
        L.textColor = [UIColor grayColor];
        L.textAlignment = 1;
        L.font = [UIFont systemFontOfSize:12.0f];
        L.text = arr[i];
        [bgL addSubview:L];
        [L release];
        
        UILabel * lineL = [[UILabel alloc]initWithFrame:CGRectMake(iWidth+i*iWidth, 0, 1, 40)];
        lineL.backgroundColor = [UIColor grayColor];
        lineL.alpha = 0.5f;
        [bgL addSubview:lineL];
        [lineL release ];
        
        
    }
    bgL.hidden = YES;
    tixingbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    tixingbutton.frame=CGRectMake(self.view.frame.size.width-(self.view.frame.size.width-260)/2/2-130, -100, 130, 40);
    [tixingbutton addTarget:self action:@selector(TiXingMenth) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image11 = [[UIImage imageNamed:@"004_钮.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:18];
    [tixingbutton setBackgroundImage:image11 forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"yumiaotixing"]) {
        [tixingbutton setTitle:@"取消提醒" forState:UIControlStateNormal];
    }
    else
    {
        [tixingbutton setTitle:@"提醒我" forState:UIControlStateNormal];
    }
    tixingbutton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_uitable addSubview:tixingbutton];
    tixingbutton.hidden=YES;

    if ([[userDic valueForKey:@"type"] intValue]==1) {
        tuisuanBut.userInteractionEnabled=NO;
        dataLab.text=[userDic valueForKey:@"birthday"];
        [self clicked_tuisuanBut];
    }
    else
    {
        UIButton * dataBut = [UIButton buttonWithType:UIButtonTypeCustom];
        dataBut.frame = CGRectMake(160+iLeft, -170, 140, 40 );
        [dataBut addTarget: self action:@selector(clicked_dataBut) forControlEvents:UIControlEventTouchUpInside];
        [_uitable addSubview:dataBut];
        tuisuanBut.userInteractionEnabled=YES;
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @" yyyy-MM-dd";
        NSString * daStr = [dateFormatter stringFromDate:dataPicker.date];
        dataLab.text = daStr;
        NSString *tishiString=[[NSString alloc]init];
        if ([[userDic valueForKey:@"type"] intValue]==2) {
            tishiString=@"您设置的是准妈妈，确定使用疫苗提醒吗？";
        }
        else
        {
            tishiString=@"您设置的是备孕，确定使用疫苗提醒吗？";
        }
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提醒" message:tishiString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
        [tishiString release];
    }

}

- (void)TiXingMenth
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"yumiaotixing"]) {
       
            [tixingbutton setTitle:@"提醒我" forState:UIControlStateNormal];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"yumiaotixing"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [tixingbutton setTitle:@"取消提醒" forState:UIControlStateNormal];

    for (int i=0; i<_timeArr.count; i++) {
        if ([TuiSongTongZhi ShiFouJianTuiSongMenth:[TuiSongTongZhi TuiSongShiJianMenth:[_timeArr objectAtIndex:i]]]){
            NSLog(@"%@",[TuiSongTongZhi TuiSongShiJianMenth:[_timeArr objectAtIndex:i]]);
            [TuiSongTongZhi CteLocalNotification:[TuiSongTongZhi TuiSongShiJianMenth:[self DataMenth:[_timeArr objectAtIndex:i]]] TuisongContent:[NSString stringWithFormat:@"不要忘了，明天宝宝的疫苗接种计划：%@ %@(%@)",[_ageArr objectAtIndex:i],[_zlArr  objectAtIndex:i],[_smArr objectAtIndex:i]] TuisongName:[NSString stringWithFormat:@"明天%@%@%@%@",[_timeArr objectAtIndex:i],[_ageArr objectAtIndex:i],[_zlArr objectAtIndex:i],[_smArr objectAtIndex:i]]];

            [TuiSongTongZhi CteLocalNotification:[TuiSongTongZhi TuiSongShiJianMenth:[_timeArr objectAtIndex:i]] TuisongContent:[NSString stringWithFormat:@"不要忘了，宝宝的疫苗接种计划：%@ %@(%@)",[_ageArr objectAtIndex:i],[_zlArr  objectAtIndex:i],[_smArr objectAtIndex:i]] TuisongName:[NSString stringWithFormat:@"%@%@%@%@",[_timeArr objectAtIndex:i],[_ageArr objectAtIndex:i],[_zlArr objectAtIndex:i],[_smArr objectAtIndex:i]]];
        }
//        [TuiSongTongZhi TuiSongShiJianMenth:[_timeArr objectAtIndex:i]]
//        NSLog(@"TuiSongShiJianMenth %d  %@",[TuiSongTongZhi ShiFouJianTuiSongMenth: [TuiSongTongZhi TuiSongShiJianMenth:[_timeArr objectAtIndex:i]]],[_timeArr objectAtIndex:i]);
    }

//    [TuiSongTongZhi CteLocalNotification:[NSDate dateWithTimeInterval:10 sinceDate:[NSDate date]] TuisongContent:@"您今天需要产检了。" TuisongName:@"第一次"];
//    [TuiSongTongZhi RemoveLocalNotication:@"第一次"];
//    [TuiSongTongZhi CteLocalNotification:10 TuisongContent:@"您今天需要产检了===。" TuisongName:@"第1次"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"yumiaotixing"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        [self clicked_backBut];
    }
}

-(void)clicked_tuisuanBut{
    
    if (dataLab .text  == nil) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"生日不能为空！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }else{
        bgL.hidden = NO;
        NSDictionary * userDic=[[NSUserDefaults standardUserDefaults]valueForKey:@"logindata"];
        
        if ([[userDic valueForKey:@"type"] intValue]==1) {
        tixingbutton.hidden=NO;
        }
        [self clicked_dBut];
        [self initWithSting];
        
        
        NSString *dataStr = dataLab.text;
        NSLog(@"%@  %d",dataStr,dataStr.length);
        int rangel=0;
        if (dataStr.length>10) {
            rangel=1;
        }
        NSString *yStr = [dataStr substringWithRange:NSMakeRange(rangel, 4)];
        NSString *mStr = [dataStr substringWithRange:NSMakeRange(rangel+5, 2)];
        
        NSString *dStr = [dataStr substringWithRange:NSMakeRange(dataStr.length-2, 2)];
        
        int year = [yStr intValue];
        int month = [mStr intValue];
        int day = [dStr integerValue]>0?[dStr integerValue]:[[dStr substringWithRange:NSMakeRange(1, 1)] integerValue];
        
        _timeArr = [[NSMutableArray alloc]init];
        dataStr = [self year:year month:month day:day tmp:0];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:0];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:1];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:2];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:3];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:3];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:3];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:4];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:4];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:5];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:6];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:8];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:12];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:18];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:18];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:18];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:48];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:48];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:12*7];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:12*7];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:12*7];
        [_timeArr addObject:dataStr];
        dataStr = [self year:year month:month day:day tmp:12*12];
        [_timeArr addObject:dataStr];
        
        
        
        NSLog(@"count ==%d  cont == %@",_timeArr.count,_timeArr);
        
        [_uitable reloadData];
        
    }
    
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
            if ([self isLeapYear:iYear]) {
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

-(NSString *)year:(int)y month:(int)m day:(int )d tmp :(int)t{
    m = m +t ;
    if (m > 12) {
        y = y +m/12;
        m = m%12;
    }
    if (m==0) {
        y--;
        m=12;
    }
    if ([self DaysOfMonth:y :m]<d) {
        d=[self DaysOfMonth:y :m];
    }
    NSString *dateStr = [NSString stringWithFormat:@"%d-%02d-%02d",y,m,d];
    return dateStr;
    
}
-(void)initWithSting{
    
    _ageArr = [[NSMutableArray alloc]initWithObjects:@"出生时",@"出生时",@"1月足",@"2月足",@"3月足",@"3月足",@"3月足",@"4月足",@"4月足",@"5月足",@"6月足",@"8月足",@"1岁",@"1岁半至2岁",@"1岁半至2岁",@"1岁半至2岁",@"4岁",@"4岁",@"7岁",@"7岁",@"7岁",@"12岁",nil];
    _zlArr = [[NSMutableArray alloc]initWithObjects:@"卡介苗",@"乙肝疫苗",@"乙肝疫苗",@"脊髓灰质炎活疫苗",@"卡介苗",@"脊髓灰质炎活疫苗",@"百白破制剂",@"脊髓灰质炎活疫苗",@"百白破制剂",@"百白破制剂",@"乙肝疫苗",@"麻疹活疫",@"乙脑疫苗",@"脊髓灰质炎活疫苗",@"百白破制剂",@"乙脑疫苗",@"脊髓灰质炎活疫苗",@"麻疹活疫",@"百白破制剂",@"麻疹活疫",@"乙脑疫苗",@"卡介苗", nil];
    _smArr = [[NSMutableArray alloc]initWithObjects:@"初种",@"第一针",@"第二针",@"第一次",@"OT复查",@"第二次",@"第一次",@"第三次",@"第二次",@"第三次",@"第三针",@"第一针",@"初免两针",@"加强",@"加强",@"加强",@"加强",@"加强",@"加强(白破)",@"加强",@"初免两针",@"加强(农村)", nil];
    NSLog(@"num ==== %d",_ageArr.count);
    
}
-(void)clicked_dataBut{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    dataBgView.frame = CGRectMake(0, Screen_Height-260, self.view.frame.size.width, 260);
    [UIView commitAnimations];
    
}
-(void)clicked_dBut{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    dataBgView.frame = CGRectMake(0, Screen_Height, self.view.frame.size.width, 260);
    [UIView commitAnimations];
    
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSString * str = [dateFormatter stringFromDate:datePicker.date];
	NSLog(@"data === %@", str);
    
    dataLab.text = str;
	
	[dateFormatter release];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _zlArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yumiaoCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"yumiaoCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        int iWidth = self.view.frame.size.width/4;
        for (int i = 0; i<4 ; i++) {
            UILabel * hL = [[UILabel alloc]initWithFrame:CGRectMake(iWidth+i*iWidth, 0, 1, 40)];
            hL.backgroundColor = [UIColor grayColor];
            hL.alpha = 0.5f;
            [cell.contentView addSubview:hL];
            [hL release ];
            
            UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectMake(1+i*iWidth, 0, iWidth-1, 39)];
            
            contentL.backgroundColor = [UIColor clearColor];
            contentL.textAlignment = 1;
            contentL.textColor = [UIColor grayColor];
            contentL.font = [UIFont systemFontOfSize:12];
            contentL.tag = 1000+i;
            contentL.adjustsFontSizeToFitWidth = YES;
            contentL.minimumFontSize = 1.0f;
            [cell.contentView addSubview:contentL];
            [contentL release];
            
        }
        
        UILabel *wL = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
        wL.backgroundColor = [UIColor grayColor];
        wL.alpha = 0.5f;
        [cell.contentView addSubview:wL];
        [wL release ];
        
    }
    
    UILabel *timeLab = (UILabel *)[cell.contentView viewWithTag:1000];
    timeLab.text = _timeArr[indexPath.row];
    
    UILabel *ageLab = (UILabel *)[cell.contentView viewWithTag:1001];
    ageLab.text = _ageArr[indexPath.row];
    UILabel *zlLab = (UILabel *)[cell.contentView viewWithTag:1002];
    zlLab.text = _zlArr[indexPath.row];
    UILabel *smLab = (UILabel *)[cell.contentView viewWithTag:1003];
    smLab.text = _smArr[indexPath.row];
    
    
    return  cell;
    
    
}




-(void)clicked_backBut{

    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
