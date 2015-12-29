//
//  WanshanViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "WanshanViewController.h"
#import "TishiView.h"
#import "TuijianquanziViewController.h"
#import  "AutoAlertView.h"
#import "RootViewController.h"

@interface WanshanViewController ()

@end

@implementation WanshanViewController
@synthesize mcTextFeild;
@synthesize myPickerView;
@synthesize oldDictionary;
@synthesize loginDictionary;
@synthesize tishiView;
- (void)dealloc
{
    [tishiView release];
    [loginDictionary release];
    [oldDictionary release];
    [myPickerView release];
    [mcTextFeild release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    xingbieNum=2;
    self.loginDictionary=[[[NSMutableDictionary alloc]initWithCapacity:1] autorelease];
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.backgroundColor=[UIColor blackColor];
    navigation.userInteractionEnabled=YES;
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(11), (Screen_Width-160), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"完善您的信息";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [rightBut setImage:[UIImage imageNamed:@"006_4.png"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:rightBut];
    
    for (int i=0; i<3; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(84*i+(Screen_Width-252)/2+20, 20+(KUIOS_7(44)), 69, 32);
        if (ISIPAD) {
            button.frame=CGRectMake(84*1.4*i+(Screen_Width-252*1.4)/2+20*1.4, (KUIOS_7(64))*1.4, 69*1.4, 32*1.4);
        }
        if (i==0) {
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",i+1] ofType:@"png"]] forState:UIControlStateNormal];
        }
        else
        {
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",i+1] ofType:@"png"]] forState:UIControlStateNormal];
        }
        button.tag=i;
        [button addTarget:self action:@selector(LeiXingMenth:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    selectNum=1;
    for (int i=0; i<2; i++) {
        UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-272.5)/2+10, (KUIOS_7(44))+52+30+44*i, 272.5, 38.5)];
        if (ISIPAD) {
            backImageView.frame=CGRectMake((Screen_Width-272.5*1.4)/2+10*1.4, ((KUIOS_7(44))+52+30+44*i)*1.4, 272.5*1.4, 38.5*1.4);
        }
        backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_5_%d",i] ofType:@"png"]];
        [self.view addSubview:backImageView];
        [backImageView release];
    }
    self.mcTextFeild=[[[UITextField alloc]initWithFrame:CGRectMake(40+(Screen_Width-272.5)/2+10, (KUIOS_7(44))+52+30+4, 272.5-50, 30.5)] autorelease];
    self.mcTextFeild.text=@"输入用户名昵称";
    self.mcTextFeild.delegate=self;
    self.mcTextFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.mcTextFeild.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.mcTextFeild];
    riqiButton=[UIButton buttonWithType:UIButtonTypeCustom];
    riqiButton.frame=CGRectMake(40+(Screen_Width-272.5)/2+10, (KUIOS_7(44))+52+30+44+4, 272.5-50, 30.5);
    rightBut.tag=10000;
    if (selectNum==1) {
    
    [riqiButton setTitle:@"选择宝宝生日" forState:UIControlStateNormal];
    }
    else
    {
        [riqiButton setTitle:@"选择预产期" forState:UIControlStateNormal];
    }
    [riqiButton addTarget:self action:@selector(XuanzeRiqiMenth:) forControlEvents:UIControlEventTouchUpInside];
    [riqiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    riqiButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [self.view addSubview:riqiButton];
    for (int i=0; i<2; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake((Screen_Width-272.5)/2+30+139*i, (KUIOS_7(44))+52+30+44+38.5+20, 39, 39);
        button.tag=i;
        [button addTarget:self action:@selector(BaobaoxingbieMenth:) forControlEvents:UIControlEventTouchUpInside];
       
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",18+i] ofType:@"png"]] forState:UIControlStateNormal];
    
        [self.view addSubview:button];
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.size.width+button.frame.origin.x+5, button.frame.origin.y+button.frame.size.height-15, 45, 15)];
        ;
       
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.font=[UIFont systemFontOfSize:15];
        if (ISIPAD) {
            button.frame=CGRectMake((Screen_Width-272.5*1.4)/2+30*1.4+139*1.4*i, ((KUIOS_7(44))+52+30+44+38.5+20)*1.4, 39*1.4, 39*1.4);
            titleLabel.frame=CGRectMake(button.frame.size.width+button.frame.origin.x+5, button.frame.origin.y+button.frame.size.height-15, 45*1.4, 15*1.4);
            titleLabel.font=[UIFont systemFontOfSize:15*1.4];

        }
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
    }
    self.myPickerView=[[[UIPickerView alloc]initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, 150)] autorelease];
//    self.myPickerView.backgroundColor=[UIColor whiteColor];
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

    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    if (ISIPAD) {
        self.mcTextFeild.frame=CGRectMake(40*1.4+(Screen_Width-272.5*1.4)/2+10*1.4, self.mcTextFeild.frame.origin.y*1.4, self.mcTextFeild.frame.size.width*1.4, self.mcTextFeild.frame.size.height*1.4);
        self.mcTextFeild.font=[UIFont systemFontOfSize:17*1.4];
        riqiButton.frame=CGRectMake(40*1.4+(Screen_Width-272.5*1.4)/2+10*1.4, riqiButton.frame.origin.y*1.4, riqiButton.frame.size.width*1.4, riqiButton.frame.size.height*1.4);
        riqiButton.titleLabel.font=[UIFont systemFontOfSize:17*1.4];
    }
    for (NSString * ncString in self.oldDictionary.allKeys) {
        if ([ncString isEqualToString:@"nickname"]) {
            self.mcTextFeild.text=[self.oldDictionary valueForKey:@"nickname"];
            break;
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.myPickerView.frame=CGRectMake(0, Screen_Height, Screen_Width, 150);
    }];
    pickerBool=NO;
    self.mcTextFeild.text=@"";
}
- (void)LeiXingMenth:(UIButton *)sender
{
    self.mcTextFeild.text=@"输入用户名昵称";
    for (NSString * ncString in self.oldDictionary.allKeys) {
        if ([ncString isEqualToString:@"nickname"]) {
            self.mcTextFeild.text=[self.oldDictionary valueForKey:@"nickname"];
            break;
        }
    }
    selectNum=sender.tag+1;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    for (int i=0; i<[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] count]; i++) {
        [myPickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:i] intValue]-1 inComponent:i animated:NO];
    }
    [self.myPickerView reloadAllComponents];
    
    for (int i=2; i<5; i++) {
        if (i==sender.tag+2) {
            [[[sender.superview subviews] objectAtIndex:i] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_2",i-1] ofType:@"png"]] forState:UIControlStateNormal];
        }
        else
        {
            [[[sender.superview subviews] objectAtIndex:i] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",i-1] ofType:@"png"]] forState:UIControlStateNormal];
        }
    }
    [self.mcTextFeild resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{

        self.myPickerView.frame=CGRectMake(0, Screen_Height, Screen_Width, 150);
    }];
    pickerBool=NO;
        for (int i=0; i<[[sender.superview subviews] count]; i++) {
            UIView * aView=[[sender.superview subviews] objectAtIndex:i];
            aView.hidden=NO;
        }
    if (sender.tag==0)
    {
    [riqiButton setTitle:@"选择宝宝生日" forState:UIControlStateNormal];
    }
    
    if (sender.tag==1)
    {
        [riqiButton setTitle:@"选择预产期" forState:UIControlStateNormal];

        for (int i=[[sender.superview subviews] count]-6; i<[[sender.superview subviews] count]-2; i++) {
            UIView * aView=[[sender.superview subviews] objectAtIndex:i];
            aView.hidden=YES;
        }
    }
    else if(sender.tag==2)
    {
        for (int i=[[sender.superview subviews] count]-9; i<[[sender.superview subviews] count]-1; i++) {
            
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
                    NSLog(@"fdsfsd");
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
            if ([[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]<=[pickerView selectedRowInComponent:1]+1)
            {
                [pickerView selectRow:[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]-1 inComponent:1 animated:YES];
                
                if ([[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]<[pickerView selectedRowInComponent:2]+1)
                {
                    
                    
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


- (void)RightMenth
{
    NSLog(@"%d  %@  ",selectNum,[NSString stringWithFormat:@"%d",selectNum]);
    NSLog(@"%@",self.oldDictionary);
    NSMutableDictionary * aDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
    if (self.mcTextFeild.text.length&&![self.mcTextFeild.text isEqualToString:@"输入用户名昵称"]) {
        

    [aDictionary setValue:self.mcTextFeild.text forKey:@"name"];
    }
    else
    {
        [AutoAlertView ShowAlert:@"温馨提示" message:@"请输入名称"];
        return;
    }
   
    if (selectNum!=3) {
        NSLog(@"%@  %d",riqiButton.titleLabel.text,riqiButton.titleLabel.text.length);
       
        if (riqiButton.titleLabel.text.length) {
            
            if (selectNum==1&&[riqiButton.titleLabel.text isEqualToString:@"选择宝宝生日"]) {
                [AutoAlertView ShowAlert:@"温馨提示" message:@"请选择宝宝生日"];
               return;
            }
            else if(selectNum==2&&[riqiButton.titleLabel.text isEqualToString:@"选择预产期"])
            {
                [AutoAlertView ShowAlert:@"温馨提示" message:@"请选择预产期"];
              return;
            }
            
        }
        [aDictionary setObject:riqiButton.titleLabel.text forKey:@"birthday"];

        if (selectNum==1) {
        [aDictionary setObject:[NSString stringWithFormat:@"%d",xingbieNum] forKey:@"babysex"];
        }
        
    }
    if ([[self.oldDictionary valueForKey:@"denglutype"]isEqualToString:@"1"]) {
        [aDictionary setObject:[self.oldDictionary valueForKey:@"oid"] forKey:@"oid"];
        [aDictionary setObject:[self.oldDictionary valueForKey:@"feil"] forKey:@"file"];

    }
    else
    {
        [aDictionary setObject:[self.oldDictionary valueForKey:@"shoujihao"] forKey:@"mobile"];
        [aDictionary setObject:[self.oldDictionary valueForKey:@"mima"] forKey:@"password"];
    }
    [aDictionary setValue:[self.oldDictionary valueForKey:@"devicetoken"] forKey:@"devicetoken"];
    [aDictionary setValue:[self.oldDictionary valueForKey:@"lng"] forKey:@"lng"];
    [aDictionary setValue:[self.oldDictionary valueForKey:@"lat"] forKey:@"lat"];
    [aDictionary setValue:[NSString stringWithFormat:@"%d",selectNum] forKey:@"type"];
    [self.tishiView StartMenth];
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/createuser"];
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    if (analysis==nil) {
        
    
     analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:@"zhucechenggong" delegate:self];
    [aUrl release];

    NSLog(@"aDictionary  %@",aDictionary);
    [analysis PostMenth:aDictionary];
    [self.loginDictionary removeAllObjects];
    [self.loginDictionary addEntriesFromDictionary:aDictionary];
    [aDictionary release];
    }

}

- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    NSDictionary * asidictionary=[array valueForKey:asi.ControllerName];
    [self.tishiView StopMenth];

    if ([[asidictionary valueForKey:@"code"] intValue]) {
        [self.loginDictionary addEntriesFromDictionary:asidictionary];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logindata"];
        [[NSUserDefaults standardUserDefaults] setValue:self.loginDictionary forKey:@"logindata"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shifoulogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSMutableDictionary * dataDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
        [dataDictionary setValue:@"推荐圈子" forKey:@"Title"];
        [dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/recommentcircles" forKey:@"aUrl1"];
        NSArray * typeArr=[[NSArray alloc]initWithObjects:@"完成", nil];
        [dataDictionary setValue:typeArr forKey:@"typeArr"];
        [typeArr release];
//        TuijianquanziViewController * tuijianquanzi=[[TuijianquanziViewController alloc]init];
//        tuijianquanzi.oldDictionary=dataDictionary;
//        [dataDictionary release];
//        [self.navigationController pushViewController:tuijianquanzi animated:YES];
//        [tuijianquanzi release];

        RootViewController * root=[[RootViewController alloc]init];
        [self.navigationController pushViewController:root animated:YES];
        [root release];
        
        
        
//        BangzhuViewController * bangzhu=[[BangzhuViewController alloc]init];
//        bangzhu.shouming=NO;
//        [self presentModalViewController:bangzhu animated:NO];
//        [bangzhu release];
    }
    else
    {
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[asidictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    [asi release];
    analysis=nil;

}
- (void)XuanzeRiqiMenth:(UIButton *)sender
{
    [self.mcTextFeild resignFirstResponder];
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
            
            [[[sender.superview subviews]objectAtIndex:[[sender.superview subviews] count]-6] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_18_2" ofType:@"png"]] forState:UIControlStateNormal];
            [[[sender.superview subviews]objectAtIndex:[[sender.superview subviews] count]-4] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_19" ofType:@"png"]] forState:UIControlStateNormal];
        }
        else
        {
            [[[sender.superview subviews]objectAtIndex:[[sender.superview subviews] count]-6] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_18" ofType:@"png"]] forState:UIControlStateNormal];
            [[[sender.superview subviews]objectAtIndex:[[sender.superview subviews] count]-4] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_19_2" ofType:@"png"]] forState:UIControlStateNormal];
        }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mcTextFeild resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.myPickerView.frame=CGRectMake(0, Screen_Height, Screen_Width, 150);
    }];
    pickerBool=NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
