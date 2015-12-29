//
//  yuchanViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "yuchanViewController.h"

@interface yuchanViewController ()

@end

@implementation yuchanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (ISIPAD) {
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.97 blue:0.89 alpha:1.0];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底.png"]];
    }
    //  olddate = [[NSDate alloc]init];
    
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
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(0), self.view.frame.size.width-200, 44)];
    titLab.text = @"预产期计算";
    titLab.textAlignment = 1;
    titLab.backgroundColor = [UIColor clearColor];
    titLab.textColor = [UIColor whiteColor];
    titLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [navigation addSubview:titLab];
    [titLab release];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-44)];
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    bgView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"001_22.png"]stretchableImageWithLeftCapWidth:100 topCapHeight:40]];
    bgView.userInteractionEnabled = YES;
    bgView.tag = 1000;
    bgView.userInteractionEnabled = YES;
    //  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
    //  [bgView addGestureRecognizer:singleTap];
    //  [singleTap release];
    [_scrollView addSubview:bgView];
    [bgView release];
    
    dataBgView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height, self.view.frame.size.width, 260)];
    dataBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wheel_shadow@2x.png"]];
    [self.view addSubview:dataBgView];
    [dataBgView release];
    
    UIButton *dBut = [UIButton buttonWithType:UIButtonTypeCustom];
    dBut .frame = CGRectMake(dataBgView.frame.size.width-50, 10, 30, 20);
    [dBut addTarget:self action:@selector(clicked_dBut) forControlEvents:UIControlEventTouchUpInside];
    [dBut setImage:[UIImage imageNamed:@"check_selected@2x.png"] forState:UIControlStateNormal];
    [dataBgView addSubview:dBut];
    
    
    dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, dataBgView.frame.size.width, 0)];
	dataPicker.datePickerMode = UIDatePickerModeDate;
    dataPicker.backgroundColor = [UIColor whiteColor];
	[dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
  
  
	[dataBgView addSubview:dataPicker];
	[dataPicker release];
    
  NSDate *newdate = [NSDate dateWithTimeInterval:-3600*24*275 sinceDate: [NSDate date]];
  
  NSLog(@"newDate = %@",newdate);
  dataPicker.minimumDate = newdate;
  dataPicker.maximumDate =  [NSDate date];


    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @" yyyy-MM-dd";
	NSString * daStr = [dateFormatter stringFromDate:dataPicker.date];
    self.olddate = dataPicker.date;
    //  [olddate retain];
    
    //  UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 140, 40)];
    //  lab1.textAlignment = 2;
    //  lab1.text = @"末次月经时间";
    //  lab1.backgroundColor = [UIColor clearColor];
    //  [bgView addSubview:lab1];
    //  [lab1 release];
    
    
    
    dataLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 290, 40 )];
    dataLab.backgroundColor = [UIColor clearColor];
    dataLab.text = [NSString stringWithFormat:@"  末次月经时间：%@", daStr];
    dataLab.textColor = [UIColor grayColor];
    dataLab.textAlignment = 0 ;
    [bgView addSubview:dataLab];
    [dataLab release];
    
    CALayer* l1=[dataLab layer];
    [l1 setMasksToBounds:YES];
    //  [l1 setCornerRadius:6];
    [l1 setBorderWidth:1];
    [l1 setBorderColor:[[UIColor grayColor]CGColor] ];
    
    UIButton * dataBut = [UIButton buttonWithType:UIButtonTypeCustom];
    dataBut.frame = CGRectMake(160, 5, 140, 40 );
    [dataBut addTarget: self action:@selector(clicked_dataBut) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:dataBut];
    
    
    
    
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 290, 40)];
    lab2.textAlignment = 0;
    lab2.text = @"  月经周期天数：";
    lab2.textColor = [UIColor grayColor];
    lab2.backgroundColor = [UIColor clearColor];
    [bgView addSubview:lab2];
    [lab2 release];
    
    l1=[lab2 layer];
    [l1 setMasksToBounds:YES];
    //  [l1 setCornerRadius:6];
    [l1 setBorderWidth:1];
    [l1 setBorderColor:[[UIColor grayColor]CGColor] ];
    
    tf2 = [[UITextField alloc]initWithFrame:CGRectMake(143, 50, 130, 40 )];
    //  tf2.borderStyle = UITextBorderStyleLine;
    tf2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf2.keyboardType = UIKeyboardTypeNumberPad;
    tf2.text = @"28";
    tf2.textColor = [UIColor grayColor];
    tf2.tag = 2001;
    tf2.clearsOnBeginEditing = YES;
    [bgView addSubview:tf2];
    [tf2 release];
    
    
    UIImage *image = [[UIImage imageNamed:@"004_钮.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:18];
    tuisuanBut=[UIButton buttonWithType:UIButtonTypeCustom];
    tuisuanBut.frame=CGRectMake(90, 100, 130, 40);
    [tuisuanBut addTarget:self action:@selector(clicked_tuisuanBut) forControlEvents:UIControlEventTouchUpInside];
    [tuisuanBut setBackgroundImage:image forState:UIControlStateNormal];
    [tuisuanBut setTitle:@"推算" forState:UIControlStateNormal];
    [tuisuanBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tuisuanBut.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bgView addSubview:tuisuanBut];
    
    int height = tuisuanBut.frame.origin.y + tuisuanBut.frame.size.height + 10;
    
    int iTop = 0;
    if (ISIPAD) {
        iTop = 60;
    }
    bgView.frame = CGRectMake((_scrollView.frame.size.width-310)/2, 5+iTop, 310, height);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height +30+iTop);
    
    UIImage *image2 = [UIImage imageNamed:@"004_10.png"];
    
    jgBut=[UIButton buttonWithType:UIButtonTypeCustom];
    jgBut.frame=CGRectMake(80, 160, 150, 30);
    [jgBut setBackgroundImage:image2 forState:UIControlStateNormal];
    [jgBut setTitle:@"推算结果" forState:UIControlStateNormal];
    [jgBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jgBut.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bgView addSubview:jgBut];
    
    jgLab  = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 300, 70)];
    jgLab.backgroundColor = [UIColor clearColor];
    jgLab.textColor = [UIColor grayColor];
    [bgView addSubview:jgLab];
    jgLab.numberOfLines = 0;
    [jgLab release];
    
    jgBut.hidden = YES;
    jgLab.hidden = YES;
    
    
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
	dateFormatter.dateFormat = @" yyyy-MM-dd";
	NSString * str = [dateFormatter stringFromDate:datePicker.date];
	NSLog(@"data === %@", str);
    
    self.olddate =  datePicker.date;
    //  [olddate retain];
    
    dataLab.text = [NSString stringWithFormat:@"末次月经时间：%@", str];;
	
	[dateFormatter release];
}



-(void)clicked_tuisuanBut{
    [self clicked_dBut];
    
    [tf2 resignFirstResponder];
    int cycle = [tf2.text intValue];
    
    if (cycle >=24 && cycle <=35) {
        int tmp = 280 + cycle - 28;
        
        
        NSDate *newdate = [NSDate dateWithTimeInterval:3600*24*tmp sinceDate:self.olddate];
        
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @" yyyy-MM-dd日";
        NSString * str = [dateFormatter stringFromDate:newdate];
        
        NSLog(@"预产期   %@",str);
        
        NSTimeInterval ita = [[NSDate date] timeIntervalSinceDate:self.olddate];
        
        NSLog(@"ddd   = %f %@",ita,self.olddate);
        int day = ita/3600/24;
        day += 1;
        int zhou = day/7;
        int tian = day%7;
        
        NSTimeInterval ita2 = [newdate timeIntervalSinceDate:[NSDate date]];
        
        int day2 = ita2/3600/24;
        
        jgLab.hidden = NO;
        jgBut.hidden = NO;
        
        
        int height = jgLab.frame.origin.y + jgLab.frame.size.height + 10;
        
        if (zhou == 0) {
            jgLab.text = [NSString stringWithFormat:@"通过计算，您的预产期是%@。目前正处于孕期第%d天，距离宝宝出生还有%d天。",str,tian,day2+1];

        }else{
            if (tian == 0) {
                jgLab.text = [NSString stringWithFormat:@"通过计算，您的预产期是%@。目前正处于孕期%d周，距离宝宝出生还有%d天。",str,zhou,day2+1];

            }else{
                jgLab.text = [NSString stringWithFormat:@"通过计算，您的预产期是%@。目前正处于孕期%d周+%d天，距离宝宝出生还有%d天。",str,zhou,tian,day2+1];

            }

        }
        
        int iTop = 0;
        if (ISIPAD) {
            iTop = 60;
        }
        bgView.frame = CGRectMake((_scrollView.frame.size.width-310)/2, 5+iTop, 310, height);
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height +30+iTop);
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:self.olddate forKey:@"yuchanqi_sam"];
        [ud setObject:jgLab.text forKey:@"yuchanqi_text_sam"];
        [ud setObject:[NSString stringWithFormat:@"%d", day] forKey:@"day_sam"];
        
        NSLog(@"day == %@",[ud objectForKey:@"day_sam"]);
        
    }else{
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"月经周期必须在24天到35天之间！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
    
    
    
    
    
}

-(void)UesrClicked:(id)sender{
    [tf2 resignFirstResponder];
    
}
-(void)clicked_backBut{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
