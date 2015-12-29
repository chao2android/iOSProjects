//
//  XiuGaibaobaoViewController.m
//  好妈妈
//
//  Created by iHope on 13-11-1.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "XiuGaibaobaoViewController.h"
#import "GerzxViewController.h"
#import "AutoAlertView.h"
@interface XiuGaibaobaoViewController ()

@end

@implementation XiuGaibaobaoViewController
@synthesize myPickerView;
@synthesize oldDictionary;
@synthesize loginDictionary;
@synthesize temp;
- (void)dealloc
{
    [temp release];
    [loginDictionary release];
    [oldDictionary release];
    [myPickerView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    xingbieNum=[[self.oldDictionary valueForKey:@"babysex"] intValue];
    selectNum=[[self.oldDictionary valueForKey:@"type"] intValue];
    NSLog(@"%@",self.oldDictionary);
	// Do any additional setup after loading the view.
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.userInteractionEnabled=YES;
    navigation.backgroundColor=[UIColor blackColor];
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(11), (Screen_Width-160), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"修改宝宝信息";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];

    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake((Screen_Width-252)/2+20, 20+(KUIOS_7(44)), 69, 32);
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",1] ofType:@"png"]] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",1] ofType:@"png"]] forState:UIControlStateNormal];

    [button addTarget:self action:@selector(LeiXingMenth:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=0;
    [self.view addSubview:button];
    
    UIButton * button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake((Screen_Width-252)/2+20+84, 20+(KUIOS_7(44)), 69, 32);
    [button1 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",2] ofType:@"png"]] forState:UIControlStateNormal];
    button1.tag=1;
    [button1 addTarget:self action:@selector(LeiXingMenth:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    UIButton * button2=[UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",3] ofType:@"png"]] forState:UIControlStateNormal];
    button2.tag=2;
    [button2 addTarget:self action:@selector(LeiXingMenth:) forControlEvents:UIControlEventTouchUpInside];
    button2.frame=CGRectMake((Screen_Width-252)/2+20+84*2, 20+(KUIOS_7(44)), 69, 32);
    [self.view addSubview:button2];
    if (selectNum==1) {
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",1] ofType:@"png"]] forState:UIControlStateNormal];
 
    }
    else if (selectNum==2)
    {
        [button1 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",2] ofType:@"png"]] forState:UIControlStateNormal];

    }
    else
    {
        [button2 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",3] ofType:@"png"]] forState:UIControlStateNormal];

    }
//        selectNum=1;
//    for (int i=0; i<3; i++) {
//        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame=CGRectMake(84*i+(Screen_Width-252)/2+20, 20+44, 69, 32);
//        if (selectNum-1==i) {
//            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",i+1] ofType:@"png"]] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",i+1] ofType:@"png"]] forState:UIControlStateNormal];
//        }
//        
//        button.tag=i;
//        [button addTarget:self action:@selector(LeiXingMenth:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:button];
//    }
    
        UIImageView * backImageView1=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-272.5)/2+10, (KUIOS_7(44))+52+30, 272.5, 38.5)];
        backImageView1.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_5_%d",0] ofType:@"png"]];
        [self.view addSubview:backImageView1];
        [backImageView1 release];
    
    riqiButton=[UIButton buttonWithType:UIButtonTypeCustom];
    riqiButton.frame=CGRectMake(40+(Screen_Width-272.5)/2+10, (KUIOS_7(44))+52+30+4, 272.5-50, 30.5);
    [riqiButton setTitle:[self.oldDictionary valueForKey:@"birthday"] forState:UIControlStateNormal];
    [riqiButton addTarget:self action:@selector(XuanzeRiqiMenth:) forControlEvents:UIControlEventTouchUpInside];
    [riqiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    riqiButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [self.view addSubview:riqiButton];
    if (ISIPAD) {
        button.frame=CGRectMake((Screen_Width-252*1.4)/2+20*1.4, 64*1.4, 69*1.4, 32*1.4);
        button1.frame=CGRectMake((Screen_Width-252*1.4)/2+20*1.4+84*1.4, 64*1.4, 69*1.4, 32*1.4);
        button2.frame=CGRectMake((Screen_Width-252*1.4)/2+20*1.4+84*2*1.4, 64*1.4, 69*1.4, 32*1.4);
        backImageView1.frame=CGRectMake((Screen_Width-272.5*1.4)/2+10*1.4, (44+52+30)*1.4, 272.5*1.4, 38.5*1.4);
        riqiButton.frame=CGRectMake(40*1.4+(Screen_Width-272.5*1.4)/2+10*1.4, (44+52+30+4)*1.4, (272.5-50)*1.4, 30.5*1.4);
        riqiButton.titleLabel.font=[UIFont systemFontOfSize:17*1.4];
    }
    for (int i=0; i<2; i++)
    {
        UIButton * button5=[UIButton buttonWithType:UIButtonTypeCustom];
        button5.frame=CGRectMake((Screen_Width-272.5)/2+30+139*i, (KUIOS_7(44))+52+30+38.5+20, 39, 39);
        button5.tag=i;
        [button5 addTarget:self action:@selector(BaobaoxingbieMenth:) forControlEvents:UIControlEventTouchUpInside];
        [button5 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",i+18] ofType:@"png"]] forState:UIControlStateNormal];

        if ([[self.oldDictionary valueForKey:@"type"] intValue]==1)
        {
            if (xingbieNum)
            {
                if (i)
                {
                    [button5 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_19_2" ofType:@"png"]] forState:UIControlStateNormal];
                }else
                {
                    [button5 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_18" ofType:@"png"]] forState:UIControlStateNormal];
                }

            }
            else
            {
                if (i==0)
                {
                    [button5 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_18_2" ofType:@"png"]] forState:UIControlStateNormal];
                }else
                {
                    [button5 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_19" ofType:@"png"]] forState:UIControlStateNormal];
                }

                
            }
        }
        [self.view addSubview:button5];
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(button5.frame.size.width+button5.frame.origin.x+5, button5.frame.origin.y+button5.frame.size.height-15, 45, 15)];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.font=[UIFont systemFontOfSize:15];
        if (i==0) {
            titleLabel.text=@"男宝宝";
        }
        else
        {
            titleLabel.text=@"女宝宝";
        }
        titleLabel.backgroundColor=[UIColor clearColor];;
        [self.view addSubview:titleLabel];
        [titleLabel release];
        if (ISIPAD) {
            button5.frame=CGRectMake((Screen_Width-272.5*1.4)/2+30*1.4+139*1.4*i, (44+52+30+38.5+20)*1.4, 39*1.4, 39*1.4);
            titleLabel.frame=CGRectMake(button5.frame.size.width+button5.frame.origin.x+5, button5.frame.origin.y+button5.frame.size.height-15, 45*1.4, 15*1.4);
            titleLabel.font=[UIFont systemFontOfSize:15*1.4];
            
        }
    }
    self.myPickerView=[[[UIPickerView alloc]initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, 150)] autorelease];
    self.myPickerView.delegate=self;
    self.myPickerView.dataSource=self;
    self.myPickerView.showsSelectionIndicator=YES;
    [self.view addSubview:self.myPickerView];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    for (int i=0; i<[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] count]; i++) {
        [myPickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:i] intValue]-1 inComponent:i animated:NO];
    }
   
    
//    
    if ([[self.oldDictionary valueForKey:@"type"] intValue]==2) {
//        button.frame=CGRectMake((Screen_Width-252)/2+20+84, 20+44, 69, 32);
//        button1.frame=CGRectMake((Screen_Width-252)/2+20, 20+44, 69, 32);
//        [button1 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",2] ofType:@"png"]] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",1] ofType:@"png"]] forState:UIControlStateNormal];
        
        for (int i=[[button.superview subviews] count]-5; i<[[button.superview subviews] count]-1; i++) {
            UIView * aView=[[button.superview subviews] objectAtIndex:i];
            aView.hidden=YES;
        }
        
        
    }
    else if([[self.oldDictionary valueForKey:@"type"] intValue]==3)
    {
//        button.frame=CGRectMake((Screen_Width-252)/2+20+84, 20+44, 69, 32);
//        button1.frame=CGRectMake((Screen_Width-252)/2+20+84*2, 20+44, 69, 32);
//        button2.frame=CGRectMake((Screen_Width-252)/2+20, 20+44, 69, 32);
//        [button2 setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",3] ofType:@"png"]] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",1] ofType:@"png"]] forState:UIControlStateNormal];
        for (int i=[[button.superview subviews] count]-7; i<[[button.superview subviews] count]; i++) {
            
            if ([[[button.superview subviews] objectAtIndex:i] isKindOfClass:NSClassFromString(@"UITextField")]) {
                continue;
            }
            UIView * aView=[[button.superview subviews] objectAtIndex:i];
            aView.hidden=YES;
        }
        
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.myPickerView.frame=CGRectMake(0, Screen_Height, Screen_Width, 150);
    }];
    pickerBool=NO;
}
- (void)LeiXingMenth:(UIButton *)sender
{
    
    selectNum=sender.tag+1;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    for (int i=0; i<[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] count]; i++)
    {
        [myPickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:i] intValue]-1 inComponent:i animated:NO];
    }
    [self.myPickerView reloadAllComponents];
    
    for (int i=2; i<5; i++)
    {
        if (i==sender.tag+2)
        {
            [[[sender.superview subviews] objectAtIndex:i] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",i-1] ofType:@"png"]] forState:UIControlStateNormal];
        }
        else
        {
            [[[sender.superview subviews] objectAtIndex:i] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",i-1] ofType:@"png"]] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        self.myPickerView.frame=CGRectMake(0, Screen_Height, Screen_Width, 150);
    }];
    pickerBool=NO;
    for (int i=0; i<[[sender.superview subviews] count]; i++) {
        UIView * aView=[[sender.superview subviews] objectAtIndex:i];
        aView.hidden=NO;
    }
    if([[self.oldDictionary valueForKey:@"type"] intValue]==1)
    {
        [riqiButton setTitle:[self.oldDictionary valueForKey:@"birthday"] forState:UIControlStateNormal];
    }
    else
    {
        [riqiButton setTitle:@"选择宝宝日期" forState:UIControlStateNormal];

        
    }


    if (sender.tag==1)
    {
        if([[self.oldDictionary valueForKey:@"type"] intValue]==2)
        {
            [riqiButton setTitle:[self.oldDictionary valueForKey:@"birthday"] forState:UIControlStateNormal];
        }
        else
        {
            [riqiButton setTitle:@"选择预产期" forState:UIControlStateNormal];

        }

        NSLog(@"%@",[sender.superview subviews]);
        for (int i=[[sender.superview subviews] count]-5; i<[[sender.superview subviews] count]-1; i++) {
            UIView * aView=[[sender.superview subviews] objectAtIndex:i];
            aView.hidden=YES;
        }
    }
    else if(sender.tag==2)
    {
        for (int i=[[sender.superview subviews] count]-7; i<[[sender.superview subviews] count]; i++) {
            
            if ([[[sender.superview subviews] objectAtIndex:i] isKindOfClass:NSClassFromString(@"UITextField")]) {
                continue;
            }
            UIView * aView=[[sender.superview subviews] objectAtIndex:i];
            aView.hidden=YES;
        }
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}
// 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYY"];
        NSString* date = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        return 2*[date intValue];
    }
    else if (component==1)
    {
        return 12;
    }
    
    return 31;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.myPickerView reloadComponent:1];
    [self.myPickerView reloadComponent:2];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    if (selectNum==1)
    {
        if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]<[pickerView selectedRowInComponent:0]+1)
        {
            [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]-1 inComponent:0 animated:YES];
            
        }
        else if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]==[pickerView selectedRowInComponent:0]+1)
        {
            if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]<[pickerView selectedRowInComponent:1]+1)
            {
                
                [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]-1 inComponent:1 animated:YES];
                if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]<=[pickerView selectedRowInComponent:2]+1)
                {
                    
                    
                    [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]-1 inComponent:2 animated:YES];
                }
                
            }
            else if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]==[pickerView selectedRowInComponent:1]+1)
            {
                if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]<[pickerView selectedRowInComponent:2]+1)
                {
                    [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]-1 inComponent:2 animated:YES];
                }
            }
            
        }
        
    }
    else
    {
        NSDate *newdate = [NSDate dateWithTimeInterval:3600*24*252 sinceDate:[NSDate date]];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString * str = [dateFormatter stringFromDate:newdate];
        
        
        if ([[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]<[pickerView selectedRowInComponent:0]+1) {
            [pickerView selectRow:[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]-1 inComponent:0 animated:YES];
            
        }
        else if ([[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]==[pickerView selectedRowInComponent:0]+1)
        {
            if ([[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]<=[pickerView selectedRowInComponent:1]+1) {
                [pickerView selectRow:[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]-1 inComponent:1 animated:YES];

                if ([[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]<[pickerView selectedRowInComponent:2]+1) {
                    
                    
                    [pickerView selectRow:[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]-1 inComponent:2 animated:YES];
                }


            }
        }
        else if ([[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]==[pickerView selectedRowInComponent:1]+1)
        {
            if ([[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]<[pickerView selectedRowInComponent:2]+1)
            {
                [pickerView selectRow:[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]-1 inComponent:2 animated:YES];
            }
        }

        if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]>[pickerView selectedRowInComponent:0]+1) {
            [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]-1 inComponent:0 animated:YES];

        }
        else if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]==[pickerView selectedRowInComponent:0]+1)
        {
            if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]>[pickerView selectedRowInComponent:1]+1) {
                [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]-1 inComponent:1 animated:YES];
                if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]>[pickerView selectedRowInComponent:2]+1) {
                    
                    
                    [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]-1 inComponent:2 animated:YES];
                }
                
            }
            else if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]==[pickerView selectedRowInComponent:1]+1)
            {
                if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]>[pickerView selectedRowInComponent:2]+1)
                {
                    [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]-1 inComponent:2 animated:YES];
                }
            }
        }
    }
    if ([pickerView selectedRowInComponent:1]==1)
    {
        if ((([pickerView selectedRowInComponent:0]+1)%4==0&&([pickerView selectedRowInComponent:0]+1)%100)||([pickerView selectedRowInComponent:0]+1)%400==0)
        {
            if ([pickerView selectedRowInComponent:2]>28)
            {
                
                [pickerView selectRow:28 inComponent:2 animated:YES];
            }
        }
        else
        {
            if ([pickerView selectedRowInComponent:2]>27)
            {
                
                [pickerView selectRow:27 inComponent:2 animated:YES];
            }
        }
    }
    
    else if (([pickerView selectedRowInComponent:1]==3||[pickerView selectedRowInComponent:1]==5||[pickerView selectedRowInComponent:1]==8||[pickerView selectedRowInComponent:1]==10)&&[pickerView selectedRowInComponent:2]==30) {
        [pickerView selectRow:29 inComponent:2 animated:YES];
    }
    
    
    NSMutableString * butString=[[NSMutableString alloc]initWithCapacity:1];
    [butString appendFormat:@"%d-",[pickerView selectedRowInComponent:0]+1];
    [butString appendFormat:@"%d-",[pickerView selectedRowInComponent:1]+1];
    [butString appendFormat:@"%d",[pickerView selectedRowInComponent:2]+1];
    [riqiButton setTitle:butString forState:UIControlStateNormal];
    [butString release];
    
    
}
-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    int fontSize = 25;
    CGRect rect = CGRectMake(0.0, 0.0, 100, 50);
    UILabel *myView = [[[UILabel alloc] initWithFrame:rect] autorelease];
    myView.textAlignment = UITextAlignmentCenter;
    myView.font = [UIFont boldSystemFontOfSize:fontSize];
    myView.backgroundColor = [UIColor clearColor];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:component] intValue]==row+1) {
        myView.textColor=[UIColor blueColor];
        myView.userInteractionEnabled=YES;
    }
    else
    {
        if ([pickerView selectedRowInComponent:1]==1)
        {
            if ((([pickerView selectedRowInComponent:0]+1)%4==0&&([pickerView selectedRowInComponent:0]+1)%100)||([pickerView selectedRowInComponent:0]+1)%400==0)
            {
                if (row==29||row==30)
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
            }
            else
            {
                if (row==28||row==29||row==30)
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
            }
        }
        else if (([pickerView selectedRowInComponent:1]==3||[pickerView selectedRowInComponent:1]==5||[pickerView selectedRowInComponent:1]==8||[pickerView selectedRowInComponent:1]==10)&&row==30)
        {
            myView.textColor=[UIColor grayColor];
            myView.userInteractionEnabled=NO;
        }
        else
        {
            myView.userInteractionEnabled=YES;
            myView.textColor=[UIColor blackColor];
        }
        
        if (selectNum==1)
        {
            if (component==0&&row+1>[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue])
            {
                myView.textColor=[UIColor grayColor];
                myView.userInteractionEnabled=NO;
            }
            
            if (component==1&&[pickerView selectedRowInComponent:0]+1>=[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue])
            {
                if (row+1>[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue])
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
                
            }
            if (component==2&&[pickerView selectedRowInComponent:0]+1>=[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]&&[pickerView selectedRowInComponent:1]+1>=[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue])
            {
                if (row+1>[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue])
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
            }
        }
        else if(selectNum==2)
        {
            NSDate *newdate = [NSDate dateWithTimeInterval:3600*24*252 sinceDate:[NSDate date]];
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString * str = [dateFormatter stringFromDate:newdate];
            
            
            
            if ((component==0&&row+1<=[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue])||(component==0&&row+1>[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]))
            {
                myView.textColor=[UIColor grayColor];
                myView.userInteractionEnabled=NO;
            }
            
            if (component==1&&[pickerView selectedRowInComponent:0]+1<=[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue])
            {
                if (row+1<[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue])
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
                
            }
            if (component==1&&[pickerView selectedRowInComponent:0]+1>=[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue])
            {
                if (row+1>[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue])
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
                
                
            }
            if (component==2&&[pickerView selectedRowInComponent:0]+1<=[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]&&[pickerView selectedRowInComponent:1]+1<=[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue])
            {
                if (row+1<[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue])
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
                
            }
            if (component==2&&[pickerView selectedRowInComponent:0]+1>=[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]&&[pickerView selectedRowInComponent:1]+1>=[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue])
            {
                if (row+1>[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue])
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
            }
            
        }
        
    }
    
    
    myView.text = [NSString stringWithFormat:@"%d",row+1];
    return myView;
}



- (void)XuanzeRiqiMenth:(UIButton *)sender
{
    CGRect aRect;
    if (pickerBool) {
        aRect=CGRectMake(0, Screen_Height, Screen_Width, 150);
        pickerBool=NO;
    }
    else
    {
        aRect=CGRectMake(0, Screen_Height-150-30, Screen_Width, 150);
        pickerBool=YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.myPickerView.frame=aRect;
    }];
    
}
- (void)BaobaoxingbieMenth:(UIButton *)sender
{
    if (sender.tag) {
        xingbieNum=0;
    }
    else
    {
        xingbieNum=1;
    }
    if (sender.tag) {
        
        [[[sender.superview subviews]objectAtIndex:[[sender.superview subviews] count]-5] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_18_2" ofType:@"png"]] forState:UIControlStateNormal];
        [[[sender.superview subviews]objectAtIndex:[[sender.superview subviews] count]-3] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_19" ofType:@"png"]] forState:UIControlStateNormal];
    }
    else
    {
        [[[sender.superview subviews]objectAtIndex:[[sender.superview subviews] count]-5] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_18" ofType:@"png"]] forState:UIControlStateNormal];
        [[[sender.superview subviews]objectAtIndex:[[sender.superview subviews] count]-3] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_19_2" ofType:@"png"]] forState:UIControlStateNormal];
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
        self.myPickerView.frame=CGRectMake(0, Screen_Height, Screen_Width, 150);
    }];
    pickerBool=NO;
}

- (void)backup
{
    GerzxViewController * gerzx=(GerzxViewController *)temp;
    if (selectNum!=3) {
        
        
    if (riqiButton.titleLabel.text.length) {
        
        if (selectNum==1&&[riqiButton.titleLabel.text isEqualToString:@"选择宝宝日期"]) {
            [AutoAlertView ShowAlert:@"温馨提示" message:@"请选择宝宝日期"];
            return;
        }
        else if(selectNum==2&&[riqiButton.titleLabel.text isEqualToString:@"选择预产期"])
        {
            [AutoAlertView ShowAlert:@"温馨提示" message:@"请选择预产期"];
            return;
        }
        if (selectNum==1) {
            [gerzx.oldDictionary setValue:[NSString stringWithFormat:@"%d",xingbieNum] forKey:@"babysex"];
            
        }
        
    }
    [gerzx.oldDictionary setObject:riqiButton.titleLabel.text forKey:@"birthday"];
    }
    [gerzx.oldDictionary setValue:[NSString stringWithFormat:@"%d",selectNum] forKey:@"type"];

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
